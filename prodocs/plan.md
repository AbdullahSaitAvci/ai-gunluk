# Ayna AI — MVP Geliştirme Planı

## Çalışma Kuralları (kalıcı — her oturumda geçerli)

**Araçlar:**
- Geliştirme: VS Code içinde **Claude Code** (Cursor artık KULLANILMIYOR)
- Kod değişiklikleri Claude Code'a net prompt olarak verilir
- **git commit/push: Claude Code'dan DEĞİL, elle normal terminalden** (repo kökü ~/ai-gunluk baz alınır)

**Model/effort seçimi (Claude Code):**
- Her prompt'un başında `/model` ve `/effort` AYRI satır/mesaj olarak verilir
- Claude Code'da ayrı "thinking" komutu yoktur — effort seviyesi thinking derinliğini kapsar
- Rutin/net iş: sonnet + low | Çok dosyalı/tutarlılık: sonnet + medium | Geri dönüşü zor tasarım kararı: opus + high

**Oturum ritmi:**
- Adım adım: bir görev, tamamla, rapor et, sonra devam (batch yok)
- Önce "neden", sonra uygulama
- Her görev = ayrı commit (feat/fix/docs/chore), semantic mesaj
- **Her gün sonunda progress.md'ye o günün girişi eklenir** (geçmişe bakış için kritik)
- **Her gün sonunda kapanış özeti:** (1) bugün ne bitti, (2) sonraki gün ne yapılacak, (3) sonraki gün için claude web tarayıcısında kullanılması önerilen model + effort + thinking modu (açık/kapalı)

**Planlama döngüsü:**
- Uzun vade: bu plan.md'deki fazlar (W1, W2-W4...) — büyük roadmap
- Günlük görev: plan.md'deki açık maddeler [ ] + GitHub Issues'tan seçilir

## Hedef ve Kapsam
Bu plan, PRD.md dokümanındaki v1.0 (MVP) kapsamını hayata geçirmek için hazırlanmıştır.
Odak: Magic Flow, güvenli veri mimarisi, düşük gecikmeli AI deneyimi ve Play Store beta yayını.

## Uygulama Prensipleri
- MVP dışı maddeler (sesli günlük, widget, sosyal paylaşım) kapsam dışı kalır
- AI davranışı "ghostwriting değil parlatma" ilkesine bağlıdır
- Tüm AI çağrıları tek noktadan (ai_service.py) yapılır
- Gizlilik varsayılanı: RLS, biyometrik kilit, şeffaf veri politikası
- Teknik kararlar için ana referanslar: PRD.md ve CLAUDE.md (Claude Code talimatları)

---

## Faz 0 — Proje Hazırlığı ✅
**Süre:** W1 başı (tamamlandı)

- [x] Monorepo yapısı: mobile/ (Flutter) ve backend/ (FastAPI)
- [x] Proje kuralları (CLAUDE.md): FastAPI, Flutter+Supabase, design system
- [x] FastAPI ve Flutter dokümantasyonu proje dokümanlarına eklendi
- [x] Backend iskeleti + /health endpoint çalışıyor
- [x] Flutter mobile iskeleti Chrome'da çalışıyor
- [x] progress.md ve progress-log command eklendi
- [x] Supabase proje kurulumu (kısmen — tablolar henüz oluşturulmadı)
- [x] .env ve gizli anahtar yönetimi

---

## Faz 1 — Kimlik, Veri ve Navigasyon
**Süre:** W1-W2

- [x] Demo modu ile giriş (Auth v2'ye bırakıldı — login ekranı 'Demo Olarak Giriş Yap' ile basitleştirildi)
- [ ] users, entries, ai_interactions tablolarını oluştur
- [ ] RLS policy'lerini devreye al
- [x] Flutter: onboarding (3 ekran), auth ekranı, ana kabuk (mock olarak tamamlandı)
- [x] Ayarlar ekranı iskeleti

**Çıktı:** Kullanıcı giriş yapar, profil oluşur, ana ekrana düşer.

---

## Faz 2 — Magic Flow (Uçtan Uca)
**Süre:** W2-W4

- [x] Entry, Review, Mood ekranları (mock olarak tamamlandı)
- [x] /daily-question endpoint (fallback sorularla çalışıyor)
- [x] /process-entry endpoint → /enrich endpoint olarak eklendi, Claude Haiku ile çalışıyor
- [x] POST /entries endpoint
- [x] AI prompt katmanı: zenginleştirme ton bazlı çalışıyor
- [ ] Hata durumları: yükleme, retry, AI fallback

**Çıktı:** Soru → Cevap → Zenginleştir → Onayla → Duygu → Kaydet akışı çalışıyor.

---

## Faz 3 — Geçmiş ve Özet
**Süre:** W5

- [ ] GET /entries (sayfalı)
- [ ] GET /entries/{id}
- [ ] GET /summary/monthly
- [x] Takvim görünümü (table_calendar) — giriş olan günler işaretli, güne tıklayınca o günün kayıtları listeleniyor
- [ ] Aylık duygu istatistiği + AI özet paragrafı

**Çıktı:** Kullanıcı geçmişini tarar, aylık trendini görür.

---

## Faz 4 — Güvenlik ve Kalite
**Süre:** W6-W7

- [x] CORS kısıtlaması (sadece production frontend origin'e izin)
- [x] Rate limiting (/enrich için dakikada 10 istek, slowapi)
- [x] Prompt injection koruması (anahtar kelime filtresi + karakter limiti)
- [ ] Biyometrik kilit (FaceID/parmak izi)
- [ ] Push bildirimi + kullanıcı saat seçimi
- [ ] Hata izleme altyapısı
- [ ] Backend ve mobil testler
- [ ] AI yanıt süresi < 5 sn optimizasyonu

**Çıktı:** Güvenli, stabil beta adayı.

---

## Faz 5 — Beta Yayın
**Süre:** W8

- [ ] Play Store kapalı beta
- [ ] Store görselleri ve gizlilik metni
- [ ] D1/D7 retention, completion rate takibi
- [ ] İlk 50-100 kullanıcıdan geri bildirim

**Çıktı:** Yayında, ölçümlenebilir MVP.

---

## Kullanıcı Akışı

```
Onboarding/Auth
      ↓
Ana Ekran (Timeline)
      ↓
GET /daily-question
      ↓
Ham Cevap + Ton Seçimi
      ↓
POST /process-entry (AI)
      ↓
Review/Düzenle
      ↓
Duygu Seçimi
      ↓
POST /entries (Kaydet)
      ↓
GET /entries (Geçmiş)
      ↓
GET /summary/monthly (Özet)
```

---

## Done Kriterleri (MVP Kabul)
- 10 temel ekranın tamamı çalışır
- PRD endpoint seti canlıdır; auth + RLS testleri geçer
- AI metin zenginleştirme Türkçe ve ton bazlı çalışır
- KPI ölçümü için event/telemetri üretimi doğrulanır
- Kapalı beta yayını yapılmış

---

## Deploy Durumu (2026-06-14)

- Backend: https://ayna-ai-backend.onrender.com (Render, ücretsiz tier)
- Frontend Web: https://ayna-ai-yga.netlify.app (Netlify)
- Render uyku modu cron-job.org ile önleniyor (10 dk'da bir /health ping)

---

## Risk Azaltma
- API maliyeti: prompt kısaltma, token limit, budget alarmı
- Güven sorunu: açık gizlilik metni + biyometrik opt-in
- Teknik gecikme: haftalık demo, her faz sonunda go/no-go
- Performans: AI timeout, retry/backoff, fallback mesajları

---

*Bu doküman YGA Future Talent Modül 301 Bootcamp kapsamında hazırlanmıştır.*