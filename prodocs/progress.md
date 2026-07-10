# Progress - 2026-04-22

## Tamamlananlar

- `backend/` iskeleti olusturuldu.
- `/health` endpoint'i calisiyor.
- `mobile/` Flutter iskeleti olusturuldu.
- Flutter uygulamasi Chrome'da basariyla calisiyor.
- Cursor kurallari guncellendi:
  - FastAPI rule eklendi.
  - Flutter rule eklendi.
  - Design system rule eklendi.
- FastAPI dokumantasyonu eklendi.
- Flutter dokumantasyonu eklendi.
- `plan.md` olusturuldu.

# Progress - 2026-05-13

## Tamamlananlar
- Supabase paketi kuruldu
- backend/routers/ yapısı oluşturuldu
- GET /daily-question/, GET/POST /entries/, GET /entries/{id} endpoint'leri yazıldı
- CORS middleware eklendi
- Swagger UI çalıştırıldı, endpoint'ler test edildi
- ER diyagramı Mermaid formatında oluşturuldu
- Flutter home ekranı backend /daily-question/ endpoint'ine bağlandı

# Progress - 2026-06-03

## Tamamlananlar
- POST /enrich/ endpoint'i eklendi
- Claude Haiku (claude-haiku-4-5) AI entegrasyonu tamamlandı
- Flutter enrich_screen.dart gerçek AI endpoint'ine bağlandı
- enrichedTextProvider mock'tan FutureProvider'a dönüştürüldü
- api_service.dart enrichEntry metodu eklendi
- .gitignore düzeltildi, .vscode tracking'den kaldırıldı
- Tüm Flutter ekranları GitHub'a push edildi



# Progress - 2026-06-14

## Tamamlananlar
- Backend Render'a deploy edildi: https://ayna-ai-backend.onrender.com
- Flutter web Netlify'a deploy edildi: https://ayna-ai-yga.netlify.app
- api_service.dart base URL production backend'e güncellendi
- Login ekranı sadeleştirildi: "Demo Olarak Giriş Yap" tek butonu
- Ayarlar ekranındaki tüm "(mock)" ifadeleri kaldırıldı, versiyon v1.0.0
- Onboarding: başlık kaldırıldı, 2. ve 3. ekranlara geri butonu eklendi, BouncingScrollPhysics ile akıcı geçiş
- "Geçmiş" ekranı "Takvim"e dönüştürüldü: table_calendar entegrasyonu, giriş olan günlerde işaretleyici, güne tıklayınca o günün kayıtları listeleniyor
- Entry ekranına "Direkt Kaydet" seçeneği eklendi — AI zenginleştirme artık opsiyonel
- AI zenginleştirme tonları 3'ten 5'e çıkarıldı: Neşeli / Hüzünlü / Minnettar / Motive / Sakin
- AI sistem promptu sıkılaştırıldı: kelime sayısı limiti eklendi, kullanıcı sesini koruma vurgusu güçlendirildi
- Güvenlik: prompt injection koruması (anahtar kelime filtresi), CORS kısıtlaması (sadece Netlify origin), rate limiting (slowapi, /enrich için dakikada 10 istek)
- cron-job.org ile Render free tier uyku modu önlendi (10 dk'da bir /health ping)

# Progress - 2026-06-25

## Tamamlananlar
- Android Studio kuruldu, SDK Command-line Tools eklendi
- flutter doctor tüm satırlar yeşil
- pubspec.yaml versiyonu 0.1.0+1 olarak güncellendi

# Progress - 2026-06-26

## Tamamlananlar
- flutter build apk --debug başarıyla tamamlandı
- NDK, Build-Tools, Platform 36 otomatik kuruldu
- Fiziksel Android cihazda flutter run ile uygulama çalıştı
- İlk Android build milestone tamamlandı

# Progress - 2026-07-02

## Tamamlananlar
- Fiziksel cihazda uçtan uca test yapıldı
- Supabase pause sorunu tespit edildi ve resume edildi
- Tüm temel akış çalışıyor: onboarding, kayıt, AI zenginleştirme, takvim
- Klavye ve buton sorunları yok
- GitHub Issues'a kaydırma animasyonu iyileştirme notu eklendi

# Progress - 2026-07-04

## Tamamlananlar
- GitHub Issues kuruldu: 5 issue açıldı
- Label'lar oluşturuldu: bug, enhancement, mobile, ui
- v0.2.0 — Stabilizasyon milestone'u kuruldu
- Tüm issue'lar milestone'a bağlandı

# Progress - 2026-07-06

## Tamamlananlar
- progress.md içindeki hatalı satır silindi (#5 kapatıldı)
- BouncingScrollPhysics eklendi: enrich, history, settings ekranları (#1 kapatıldı)
- Wireless debugging kuruldu, USB'siz deploy çalışıyor
- Telefonda test edildi, animasyon onaylandı

# Progress - 2026-07-08

## Tamamlananlar
- flutter analyze: 10 issue → 0 issue
- withOpacity → withValues(alpha:) migration (8 yerde)
- dangling_library_doc_comment düzeltildi (api_service.dart)
- dart format: 14 dosya formatlandı

# Progress - 2026-07-09

## Tamamlananlar
- pubspec.yaml versiyonu 0.2.0+2 olarak güncellendi
- GitHub Issues #1 ve #5 kapatıldı
- README.md güncellendi: versiyon, Android build durumu, kurulum komutu
- v0.2.0 — Stabilizasyon milestone'u tamamlandı

## Hafta 1 Özeti
- Android toolchain kuruldu (SDK, NDK, Command-line Tools)
- İlk Android debug APK build başarılı
- Wireless ADB debugging kuruldu
- Fiziksel cihazda uçtan uca test tamamlandı
- flutter analyze: 10 issue → 0 issue
- dart format: 14 dosya formatlandı
- GitHub Issues + v0.2.0 milestone kuruldu
- BouncingScrollPhysics ile kaydırma animasyonu iyileştirildi


# Progress - 2026-07-10

## Tamamlananlar
- applicationId + namespace: com.example.mobile → com.aynaai (#2)
- MainActivity.kt yeni package'a taşındı (git mv), package satırı güncellendi
- INTERNET izni main manifest'e eklendi — release APK artık backend'e ulaşır (#3)

## Debug notu — web'de boş takvim (CORS)
- Chrome/flutter web'de takvim boştu; kök neden CORS
- Backend allow_origins sabit port istiyor, flutter run rastgele port kullanıyor
- Geçici çözüm: flutter run -d chrome --web-port 8080 (origin allowlist ile eşleşir)
- Android'de CORS yok → ürün hiç bozuk değildi; veri Supabase'de sağlam (29 kayıt)

## Öğrenilen
- namespace (derleme içi) ≠ applicationId (Play Store'da kalıcı kimlik)
- getEntries() hatayı yutup [] dönüyor → "yüklenemedi" ile "veri yok" ayırt edilemiyor