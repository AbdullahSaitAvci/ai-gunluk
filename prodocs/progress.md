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


# Progress - 2026-07-10 (Gün 9)

## Tamamlananlar
- getEntries() artık hatayı yutmuyor: ApiException fırlatıyor (network/timeout/sunucu ayrı mesajlar)
- Soğuk başlangıç için tek seferlik retry: 30sn ilk deneme → başarısızsa 45sn ikinci deneme
- Takvimde error: dalı gerçek hata mesajı + "Tekrar Dene" butonu (ref.invalidate) gösteriyor
- Pull-to-refresh eklendi: Column+Expanded → ListView, RefreshIndicator ile sarıldı
- _refreshablePhysics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()) — bounce hissi korundu
- Telefonda (wireless ADB) test edildi: yenileme efekti ve fonksiyonu çalışıyor
- Commit'ler: 7a9930c (hata yönetimi), db43a52 (pull-to-refresh)

## Tespit edilen / açılan
- Issue #6: Günlük kaydı sonrası state temizlenmiyor (entryTextProvider vb. StateProvider'lar reset edilmiyor, mood_screen _save() whenComplete'inde temizlik yok)

## Öğrenilen
- FutureProvider (autoDispose değil) ilk sonucu cache'ler; RefreshIndicator scrollable child ister
- Claude Code: /model ve /effort AYRI mesajlar olmalı, "|" ile zincirlenmez; ayrı thinking komutu yok (effort = thinking derinliği)
- Web'deki CORS sorunları Android'de yok — Play Store hedefi için web sadece hızlı önizleme


# Progress - 2026-07-12 (Gün 10)

## Tamamlananlar
- Issue #6 çözüldü: SuccessScreen artık ConsumerWidget
- "Ana Sayfaya Dön" tıklanınca entryTextProvider, selectedToneProvider,
  selectedMoodProvider, enrichedTextProvider ref.invalidate() ile sıfırlanıyor
- Reset noktası bilinçli olarak success_screen'de seçildi (mood_screen._save()
  değil) — çünkü _save() sonrası normal pushNamed kullanılıyor, stack
  temizlenmiyor; erken reset, altta mount'lu duran EnrichScreen'de gereksiz
  bir AI zenginleştirme API çağrısı tetikleyebilirdi
- Telefonda (wireless ADB) manuel test edildi, doğrulandı
- Branch ismi düzeltildi: Abdullah02100/A → main (GitHub'da rename edilmişti,
  lokal git senkronize edildi)

## Öğrenilen
- ref.invalidate() bir provider'ı kendi tanımındaki başlangıç değerine
  döndürür — manuel .state = x atamaktan daha az hataya açık
  (varsayılan değişirse tek yerden güncellenir)
- Reset noktası seçimi kritik: "hangi an state'i temizlemek güvenli" sorusu,
  o an hangi widget'ların hâlâ mount'lu olduğuna bağlı
- GitHub'da branch rename yapınca lokal git otomatik senkronize olmuyor;
  git branch -m + fetch --prune + push -u gerekiyor


# Progress - 2026-07-13 (Gün 11)

## Tamamlananlar
- Issue #4 çözüldü: /health endpoint'ine Supabase keep-alive sorgusu eklendi
- entries tablosundan select("id").limit(1) — minimal veri, gerçek "aktivite"
- try/except: hata olsa bile /health her zaman 200 döner (Render kontrolü
  Supabase durumundan bağımsız kalıyor)
- Yanıta "supabase": "ok"/"unreachable" alanı eklendi (görünürlük için)
- Lokalde (uvicorn) ve canlıda (curl) doğrulandı
- Commit push edildi, Render otomatik deploy oldu

## Öğrenilen
- Supabase resmi dokümantasyonu: ücretsiz tier, son 1 hafta içinde yeterli
  veritabanı aktivitesi almazsa pause oluyor; günde birkaç istek bile yeterli
- Zaten var olan cron altyapısı (cron-job.org → /health) genişletilerek yeni
  bir servise gerek kalmadan iki ayrı "uyuma" sorunu (Render + Supabase)
  tek ping ile çözülebiliyor
- Bu fix mevcut pause'u geri açmaz — sadece gelecekteki pause'ları önler


# Progress - 2026-07-15 (Gün 12)

## Tamamlananlar
- Auth mimarisi kararı verildi ve ADR-1 olarak plan.md'ye yazıldı:
  Flutter → Supabase Auth (Seçenek A), backend proxy reddedildi
- Mevcut durum analizi: supabase_flutter yok, login mock, user_id TEXT
  "anonymous", GET /entries auth'suz herkese açık (güvenlik açığı tespiti)
- 5 günlük iş bölümlemesi çıkarıldı (konsol → Flutter → backend → RLS)

## Öğrenilen
- Supabase'in tasarım modeli: client SDK doğrudan Auth ile konuşur,
  anon key + RLS birlikte güvenli; backend proxy SDK'nın çözdüğü her
  şeyi (refresh, session, PKCE) elle yazmak demek
- RLS "yeni özellik" değil — mevcut açığın kapatılması; ama en son
  açılmalı, yoksa auth hazır olmadan her şey kilitlenir
- Geri dönüşü zor karar (mimari) ile döndürülebilir karar (native vs
  browser OAuth) ayrımı: ilki bugün kilitlendi, ikincisi Gün 14'e esnek


# Progress - 2026-07-16 (Gün 13)

## Tamamlananlar
- Google Cloud Console: mevcut "ai-gunluk" projesi (Gemini API key için
  açılmıştı) yeniden kullanıldı, dokunulmadı
- OAuth consent screen (Google Auth Platform): Branding, Audience (External),
  Contact bilgileri dolduruldu
- Android OAuth Client oluşturuldu: package com.aynaai + debug SHA-1
- Web OAuth Client oluşturuldu: Client ID + Secret alındı (Supabase için)
- Supabase Dashboard → Authentication → Providers → Google aktif edildi,
  Web Client ID + Secret girildi
- Redirect URI (https://voetvwldxfumcufxpkht.supabase.co/auth/v1/callback)
  Google Cloud'daki Web Client'ın Authorized redirect URIs'ine eklendi

## Öğrenilen
- native google_sign_in + signInWithIdToken akışı için 2 ayrı OAuth Client
  gerekiyor: Android (SHA-1 doğrulama için) + Web (Supabase'in token'ı
  doğrulaması için) — Android uygulaması giriş yapıyor ama Supabase'e
  verilen ID bir Web client'ının ID'si, kontrintuitif ama doğru
- SHA-1 debug fingerprint hassas bilgi değil (public sertifika özeti,
  private key'e geri çevrilemez) — release keystore'un SHA-1'i de aynı
  şekilde güvenle paylaşılabilir, ama release keystore DOSYASININ kendisi
  ve şifresi kesinlikle gizli tutulmalı
- Google'ın yeni arayüzü: eski "OAuth consent screen" artık "Google Auth
  Platform" altında Branding/Audience/Clients/Data Access sekmelerine bölünmüş
- Release build günü (Play Store yayını) için NOT: bugünkü Android client
  sadece DEBUG SHA-1 ile kayıtlı; release keystore'un SHA-1'i ayrıca
  eklenmeli, yoksa release APK'da Google girişi çalışmaz