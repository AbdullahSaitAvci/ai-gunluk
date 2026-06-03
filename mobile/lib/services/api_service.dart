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

  /// Backend erişilemezse kullanılacak yedek soru
  static String _fallbackQuestion() {
    return 'Bugün seni en çok ne düşündürdü?';
  }
}