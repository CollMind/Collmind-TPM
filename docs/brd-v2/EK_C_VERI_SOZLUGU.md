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

> ❌ **Ölçülmüş sapma (2026-08-18, `Z11`):** **kanal referansı ARTIK YOK.**
> `user_scopes.channel_id` düşürüldü (`T-238`, migration `1809`). Tablonun bugünkü
> kapsam alanları: **`cpl_id` (müşteri) · `category_id` (kategori)**.
>
> Bu satır **düzeltilmiyor, sapma olarak işaretleniyor** — `A7`'nin kararı (kanal bir
> eksendir) hâlâ geçerli; sapan şey **uygulama**. Gerekçe ve bedel `Z11`'de.

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
| `S11` | `donemler` tablosu + **biçim doğrulamalı** backfill · ⛔ **FK YOK** (aşağı) | `K-2.13.21` · `Ö4` |
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

### ⛔ `S11`'in FK'leri GERİ ÇEKİLDİ — `F12` kararının sınırına dönüş (2026-08-13)

İlk uygulama sekiz dönem kolonuna + `claims`'e **bileşik FK** ekledi. Ölçüldü (pozitif
kontrollü, `ROLLBACK` içinde):

```
UPDATE main.agreements SET period_month='2026-02';  → UPDATE 3        ← pozitif kontrol
UPDATE main.agreements SET period_month='2028-01';  → ERROR 23503     ← FK canlı
```

Ve **dönem yaratan bir üretim yolu yok**: `FiscalPeriod` için controller **0**, servis **0**,
`TenantService.create` dönem kurmuyor. Yani **API'den doğan her yeni tenant sıfır dönemle
doğuyor** ve ilk anlaşma/plan/sales-actual yazması ham `23503` ile `500` döner. Tek pencere
bir seed dosyasında sabit: `2025-01..2027-12` — 2028'e geçildiğinde ürün, **hiçbir kod
değişmeden** durur.

> Bu `T-101`'in sınıfının **sertleşmiş** hâli: orada konfigürasyon ulaşılamıyordu, burada
> **veri yokluğu daha önce çalışan bir yolu kapatıyor.**

**Karar: FK'ler çıkar, tablo ve backfill kalır.**

```
S11 bu dalgada:   donemler tablosu + backfill + FK YOK
sonraki dalgada:  FK — ön koşulu DÖNEM YARATMA YOLU
```

📌 **Bu kararı geri almak değil, kararın kendi sınırına dönmektir.** `F12` yumuşatması zaten
şunu söylüyordu: *tablo + backfill bu dalgada; `NOT NULL` bir sonraki dalgada, ön koşulu bir
ölçüm.* FK'ler o sınırın **ötesine** geçmişti — ve nullable bir FK bile referans bütünlüğü
zorlar, yani dönem yaratma yolu yokken yeni tenant'ı **ölü doğurur.**

⚠️ Dönem yaratma bir **ürün yeteneğidir** (`K-2.13.21`, dönem kapanışı ailesi) ve tasarım
gerektirir: **kim yaratır · ne zaman · hangi pencere.** Bir migration kalemi değildir.

## `R` · Çıkarmalar

| # | Kalem | Gerekçe |
|---|---|---|
| `R1` | `ledger_entries.deleted_at` **kaldırılır** | `K-2.3.4` — *"hep boş olmalı"* diyen bir kural, kolonun **olmaması gerektiğinin** işaretidir |
| `R2a` | `users.role` **enum + veri** — değerler **ASCII kalır**; bir ad değişikliği (`FINANCE_MANAGER`→`FINANCE`), üç silme. **Önce sil, sonra adlandır.** ⚠️ **frontend uyumu DAHİL** | `K-2.6.4d` · `K-2.6.10` |
| `R2b` | **ölü referans temizliği** — `APPROVER` · `MANAGER` · `FINANCE` · **+ enum KEY'i `FINANCE_MANAGER` → `FINANCE`** · **ayrı PR** | `K-2.6.4d` |
| `R3` | `skus.unit_of_measure` serbest alanı **kaldırılır** (yerine `S12`) | `K-2.1.12b` |

> ✅ Üçünün de bugün **var olduğu** ölçüldü (2026-08-13, `main` şeması):
> `ledger_entries.deleted_at` nullable timestamp · `users_role_enum` **sekiz** değer
> (`ADMIN, PLANNER, APPROVER, FINANCE, FINANCE_MANAGER, CATEGORY_MANAGER, MANAGER,
> READONLY`) · `skus.unit_of_measure` varchar.

### `R2` eşleme tablosu — karar (ürün sahibi, 2026-08-13)

`K-2.6.4d` sırayı bağlıyor: **önce sayım → sonra eşleme → sonra silme.** Sayım yapıldı
(CTPM'in deploy edilmiş ortamı yok, yani `main` **tek** ortam — 9 kullanıcı):

| bugünkü etiket | kullanıcı | → | **enum değeri** (tel) | **görüntü** (`K-2.6.4`) |
|---|---|---|---|---|
| `ADMIN` | 1 | → | `ADMIN` | `YÖNETİCİ` |
| `PLANNER` | 2 | → | `PLANNER` | `PLANLAMACI` |
| `CATEGORY_MANAGER` | 3 | → | `CATEGORY_MANAGER` | `KATEGORİ MÜDÜRÜ` |
| **`FINANCE_MANAGER`** | **2** | → | **`FINANCE`** ⚠️ ad değişiyor | `FİNANS` |
| `READONLY` | 1 | → | `READONLY` | `İZLEYİCİ` |
| `APPROVER` · `MANAGER` · **(eski) `FINANCE`** | 0 · 0 · 0 | ⛔ | **silinir** | — |

📌 **Enum KEY'i `R2b`'ye ertelendi (2026-08-13).** Bugün `UserRole.FINANCE_MANAGER`'ın
**değeri** `'FINANCE'` — okuyanı yanıltır, ve bu tam olarak bu turda **iki kez** ısıran
sınıftır: **ad benzerliği ile anlam ayrışması**. Ayrıca `K-2.6.4`'ün *"kullanımdan kalkmış
etiket"* kavramı açısından, key olarak kalan `FINANCE_MANAGER` o listede **yaşamaya devam
ediyor görünür**.
Ama düzeltmesi **çağrı yerlerini** değiştirir ve ölçülmelidir → `R2b` ile aynı tur.
**Değer doğru, key kozmetik — dalgayı büyütmeye değmez.**

> ### ⚡ GEÇERSİZLEŞTİ — `ADIM 3` kapsamına alındı (2026-08-17, kayıt `Z7`)
>
> *"Dalgayı büyütmeye değmez"* gerekçesi **iki sebeple düştü**:
>
> 1. **Dalga zaten o dosyalara dokunuyor** — `ADIM 3` `@Roles` dekoratörlerini ve rol
>    haritasını yazacak; maliyet **sıfıra** indi.
> 2. **Kozmetik olmaktan çıktı** — `ROLE_CAPABILITIES` **rollerle anahtarlanacak**, ve
>    `UserRole.FINANCE_MANAGER`'ın **değeri** `'FINANCE'`. Haritanın **anahtarı ile veri
>    değeri ayrışır** — yukarıdaki *"ad benzerliği ile anlam ayrışması"* uyarısının ta
>    kendisi.
>
> Ölçüm (`0072`): ölü **değerler** temiz (`0`/`0`/`0` — `R2b`'nin o yarısı **indi**), ama
> key `64` uçta kullanımda.

> ⚠️ **MIGRATION SIRASI: önce SİL, sonra YENİDEN ADLANDIR.** Eski `FINANCE` siliniyor **ve**
> `FINANCE_MANAGER` `FINANCE` oluyor — ters sırada çakışır.

### 📌 Rol değer kümesi — KANONİK KAYIT (tek doğruluk kaynağı)

```
ADMIN · PLANNER · CATEGORY_MANAGER · FINANCE · READONLY
```

**Bu satır kanoniktir.** `collmind.backend/src/database/entities/user.entity.ts` ve
`collmind.frontend/src/types/user.types.ts` ona **atıf verir**; iki repo ayrı CI olduğu
için kod düzeyinde bağımlılık kurulamaz, senkronu koruyan şey **bu kayıttır**.

⚠️ **Bir test bu kayda karşı İKİ YÖNLÜ assert etmelidir:**

```
frontend değerleri  ⊇  kanonik küme     (eksik yok)
frontend değerleri  ⊆  kanonik küme     (FAZLA da yok)
```

İkincisi kritik ve çoğu zaman atlanır: yalnız *"eksik yok"* sınanırsa, sessizce eklenen
bir değer görünmez.

⛔ **Testin içine elle yazılmış statik bir dizi YETMEZ** — o dizi **bayatlar**, ve
bayatladığında test **yeşil kalır**. `guard.sh`'ın öğrettiği sınıf: elle tutulan bir liste
kendisi bir doğruluk kaynağına dönüşür ve sessizce ayrışır. Üçüncü bir kopya doğarsa bu,
`F1`'in **altıncı yüzü** olur.

📌 **Kabul şartı ölçülmüştür:** backend enum'una `'YÖNETİCİ'` mutasyonu uygulandığında
bugün **dört kapı da yeşil** kalıyor (backend `tsc`/`guards`, frontend `type-check`/
`vitest` 524/524). **Yeni test o mutasyonda kırmızıya dönmelidir** — dönmüyorsa test
yazılmamış sayılır.

### ⛔ Enum DEĞERLERİ ASCII kalır — `K-2.6.4`'ün Türkçe adları GÖRÜNTÜ katmanına ait

Karar (ürün sahibi, 2026-08-13), üç gerekçeyle:

1. **Enum değeri bir TEL PROTOKOLÜDÜR** — JWT'de, API'de, URL'de geçer. `KATEGORİ MÜDÜRÜ`
   boşluk ve Türkçe noktalı `İ` taşır; JS'te `toUpperCase()`/`toLowerCase()` locale
   duyarlıdır ve bir gün biri normalize eder (`İ` → `i̇`).
2. **`K-2.6.4` bir İŞ KATALOĞUDUR, bir şema tanımı değil.** `L2`'nin her yerinde kavramlar
   Türkçe yazılı (`TAHAKKUK` · `FİNANSA DEVRET` · `GÖZLENEN`) ve **hiçbiri enum değeri
   olsun diye yazılmadı**.
3. **`K-2.2.7`'nin renk/davranış ayrımının aynısı:** görüntü katmanı davranışa sızmaz.
   **Türkçe ad kullanıcıya, `ADMIN` tele.**

⚠️ **Ölçülmüş bedel:** ilk uygulama değerleri Türkçeye taşıdı; enum **key**'leri korunduğu
için backend derlendi ve altı guard yeşil verdi, ama frontend `UserRole.ADMIN = 'ADMIN'`
karşılaştırıyordu → **her rol kapılı rota, her kullanıcı için reddedildi** (admin bypass'ı
dahil). Frontend `type-check` de **0** verdi — `user.role as UserRole` cast'i tipi
susturuyor. → `CLAUDE.md` · *"bir DUR listesi her sınırı saymalıdır"*

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
| 2 | **iki** onay şablonu (`STANDARD` · `TWO_TIER`) · ⏸️ **üçüncüsü ([[T-214]]'e bağlı)** | `K-2.5.13a` |
| 3 | `roller` tablosu, **beş rol** ✅ · `capabilities`/`role_capabilities` **⏸️ `T-165` ile** | `K-2.6.4` · `K-2.6.3` |
| 4 | aktif dönemler | `S11` backfill'inin **hedefi** |
| 5 | mekanik kütüphanesi — kadans/taban/kanıt alanlarıyla | `S1` |

### ~~`EŞİKLİ` şablonu `NULL` eşikle yazılır~~ 🔄 REVİZE (2026-08-14)

> **🔄 Karar bugünkü şemayla çelişiyor — ve dayandığı ayrım modelde YOK.**
>
> Kararın varsayımı *"satır = katalog seçeneği"*ydi; şema *"satır = tenant'ın politikası"*
> diyor: `approval_policies.tenant_id` **`NOT NULL`**, yani bir satırın varlığı zaten
> **seçilmiş politika** demek. `CHK_approval_policies_threshold_template` tam bunun için
> yazılmış ve `THRESHOLD` + `NULL`'u **INSERT anında** reddediyor (ölçüldü, pozitif
> kontrollü: `THRESHOLD` + `50000` → `INSERT 0 1`; `THRESHOLD` + `NULL` → **`23514`**).
>
> ⚠️ Ve `K-2.1.8b` benzetmesi de aynı ayrımı varsayıyordu: *"girilmemiş bir değer
> bayrağıyla durur"* ancak satır bir **katalog** ise anlamlıdır.
>
> **`CHECK`'i gevşetmek çözüm değil:** kabul şartının ikinci yarısı (*"seçilmeye
> çalışılınca reddedilir"*) **gösterilemez** — `approval_policies`'i tüketen **0** modül
> var, seçim yolu yok. Yani kısıt kaldırılır, yerine **hiçbir şey** konmaz (`§4.2`:
> mekanizma var, yol yok).
>
> **Bugünkü davranış korunur:** `THRESHOLD` satırı **eşik girilene kadar yazılmaz.**
> Kararın varsaydığı ayrım → [[T-214]] (katalog/seçim modeli), Faz 1 politika işiyle.
>
> ### ✅ KAPANDI — [[T-214]], 2026-08-17 (kayıt `Z6`)
>
> ⚠️ **Yukarıdaki teşhis DOĞRUYDU ve öyle kalıyor.** Bayatlayan tek cümle şu:
> *"`approval_policies`'i tüketen **0** modül var, **seçim yolu yok**."*
>
> **`b92a725` o yolu açtı:** `PATCH /approval-policies/:id` · `@Roles(ADMIN)` · tek
> çağrıda **şablon + eşik** (`K-2.5.13c`: *"seçer **ve** ayarlar"* — iki ayrı çağrı
> `CHECK`'i ihlal eden bir **ara durum** doğururdu).
>
> Yani kabul şartının **"gösterilemez"** dediği ikinci yarısı — *"seçilmeye çalışılınca
> reddedilir"* — **artık gösteriliyor**, ve `test/approval-policy-write.e2e-spec.ts` ile
> **pinli**:
>
> ```
> THRESHOLD + eşiksiz  →  400, açık mesaj (500 DEĞİL)
> STANDARD  + eşik     →  400   (sessizce yok sayılMAZ — §2.5)
> THRESHOLD → STANDARD →  eşik AÇIKÇA null'lanır, katalog sorgusuyla doğrulandı
> ```
>
> 📌 **Bu bir düzeltme değil, bir KAPANIŞ:** blok bir eksikliği **doğru** teşhis etmişti,
> ve eksiklik kapandı. Model **değişmedi** (`78de03e`) — katalog = enum, seçim = satır,
> parametre = aynı satır.
>
> ⚠️ **`EŞİKLİ` hâlâ SEED'LENMEZ**, ve bu doğru: `X` bir **tenant değeridir**, ürün
> varsayılanı değil. Tenant onu **uçtan** girer.

📌 **`S3` deseninin ÜÇÜNCÜ vakası** — üçünde de sıralanacak şey bir veri düzeltmesi değil,
bir **tanım**:

| kalem | teşhis | sonuç |
|---|---|---|
| `S3` | kısıt yanlış, veri değil | dalgadan **çıktı** |
| `K-2.7.4a` | `net ≤ brüt`, `C2`'ye bağlı | kural kaldı, **kısıt girmedi** |
| **`EŞİKLİ`** | **ayrım modelde yok** | **karar kaldı, seed girmedi** |

<details><summary>Eski karar metni (silinmedi — <code>0006-R</code> deseni)</summary>



İlk uygulama şablonu **hiç yazmadı**, gerekçesi `§2.5` (*"`X` bir değişken, kaynakta somut
tutar yok, uydurma"*). **Refleks doğru, sonuç yanlış:** şablonu hiç yazmamak uydurmaktan
kötüdür — üç şablon `K-2.5.13a`'nın **kararıydı**, ve `EŞİKLİ` orta ölçeğin en yaygın
deseni. Yoksa tenant onu **seçemez**, ve *"kural yazamaz, şablon seçer"* modeli iki
seçenekle kalır.

```
şablon satırı:  EŞİKLİ
eşik değeri:    NULL
davranış:       eşik NULL iken şablon SEÇİLEMEZ — tenant değeri girmeden aktifleşmez
```

`X` bir **tenant değeridir**, bir ürün varsayılanı değil (`K-2.5.13c`: *"tenant şablon
seçer ve eşik değerlerini ayarlar"*). Yani `NULL` **doğru hâldir** — eksik değil,
**girilmemiş**. `K-2.1.8b`'nin (tarihsiz SKU) aynı ailesi: sistemin uydurmadığı bir değer,
**bayrağıyla** duruyor.

⚠️ **Kabul şartı:** `NULL` eşikli bir şablonun **seçilmesi reddedilmeli**. Yoksa sessiz
sıfır sınıfı doğar — `§2.5`.

</details>

### Rol ailesinin verisizliği BİLİNÇLİ — adresli erteleme (2026-08-14)

```
3  roller tablosu, beş rol            ✅ bu dalgada
   capabilities · role_capabilities   ⛔ ARTIK DOLMAYACAK (0056-K3 → (b), kayıt Z4)
   RBAC users.role enum'undan koşmaya devam eder
```

`SÜRESİ_DOLDU` deseniyle aynı: **yapı bugün, davranış Faz 1 tabanında.** `capabilities`
doldurmak, `K-2.6.3`'ün (yetenek tabanlı yetki) **20 yeteneğini şimdi tanımlamak** demek —
ve `0056-K3` hâlâ açık: *"`§7.2`'nin 20 yeteneği mi, daha kaba mı?"* **Veri yazılamaz,
çünkü içeriği bir karara bağlı.**

> ### ✅ ÇÖZÜLDÜ — `0056-K3` → **`(b)`** (2026-08-16, ürün sahibi · kayıt `Z4`)
>
> Yetenekler **kodda** tanımlanacak (`const CAPABILITIES`), **tabloda değil**. Yani
> `capabilities` / `role_capabilities` **hiç dolmayacak** — ve bu satırın `⏸️`'si bir
> bekleme değil, bir **son** oldu.
>
> ⚠️ İki tablo `B` dalgasında **indi** (ölçüldü: `10` ve `9` kolon, **`0` satır**).
> Düşürüldüler — [[T-233]], migration `1807000000000`.
>
> ⚠️ **Düzeltme (kayıt `Z5`):** burada önce *"`Capability` entity dosyası `0`"* yazıyordu ve
> **yanlıştı** — `Capability`/`RoleCapability` sınıfları `role.entity.ts` **içinde** tanımlıydı
> ve `ALL_ENTITIES`'te kayıtlıydı. Ölçüm dosya adı saymıştı, sınıf değil.
> Bu, `T-225`'in (`BudgetReservation`) sınıfı: **yapı var, yol yok.**

📌 **Ama seed kalemi yanıltıcı yazılmıştı:** *"rol kataloğu, beş rol"* teslim edildi ve
mekanizma **yolsuz** kaldı. Yukarıdaki üç satır o boşluğu kapatır — **adresli erteleme,
sessiz eksiklik değil.**

> ⛔ **Ölçüldü 2026-08-13: beşin DÖRDÜ yazılmamış.** Yalnız kalem 4 (`fiscal_periods`,
> 36 satır) var; `budget_policies` · `approval_policies` · `roles` · `capabilities`
> **0 satır**, ve mekanik alanları boş. Migration şemayı kuruyor, **hiçbirine `INSERT`
> etmiyor**.
>
> ⚠️ **Ve bulunuş biçimi bir ders:** kalem 4'ün eksikliği **FK'si seed'i kırdığı için**
> ortaya çıktı. Diğer dördünün FK'si yok — **hiçbir şeyi kırmadılar ve sessizce eksik
> kaldılar.** Bir kanonik listeye yazmak, yazıldığının kanıtı değildir; **listenin her
> kalemi ayrıca ölçülmelidir.**
>
> `K-2.2.8d`'nin joker satırı **zorunludur** — sıfır satır, bütçe politikası
> çözümlemesinin fallback'siz olması demek. → [[T-211]]'in `Done`'unda şart.

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
