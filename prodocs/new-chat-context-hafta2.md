# Ayna AI — Yeni Sohbet için Bağlam Notu

**Son güncelleme:** 2. hafta bitişi (Gün 8-14 tamamlandı)

---

## Proje Özeti

**Ayna AI** — Türkçe, AI destekli mobil günlük uygulaması.
"AI sorar, sen cevaplarsın — gerisini AI halleder."

YGA Future Talent 301 Modülü kapsamında geliştirildi, teslim edildi.
**Şimdiki hedef: Play Store'a çıkarmak.**

## Repo ve Canlı Linkler

- **GitHub:** `https://github.com/AbdullahSaitAvci/ai-gunluk` — branch **`main`**
  (eski `Abdullah02100/A` branch'i main'e taşındı, artık tek branch)
- **Backend:** `https://ayna-ai-backend.onrender.com`
- **Frontend web:** `https://ayna-ai-yga.netlify.app`
- **Supabase proje:** `https://voetvwldxfumcufxpkht.supabase.co`

**Önemli:** Claude yeni sohbette önce repo'yu klonlayıp güncel hâli görmeli —
GitHub tek doğru kaynak.

## Tech Stack

| Katman | Teknoloji |
|---|---|
| Frontend | Flutter/Dart, Riverpod, web + Android |
| Backend | FastAPI (Python), Render |
| Veritabanı | Supabase (PostgreSQL) |
| Auth | Supabase Auth + google_sign_in v7 (native) |
| AI | Claude Haiku (`claude-haiku-4-5`), vendor-agnostic katman |

---

## ✅ Tamamlanan: Hafta 2 (Gün 8-14)

- **Gün 8:** `applicationId` + `namespace` → `com.aynaai` (#2, kalıcı karar),
  INTERNET izni main manifest'e (#3). Web'de boş takvim bug'ı teşhis edildi:
  CORS + rastgele port (Android'de yok, sadece web sorunu).
- **Gün 9:** `getEntries()` hatayı yutmuyor (ApiException), cold-start retry
  (30sn→45sn), "Tekrar Dene" butonu, pull-to-refresh (ListView'a geçildi).
- **Gün 10:** Issue #6 — kayıt sonrası state reset (SuccessScreen'de 4 provider
  `ref.invalidate()`). Branch `main` olarak düzeltildi.
- **Gün 11:** Issue #4 — `/health` endpoint'ine Supabase keep-alive sorgusu
  (mevcut cron-job.org ping'i artık Supabase'i de canlı tutuyor).
- **Gün 12:** **ADR-1 kararı** — Auth mimarisi: Flutter → Supabase Auth
  (backend proxy reddedildi). `plan.md`'de kayıtlı.
- **Gün 13:** Google Cloud Console + Supabase konsol kurulumları
  (Android + Web OAuth client, SHA-1, redirect URI).
- **Gün 14:** **Gerçek Google girişi çalışıyor.** `google_sign_in` v7 +
  `signInWithIdToken`. Splash oturum kontrolü (giriş yapılmışsa direkt Home).
  Telefonda uçtan uca doğrulandı.

**Kapanan issue'lar:** #2, #3, #4, #6

---

## 🔜 Sıradaki: Gün 15 — Backend JWT Doğrulama

Bu, ADR-1'in en kritik teknik adımı. Kararlaştırılması gerekenler:

- **JWT doğrulama yöntemi:** lokal (PyJWT) tercih ediliyor — her istekte
  Supabase'e sormak Singapur gecikmesi (+200-400ms) ekler. İmza türü
  (HS256 secret mi, JWKS mi) Supabase projesinin yaşına bağlı, dashboard'dan
  bakılacak.
- **`user_id` migration:** TEXT `"anonymous"` → UUID (PRD'ye dönüş).
  Mevcut ~29 test kaydının kaderi (kendi UUID'ye taşı / sil) karar bekliyor.
- **Demo girişi kaldırılacak** (RLS'te istisna = güvenlik deliği).
- **RLS EN SON açılacak** — erken açılırsa geliştirme kilitlenir.

**Açık issue:** Logout (çıkış) özelliği yok — settings_screen'e
`auth.signOut()` + stack temizleyerek LoginScreen'e dönüş.

**Bilinen güvenlik açığı (henüz açık):** `GET /entries/` auth'suz, herkese
tüm günlükleri döndürüyor. Play Store öncesi kapanması zorunlu.

---

## Bilinen Kısıtlamalar / Notlar

- **Render free tier:** 15 dk'da uyur, cron-job.org 10 dk'da bir `/health` ping.
- **Supabase free tier:** 1 hafta aktivite yoksa pause; `/health` sorgusu bunu önlüyor.
- **Web'de CORS:** `flutter run -d chrome --web-port 8080` kullanılmalı
  (backend allowlist'te sadece 8080 ve 51926 var). Android'de bu sorun yok.
- **Debug logları:** `login_screen.dart`'ta `debugPrint`'ler var, Play Store
  öncesi genel temizlikte kaldırılacak.
- **Release keystore SHA-1** henüz Google Console'a eklenmedi — release APK'da
  Google girişi çalışmaz, Play Store yayın günü eklenmeli.
- **Mood verisi:** emoji↔sayı dönüşümü (1=😢, 2=😠, 3=😴, 4=🤩, 5=😊)
  `api_service.dart` ve `history_screen.dart` arasında tutarlı olmalı.

---

## Çalışma Kuralları (kalıcı)

**Araçlar:**
- VS Code içinde **Claude Code** (Cursor KULLANILMIYOR)
- Kod değişiklikleri Claude Code'a net prompt olarak verilir
- **git commit/push: Claude Code'dan DEĞİL, elle terminalden** (repo kökü `~/ai-gunluk`)
- Issue yönetimi: `gh` CLI kurulu (`gh issue create/close/list`)

**Model/effort (Claude Code):**
- `/model` ve `/effort` **AYRI mesajlar** olarak verilir (aynı satırda zincirlenmez)
- Claude Code'da ayrı "thinking" komutu yok — effort thinking derinliğini kapsar
- Rutin: sonnet+low | Çok dosyalı: sonnet+medium | Geri dönüşü zor karar: opus+high

**Oturum ritmi:**
- Adım adım: bir görev, tamamla, rapor et, sonra devam
- Önce "neden", sonra uygulama
- Her görev = ayrı commit (feat/fix/docs/chore)
- **Her gün sonunda `progress.md`'ye o günün girişi**
- **Her gün sonunda kapanış özeti:** (1) bugün ne bitti, (2) sonraki gün ne,
  (3) **web tarayıcısı Claude için** Model + Thinking (Açık/Kapalı) + Effort tablosu
- Bir "Gün" birden fazla oturuma yayılabilir — sadece Abdullah "Gün X+1'e
  başlayalım" derse yeni güne geçilir

**Test:**
- Telefon (wireless ADB): `adb connect <ip>:<port>` → `flutter run -d <device-id>`
- `flutter run` açık bırakılıp `r` ile hot reload kullanılmalı (her seferinde
  baştan build çok yavaş)

---

## 🗓 Bir Sonraki Oturum için Önerilen Parametreler (web Claude)

| Parametre | Değer |
|---|---|
| **Konu** | Gün 15 — Backend JWT doğrulama + user_id migration planı |
| **Model** | Opus |
| **Thinking** | Açık |
| **Effort** | Yüksek |

**Neden:** Birden fazla geri dönüşü zor alt karar var (JWT imza türü, migration
stratejisi, RLS politikaları). Gün 12'deki gibi önce derin analiz, sonra kod.

---

**Yeni sohbete başlarken ilk mesaj örneği:**

> "Ayna AI projesine devam ediyorum, bu bağlam dosyasını okudun. Repo'yu
> klonlayıp güncel durumu kontrol eder misin? Gün 15'e başlıyorum —
> backend JWT doğrulama ve user_id migration."