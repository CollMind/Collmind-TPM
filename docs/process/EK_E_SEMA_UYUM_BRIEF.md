# EK_E Şema-Uyum Turu — Brief (Fable → yürütücü)

> **Tarih:** 2026-08-22 · **Onay:** ürün sahibi · **Tür:** ölçüm + envanter turu, KOD DOKUNUŞU YOK
> **Ad disiplini:** ⛔ Bu tur "ekran denetimi" DEĞİLDİR. Ekran denetimi ayrı ve kayıtlı bir
> karardır (`YOL_HARITASI_EKRAN_VE_SENARYO §2`: sorusu "AKIŞ çalışıyor mu", Faz 2'de başlar).
> Bu turun sorusu `EK_E`'nin sorusudur: **"yetenek/alan var mı, ekran onu taşıyor mu."**
> İki ada tek iş yazmak F2'nin süreç halidir — bu satır o riski kapatır.

---

## Soru

B dalgası ve karar turu şemayı değiştirdi; ekranlar değişiklikten ÖNCE yazılmıştı.
**Hangi ekran, hangi yeni şema gerçeğini taşımıyor?**

## Ölçüm kalemleri — her satır için üç sütun doldurulur

Sütunlar: `ekran var mı` · `yeni alan/model ekranda yaşıyor mu` · `sınıf`
Sınıflar: `UYUMLU` · `EKSİK-ALAN` (ekran var, alan yok) · `YENİ-EKRAN` (yüzey hiç yok) ·
`B4-ÖNKOŞUL` (yokluğu default-deny'ı bloklar)

| # | şema gerçeği | kaynak | bakılacak yüzey |
|---|---|---|---|
| 1 | Mekanik 4 alanı: kadans · taban · kanıt sınıfı · azami süre | B-dalgası S1 | mekanik yönetim ekranı |
| 2 | SKU: satış birimi + çevrim çarpanı VAR, serbest birim alanı YOK | S6/R1 | SKU ekranı + import önizleme |
| 3 | Çok-rol atama (kullanıcı ↔ roller n:m) | S8/R2 | kullanıcı yönetim ekranı — ⚠️ B4-ÖNKOŞUL adayı: rol atayamayan admin, default-deny dünyasında kilitli tenant |
| 4 | Bütçe politikası tablosu (eşikler · joker · mod) | S7 | yüzey VAR MI — 0071 "üretim yolu yok" demişti |
| 5 | Onay şablonu seçimi (üç şablon · eşik değeri) | S3/B3 | aynı — üretim yolu |
| 6 | Dönem varlığı (AÇIK/KAPALI yönetimi) | S11/F12 | yüzey hiç olmadı — YENİ-EKRAN adayı |
| 7 | Müşteri → kanal zorunluluğu (K-2.1.4) | S9 türetme dayanağı | müşteri ekranı kanalı zorluyor mu |
| 8 | Talep ailesi yüzeyleri | S9 | ⛔ ÖLÇÜLMEZ — Faz 2 senaryo→ekran zincirinin işi; buraya yalnız "Faz 2" notu düşülür |
| 9 | Kapsam (scope) atama yüzeyi | T-242a REPLACE ucu | admin, kullanıcı kapsamını ekrandan yönetebiliyor mu |
| 10 | Rol enum kalıntısı frontend'de | R2b ailesi | rol-adı-bağlı kapılar/formlar (B3a tel-protokol ölçümüyle ÇAKIŞMASIN — bulgu varsa B3a'ya devredilir, burada çözülmez) |

## Kurallar

- **Sayı değil liste** — her sınıf, üye listesiyle raporlanır.
- **İşaretleme:** ÖLÇÜLDÜ (dosya:satır) · GEREKÇELİ · VARSAYIM.
- Çapraz-repo okuma serbest (frontend), yazma yok.
- Akış soruları ("kaç ekran değiştiriyor") kapsam DIŞI — o, ekran denetiminin sorusu.
- Yerleşim önerileri (hangi faz) **ADAY** statüsünde — karar ürün sahibinde.

## Çıktı

1. `EK_E`'ye yeni sütun: **şema-uyum** (yukarıdaki sınıflarla) — dondurma rejimi gereği
   bu güncelleme karar defteri kaydıyla iner (Team Lead kanalı).
2. Yerleşim öneri tablosu: her `EKSİK-ALAN`/`YENİ-EKRAN` kalemi için faz adayı
   (çok-rol → Faz 1/B4-önkoşul · mekanik alanları → Faz 2-önkoşul · SKU/dönem/politika →
   Faz 3 · kurulum akışı bağları → Faz 4).
3. `B4-ÖNKOŞUL` çıkan kalemler `ADIM3_FAZB_PLAN`'a satır olarak devredilir.

## DUR koşulları

- L2/EK_E metnine bu turda dokunulmaz — çıktı rapor + karar paketidir.
- Bir kalemin sınıfı ölçümden çıkarılamıyorsa `?` ile işaretlenir, tahmin yazılmaz.
