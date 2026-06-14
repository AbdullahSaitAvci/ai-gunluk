# 🏗️ Mimari ve Repo Yapısı — Ayna AI

Bu doküman, projenin klasör yapısını ve bileşenler arası iletişimi açıklar.

## Genel Mimari

```
Kullanıcı (Tarayıcı/Mobil)
        │
        ▼
Flutter Web (Netlify)
        │  HTTP/REST
        ▼
FastAPI Backend (Render)
        │
        ├──→ Supabase (PostgreSQL) — veri saklama
        └──→ Claude Haiku API — AI zenginleştirme
```

## backend/

| Dosya/Klasör | Görev |
|---|---|
| main.py | FastAPI app, CORS, rate limiter, router kayıtları |
| ai_service.py | Claude Haiku API çağrıları, prompt yönetimi, ton rehberi |
| limiter.py | slowapi rate limit yapılandırması |
| constants.py | Ortam değişkenleri (Supabase, Anthropic key) |
| routers/entries.py | Günlük girişleri CRUD (GET/POST /entries) |
| routers/questions.py | Günlük soru üretimi (GET /daily-question) |
| routers/enrich.py | AI zenginleştirme + güvenlik kontrolleri (POST /enrich) |

## mobile/lib/

| Dosya/Klasör | Görev |
|---|---|
| main.dart | Uygulama girişi, Riverpod ProviderScope, Türkçe locale |
| screens/ | Her ekran için ayrı dosya (login, home, entry, enrich, mood, history/takvim, settings, vb.) |
| services/api_service.dart | Backend ile HTTP iletişimi |
| widgets/ | Tekrar kullanılan UI bileşenleri (buton, kart, tema) |

## Veri Akışı: Bir Günlük Girişinin Yolculuğu

1. Kullanıcı Ana Ekran'da günün sorusunu görür (`GET /daily-question`)
2. Entry ekranında ham metnini yazar
3. İki seçenek:
   - **Zenginleştir** → `POST /enrich` → Claude Haiku tonlu metin üretir
   - **Direkt Kaydet** → AI atlanır, ham metin kullanılır
4. Mood seçilir, `POST /entries` ile Supabase'e kaydedilir
5. Takvim ekranında `GET /entries` ile geçmiş görüntülenir

## Güvenlik Katmanları

- **CORS:** Sadece production frontend origin'ine izin verilir
- **Rate Limiting:** `/enrich` endpoint'i dakikada 10 istekle sınırlı (slowapi)
- **Prompt Injection Koruması:** Şüpheli anahtar kelimeler (ignore, forget, system, talimat, vb.) içeren girdiler AI'a gönderilmeden direkt döndürülür
- **Girdi Sınırlama:** raw_text maksimum 500 karakter, tone değeri sabit bir liste ile doğrulanır

---

*Bu doküman YGA Future Talent Modül 301 Bootcamp kapsamında hazırlanmıştır.*
