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

## `musteriler` (CPL) ✅

| Alan | Tip | Not |
|---|---|---|
| kanal referansı | — | ⚠️ `NOT NULL`, tekil — bir müşteri **tam olarak bir** kanala bağlıdır (`K-2.1.4`) |
| bölge referansı | — | bugün boş |
| ad · kod | metin | |
| aktif | boolean | |

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
| Kısıt eklemesi | defter tutarı ≥ 0 · bütçe politikası tekilliği · net = brüt − indirim |

⚠️ **Hepsi deploy öncesi.** Ve birkaçı için ek gerekçe var: alan olmazsa **karar yeniden
icat edilir** — `hesaplaşma kadansı` bunun en net örneği.

---

# Açık kalanlar

| Konu | Bekliyor |
|---|---|
| İade temsili | Ölçüm — net tanımı buna bağlı |
| `net = brüt − indirim` tutarlılığı | Ölçüm — mevcut veride |
| Veri ayrımı modeli | Karar — `NFR-3` |
| Rol kümesi | Karar |
