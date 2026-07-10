# Ayna AI — Yeni Sohbet için Bağlam Notu

**Son güncelleme:** 10 Temmuz 2026 (v0.2.0 stabilizasyon haftası tamamlandı)

Bu dosyayı yeni bir Claude sohbetinin başında paylaş ki kaldığımız yerden devam edilsin.

---

## Proje Özeti

**Ayna AI** — Türkçe, AI destekli mobil günlük uygulaması. Tek cümle: "AI sorar, sen cevaplarsın — gerisini AI halleder." Kullanıcı kısa bir not yazar, seçtiği tonda AI bunu kendi sesini koruyarak zenginleştirir.

YGA Future Talent Programı 301 Modülü kapsamında geliştirildi, 14 Haziran 2026'da teslim edildi, program tamamlandı. **Şimdiki hedef: Play Store'a çıkarmak.**

## Repo ve Canlı Linkler

- **GitHub:** `https://github.com/AbdullahSaitAvci/ai-gunluk` — branch `Abdullah02100/A` (default branch, `main` değil)
- **Backend (canlı):** `https://ayna-ai-backend.onrender.com`
- **Frontend web (canlı):** `https://ayna-ai-yga.netlify.app`
- **API docs (Swagger):** `https://ayna-ai-backend.onrender.com/docs`

**Önemli:** Kod sürekli değişiyor. Claude yeni sohbette önce `git clone` ile repo'yu çekip güncel hâli görmeli — **GitHub tek doğru kaynak.**

## Tech Stack

| Katman | Teknoloji |
|---|---|
| Frontend | Flutter/Dart, Riverpod, web + **Android (debug build çalışıyor)** |
| Backend | FastAPI (Python), Render'da deploy |
| Veritabanı | Supabase (PostgreSQL + RLS) |
| AI | Claude Haiku (`claude-haiku-4-5`), vendor-agnostic katman (`backend/ai_service.py`) |
| Güvenlik | CORS kısıtlaması, slowapi rate limiting, regex prompt injection filtresi |

## Repo Yapısı

```
ai-gunluk/
├── backend/              # FastAPI, routers/, ai_service.py
├── mobile/               # Flutter, lib/screens/, lib/widgets/
├── prodocs/              # PRD.md, MVP.md, plan.md, progress.md, tech-stack.md, DesignSystem.md
├── docs/ARCHITECTURE.md
├── .env.example
└── README.md
```

---

## ✅ Tamamlanan: Hafta 1 — Stabilizasyon (v0.2.0)

- Android toolchain kuruldu (Android Studio, SDK, NDK, Command-line Tools)
- **İlk Android debug APK build başarılı** — `flutter build apk --debug`
- Fiziksel cihazda (Samsung Galaxy) uçtan uca test tamamlandı, tüm akış çalışıyor
- **Wireless ADB debugging kuruldu** — USB'siz deploy çalışıyor (`adb pair` + `adb connect`)
- `flutter analyze`: 10 issue → **0 issue** (`withOpacity` → `withValues(alpha:)` migration dahil)
- `dart format`: 14 dosya formatlandı
- GitHub Issues + `v0.2.0 — Stabilizasyon` milestone kuruldu, label'lar tanımlandı
- `BouncingScrollPhysics` eklendi (enrich, history, settings ekranları)
- Versiyon: `pubspec.yaml` → `0.2.0+2`

---

## 🔜 Sıradaki: Hafta 2 / 1. Ay — Auth ve Mobil Temel

**Açık GitHub Issue'ları:**

- **#2 — `applicationId` placeholder değiştirilmeli.** Şu an `com.example.mobile`. Play Store'a çıkınca **asla değiştirilemez.** Öneri: `com.abdullahsaitavci.aynaai`
- **#3 — INTERNET izni release manifest'ine eklenmeli.** `mobile/android/app/src/main/AndroidManifest.xml` içinde yok. Debug'da çalışıyor ama **release APK backend'e ulaşamaz.**
- **#4 — Supabase pause kalıcı çözüm.** Ücretsiz tier düzenli pause oluyor.

**Roadmap'in 1. ay hedefleri:**
- Supabase Auth ile gerçek Google girişi
- RLS'i gerçek `user_id`'ye göre düzenle (şu an herkes `anonymous`)
- Uygulama ikonu, splash screen, marka kimliği
- Temel hata/offline durumu yönetimi

---

## Bilinen Kısıtlamalar / Mimari Kararlar

- **Auth:** Demo modunda ("Demo Olarak Giriş Yap" tek buton). Tüm kayıtlar `user_id: "anonymous"`.
- **Render free tier:** 15 dk hareketsizlikte uyur, cron-job.org ile 10 dk'da bir `/health` ping.
- **Supabase free tier:** Düzenli pause oluyor, dashboard'dan manuel resume gerekiyor. Veri kaybı yok.
- **Supabase region:** Singapur (ap-southeast-1), Türkiye'ye ~200-400ms gecikme.
- **Mood verisi:** `_moodToScore`/`_moodFor` emoji↔sayı dönüşümü (1=😢, 2=😠, 3=😴, 4=🤩, 5=😊) — `api_service.dart` ve `history_screen.dart` arasında **tutarlı olmalı**, daha önce bug çıkmıştı.
- **AI prompt:** `ai_service.py`'deki `_SYSTEM_PROMPT` kullanıcının sesini koruyacak sıkı kısıtlamalarla yazıldı. 5 ton: Neşeli, Hüzünlü, Minnettar, Motive, Sakin.
- **Versiyonlama:** `0.x.x` (geliştirme) → `1.0.0` (Play Store ilk yayın)

---

## Çalışma Tarzı (Abdullah'ın tercihleri)

- **Adım adım** ilerleme — bir seferde tek görev, tamamlayıp rapor eder, sonra devam
- **Önce anlama, sonra uygulama** — "neden" sorusuna önem veriyor, black-box talimat istemiyor
- Her görev = ayrı commit, semantic commit mesajı (`feat:`/`fix:`/`docs:`/`chore:`)
- Her oturum sonunda `progress.md`'ye not
- Üniversite 3. sınıf seviyesine uygun açıklama, kod satırlarında yorum
- **Türkçe yanıt**
- Bütçe bilinçli — ücretsiz tier tercihi

### Model / Thinking Seçim Çerçevesi

Abdullah her oturum sonunda bir sonraki oturum için **model + thinking + effort** önerisi bekliyor.

- **Model seviyesi = zekâ tavanı** (problemi ne kadar derinden kavradığı)
- **Thinking = düşünme süresi** (dikkat ve tutarlılık; tavanı yükseltmez)

Karar kuralı:
- Yaklaşım doğru ama edge-case atlanmış / dosyalar arası tutarsızlık var → **thinking aç, model aynı kalsın**
- Model problemi temelden yanlış anlıyor, jenerik öneriler veriyor → **üst modele geç**

Pratik politika:
- **Sonnet, thinking kapalı/düşük:** rutin kod, net spec'ten implementasyon, formatlama, dokümantasyon
- **Sonnet, thinking medium:** çok dosyalı refactor, build/dependency hata ayıklama, tutarlılık gerektiren değişiklikler
- **Opus, thinking high:** geri dönüşü zor tasarım kararları (mimari, auth akışı, `applicationId`), inatçı bug'lar, Sonnet+thinking dönüp duruyorsa

---

## 🗓 Bir Sonraki Oturum için Önerilen Parametreler

| Parametre | Değer |
|---|---|
| **Model** | Opus |
| **Thinking** | Açık |
| **Effort** | High |

**Neden:** Sıradaki iş `applicationId` kararı (#2) ve Supabase Auth mimarisi. İkisi de **geri dönüşü zor tasarım kararları** — `applicationId` Play Store'da kalıcı, Auth yapısı tüm RLS'i etkiliyor. Derin kavrama gerektiriyor, thinking ile tradeoff'lar atlanmadan ele alınmalı.

---

**Yeni sohbete başlarken ilk mesaj örneği:**

> "Ayna AI projesine devam ediyorum, bu bağlam dosyasını okudun. Repo'yu klonlayıp güncel durumu kontrol eder misin? Hafta 2'ye başlıyorum — issue #2 (applicationId) ve #3 (INTERNET izni) ile devam edelim."
