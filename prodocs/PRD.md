# 📝 Ürün Gereksinim Dokümanı (PRD): Ayna AI
**Product Requirements Document**
**Hazırlayan:** Abdullah Sait Avcı
**Program:** YGA Future Talent — Modül 301 Bootcamp
**Tarih:** Nisan 2026
**Versiyon:** v1.0 (MVP)
**Durum:** Taslak

---

## 1. Ürün Özeti

**Ayna AI**, kullanıcıların "boş sayfa" korkusunu yenmelerini sağlayan, yapay zeka destekli akıllı bir günlük asistanıdır. Her gün kişiselleştirilmiş bir soru sorar, kullanıcı kısa bir cevap yazar, AI bu ham cevabı kullanıcının kendi ses tonunu koruyarak anlamlı ve yapılandırılmış bir günlük girişine dönüştürür.

**Temel felsefe:** AI kullanıcı adına yazmaz — kullanıcının ham duygusunu "parlatır." Ghostwriting değil, yansıtma.

**Temel odak:** Yerelleşme (Türkçe), gizlilik, minimum eforla maksimum farkındalık.

---

## 2. Hedef Kullanıcı ve Persona

**Birincil hedef:** 20–35 yaş arası, Türkiye'de yaşayan, kişisel gelişime ilgi duyan bireyler.

**İkincil hedef:** Daha önce günlük tutmayı deneyip bırakan, kendini geliştirmek isteyen ama bunun için çok zaman ayıramayan herkes.

**Persona: Melis (26, Beyaz Yakalı)**
- İstanbul'da çalışıyor, akşam eve yorgun geliyor
- Günlük tutmak istiyor ama boş sayfaya bakınca vazgeçiyor
- Podcast dinliyor, kendini geliştirmek istiyor
- Telefonu hayatının merkezinde
- "Günlüğüm okunur mu?" diye düşünüyor — gizlilik hassasiyeti yüksek
- **İhtiyacı:** Birinin ona soru sorması ve 3-5 kelimelik karmaşık duygularını toparlaması

**Not:** Bu persona tasarım odak noktamızdır. Uygulama her yaştan kullanıcıya açık olacak.

---

## 3. Çözülen Problemler

| Problem | Mevcut Durum | Bizim Çözümümüz |
|---|---|---|
| Boş sayfa korkusu | Kullanıcı ne yazacağını bilemez, bırakır | AI dinamik soru sorar, yazma bariyerini yıkar |
| Tutarsız kullanım | Çoğu günlük uygulaması terk edilir | Günlük bildirim + tek soruluk alışkanlık |
| AI kullanıcı adına yazıyor hissi | Sahiplik duygusu kaybolur | AI parlatır, kullanıcının sesi korunur |
| Gizlilik kaygısı | "Günlüğüm okunur mu?" korkusu | Biyometrik kilit + şeffaf veri politikası |
| Pahalı rakipler | Day One $34.99/ay, İngilizce | Türkçe, ücretsiz başlangıç katmanı |
| Ham notlar değersiz kalır | Yazdıklarını kimse tekrar okumaz | AI zenginleştirir, aylık özet çıkarır |

---

## 4. MVP Kapsamı (v1.0)

### 4.1 Dahil Olanlar (Must-Have)

**Kimlik Doğrulama:**
- Google / Apple ID ile tek tık giriş (Supabase Auth)
- Biyometrik kilit (FaceID / Parmak izi) — Türkiye'deki gizlilik kaygısı için kritik

**Günlük Akışı (Magic Flow):**
- Uygulama açılınca günün AI sorusu ekranda
- Kullanıcı kısa metin cevabı yazar (max 500 karakter)
- Ton seçimi: Stoacı / Neşeli / Sade (3 seçenek)
- "Zenginleştir" butonuyla AI metni işler (yükleme animasyonu)
- Dönüştürülmüş günlük gösterilir, kullanıcı onaylar veya düzenler
- Emoji bazlı duygu seçimi (😄 😊 😐 😟 😢)
- Giriş kaydedilir

**Soru Motoru:**
- Kullanıcının geçmiş cevaplarına göre kişiselleştirilmiş sorular
- Hafta sonu soruları hafta içinden farklı
- Soru kategorileri: bugün nasıl hissettim, ne öğrendim, neyi farklı yapardım, minnettar olduğum şey

**Geçmiş ve Özet:**
- Timeline (kart yapısında geçmiş günlükler)
- Takvim bazlı görünüm
- Aylık duygu özeti: "Bu ay en çok 😊 hissettiniz"
- AI aylık özet paragrafı

**Bildirim:**
- Günlük tek push notification (kullanıcı saati seçer)

### 4.2 Dahil Olmayanlar (v2 ve Sonrası)

- Sesli günlük (Speech-to-Text) — v2 büyüme kaldıracı
- Spotify / sağlık verisi entegrasyonu
- Sosyal paylaşım kartları
- Fiziksel günlük baskısı
- Haftalık detaylı analiz raporları
- Çoklu dil desteği (İngilizce)
- Widget (ana ekrandan hızlı giriş)
- Tema / renk kişiselleştirme

---

## 5. Teknik Mimari

```
┌─────────────────────────────────────────────┐
│           FLUTTER MOBİL UYGULAMA             │
│     (iOS + Android, Play Store öncelikli)    │
└──────────────────┬──────────────────────────┘
                   │ HTTP (REST)
┌──────────────────▼──────────────────────────┐
│           FASTAPI BACKEND (Python)           │
│  • /auth          → kullanıcı yönetimi      │
│  • /daily-question → AI soru üret           │
│  • /process-entry → ham metni zenginleştir  │
│  • /entries       → CRUD işlemleri          │
│  • /summary       → aylık özet              │
└───────────┬──────────────────┬──────────────┘
            │                  │
┌───────────▼──────┐  ┌────────▼───────────────┐
│ SUPABASE         │  │ AI KATMANI             │
│ • PostgreSQL DB  │  │ • Gemini 1.5 Flash     │
│ • Auth           │  │ • Vendor-agnostic yapı │
│ • Row Level Sec. │  │   (ai_service.py ile   │
│ • Real-time DB   │  │    provider değişimi)  │
└──────────────────┘  └────────────────────────┘
```

**Stack Kararları:**

| Bileşen | Seçim | Neden |
|---|---|---|
| Mobil | Flutter | Tek kodla iOS + Android |
| Backend | FastAPI | Python bilgisi; async; hızlı prototipleme |
| DB & Auth | Supabase | PostgreSQL + Auth hazır + ücretsiz tier |
| AI | Gemini 1.5 Flash | Türkçe yüksek, düşük gecikme, ücretsiz tier |
| Deploy | Play Store | Türkiye pazarı odağı |

---

## 6. Kullanıcı Akışı

```
Splash & Onboarding (gizlilik vurgulu, 3 ekran)
        │
        ▼
Google / Apple ile Giriş (Supabase Auth)
        │
        ▼
Ana Ekran (Timeline) → Geçmiş günlükler + "Bugün Nasılsın?" butonu
        │
        ├─ [Bugün Nasılsın?] ──→ AI sorusu gösterilir
        │                            │
        │                        Kullanıcı cevap yazar
        │                            │
        │                        Ton seçimi (Stoacı/Neşeli/Sade)
        │                            │
        │                        [Zenginleştir] → AI işler
        │                            │
        │                        Önizleme ekranı → Onayla/Düzenle
        │                            │
        │                        Emoji duygu seçimi
        │                            │
        │                        [Kaydet] → Veritabanına yaz
        │                            │
        │                        Tamamlandı animasyonu
        │
        ├─ [Geçmiş] ───→ Timeline / Takvim → Giriş detayı
        │
        └─ [Özet] ─────→ Aylık duygu grafiği + AI özeti
```

---

## 7. Ekran Listesi

| # | Ekran | Açıklama |
|---|---|---|
| 1 | Splash / Onboarding | Gizlilik vurgulu 3 tanıtım ekranı |
| 2 | Auth | Google / Apple giriş |
| 3 | Ana Ekran (Timeline) | Kart yapısında geçmiş + "Bugün Nasılsın?" |
| 4 | Entry (Yazma) | AI sorusu + metin alanı + ton seçimi |
| 5 | Review (Önizleme) | AI çıktısı + onayla/düzenle |
| 6 | Duygu Seçimi | Emoji seçimi + kaydet |
| 7 | Geçmiş (Takvim) | Takvim + liste görünümü |
| 8 | Giriş Detayı | Tek günlük okuma ekranı |
| 9 | Aylık Özet | Duygu grafiği + AI özeti |
| 10 | Ayarlar | Biyometrik kilit, bildirim saati, hesap |

---

## 8. API Endpoint Tasarımı (FastAPI)

```
POST /auth/register-login     → Supabase entegreli kullanıcı yönetimi

GET  /daily-question          → Kullanıcı geçmişine göre AI soru üretir
     Response: { question: string, category: string }

POST /process-entry           → Ham metni Gemini ile zenginleştirir
     Request:  { raw_text: string, tone: "stoic|joyful|plain" }
     Response: { enriched_text: string, token_usage: int }

GET  /entries                 → Geçmiş günlükler (sayfalı)
     Response: { entries: [...], total: int, page: int }

POST /entries                 → Yeni günlüğü kaydeder
     Request:  { question, raw_text, enriched_text, mood, tone }

GET  /entries/{id}            → Tek giriş detayı

GET  /summary/monthly         → Aylık özet (AI üretir)
     Response: { summary: string, mood_stats: {...} }
```

---

## 9. Veritabanı Şeması (Supabase)

```sql
-- Kullanıcılar (Supabase Auth yönetir)
Table users {
  id                uuid [pk]
  email             varchar
  biometric_enabled boolean [default: false]
  notification_time time [default: '21:00']
  created_at        timestamp
}

-- Günlük girişleri
Table entries {
  id            uuid [pk]
  user_id       uuid [ref: > users.id]
  date          date
  question      text          -- Sorulan soru
  raw_text      text          -- Kullanıcının ham cevabı
  enriched_text text          -- AI'ın zenginleştirdiği metin
  tone          varchar       -- stoic | joyful | plain
  mood          integer       -- 1-5 (emoji skalası)
  created_at    timestamp
}

-- AI kullanım takibi (maliyet kontrolü)
Table ai_interactions {
  id           uuid [pk]
  user_id      uuid [ref: > users.id]
  prompt_type  varchar       -- question | enrich | summary
  token_usage  integer
  created_at   timestamp
}
```

**Güvenlik:** Supabase Row Level Security (RLS) aktif — her kullanıcı sadece kendi verisini görür.

---

## 10. AI Prompt Stratejisi

**Temel kural:** Ghostwriting değil, parlatma. Kullanıcının söylemediği hiçbir bilgi eklenmez.

**Sistem promptu (zenginleştirme):**
```
Sen bir yansıtıcı aynasın. Kullanıcının verdiği ham metni asla 
değiştirmeden, sadece dilbilgisini düzelterek ve seçilen tonda 
({{ ton }}) daha akıcı hale getirerek yeniden yapılandır. 
Kullanıcının söylemediği hiçbir bilgiyi veya olayı metne ekleme. 
Türkçe yaz. 1. tekil şahıs kullan.

Ton rehberi:
- Stoacı: Sakin, nesnel, felsefi
- Neşeli: Pozitif, enerjik, umut dolu  
- Sade: Düz, samimi, süssüz
```

**Soru üretme promptu:**
```
Kullanıcının son {{ N }} günlük girişine bakarak bugün ona 
anlamlı, kişiselleştirilmiş bir günlük sorusu sor. 
Soru Türkçe, tek cümle, düşündürücü ama ağır olmayan bir 
tonda olsun. Sadece soruyu döndür, açıklama ekleme.

Önceki giriş özeti: {{ gecmis_ozet }}
```

**Vendor-agnostic yapı:** Tüm AI çağrıları `ai_service.py` üzerinden yapılır. Provider değişikliği sadece config dosyasını etkiler.

---

## 11. Başarı Kriterleri (KPIs)

| Kriter | Hedef | Neden |
|---|---|---|
| D1 Retention | %50+ | Ertesi gün geri gelen kullanıcı |
| D7 Retention | %40+ | Alışkanlık oluştu mu? |
| Completion Rate | %80+ | Başlayıp bitirme oranı |
| AI Kabul Oranı | %70+ | AI metnini düzenlemeden kabul etme |
| AI Yanıt Süresi | < 5 sn | Kullanıcı beklemeden sıkılır |
| Crash Rate | < %1 | Teknik kalite |

---

## 12. Riskler ve Azaltma Stratejileri

| Risk | Etki | Azaltma |
|---|---|---|
| Gemini API maliyeti | Orta | Promptları kısa tut; caching; token limiti koy |
| Kullanıcı güvensizliği (veri) | Yüksek | Enterprise API kullan; şeffaf beyan; biyometrik kilit |
| Flutter öğrenme eğrisi | Orta | Cursor + AI ile yaz; basit ekranlardan başla |
| Alışkanlık oluşturamaması | Yüksek | Push notification + streak mekaniği |
| Supabase ücretsiz limit | Düşük | MVP ölçeğinde sınır içinde kalınır |

---

## 13. Geliştirme Takvimi (8 Hafta)

| Hafta | Odak | Çıktı |
|---|---|---|
| W1 | Temel altyapı | Supabase kurulum, Flutter iskelet, Auth ekranları |
| W2 | Günlük akışı UI | Entry + Review + Duygu ekranları (statik) |
| W3 | Backend | FastAPI endpoint'leri + Supabase bağlantısı |
| W4 | AI entegrasyonu | Gemini bağlantısı, soru üretme, zenginleştirme |
| W5 | Geçmiş ve özet | Timeline, takvim, aylık özet ekranı |
| W6 | Güvenlik & UX | Biyometrik kilit, bildirimler, animasyonlar |
| W7 | Test & hata ayıklama | Beta testi, bug fix, performans |
| W8 | Yayın | Play Store beta, TestFlight, store görselleri |

---

## 14. Tanımlar

| Terim | Açıklama |
|---|---|
| MVP | Minimum Viable Product — temel işlevlerin çalıştığı ilk sürüm |
| Ghostwriting | AI'ın kullanıcı adına tamamen yazması — biz bunu yapmıyoruz |
| Vendor-agnostic | Belirli bir AI sağlayıcısına bağımlı olmayan yapı |
| RLS | Row Level Security — her kullanıcı sadece kendi verisini görür |
| D7 | 7. günde hala aktif olan kullanıcı oranı |
| Magic Flow | Soru → Cevap → Zenginleştir → Kaydet akışının adı |
| Parlatma | Kullanıcının ham metnini ses tonunu koruyarak düzenleme |

---

*Bu doküman YGA Future Talent Modül 301 Bootcamp kapsamında hazırlanmıştır.*
*Claude PRD + Gemini PRD birleştirilerek oluşturulmuştur.*
