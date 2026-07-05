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