# BRD v2.0 — Ek C · Veri Sözlüğü

> **`L2`'nin ekidir, ayrı bir katman değil.** Ayrı katman olsaydı şema kararları
> kurallardan koparadı — ve kopmuş kaynak/uygulama çiftlerinin ne ürettiğini bu kod
> tabanında yeterince ölçtük.
>
> Her tablo, dayandığı kurala **atıf verir.** Bir kural değişirse şemadaki yankısı buradan
> bulunur.

- **Sürüm:** taslak, 2026-08-12
- **Kapsam:** iş varlıkları. Altyapı tabloları (oturum, göç, kuyruk) kapsam dışı.

**İşaretler:** ✅ var · 🔶 kısmen · ❌ yok · 🆕 karar turunda eklendi

---

## Sözleşmeler

**Her tabloda:** kimlik · kiracı referansı · oluşturma ve güncelleme zamanı · oluşturan
kullanıcı.

**Para alanları:** `numeric(18,2)` — ve okunurken **tam temsil** kullanılır (`K-2.4.1`).
Kayan noktaya dönüştürülmez.

**Oran alanları:** `numeric(9,4)` — yüzde olarak `0–100` aralığında.

**Birim fiyat alanları:** `numeric(18,4)` — kuruş kuralından muaftır (`K-2.1.12`).

**Hacim alanları:** `numeric(18,3)`, ve **birimi yoktur** — her hacim tanım gereği adettir
(`K-2.1.12b`).

⚠️ **Kiracı ayrımı** her tabloda zorunludur ve iki katmanda korunur: uygulama filtresi
**ve** veritabanı seviyesinde (`K-2.6.12`).

---

# C.1 · Ürün hiyerarşisi

## `markalar` ✅

```
ad · kod · aktif
```

## `kategoriler` ✅

```
marka referansı · ad · kod · aktif
```

⚠️ Kategori bir **ürün** eksenidir. Yetki kapsamında kullanılması bilinçli bir sapmadır
(`K-2.6.7`).

## `urun_gruplari` ✅

```
kategori referansı · ad · kod · aktif
```

## `tahmin_birimleri` (FU) ✅

```
ürün grubu referansı · ad · kod · aktif
```

**Planlama girişinin seviyesidir** — hem taktik hem hacim (`K-2.1.7`, `K-2.1.8`).

## `urunler` (SKU) 🔶

| Alan | Tip | Not |
|---|---|---|
| tahmin birimi referansı | — | |
| ad · kod | metin | |
| liste fiyatı | `numeric(18,4)` | birim fiyat ölçeği |
| maliyet | `numeric(18,4)` | ⚠️ bugün 170'te 4 dolu |
| 🆕 satış birimi | metin | bilgi amaçlı — *"koli"* |
| 🆕 çevrim çarpanı | `numeric(9,4)` | koli → adet, **varsayılan 1** |
| aktif | boolean | |

> 🆕 `K-2.1.12c`. Ve bugünkü serbest `birim` alanı **kaldırılır** — ya bu modele dönüşür ya
> silinir. Uyuyan on iki kat hata bugün kapanır.

---

# C.2 · Organizasyon hiyerarşisi

## `kanallar` ✅

```
ad · kod · aktif
```

## `bolgeler` ✅ *(kurulu, kullanılmıyor)*

```
üst bölge referansı · seviye · ülke · ad
```

⚠️ Mekanizma tam kurulu, **sıfır satır.** Yetki kapsamına bağlı değildir ve aktivasyonu bir
müşteri talebine bağlıdır (`K-2.6.7a`).

## `musteriler` (CPL) — `main.cpls` ✅

> ⚠️ **DÜZELTME (2026-08-13):** bu bölüm önceden **iki ayrı varlığı tek satırda**
> anlatıyordu. `main.cpls` ile `main.customers` farklı tablolar, farklı kanal
> mekanizmalarıyla — ve `S9` brief'i yanlışlıkla `customers` üstüne kurulmak üzereydi.

| Alan | Tip | Not |
|---|---|---|
| kanal referansı | `uuid` | ⚠️ `NOT NULL` → `channels(id)` **`ON DELETE RESTRICT`** — bir CPL **tam olarak bir** kanala bağlıdır (`K-2.1.4`) |
| bölge referansı | `uuid` | nullable — bugün boş |
| ad · kod | metin | |
| durum | enum | |

✅ **`K-2.1.4` ölçüldü (2026-08-13):** birden çok kanallı CPL **0** · plan kanalı ile CPL
kanalı çelişkisi **0**. Garantiyi veren şey tek `NOT NULL` FK kolonudur, veri sayısı değil.
⚠️ Ortamda **1 plan** var — plan tarafındaki kanıt zayıf.

## `customers` 🔶 — CPL DEĞİL, ve kanalı bir ENUM

`main.customers` bir **müşteri kütüğü** (CRM alanlarıyla), `cpl_id` üzerinden CPL'ye
**nullable** bağlanır. Kanal alanı **bambaşka bir mekanizma**:

| Alan | Tip | Not |
|---|---|---|
| `channel` | **`customers_channel_enum`** | ⛔ **`channels` tablosuna FK DEĞİL** — paralel bir sözlük |
| `cpl_id` | `uuid` | nullable → `cpls(id)` `ON DELETE SET NULL` |

⚠️ **`INV-C-*` ailesinin yeni adayı: kazara sağlanan bir şart.**

```
enum etiketleri ↔ channels.code     ayrışma YOK — sekizi de birebir
customers.channel ↔ CPL'nin kanalı  0 çelişki / 27 bağlı müşteri
bunu koruyan kısıt                  HİÇBİRİ
```

İki sözlük bugün aynı, ve **bir kod değişikliğiyle değil, bir veri işlemiyle** ayrışır — o
gün hiçbir test kırmızıya dönmez. `INV-C-001` (hiçbir şey silinmiyor) ve `Ö4`'ün dönem
biçimi (`2026-13` kabul ediliyor) ile **aynı şekil**.

📌 Sözleşmeye `INV-C-*` maddesi **basılmadı** — invariant üretmek ürün sahibinin kararı;
burada **aday** olarak kayıtlı.

---

# C.3 · Bütçe

## `butce_zarflari` ✅

| Alan | Tip | Not |
|---|---|---|
| kanal · kategori · dönem | — | zarf boyutu (`K-2.2.1`) |
| harcama tipi | enum | `FATURA_İÇİ` · `FATURA_DIŞI` · boş (bölünmemiş) |
| ayrılan tutar | para | |

**Dört kova hesaplanır, saklanmaz:** ayrılan · rezerve · taahhüt · tüketilen (`K-2.2.4`).

⚠️ `Rezerve` ve `Taahhüt` **ayrı** hesaplanır — birleştirilemez (`K-2.2.6`).

## 🆕 `butce_politikalari` ❌

| Alan | Tip | Not |
|---|---|---|
| kanal referansı | — | boş = joker |
| kategori referansı | — | boş = joker |
| uyarı eşiği | oran | varsayılan `80` |
| finans inceleme eşiği | oran | varsayılan `90` |
| blok eşiği | oran | varsayılan `100` |
| finans inceleme modu | enum | `BİLDİRİM` \| `ONAY` — **varsayılan `BİLDİRİM`** |

**Kısıt:** `UNIQUE(kiracı, kanal, kategori)`

⚠️ **Öncelik kolonu yoktur ve bilinçli olarak eklenmez** (`K-2.2.8c`). Çözümleme
*en-spesifik-kazanır*; tekillik kısıtı eşit spesifikliği imkânsız kılar — **açıklanabilirlik
yapıya gömülüdür.**

**Zorunlu:** her kiracıda bir joker satır (`K-2.2.8d`).

> Renk sınırları (`80/95`) ayrı bir merdivendir ve gösterge konfigürasyonunda yaşar
> (`K-2.2.7`).

---

# C.4 · Plan

## `planlar` ✅

```
dönem · durum · toplam planlanan harcama · onay bilgileri
🆕 kapsama oranı
```

**Durumlar:** `TASLAK` · `ONAY_BEKLİYOR` · `ONAYLANDI` · `REDDEDİLDİ` · 🆕 `SÜRESİ_DOLDU`

> 🆕 `SÜRESİ_DOLDU` bugün eklenir, davranışı Faz 2'de gelir (`K-2.5.10e`).

## `plan_fu` ✅

| Alan | Tip | Not |
|---|---|---|
| plan · tahmin birimi referansı | — | |
| 🆕 hacim | `numeric(18,3)` | **giriş burada** (`K-2.1.8`) |
| taktikler | JSONB | mekanik kodu → girilen değer |
| sürüm | tamsayı | iyimser kilitleme |

## `plan_sku` 🔶

| Alan | Tip | Not |
|---|---|---|
| plan FU · ürün referansı | — | |
| hacim | `numeric(18,3)` | **türetilir** (`K-2.1.8a`) |
| 🆕 elle düzeltildi | boolean | düzeltilen hücre kilitlenir (`K-2.1.8d`) |
| 🆕 tarihsiz | boolean | geçmişi olmayan SKU işareti (`K-2.1.8b`) |

⚠️ **Satırlar payı sıfırdan büyük olanlar için türetilir.** Bugünkü *"FU eklendi → tüm aktif
SKU'lar satır oldu"* davranışı kaldırılır (`K-2.1.8h`).

**Invariant:** `Σ(SKU hacimleri) = FU hacmi` (`K-2.1.8e`).

## `plan_hesaplanan_degerler` ✅

```
plan SKU referansı · girilen oran · girilen birim tutar · girilen toplam tutar
hesaplanan harcama
```

⚠️ Üç *"girilen"* kolonundan **en fazla biri** dolu olabilir (`K-2.1.11`).

---

# C.5 · Mekanik ve taktik

## `mekanikler` 🔶

| Alan | Tip | Not |
|---|---|---|
| kod · ad | metin | |
| giriş tipi | enum | `oran` · `tutar` |
| mekanik tipi | enum | `ORAN` · `TUTAR` · `BİRİM_BAŞI` |
| 🆕 kanıt sınıfı | enum | `GÖZLENEN` · `TÜRETİLEBİLİR` · `SÖZLEŞMESEL` (`K-2.13.14f`) |
| 🆕 hesaplaşma kadansı | enum | `TEK` · `DÖNEMSEL` (`K-2.1.13`) |
| 🆕 tahakkuk takvimi | enum | `YOK` · `AYLIK` — kadans dönemselse |
| 🆕 taban | enum | `BRÜT` · `NET` — **varsayılan `NET`** (`K-2.13.14h3`) |
| 🆕 azami süre (gün) | tamsayı | **doğrular, sınıflandırmaz** (`K-2.1.16`) |
| birleşik indirim tavanı | oran | ⚠️ **sıfır yazılamaz** (`K-2.1.18`) |
| aktif | boolean | |

> 🆕 Beş alan karar turunda eklendi. Üçü davranış belirliyor — ve `K-2.1.15`: `KISA`/`UZUN`
> etiketi bir **türetilmiş görünümdür**, davranış kaynağı değil.

---

# C.6 · Anlaşma

## `anlasmalar` 🔶

| Alan | Tip | Not |
|---|---|---|
| müşteri · dönem | — | |
| kaynak | enum | `PLANDAN` · `DOĞRUDAN` |
| plan referansı | — | plandan üretildiyse |
| harcama tavanı | para | ⚠️ pozitif ya da boş — **sıfır yazılamaz** |
| durum | enum | |
| kapanış zamanı · kapatan | — | ✅ mekanizma olgun |

---

# C.7 · Defter

## `defter_kayitlari` ✅

| Alan | Tip | Not |
|---|---|---|
| tutar | para | ⚠️ **`CHECK (tutar >= 0)` eksik** — düzeltme kaydı yönle yapılır (`K-2.3.7`) |
| yön | enum | `BORÇ` · `ALACAK` |
| işlem tipi | enum | `TAHSİS` · `REZERVE` · `TAAHHÜT` · `İADE` · `TRANSFER` · `DÜZELTME` |
| harcama tipi | enum | `FATURA_İÇİ` · `FATURA_DIŞI` · `DÜZELTME` · `TAHAKKUK` |
| kaynak tipi · kaynak kimliği | — | |
| zarf referansı | — | |
| tekrarsızlık anahtarı | metin | kısmi tekil — anahtar taşıyan satırlarda |
| ters kayıt referansı · ters çevrildi | — | en fazla bir kez (`K-2.3.6`) |
| 🆕 transfer kimliği | — | iki bacağı bağlar (`K-2.2.9k`) |

⚠️ **Silinme tarihi kolonu kaldırılmalıdır.** Bir kuralın *"bu kolon hep boş olmalı"* demek
zorunda kalması, kolonun hiç olmaması gerektiğinin işaretidir (`K-2.3.4`).

**Invariantlar:**
```
Σ(transfer bacakları) = 0                      K-2.2.9l
tüketim = Σ borç − Σ alacak                    K-2.3.11
```

---

# C.8 · Hakediş 🆕

> **Bu bölümün tamamı yenidir.** Ürünün çekirdeği, ve bugün yalnız üretim tarafı var.

## 🆕 `talepler` ❌

| Alan | Tip | Not |
|---|---|---|
| kaynak | enum | `İÇ` · `DIŞ` (`K-2.13.5`) |
| anlaşma referansı | — | |
| dönem · müşteri · kategori · kanal | — | hakediş grain'i |
| tutar | para | |
| durum | enum | kaynağa duyarlı geçiş (`K-2.13.5d`) |
| dayanak belge referansı | — | ⚠️ `DIŞ` ise zorunlu |
| hesap izi referansı | — | ⚠️ `İÇ` ise zorunlu |
| üretim / alım zamanı | — | |

**Durumlar:**
```
DIŞ:  ALINDI    → EŞLEŞTİRİLDİ → KABUL_EDİLDİ | REDDEDİLDİ | İTİRAZLI
İÇ:   ÜRETİLDİ  → GÖNDERİLDİ   → KARŞILANDI
```

⚠️ Geçersiz kombinasyonlar (`İÇ` + `İTİRAZLI`) **şemada değil, geçiş tablosunda** engellenir
(`K-2.13.5e`).

## 🆕 `eslestirmeler` ❌

| Alan | Tip | Not |
|---|---|---|
| iç talep referansı | — | |
| dış talep referansı | — | |
| fark tutarı | para | |
| fark sınıfı | enum | `ZAMANLAMA` · `TUTAR` · `KAPSAM` |
| karar · karar veren · karar zamanı | — | |

⚠️ **Ayrı bir bağ varlığıdır** ve `n:m`'dir — bir dış kesinti birden çok iç talebe, ya da
hiçbirine denk düşebilir (`K-2.13.5f`).

## 🆕 `taktik_gerceklesmeleri` ❌

```
talep referansı · mekanik referansı · hesaplanan tutar · kanıt sınıfı
```

**Invariant:** `Σ(taktik gerçekleşmeleri) + FARK = dış talep tutarı` (`K-2.13.14j`)

---

# C.9 · Gerçekleşen veri

## `satis_gerceklesmeleri` 🔶

| Alan | Tip | Not |
|---|---|---|
| müşteri · kategori · kanal · dönem | — | |
| brüt tutar · indirim tutarı · net tutar | para | ⚠️ `net = brüt − indirim` **doğrulanmalı** (`K-2.13.14h7`) |
| hacim | — | ❌ **yok** — birim başı hesaplar bu yüzden yapılamıyor |

⛔ **İade temsili ölçülmedi** ve net tanımı ona bağlı (`K-2.13.14h6`).

## `fatura_ici_kayitlar` 🔶

| Alan | Tip | Not |
|---|---|---|
| ürün · miktar · liste fiyatı · gerçekleşen fiyat · indirim | — | |
| zarf referansı | — | ✅ var |
| 🆕 anlaşma referansı | — | ❌ **eksik** — kanıt merdiveninin ilk basamağı kör (`K-2.13.14l`) |

## `ice_aktarma_partileri` 🔶

| Alan | Tip | Not |
|---|---|---|
| durum | enum | `AKTİF` · `DEĞİŞTİRİLDİ` |
| değiştiren parti referansı | — | |
| 🆕 köken | — | kim · ne zaman · dosya içerik özeti (`K-2.13.12b`) |
| 🆕 çevrim izi | — | ham değer · çarpan · sonuç (`K-2.1.12d`) |

---

# C.10 · Yetki

## `kullanicilar` 🔶

```
e-posta · ad · aktif
```

⚠️ Bugün tek bir **rol enum kolonu** taşıyor — kaldırılır.

## 🆕 `roller` ❌ · `yetenekler` ❌ · `rol_yetenekleri` ❌ · `kullanici_rolleri` ❌

Rol bir **varlıktır**, bir enum değeri değil (`K-2.6.5a`).

Bir kullanıcı **birden çok rol** taşıyabilir; etkin yetki rollerin **birleşimidir**
(`K-2.6.5b`).

⚠️ **Kişiye özel yetki istisnası tablosu yapılmaz** — kaynaktan bilinçli sapma
(`K-2.6.5d`).

## `kullanici_kapsamlari` 🔶

```
kanal · müşteri · kategori referansları
```

⚠️ **Boş kapsam = erişim yok.** Tüm veriye erişim açık bir joker atamasıyla verilir
(`K-2.6.8a`).

---

# C.11 · Onay

## `onay_istekleri` 🔶

```
varlık tipi · varlık referansı · durum · onaylayan · gerekçe
politika referansı
```

⚠️ Politika referansı bugün **var olmayan bir tabloya** işaret ediyor.

## 🆕 `onay_politikalari` ❌

| Alan | Tip | Not |
|---|---|---|
| şablon | enum | `STANDART` · `ÇİFT_KADEME` · `EŞİKLİ` |
| tutar eşiği | para | eşikli şablonda |
| 🆕 devir izni | boolean | Faz 2 alanı, bugün eklenir |
| kademe rolleri | — | |

> Üç kararın Faz 2'si bu tabloya iniyor. Tablo gelmezse üçü de kodda sabitlenir
> (`K-2.5.13e`).

## `onay_gecmisi` 🔶

```
istek referansı · durum geçişi · kim · ne zaman
🆕 karar anındaki göstergeler
```

⚠️ Alan bugün var ama **hiçbir yazarı yok** (`K-2.11.5`).

---

# C.12 · Gösterge

## `gostergeler` ✅

```
kod · ad · formül metni · bağımlılıklar · toplama yöntemi · hesap sırası
renk eşikleri · biçim
```

⚠️ Kaydedilirken **doğrulanmalı** — bugün doğrulama yazılmış ama **çağrılmıyor**
(`K-2.4.26`).

## `hesaplanan_gostergeler` 🔶

| Alan | Tip | Not |
|---|---|---|
| varlık referansı · gösterge referansı | — | |
| değer | — | ⚠️ **boş olabilir** ve boş sıfıra çevrilemez (`K-2.4.7`) |
| 🆕 kapsama oranı | `numeric(9,4)` | (`K-2.4.21`) |
| renk | enum | ⚠️ kapsama tam değilse **`GRİ`** (`K-2.4.22c`) |

---

# C.13 · Denetim

## `denetim_kayitlari` 🔶

| Alan | Tip | Not |
|---|---|---|
| kullanıcı · zaman · varlık · işlem | — | |
| önceki değer · yeni değer | JSONB | |
| sonuç · gerekçe | — | |

⚠️ Bugünkü tablo **yönetici odaklı** (adı ve alanı öyle). Kapsam yirmi olay tipine
genişletilmelidir (`K-2.11.2`).

⚠️ **Değişmezlik veritabanı seviyesinde korunmalıdır** — bugün ölçülmedi bile
(`K-2.11.7`).

---

# Özet — değişiklik hacmi

| Tür | Sayı |
|---|---|
| Yeni tablo | **8** — bütçe politikası · onay politikası · rol ailesi (4) · talep · eşleştirme · taktik gerçekleşmesi |
| Yeni alan | **~20** |
| Kaldırılacak | **3** — defter silinme tarihi · kullanıcı rol enum'u · SKU serbest birim alanı |
| Kısıt eklemesi | defter tutarı ≥ 0 · bütçe politikası tekilliği · ~~net = brüt − indirim~~ |

⚠️ **Hepsi deploy öncesi.** Ve birkaçı için ek gerekçe var: alan olmazsa **karar yeniden
icat edilir** — `hesaplaşma kadansı` bunun en net örneği.

📌 `net = brüt − indirim` **üstü çizili**: `S3` dalgadan çıktı (2026-08-13). Sıralanacak
şey bir veri düzeltmesi değil, bir **tanım** — `discount_amount` satış iskontosu mu toplam
indirim mi. Kısıt bugün eklenemiyor (ölçüm: **3/3 satır** ihlal). → `v2-UC-ALAN` · [[T-209]]

---

# `B` dalgası — kanonik kalem listesi

> **Bu bölüm KANONİKTİR.** `_ISSUE_B_DALGASI.md` ve GitHub issue **atıf verir, kopyalamaz**.
> Kalemlerin gerekçesi ve ölçümü `docs/analysis/0069` (kod tarafı) ve `0070` (TTM kanıtı)
> içinde yaşar; bu tablo **ne yapılacağını** taşır, **neden**ini değil.

⚠️ **Neden buraya yazıldı — ölçülmüş bir boşluk (2026-08-13).** Liste **bir kez yazıldı,
iki kez numaralandı**: ürün sahibi `TEAM_LEAD_IS_LISTESI`'nde `B1`–`B9` olarak verdi,
Team Lead `S`/`R` numaralarına çevirdi, ve o eşleme **yalnız issue gövdesinde** yaşadı.
Yani kanonik hâli **hiç oluşmadı** — ve dalga uygulanmak istendiğinde repoda `S1`,`S2`,
`S4`–`S12`,`R1`–`R3` için **sıfır tanım** çıktı (pozitif kontrol: `S13` yedi dosyada).

> Bu `F2`'nin akrabası: orada **bir numara iki şeye** verilmişti, burada **bir şeye iki
> numara**. İkisinin de sonucu aynı: atıf çözümlemesi okuyana göre değişir.

### ⛔ DÜZELTME (2026-08-13, aynı gün): *"o belge bu repoda yok"* YANLIŞTI

Bu bölüm ilk yazıldığında *"`B1`–`B9` ↔ `S`/`R` eşlemesi kurulamaz, çünkü
`TEAM_LEAD_IS_LISTESI` bu repoda yok"* diyordu. **Belge duruyor:**
`docs/process/TEAM_LEAD_IS_LISTESI.md`, `§B · Şema alanları — deploy öncesi ucuz`.

İddia ölçülmeden yazılmıştı — `CLAUDE.md`'nin *"koda/belgeye 'yok' yazmadan önce ölç"*
kuralının ihlali, ve bir **kapsam kararını** dayanaksız bıraktı. Eşleme kuruldu:

| `B` | `S`/`R` | kural |
|---|---|---|
| `B1` kadans · tahakkuk takvimi | `S1` | `K-2.1.13` |
| `B2` içe aktarma kökeni | `S2` | `K-2.13.12b` |
| `B3` onay politikası + Faz 2 alanları | `S5` | `K-2.5.13e` |
| **`B4` `SÜRESİ_DOLDU` durumu + geçiş tablosundaki yeri** | ⛔ **KARŞILIĞI YOK** | `K-2.5.10e` |
| `B5` fatura-içi anlaşma referansı | `S9` | `K-2.13.14l` |
| `B6` SKU birim + çevrim, **ve** birim alanının çıkarılması | `S12` + `R3` | `K-2.1.12c` |
| `B7` bütçe politikası tablosu | `S4` | `K-2.2.8b` |
| `B8` roller varlık olur | `S6` | `K-2.6.5a` |
| `B9` talep varlığı + eşleştirme | `S7` + `S8` | `K-2.13.5` |

> ⛔ **`B4` numaralandırmada DÜŞMÜŞ.** Karar verilmiş bir şema kalemi (`SÜRESİ_DOLDU` enum
> değeri; *"davranış Faz 2'de, enum bugün"*), ve bu belgenin kendi `planlar` bölümü onu
> **"bugün eklenir"** diye yazıyor — ama `S` listesinde karşılığı yok. Dalga bugünkü
> numaralandırmayla inseydi **atlanırdı**.
>
> Bu, *"bir şeye iki numara"*nın somut bedeli: `F2`'de atıf çözümlemesi okuyana göre
> değişiyordu, burada bir kalem **iki numaralandırma arasında kayboldu**.
>
> ✅ **`S15` olarak dalgaya alındı** (ürün sahibi, 2026-08-13): gerekçesi hâlâ geçerli —
> *davranış Faz 2'de, enum bugün.* `S10`'un enum genişletmesiyle aynı migration'da.
>
> 📌 **Kayboluşun kendisi kayda geçiyor.** `F2`'de bir numara iki şeye verilmişti ve **atıf
> çözümlemesi** okuyana göre değişiyordu; burada bir şeye iki numara verildi ve **bir kalem
> iki numaralandırma arasında düştü.** İkinci biçim daha sessiz: kayıp bir kalem hiçbir
> yerde çelişki üretmez, yalnız **yapılmaz**.
>
> Ve kaybı üreten şey numaralandırma değil, **ölçülmemiş bir yokluk iddiasıydı**:
> *"`TEAM_LEAD_IS_LISTESI` bu repoda yok"* yazıldığı için eşleme hiç kurulmadı. Belge
> duruyordu. → `CLAUDE.md` · *"'yok' yazmadan önce ölç"*

📌 **`TEAM_LEAD_IS_LISTESI` artık TARİHSELDİR.** `B1`–`B9` numaraları o belgede kalır;
bağlayıcı olan `S`/`R`'dir. Yukarıdaki tablo ikisi arasındaki köprüdür ve **tek yönlüdür**:
yeni kalemler `S`/`R` alır, `B` almaz.

`S10`–`S15` ve `S3`'ün `B` karşılığı **yok ve olmamalı** — onlar sonraki ölçümlerden doğdu
(`C1`,`C3`,`Ö4`,`F16`). Aşağıdaki `S`/`R` numaraları **bundan sonra kanoniktir**.

## `S` · Şema

| # | Kalem | Kural |
|---|---|---|
| `S1` | mekanikler: kadans · tahakkuk takvimi · taban · azami süre · kanıt sınıfı | `K-2.1.13` · `K-2.13.14f` · `K-2.13.14h3` |
| `S2` | İçe aktarma köken bloğu: kim · ne zaman · dosya özeti · çevrim izi | `K-2.13.12b` · `K-2.1.12d` |
| `S3` | ⛔ **DÜŞTÜ** — net = brüt − indirim kısıtı. Yerine önerilen `K-2.7.4a` (`net ≤ brüt`) de **dalgaya girmez** — aşağı | `K-2.7.4a` |
| `S4` | `butce_politikalari` tablosu — iki boyut, `UNIQUE(tenant,kanal,kategori)`, **öncelik kolonu yok** | `K-2.2.8a`–`d` |
| `S5` | `onay_politikalari` tablosu + üç şablon + `mode` · `devir_izni` | `K-2.5.13a`–`f` |
| `S6` | Rol ailesi: `roller` · `yetenekler` · `rol_yetenekleri` · `kullanici_rolleri` | `K-2.6.4` · `K-2.6.5a` |
| `S7` | `talepler` tablosu — kaynak: `İÇ`\|`DIŞ`, kaynağa duyarlı durum | `K-2.13.5`–`5g` |
| `S8` | `eslestirmeler` bağ varlığı (n:m) + `taktik_gerceklesmeleri` | `K-2.13.5f` · `K-2.13.14j` |
| `S9` | Fatura-içi kayıtlara **anlaşma referansı** | `K-2.13.14l` |
| `S10` | Defter: `TAHAKKUK`+`TÜKETİM` tipleri · `TAHAKKUK` harcama tipinden çıkar · `duzeltme_alt_turu` (4 değer) + **çift yönlü** `CHECK` | `K-2.3.13`–`13d` |
| `S11` | `donemler` tablosu + nullable FK + **biçim doğrulamalı** backfill | `K-2.13.21` · `Ö4` |
| `S12` | SKU: `satis_birimi` + `cevrim_carpani`; girilen değer kolonları **FU'ya** | `K-2.1.12c` · `K-2.1.11a` |
| `S13` | ⚠️ **Yeniden şekillendi** — kolon **var** (`updated_by`); iş: `updateVersioned` çağıran yolların **enumerasyonu** + kontrolün genişletilmesi | `K-2.5.11` · `K-2.5.16` |
| `S14` | 🆕 `sales_actuals`: **SKU kırılımı + hacim** | `K-2.1.8a` |
| `S15` | 🆕 `planlar`: **`SÜRESİ_DOLDU`** durumu + geçiş tablosundaki yeri — davranış Faz 2'de, **enum bugün** | `K-2.5.10b` · `K-2.5.10e` |

> ⚠️ **`S13` bir kolon eklemiyor.** Önermesi (*"dayanacağı kolon yok"*) 2026-08-13'te
> çürüdü: `updated_by` `BaseEntity`'de yaşıyor (`base.entity.ts:31`) ve düzenleme yolu
> dahil yedi noktada yazılıyor (`plan.service.ts:450` → `updateVersioned`, kalıcı).
> Çürüten şey bir kapsam hatası değil, **terim listesi**ydi: aranan üç ad ne katalog
> dilindeydi (`updated_by`) ne entity dilinde (`updatedBy`). → [[T-207]]
>
> Yeni kolon eklenseydi **iki ayrı "son değiştiren" alanı** doğardı ve hangisinin
> bağlayıcı olduğu belirsiz kalırdı — `İlke 4`'ün veri tarafındaki hâli.

## `R` · Çıkarmalar

| # | Kalem | Gerekçe |
|---|---|---|
| `R1` | `ledger_entries.deleted_at` **kaldırılır** | `K-2.3.4` — *"hep boş olmalı"* diyen bir kural, kolonun **olmaması gerektiğinin** işaretidir |
| `R2a` | `users.role` **enum + veri** — beş yeniden adlandırma, üç silme (migration) | `K-2.6.4d` |
| `R2b` | **ölü referans temizliği** — `APPROVER` (7 dosya) · `MANAGER` (13 dosya) · `FINANCE` (6 dosya) · **ayrı PR** | `K-2.6.4d` |
| `R3` | `skus.unit_of_measure` serbest alanı **kaldırılır** (yerine `S12`) | `K-2.1.12b` |

> ✅ Üçünün de bugün **var olduğu** ölçüldü (2026-08-13, `main` şeması):
> `ledger_entries.deleted_at` nullable timestamp · `users_role_enum` **sekiz** değer
> (`ADMIN, PLANNER, APPROVER, FINANCE, FINANCE_MANAGER, CATEGORY_MANAGER, MANAGER,
> READONLY`) · `skus.unit_of_measure` varchar.

### `R2` eşleme tablosu — karar (ürün sahibi, 2026-08-13)

`K-2.6.4d` sırayı bağlıyor: **önce sayım → sonra eşleme → sonra silme.** Sayım yapıldı
(CTPM'in deploy edilmiş ortamı yok, yani `main` **tek** ortam — 9 kullanıcı):

| bugünkü etiket | kullanıcı | → | `K-2.6.4` rolü |
|---|---|---|---|
| `ADMIN` | 1 | → | `YÖNETİCİ` |
| `PLANNER` | 2 | → | `PLANLAMACI` |
| `CATEGORY_MANAGER` | 3 | → | `KATEGORİ MÜDÜRÜ` |
| **`FINANCE_MANAGER`** | **2** | → | **`FİNANS`** |
| `READONLY` | 1 | → | `İZLEYİCİ` |
| `APPROVER` · `MANAGER` · **`FINANCE`** | 0 · 0 · 0 | ⛔ | **silinir** |

> ⚠️ **Eşleme ilk okumada TERS kurulmuştu ve düzeltildi.** `FINANCE`'ın adı `FİNANS`'a
> benziyor diye onun karşılığı sanıldı. Değil: `K-2.6.4`'ün `FİNANS`'ı *"eşik üstü
> onay/bildirim, transfer, mutabakat, içe aktarma"* — bu **bugünkü `FINANCE_MANAGER`'ın
> tam karşılığı**. Bugünkü `FINANCE` ise `K-2.6.4b`'nin **reddettiği jenerik onaycı**.
>
> Yani ad benzerliği eşlemeyi ters çevirdi — `CLAUDE.md`'nin *"düzeltmenin iki ekseni
> vardır: hedefi ve YÖNÜ"* kuralının vakası. Hedef doğruydu (`FİNANS` satırı), yön tersti.

📌 **`ADR 0002` sessizce geri alınmıyor.** *"FM yalnız `PENDING_FINANCE_REVIEW` onaylar"*
kaygısı `0002-R` ile zaten kapandı, ve `K-2.5.12e` (`L2_03`) *"Finans, kendisine gelen
istekleri onaylar"* diyor — **sonuç aynı, dayanak şablon.**
**Katlama yok, yeniden adlandırma var.**

📌 **Ve `R2`'nin şekli bu yüzden değişti:** *"100+ dosyalık yeniden eşleme"* yanlış bir
çerçeveydi — **beşi yeniden adlandırma, üçü silme**, ve silinenlerin **kullanıcısı yok**,
yani **veri göçü yok**. Kod ayak izi gerçek ama ayrı bir iş: enum'u migration değiştirir
(`R2a`), ölü referanslar ardından gelir (`R2b`).

## Seed — **atomik**

| # | Kalem | Bağlı |
|---|---|---|
| 1 | joker bütçe politikası satırı | `K-2.2.8d` — **zorunlu** |
| 2 | üç onay şablonu | `K-2.5.13a` |
| 3 | rol kataloğu (**beş** rol) | `K-2.6.4` |
| 4 | aktif dönemler | `S11` backfill'inin **hedefi** |
| 5 | mekanik kütüphanesi — kadans/taban/kanıt alanlarıyla | `S1` |

## Kabul ölçütleri

| # | Ölçüt |
|---|---|
| `kabul-1` | `down` gidiş-dönüş: **boş VE seed'li** ortamda, sonrası şema diff = **BOŞ** |
| `kabul-2` | Σ(transfer bacakları) = 0 — **ihlal ekle, test kırılsın** |
| `kabul-3` | Σ(SKU hacimleri) = FU hacmi — aynı yöntem |
| `kabul-4` | `REZERVE` + `TAHAKKUK` + `TÜKETİM` ≤ tavan; tahakkuk **DÖNÜŞÜM** (çift düşüm yok) |
| `kabul-5` | defter tutarı ≥ 0 · bütçe politikası tekilliği — **kısıt ihlali reddedilsin** |
| `kabul-6` | işaretsiz `DÜZELTME` = 0 (backfill sonrası) · alt-türlü `REZERVE` **reddedilsin** |
| `kabul-7` | `R1`–`R3` sonrası **veri kayıpsızlığı sorguyla ispat**; `R2`'de **sayım kaydı** |
| `kabul-8a` | `K-2.1.8a`'nın `❌`'i `✅`'ya çevrilir — **bu dalgada** (`S14` ile) |
| `kabul-8b` | `K-2.5.11`'in `❌`'i `✅`'ya çevrilir — ⚠️ **bu dalgada DEĞİL**, `S13` ile ([[T-207]]) |

⚠️ `kabul-2`/`kabul-3`/`kabul-5`/`kabul-6` **aynı şekli** paylaşıyor: bir ölçütün
sağlandığını göstermek yetmez, **ihlali kasten üretip testin kırıldığı** gösterilir.
Bu, `§2.7 #9`'un kabul tarafındaki hâli — sinyal sabitse, sinyal değildir.

> ⚠️ **`kabul-8` neden ikiye ayrıldı:** `S13` bu migration'ın dışında (kolon eklemiyor),
> ama `K-2.5.11`'in ihlal notu `S13`'e bağlı. Dalga kapanışında o `❌`'i çevirmek, yapılmamış
> bir işi yapılmış göstermek olur — `L2 §Bu katmanın kuralları md.5`'in adres kuralı gereği
> her işaret **kendi** adresiyle kapanır.

## ⛔ Dalgaya GİRMEYEN, ve gerekçesi

| kalem | neden |
|---|---|
| `S3` — `net = brüt − indirim` | sıralanacak şey veri düzeltmesi değil, bir **tanım** (3/3 satır ihlal) → `v2-UC-ALAN` · [[T-209]] |
| `K-2.7.4a` — `net ≤ brüt` akıl sağlığı kontrolü | `C2`'ye bağlı ([[T-208]]): **iade negatif tutarla temsil edilecekse kural yanlış olabilir.** `S3`'ü düşürme gerekçesiyle aynı: *bir kısıt ya doğru veriyi reddeder, ya alanı anlamı dışına zorlar.* **Kural olarak `L2`'de kalır; kısıt olarak girmez** — `T-208` kapanınca ayrı kalem |
| `S13` | kolon eklemiyor ([[T-207]]); işi servis tarafında, migration'da değil |

### Üç bağlayıcı kısıt (ürün sahibi, 2026-08-13)

1. **Tek geri dönüş noktası** — tek migration seti, tek `down`. Kalemler ayrı ayrı
   indirilmez.
2. **Çıkarmalar dalganın parçası** — `R1`–`R3` ertelenmez.
3. **Seed atomik** — beş kalem tek işlemde, kısmi seed yok.

---

# Açık kalanlar

| Konu | Bekliyor |
|---|---|
| İade temsili | Ölçüm — net tanımı buna bağlı |
| `net = brüt − indirim` tutarlılığı | Ölçüm — mevcut veride |
| Veri ayrımı modeli | Karar — `NFR-3` |
| Rol kümesi | Karar |
