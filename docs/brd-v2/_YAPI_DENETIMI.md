# L2 Yapı Denetimi — Konumlanmaya Karşı

- **Tarih:** 2026-08-12
- **Soru:** *"Sıfırdan yazıyoruz"* dedik. Yapı gerçekten konumlanmadan mı türedi, yoksa eski
  kaynağın gündemini mi izliyor?

---

## Yöntem

İki test:

**Test 1 — Türetme testi.** L2'nin on iki bölümü nereden geldi? Konumlanmadan mı, kaynağın
bölüm yapısından mı?

**Test 2 — Karşılık testi.** Konumlanmanın dört iddiasının her biri L2'de bir kural bulur mu?

---

# Test 1 · Bölümler nereden geldi

| L2 bölümü | Kaynak karşılığı | Türeme |
|---|---|---|
| 2.1 Veri modeli | `§3.1` Core Components | 🔴 kaynak |
| 2.2 Bütçe | `§3.3` Budget Management | 🔴 kaynak |
| 2.3 Defter | `§3.6` Ledger | 🔴 kaynak |
| 2.4 Hesaplama | `§5.3` Calculation Engine | 🔴 kaynak |
| 2.5 Onay | `§3.4` Approval Engine | 🔴 kaynak |
| 2.6 Yetki | `§7.1–7.3` Security & Roles | 🔴 kaynak |
| 2.7 Veri kalitesi | `§6.1` Data Quality | 🔴 kaynak |
| 2.8 Entegrasyon | `§6.2` Integration | 🔴 kaynak |
| 2.9 Uyum | `§9.5/9.8` Compliance | 🔴 kaynak |
| 2.10 Bildirim | `MC-002` | 🔴 kaynak |
| 2.11 Denetim | `§7.4` Audit | 🔴 kaynak |
| 2.12 Ölçek | `§9.1–9.3` NFR | 🔴 kaynak |

**On iki bölümün on ikisi de kaynağın bölüm yapısını izliyor.**

Ve bu, tek başına bir kusur değil — kaynağın bölümleri makul kategoriler. Ama sonucu şu:

> **Kaynağın gündeminde olmayan hiçbir şey L2'de bir bölüm bulamadı.**

---

# Test 2 · Konumlanmanın dört iddiası

## İddia 1 — Farklılaşma muhasebe doğruluğunda (hakediş çekirdek)

**L2'deki karşılığı:** `2.3.8` — defter bölümünün **sekizinci alt başlığı**, ve bu turda
eklendi.

🔴 **Yetersiz.** Konumlanma bunu *"ürünün kendisi"* ilan ediyor; L2'de bir alt başlık.

Ve ölçüm dört eksik parça saydı — talep nesnesi, karşı taraf perspektifi, eşleştirme, dönem
kapanışı. Dördü de **bir alt başlıkta** anlatılamaz:

- Talep nesnesi bir **veri modeli** konusu (`2.1`'e ait)
- Eşleştirme bir **hesaplama/kural** konusu
- Dönem kapanışı bir **durum makinesi** (onay gibi)
- Karşı taraf perspektifi bir **entegrasyon** konusu

Yani hakediş bugün **dört bölüme dağılmış** ve hiçbirinin merkezi değil.

## İddia 2 — Veri olgunluğuyla ölçeklenen tek ürün

**L2'deki karşılığı:** `2.7.4` Veri hazırlık kapısı — üç modlu merdiven tablo olarak var.

🟡 **Kısmen yeterli.** Merdiven yazılı ama **sonucu** yazılı değil: bir mod kapalıyken hangi
kuralların askıya alındığı bölüm bölüm dağınık (`K-2.4.22` renk, `K-2.7.10` gizleme).

Eksik olan: **mod tanımı bir yerde, modun her bölüme etkisi başka yerde.**

## İddia 3 — Sadelik bir özellik (kurulum modeli)

**L2'deki karşılığı:** ❌ **hiç yok.**

Konumlanma diyor ki:

> Ön-konfigüre bir başlangıç paketi (hazır mekanik kütüphanesi, hazır onay şablonları, hazır
> rapor seti) bir özellik değil, **bir konumlanma aracı.**

Ve bir ölçüt öneriyor: *"boş tenant'tan ilk onaylanmış plana ≤ 1 iş günü."*

**L2'de bunu karşılayan tek bir kural yok.** Ne varsayılan konfigürasyon, ne başlangıç
paketi, ne kurulum akışı.

🔴 Ve bu, konumlanmanın **iki hendeğinden biri.**

## İddia 4 — AI kenarlarda, deterministik çekirdek ortada

**L2'deki karşılığı:** ❌ **hiç yok.**

Ve konumlanmanın en net sınırı burada: **LLM asla para hesaplamaz.**

Bu bir mimari kural ve `2.4` (Hesaplama) bölümüne aittir — `K-2.4.2`'nin (analitik alan çıktısı
para olarak kalıcılaştırılamaz) doğal kardeşi.

Ayrıca üç kenar da kural gerektiriyor: alım asistanının çıktısı **öneri**dir, insan onaylar;
açıklama katmanı denetim izinden okur, hesaplamaz; kurulum asistanının ürettiği konfigürasyon
onaylanmadan yürürlüğe girmez.

🔴 **Boşluk, ve büyük.**

---

# Sonuç

| İddia | L2'deki karşılık |
|---|---|
| 1 · Hakediş çekirdek | 🔴 bir alt başlık, dört bölüme dağılmış |
| 2 · Veri olgunluğu merdiveni | 🟡 tanım var, etkisi dağınık |
| 3 · Kurulum modeli | ❌ yok |
| 4 · AI sınırı | ❌ yok |

**Dördün ikisi hiç karşılık bulmuyor, biri yetersiz.**

Ve sebep Test 1'de: yapı kaynağın gündeminden türedi. Kaynakta kurulum modeli yok, AI yok,
hakediş yok — dolayısıyla L2'de de yok.

> **Cevap: hayır, eski BRD'den yeterince bağımsız değiliz.** Kurallar sıfırdan yazıldı ve
> ölçüldü; ama **hangi konuların kural gerektirdiği** kaynaktan alındı.

---

# Öneri — üç yapı değişikliği

## 1 · Hakediş kendi bölümünü alır

**Yeni `2.13 · Hakediş ve Mutabakat`** (numara sonda ama konumu `2.3`'ten sonra).

İçeriği ölçülen dört parçadan türer:

```
2.13.1  Talep nesnesi — iç hakediş ve dış talep aynı varlık mı, ayrı mı
2.13.2  Karşı taraf perspektifi — gelen talep durumları
2.13.3  Eşleştirme — hangi ölçüte göre, ne kadar tolerans
2.13.4  Mutabakat — fark hâlinde ne olur
2.13.5  Dönem kapanışı — anlaşma kapanışı örnek alınır
```

Ve mevcut `2.3.8` oraya taşınır; `2.3` yalnız **defter mekaniğini** anlatır.

⛔ Bu bölümün çoğu `SORULAR A3`/`A4`'e bağlı — ama **bölümün varlığı** karara bağlı değil.
Konumlanma onu çekirdek ilan etti.

## 2 · AI sınırı `2.4`'e girer

**Yeni `2.4.8 · Deterministik sınır`:**

```
K-2.4.28  Para hesabı deterministik motorda yapılır. Dil modeli veya
          olasılıksal bir bileşen para değeri üretemez.
K-2.4.29  AI bileşenleri ÖNERİ üretir. Bir öneri, insan onayı olmadan
          kalıcılaşmaz.
K-2.4.30  AI bileşeni bir denetim izi okuyabilir, yazamaz.
K-2.4.31  AI bileşenleri izolasyon ve yetki katmanının ÜSTÜNDE çalışır.
          Bir asistan, kullanıcının göremediği veriyi göremez.
```

Sonuncusu konumlanmanın §4 eklemesinden geliyor ve önemli: *"önce izolasyon, sonra agent."*

## 3 · Kurulum modeli bir bölüm alır

**Yeni `2.14 · Kurulum ve Varsayılanlar`:**

```
2.14.1  Başlangıç paketi — yeni bir tenant neyle doğar
2.14.2  Zorunlu konfigürasyon — hangi adımlar atlanamaz, ve neden
2.14.3  Varsayılan sorgulama — her ayar "varsayılanı olabilir mi" testinden geçer
2.14.4  Kurulum ölçütü — boş tenant'tan ilk onaylanmış plana geçen süre
```

Bu bölüm `2.7` (veri kalitesi) ile kesişir ama farklıdır: veri kalitesi *"müşterinin verisi
hazır mı"*, kurulum *"ürün ne kadar hazır geliyor"*.

---

# Ve bir yapı sorusu daha

`2.12 Ölçek` gerçekten bir **iş kuralı** mı?

Kapasite hedefleri, yanıt süreleri, telemetri — bunlar işlevsel olmayan gereksinimler. Bir
iş kuralı *"ne olmalı"* der; bunlar *"ne kadar hızlı olmalı"* diyor.

**Öneri:** ayrı bir katman ya da `L2`'nin sonunda açıkça işaretli bir ek. Karışması, iş
kurallarını arayan birinin performans hedeflerini okumasına yol açıyor.

Aynı soru `2.9 Uyum` için de sorulabilir — ama orada fark var: saklama süreleri **veriye ne
olacağını** söylüyor, yani bir iş kuralı.

---

# Özet

```
Bugün:  12 bölüm, hepsi kaynağın gündeminden
Öneri:  +3 bölüm (hakediş · AI sınırı · kurulum), 1 yapı sorusu (ölçek)
```

Ve genel ders:

> **Sıfırdan yazmak, sıfırdan düşünmek değildir.** Kurallar ölçüldü ve yeniden yazıldı; ama
> hangi konuların kural gerektirdiği kaynaktan devralındı. Konumlanmaya karşı bir denetim
> olmadan bu görünmüyordu.
