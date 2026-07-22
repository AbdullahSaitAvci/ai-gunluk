// Backend API ile iletişimi yöneten servis katmanı.
// Tüm HTTP istekleri buradan yapılır — ekranlar doğrudan API'ye dokunmaz.
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// getEntries() gibi çağrılarda oluşan hataları taşır.
/// message alanı kullanıcıya doğrudan gösterilebilecek Türkçe bir metindir.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://ayna-ai-backend.onrender.com';

  /// İstek header'larını üretir. requireAuth true ise geçerli bir oturum
  /// şart koşulur; false ise Authorization header'sız istek de kabul edilir.
  ///
  /// Token HER ÇAĞRIDA taze okunur, static bir alanda cache'lenmez — Supabase
  /// SDK'sı access token'ı arka planda kendi yeniliyor; saklanan bir kopya
  /// zamanla bayatlar ve backend'e süresi dolmuş token gönderilir.
  static Future<Map<String, String>> _buildHeaders({
    required bool requireAuth,
  }) async {
    var session = Supabase.instance.client.auth.currentSession;

    if (session != null && session.isExpired) {
      try {
        final response = await Supabase.instance.client.auth.refreshSession();
        session = response.session;
      } catch (e) {
        // Yenileme başarısız oldu; session'ı yok say, aşağıdaki null dalına düş.
        session = null;
      }
    }

    if (session == null) {
      if (requireAuth) {
        throw ApiException('Oturum bulunamadı. Lütfen tekrar giriş yapın.');
      }
      return {'Content-Type': 'application/json'};
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    };
  }

  /// Günün sorusunu backend'den çeker.
  /// Başarısız olursa fallback soru döner — uygulama çökmez.
  static Future<String> getDailyQuestion() async {
    try {
      final headers = await _buildHeaders(requireAuth: false);
      final response = await http
          .get(Uri.parse('$_baseUrl/daily-question/'), headers: headers)
          .timeout(const Duration(seconds: 5)); // 5 sn timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['question'] as String;
      } else {
        return _fallbackQuestion();
      }
    } catch (e) {
      // Backend kapalıysa veya hata varsa fallback kullan
      return _fallbackQuestion();
    }
  }

  /// Ham metni seçilen tonda zenginleştirir.
  /// Hata durumunda rawText'i döndürür — uygulama çökmez.
  static Future<String> enrichEntry(String rawText, String tone) async {
    try {
      final headers = await _buildHeaders(requireAuth: false);
      final response = await http
          .post(
            Uri.parse('$_baseUrl/enrich/'),
            headers: headers,
            body: jsonEncode({'raw_text': rawText, 'tone': tone}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['enriched_text'] as String;
      } else {
        return rawText;
      }
    } catch (e) {
      return rawText;
    }
  }

  /// Günlük girişi backend'e kaydeder. Başarılıysa true döner.
  static Future<bool> saveEntry(
    String question,
    String rawText,
    String enrichedText,
    String tone,
    String mood,
  ) async {
    try {
      final headers = await _buildHeaders(requireAuth: true);
      final response = await http
          .post(
            Uri.parse('$_baseUrl/entries/'),
            headers: headers,
            body: jsonEncode({
              'question': question,
              'raw_text': rawText,
              'enriched_text': enrichedText,
              'tone': tone,
              'mood': _moodToScore(mood),
            }),
          )
          .timeout(const Duration(seconds: 30));
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // _buildHeaders'ın fırlattığı ApiException (oturum yok) da dahil
      // olmak üzere tüm hatalarda false dönülür; saveEntry'nin sözleşmesi
      // bool döndürmek, exception fırlatmak değil.
      return false;
    }
  }

  /// Tüm geçmiş girişleri çeker.
  /// Hata olursa (ağ, timeout, sunucu) ApiException fırlatır — çağıran taraf
  /// (Riverpod provider'ı) bunu yakalayıp UI'da gösterebilsin diye.
  /// Eskiden burası hatayı yutup [] döndürüyordu; bu da "veri yok" ile
  /// "sunucuya ulaşamadım" durumlarını UI'da ayırt edilemez hale getiriyordu.
  static Future<List<Map<String, dynamic>>> getEntries() {
    return _getEntriesAttempt(timeoutSeconds: 30, isRetry: false);
  }

  /// getEntries()'in gerçek implementasyonu. isRetry=false iken timeout
  /// olursa, Render'ın soğuk başlangıcını (~50 sn) hesaba katıp daha uzun
  /// süreyle TEK SEFERLİK otomatik tekrar dener.
  static Future<List<Map<String, dynamic>>> _getEntriesAttempt({
    required int timeoutSeconds,
    required bool isRetry,
  }) async {
    try {
      final headers = await _buildHeaders(requireAuth: true);
      final response = await http
          .get(Uri.parse('$_baseUrl/entries/'), headers: headers)
          .timeout(Duration(seconds: timeoutSeconds));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['entries'] as List).cast<Map<String, dynamic>>();
      }
      if (response.statusCode == 401) {
        // Token süresi dolmuş; tekrar denemek anlamsız çünkü aynı (veya
        // hâlâ geçersiz) token'la tekrar 401 alınır. Retry sadece soğuk
        // başlangıç kaynaklı TimeoutException için mantıklı.
        throw ApiException('Oturum süresi doldu. Lütfen tekrar giriş yapın.');
      }
      throw ApiException('Sunucu hatası (kod: ${response.statusCode}).');
    } on TimeoutException {
      if (!isRetry) {
        // İlk deneme soğuk başlangıca denk gelmiş olabilir; sunucu artık
        // uyanmış olacağından daha uzun timeout ile bir kez daha deneriz.
        return _getEntriesAttempt(timeoutSeconds: 45, isRetry: true);
      }
      throw ApiException(
        'Sunucuya ulaşılamadı (zaman aşımı). Lütfen tekrar deneyin.',
      );
    } on http.ClientException {
      throw ApiException('İnternet bağlantınızı kontrol edin.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Beklenmeyen bir hata oluştu.');
    }
  }

  static int _moodToScore(String mood) => switch (mood) {
    '😢' => 1,
    '😠' => 2,
    '😴' => 3,
    '🤩' => 4,
    '😊' => 5,
    _ => 5,
  };

  /// Backend erişilemezse kullanılacak yedek soru
  static String _fallbackQuestion() {
    return 'Bugün seni en çok ne düşündürdü?';
  }
}