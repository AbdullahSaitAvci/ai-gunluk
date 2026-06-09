/// Backend API ile iletişimi yöneten servis katmanı.
/// Tüm HTTP istekleri buradan yapılır — ekranlar doğrudan API'ye dokunmaz.
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Geliştirme ortamında lokal backend adresi
  // Android emülatör için 10.0.2.2, iOS simülatör ve web için localhost
  static const String _baseUrl = 'http://localhost:8080';

  /// Günün sorusunu backend'den çeker.
  /// Başarısız olursa fallback soru döner — uygulama çökmez.
  static Future<String> getDailyQuestion() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/daily-question/'),
            headers: {'Content-Type': 'application/json'},
          )
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
      final response = await http
          .post(
            Uri.parse('$_baseUrl/enrich/'),
            headers: {'Content-Type': 'application/json'},
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
      final response = await http
          .post(
            Uri.parse('$_baseUrl/entries/'),
            headers: {'Content-Type': 'application/json'},
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
      return false;
    }
  }

  /// Tüm geçmiş girişleri çeker. Hata olursa boş liste döner.
  static Future<List<Map<String, dynamic>>> getEntries() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/entries/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer anonymous',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['entries'] as List).cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static int _moodToScore(String mood) => switch (mood) {
    '😊' || '🤩' => 5,
    '😴' => 3,
    '😢' => 1,
    '😠' => 2,
    _ => 3,
  };

  /// Backend erişilemezse kullanılacak yedek soru
  static String _fallbackQuestion() {
    return 'Bugün seni en çok ne düşündürdü?';
  }
}