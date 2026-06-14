# Tech Stack ve Geliştirme Sürecinde AI Kullanımı

## Kullanılan Teknolojiler ve Gerekçeleri

| Katman | Teknoloji | Neden Seçildi |
|---|---|---|
| Frontend | Flutter (Dart), web build | Tek kod tabanından mobil + web; Riverpod ile öngörülebilir state yönetimi |
| Backend | FastAPI (Python) | Async destekli, hızlı prototipleme, Python bilgisiyle uyumlu |
| Veritabanı | Supabase (PostgreSQL + RLS) | Ücretsiz tier, hazır auth altyapısı, Row Level Security ile veri izolasyonu |
| AI | Claude Haiku (Anthropic API) | Türkçe performansı iyi, düşük maliyetli, vendor-agnostic katman (ai_service.py) ile değiştirilebilir |
| State Management | Riverpod (FutureProvider, StateProvider) | Async veri ve UI state'i ayrı ayrı, test edilebilir yönetim |
| Backend Deploy | Render (ücretsiz tier) | Python uygulamalarını doğrudan çalıştırabiliyor, GitHub entegrasyonu |
| Frontend Deploy | Netlify | Statik Flutter web build'i için hızlı CDN, ücretsiz, GitHub entegrasyonu |
| Güvenlik | slowapi (rate limiting), özel CORS, regex tabanlı prompt injection filtresi | /enrich endpoint'ini kötüye kullanıma karşı korumak |

## Vendor-Agnostic AI Mimarisi

Tüm AI çağrıları backend/ai_service.py üzerinden tek noktadan yapılıyor. Sistem promptu, ton rehberi (_TONE_GUIDE) ve model adı bu dosyada merkezi. Farklı bir AI sağlayıcısına (örn. OpenRouter, Gemini) geçiş, sadece bu dosyanın değiştirilmesini gerektirir — endpoint'ler ve frontend etkilenmez.

## Geliştirme Sürecinde AI Kullanımı

Bu proje, AI destekli geliştirme sürecinin uçtan uca bir örneği olarak tasarlandı:

- **Cursor (Agent/Composer Mode):** PRD.md ve plan.md, proje köküne yerleştirilen .cursorrules ile birlikte Cursor'a referans olarak verildi. Cursor Composer, plan.md'deki fazları takip ederek ekran ve endpoint iskeletlerini oluşturdu.
- **Claude (sohbet asistanı):** Mimari kararlar (Render/Netlify ayrımı, Supabase RLS, vendor-agnostic AI katmanı), hata ayıklama (CORS, prompt injection, mood-skor eşleme bug'ları, Flutter build hataları) ve adım adım git workflow için kullanıldı. "Human in the loop" prensibiyle her adımda küçük, açıklamalı promptlar Cursor'a verildi, çıktılar incelenip commit edildi.
- **Claude Haiku (üretim AI'ı):** Uygulamanın kendisinde, kullanıcı günlük metnini seçilen tona göre yeniden ifade eden /enrich endpoint'inde kullanılıyor. Sistem promptu, kullanıcının kendi sesini koruyacak şekilde sıkı kısıtlamalarla (maks. 2-3 cümle, kelime sayısı sınırı, "kullanıcının söylemediğini ekleme") tasarlandı.
- **İterasyon örneği:** İlk AI promptları çok "felsefi/şiirsel" çıktılar üretiyordu; geri bildirimle prompt aşamalı olarak sıkılaştırıldı ve son haliyle kullanıcının orijinal metnine sadık, kısa çıktılar üretmeye başladı.

## Bilinen Sınırlamalar ve Sonraki Adımlar

- Auth (Google/Apple) şu an demo modunda; Supabase Auth + RLS ile kullanıcı bazlı veri izolasyonu v2'de planlanıyor.
- Render ücretsiz tier'ın uyku moduna girmesini önlemek için cron-job.org ile periyodik ping kullanılıyor.
