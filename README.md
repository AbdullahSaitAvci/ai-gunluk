# 🪞 Ayna AI — AI Destekli Günlük Uygulaması

> *"AI sorar, sen cevaplarsın — gerisini AI halleder."*

Ayna AI, "boş sayfa korkusunu" ortadan kaldıran Türkçe bir günlük asistanıdır. Her gün sana kişiselleştirilmiş bir soru sorar, sen kısa bir cevap yazarsın — AI bunu anlamlı bir günlük girişine dönüştürür.

---

## 🚀 Özellikler (v1.0 MVP)

- 🤖 **AI Dinamik Soru Motoru** — Geçmiş cevaplara göre kişiselleştirilmiş Türkçe sorular
- ✍️ **Metin Zenginleştirme** — 3 kelimeyi anlamlı bir günlüğe dönüştür (Stoacı / Neşeli / Sade)
- 🔐 **Biyometrik Kilit** — FaceID / Parmak izi ile gizlilik garantisi
- ☁️ **Bulut Senkronizasyonu** — Verilerini kaybetme
- 🔔 **Akıllı Bildirim** — Günlük yazma alışkanlığı kazan

---

## 🛠️ Tech Stack

| Katman | Teknoloji |
|---|---|
| Mobil | Flutter (iOS + Android) |
| Backend | FastAPI (Python 3.11+) |
| Veritabanı | Supabase (PostgreSQL) |
| AI | Gemini API (vendor-agnostic yapı) |
| Deploy | Play Store |

---

## 📁 Proje Yapısı

```
ai-gunluk/
├── PRD.md            # Ürün Gereksinim Dokümanı
├── MVP.md            # MVP Kapsamı ve Özellik Listesi
├── plan.md           # Geliştirme Planı
├── progress.md       # Geliştirme İlerleme Kaydı
├── .cursorrules      # Cursor AI kuralları
├── backend/          # FastAPI backend
│   ├── main.py       # Ana uygulama + /health endpoint
│   ├── ai_service.py # AI katmanı (vendor-agnostic)
│   ├── constants.py  # Sabitler
│   ├── routers/      # API endpoint'leri
│   ├── requirements.txt
│   └── .env.example  # Ortam değişkeni şablonu
└── mobile/           # Flutter uygulaması
    └── lib/
        └── main.dart
```

---

## ⚙️ Kurulum ve Çalıştırma

### Gereksinimler
- Python 3.11+
- Flutter 3.41+
- Git

### Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8080
```

Çalıştıktan sonra:
- **Health check:** http://localhost:8080/health
- **Swagger UI:** http://localhost:8080/docs

### Frontend (Mobil)

```bash
cd mobile
flutter pub get
flutter run -d chrome
```

---

## 📄 Dokümantasyon

- [PRD.md](./PRD.md) — Ürün gereksinimleri, teknik mimari, API tasarımı
- [MVP.md](./MVP.md) — MVP kapsamı, Eisenhower matrisi, versiyonlama
- [plan.md](./plan.md) — 5 fazlı geliştirme planı

---

## 🎓 Hakkında

Bu proje **YGA Future Talent Programı — Modül 301 Bootcamp** kapsamında geliştirilmektedir.

**Geliştirici:** Abdullah Sait Avcı
**Üniversite:** Sakarya Üniversitesi, Bilgisayar Mühendisliği

---

## 📊 Durum

🚧 **Geliştirme aşamasında** — v1.0 MVP

| Bileşen | Durum |
|---|---|
| PRD & MVP | ✅ Tamamlandı |
| Geliştirme Planı | ✅ Tamamlandı |
| Backend İskeleti | ✅ Çalışıyor |
| Frontend İskeleti | ✅ Çalışıyor |
| Supabase Kurulumu | 🔄 Devam ediyor |
| AI Entegrasyonu | 🔄 Devam ediyor |
| Play Store Beta | ⏳ Planlandı |