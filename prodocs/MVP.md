# 🎯 MVP Kapsamı: Ayna AI
**Minimum Viable Product — v1.0**
**Hazırlayan:** Abdullah Sait Avcı
**Program:** YGA Future Talent — Modül 301 Bootcamp
**Tarih:** Nisan 2026

---

## 1. MVP Felsefesi

Bu uygulamanın tek cümlesi şudur:

> **"AI sorar, sen cevaplarsın — gerisini AI halleder."**

MVP'de bu tek cümleyi kusursuz çalıştırmak önceliğimizdir. Başka hiçbir şey bu kadar kritik değildir.

Bir özelliğin MVP'ye girmesi için şu üç sorudan en az ikisine **"evet"** demesi gerekir:

- Onsuz core akış çalışır mı?
- Onsuz kullanıcı uygulamayı anlayabilir mi?
- Onsuz veri kaybı veya güven sorunu yaşanır mı?

---

## 2. Eisenhower Matrisi

| | **ACİL — Şimdi Yap** | **ACİL DEĞİL — Planla** |
|:---|:---|:---|
| **ÖNEMLİ** | **Q1: Ürünün Kalbi (MVP)** — AI Dinamik Soru Motoru, Ham Metin Zenginleştirme, Biyometrik Kilit, Bulut Senkronizasyonu, Auth, Push Bildirim | **Q2: Stratejik Büyüme (v2)** — Sesle Günlük, Haftalık/Aylık Analiz, Premium Abonelik, Spotify/Health Entegrasyonu |
| **ÖNEMSİZ** | **Q3: İllüzyon (v2/v3)** — Sosyal Paylaşım, Streak Takibi, Dinamik Temalar, Rozetler | **Q4: Atık/Lüks (v3)** — Fiziksel Baskı, VR/AR, Akıllı Ev Entegrasyonu, Vasiyet Modu |

---

## 3. Must-Have: MVP'ye Giren 9 Özellik

### 1. AI Dinamik Soru Motoru
Uygulamanın var olma sebebi. "Boş sayfa" sorununu çözen ana motor. Onsuz uygulama yoktur.
Kullanıcının geçmiş cevaplarına bakarak kişiselleştirilmiş Türkçe soru üretir.

### 2. Ham Metni Zenginleştirme (3 Ton)
Ürünün değer önerisinin merkezidir. Kullanıcının 3-5 kelimesini anlamlı bir paragrafa dönüştürür.
Ton seçenekleri: **Stoacı / Neşeli / Sade**
Bu özellik olmadan uygulama sıradan bir not defterinden farkı olmaz.

### 3. Türkçe Dil Desteği (Kusursuz)
Rakiplerden ayrıldığımız en büyük yerel avantaj. Day One ve benzerleri Türkçe'de yetersiz.
AI sorular ve zenginleştirme tamamen Türkçe çalışmalı.

### 4. Google / Apple ID ile Giriş + Hesap Silme
Google/Apple ID: Kullanıcı sürtünmesini (friction) azaltmak için şart. Uzun kayıt formu kullanıcı kaybettirir.
Hesap silme: KVKK ve Google Play politikası gereği zorunlu. Play Store bu olmadan uygulamayı reddediyor.

### 5. Biyometrik Kilit (FaceID / Parmak İzi)
Günlük uygulamalarında gizlilik bir özellik değil, **ön koşuldur.**
Türkiye'de "günlüğüm okunur mu?" korkusu gerçek. Kullanıcı kendini güvende hissetmezse yazmaz.
İlk günden olmalı — sonradan eklenemez, güven bir kez kaybolur.

### 6. Bulut Senkronizasyonu (Supabase)
Telefonu değişince anılarının gitmeyeceğini bilmeli. Veri kaybı = uygulama ölümü.
Row Level Security ile her kullanıcı sadece kendi verisini görür.

### 7. Temel Günlük Akışı + Arama
Geçmiş girişleri görebilme ve arama yapabilme. Veri birikmeden anlam ifade etmez ama
temel liste görünümü olmadan kullanıcı "yazdım, nerede?" sorusunu sorar.

### 8. Push Bildirimi + Bildirim Ayarı
Uygulamanın retention mekanizması. "Her gün aç" alışkanlığı ancak bildirimle oluşur.
Bildirim olmadan D7 retention hedefini tutturmak imkânsız.
Kullanıcı saati kendisi seçer — zorla gelen bildirim silinir.

### 9. Vendor-Agnostic AI Katmanı (ai_service.py)
Görünür bir özellik değil ama MVP'de temeli atılmalı.
Gemini'den başka modele geçmek gerektiğinde tek bir config değişikliğiyle yapılabilmeli.
Sonradan refactor etmek çok daha pahalı — teknik borç birikiyor.

---

## 4. Nice-to-Have: MVP Dışında Kalanlar

### Neden Dışarıda?

| Özellik | Neden MVP Dışı | Versiyonu |
|---|---|---|
| Duygu seçimi (emoji) | Kullanıcı önce ürünü deneyimlemeli; veri birikmeden analiz anlamsız | v2 başı |
| Takvim görünümü | Veri biriktikten sonra değer ifade eder, ilk günde tek giriş anlamsız | v2 başı |
| Aylık özet | Veri olmadan özet olmaz | v2 |
| Onboarding ekranı | İlk kullanıcılar erken benimseyiciler — core akışı mükemmelleştir önce | v2 |
| Karanlık mod | UX polish — kullanıcı geri bildirimi geldikten sonra | v2 başı |
| Sosyal paylaşım | Core problemi çözmüyor | v2 |
| Streak / rozet | Alışkanlığı pekiştirir ama önce alışkanlık kurulmalı | v2 |
| Sesle günlük | STT + AI entegrasyonu teknik hata riskini artırır | v2 |
| Premium abonelik | Önce kullanıcı kazan, sonra para konuş | v2 |
| Haftalık analiz raporları | Veri birikmeden analiz anlamsız | v2 |
| Fiziksel baskı | Lüks özellik | v3 |
| VR / AR deneyim | Vizyon ama kapsam dışı | v3 |

---

## 5. Versiyonlama

### v1.0 — MVP (Şu An)
Yukarıdaki 9 must-have özellik. Tek hedef: kullanıcı her gün açsın ve yazsın.

### v2.0 — Derinleşme (3-6 Ay)
- Sesle günlük (STT)
- Duygu analizi + takvim + aylık özet
- Streak / rozet sistemi
- Sosyal paylaşım kartları
- Premium abonelik modeli
- Onboarding ekranı
- Karanlık mod + UX polish

### v3.0 — Ekosistem (6-12 Ay)
- AI Mentor / Koç modu
- Spotify / sağlık verisi entegrasyonu
- Fiziksel günlük baskısı
- Topluluk özellikleri
- "Türkiye bugün nasıl hissediyor?" anonim veri

---

## 6. Seçim Kriteri Özeti

**Problem Çözme Gücü:** Özellik, "ne yazacağımı bilmiyorum" ve "vaktim yok" problemini doğrudan çözmüyorsa v1'e giremez.

**Güven Bariyeri:** Gizlilik bir özellik değil ön koşul. Biyometrik kilit ilk günden şart.

**Teknik Karmaşıklık vs. Değer:** Sesle günlük değerlidir ama STT teknik hata riskini artırır. Önce metin tabanlı akışı mükemmelleştir, sesi sonra ekle.

---

## 7. Kontrol Sorusu

> *"Bu 9 özellikle bile olsa, bu uygulamayı her gün kullanır mıydım?"*

Cevap **"Evet"** ise doğru MVP setindeyiz.

---

*Bu doküman YGA Future Talent Modül 301 Bootcamp kapsamında hazırlanmıştır.*
*Gemini (Eisenhower Matrisi + 9 özellik) + Claude (seçim kriterleri + versiyonlama) çıktıları birleştirilerek oluşturulmuştur.*
