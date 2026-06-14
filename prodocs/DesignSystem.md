# Design System — Ayna AI

## Renk Paleti

| Renk | Hex | Kullanım |
|---|---|---|
| Arka plan | #1A1A1A | Tüm ekranların temel arka planı (koyu tema) |
| Birincil / Vurgu (Altın) | #C8A96E | Butonlar, seçili durumlar, takvimde bugün/seçili gün |
| Metin (birincil) | Colors.white | Başlıklar, ana metinler |
| Metin (ikincil) | Colors.white70 | Alt başlıklar, açıklamalar |
| Metin (üçüncül) | Colors.white54 / white38 / white24 | Devre dışı durumlar, ipuçları, placeholder |

### Mood Renkleri (Takvim işaretleri ve banner'lar)

| Mood | Renk | Hex |
|---|---|---|
| 🤩 | Turuncu | #FF9966 |
| 😊 | Yeşil | #7FB685 |
| 😢 | Mavi | #6FA8DC |
| 😠 | Kırmızı | #E05A4E |
| 😴 | Lavanta | #B8B8E8 |

## Tipografi

- Başlıklar (ekran başlığı, soru metni): fontSize 20, FontWeight.w700
- Gövde metni: fontSize 16-17, height 1.4
- Mood emoji: fontSize 28-40
- İkincil/caption metinler: fontSize 12-13, Colors.white54/70
- Buton etiketleri: FontWeight.w700, arka plan üzerinde AppTheme.bg rengi

## Komponentler

### SectionCard
Tüm kart tabanlı içerikler (mood seçimi, geçmiş kayıtlar, onboarding sayfaları) için ortak konteyner. Köşe yuvarlama ve iç padding standartlaştırılmış.

### PrimaryButton
- Arka plan: AppTheme.primary (altın)
- Basılı durumda: AnimatedScale ile %3 küçülme (90ms) + overlayColor ile koyulaşma + elevation 3
- Devre dışı: alpha 0.4 opaklık

### MoodBanner
Her mood için kod içinde üretilen (stock görsel kullanılmaz) gradient + basit şekillerden oluşan küçük illüstrasyon. 5 mood için 5 farklı sahne: gün batımı, doğa, yağmur, fırtına, gece.

### TableCalendar (Takvim)
- Seçili gün: altın daire
- Bugün: yarı saydam altın daire
- Giriş işareti: o günün mood rengiyle eşleşen küçük nokta (6x6px)

## Layout Prensipleri

- Ekran kenar boşlukları: EdgeInsets.fromLTRB(24, 16, 24, 28)
- Köşe yuvarlama: kartlarda 14-18px, butonlarda 12-14px
- Bileşenler arası boşluk: SizedBox(height: 8-20) aralığında, hiyerarşiye göre
