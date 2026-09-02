# `BL-2` — GİRİŞ (upload ucu + parse)

> ⚠️ **Bu belge `BL` hattının ikinci adımıdır. Yürürlükteki hat adı: `BL`** (`Z79 §1`).
> **Girdiler:** `Z79` (sekiz hüküm) · `Z80` (`T-346`) · `Z81` (`T-333`) · `Z82` (round-trip
> riski) · `BL-1` ölçüm raporu · `BL_BASELINE_HATTI_BRIEF.md`
> **Ön koşul:** `BL-1` **kapandı** (`T-333` indi, `676ff7f`/`e55a86e`).

---

## `§0` · BU ADIMIN SINIRI

```
⚠️ F12 — ADLANDIRMA DÜZELTMESİ (2026-09-02, BL-2 şeridi yakaladı)
~~"BL-1 ✅ TZ ölçümü — KAPANDI"~~  YANLIŞTI ve BU BELGENİN İLK HÂLİNDE YAZILIYDI.
`BL_BASELINE_HATTI_BRIEF`'in §1'i (GÜNDEM maddesi: T-333 TZ ölçümü) ile
BL-1 (ADIM: ŞEMA) AYRI ŞEYLER. Karıştırıldı ⇒ BL-2 hedef tablosu OLMADAN açıldı.
⛔ `W3`'ün dört adı vakasının (Z79 §1) TEKRARI — hükmü veren taraf tarafından.

ön iş  ✅ T-333 TZ ölçümü + dönem etiketleri UTC'ye        KAPANDI (676ff7f)
BL-1   ✅ ŞEMA — main.baseline_volumes + _import_batches   İNDİ (d6c83e7, Z84+Z85)
          grain tenant × sku × cpl × period · period VARCHAR(7)+CHECK · dört CHECK
          RLS: gerçek fail-closed politika TANIMLI, ENABLE/FORCE YAZILMADI (Z85 §2)
BL-2   ⬅ UPLOAD UCU + PARSE                                 BU BELGE
BL-3     DOĞRULAMA (D2 SKU eşleme + D4 kapsam kapısı)
BL-4     YÜZEY
```
⛔ **`BL-2` bir DOĞRULAMA adımı değildir.** Kapsam kapısı (`D4`), SKU eşleme (`D2`) ve
uyarı/red politikası **`BL-3`'ün** işidir. Bu adım **dosyayı alır, satıra çevirir,
reddedeceğini adıyla reddeder** — o kadar.

---

## `§1` · ⛔ YENİ PARSER YAZILMAZ — EMSAL DÖRT, VE BİRİ DAR `[ÖLÇÜLDÜ]`

```
common/services/csv-parser.service.ts                    96   CSV-only  ⚠️ XLSX TAŞIMIYOR
customer/services/file-parser.service.ts                698   XLSX+CSV
on-invoice/services/on-invoice-file-parser.service.ts   741   XLSX+CSV
agreement-transaction/.../off-invoice-file-parser.ts    634   XLSX+CSV
```
Son üçü **import blokları satır-satır aynı**, yalnız **DTO satırında** ayrışıyor; ortak
taban sınıf **yok**. ⇒ Birini **uyarla**; `csv-parser` baseline için **yetersiz**
(Excel gelecek).

⭐ **Ve emsalin en değerli parçası zaten orada:** `excelSerialToIsoDate`
(`common/date/excel-serial-date.ts`), yorumunda **`new Date(str)` ile TAHMİN EDİLMEZ**
yazıyor (`T-121`/`T-328` emsali). `BL-1` üç parser'ı da bu açıdan **temiz** ölçtü.
⛔ **Bu deseni KOPYALAMA, ÇAĞIR.**

---

## `§2` · ⛔ KABUL ÇEKİRDEĞİ — **İKİ PİN** (`Z85` sonrası, `F12` izli)

> ⚠️ **`F12` — BU BÖLÜM DEĞİŞTİ.** İlk hâli *"round-trip pini"*ni kabul çekirdeği ilan
> ediyordu. **`BL-1` (`Z84`) `period`'u bir `Date` DEĞİL, bir DİZGE ANAHTARI yaptı**
> ⇒ round-trip riski **şemayla ortadan kalktı**.
> > **Bir riski ölçmek, bazen onu düzeltmek yerine ŞEMAYLA ORTADAN KALDIRMAYA yol açar.**
> Geriye kalan risk **çevrimin kendisi** — ve yanına **ikinci bir pin** eklendi.

### `2a` · PİN 1 — KAYNAK HÜCRE → PERIOD ETİKETİ, **ÜÇ `TZ`'DE AYNI**
```
kaynak hücre (metin · Excel SERIAL · ISO dizge)  →  'YYYY-MM'
⛔ TZ=UTC · TZ=Europe/Istanbul · TZ=America/New_York  →  AYNI ETİKET
⛔ EXCEL SERIAL-DATE DÂHİL (excelSerialToIsoDate — KOPYALAMA, ÇAĞIR)
```
**Reprodüksiyon:** pin'i yazmadan önce **kaymayı ÜRET** (`T-333`'ün probu: yerel
`getMonth()` ile bir ay kayması **görülmüş** olmalı). Göremiyorsan **yaz**.

### `2b` · ⛔ PİN 2 — KATALOG PAYDASI TÜRETMESİ (**kolay unutulan**)
`Z85 §3`: coverage paydası **tablodan değil KATALOGDAN** türer.
```
payda  =  aktif-SKU × aktif-CPL × 12-period          [G5: TÜRETİLMİŞ evren]
pay    =  baseline_volumes'taki KABUL EDİLMİŞ satır
```
⛔ **İKİ-GİRDİ-İKİ-ÇIKTI ile pinlenir:**
```
PASİF bir SKU/CPL   →  paydaya GİRMEZ
REDDEDİLEN satır    →  tabloda YOK ⇒ paydada "EKSİK" GÖRÜNÜR
```
> ### **BU PİN `BL-2`'DE DOĞAR Kİ `BL-3` *"PAYDA NEREDEN"* SORUSUNU BİR DAHA SORMASIN.**
`BL-3`'ün `≥%95` kapısı **bunun üstüne** kurulacak.

## `§3` · IMPORT OLGUSU — `Z79 §3`, ÜÇLÜ **DÖRDE ÇIKMAZ**

> ### **IMPORT BİLİNÇLİ BİR VERİ-GETİRME EYLEMİDİR;**
> ### **GRID'İN *"HENÜZ GİRİLMEDİ"* ARA-DURUMU ORADA YOKTUR.**
```
tam satır                  →  DOLU olgu
zorunlu alanı eksik satır  →  SATIR REDDİ + rapora SATIR NO + ALAN ADI
                              ⛔ plana HİÇ girmez — YARIM SATIR İTHAL EDİLMEZ
```
⇒ `Q20` üçlüsü **değişmez**; **`NOT_EVALUABLE` import yoluyla ÜRETİLMEZ.**

⛔ **PİN:** eksik-alanlı bir satır içeren dosya yüklenir → **o satır hedef tabloda YOK**,
**aynı dosyadaki tam satır VAR**. *(Ayırt edicilik: ikisi aynı koşumda ayrışmalı —
`§2.7 #6`.)*

---

## `§4` · KISMİ KABUL — `Z79 §4`, VE `D4` İLE ETKİLEŞİMİ

```
satır düzeyi kabul/red + ADLI hata raporu           ← BU ADIM
coverage kapısı TOPLAM EVREN üzerinden               ← BL-3
REDDEDİLEN SATIR "EKSİK"TİR
```
> **Yoksa *"kötü satırları atıp kabul-edilenlerin %95'i"* oyunu doğar.**

⛔ `BL-2`'nin sorumluluğu: **reddedilen satırların SAYISI ve KİMLİĞİ kaybolmadan
`BL-3`'e ulaşmalı.** Rapor bir **ekran metni** değil, bir **veri yapısı** — `BL-3` onu
paydada kullanacak.
📌 Dört emsalin dördü de **kısmi kabul** yapıyor (`BL-1` ölçtü: `sales-actuals:115-119` ·
`off-invoice:279-305` · `on-invoice:553-606` · `customer import`) ⇒ desen **var**, ama
hiçbiri **reddedilenleri bir kapsam hesabına** taşımıyor. **Yeni olan bu.**

---

## `§5` · VERİ ŞEKLİ — `Z79 §2`, migration **`1821`** TAHSİS EDİLDİ

```
plan_mechanic_values + nullable plan_sku_id
NULL = FU değeri geçerli · dolu = o SKU için EZME
çözümleme: TEK RESOLVER (SKU satırı varsa O, yoksa FU)
```
**İki bağlayıcı şart:**
1. ⛔ `UNIQUE` **`K-2.2.8c` dersiyle**: **`NULLS NOT DISTINCT`** + resolver'da **açık
   öncelik**, **gizli tie-break YOK**.
2. ⛔ **`plans=0` PENCERESİNDE iner.** İnmeden önce `SELECT count(*) FROM main.plans;`
   → **`0` değilse DUR ve bildir** (iş **veri taşımaya** dönüşür, o **başka bir karardır**).

⛔ **Migration'ı `data-engineer` yazar** (`CLAUDE.md §3`) — `BL-2`'nin parser işiyle
**aynı ajan değil**. Numara **`1821000000000`**, `MIGRATION_SEQUENCE`'te kayıtlı.

---

## `§5b` · ⛔ `acceptance_status` VE RED-KAYIT EVİ — **ÖLÇÜMLE, AMA ÖLÇÜT ŞİMDİDEN**

`Z85 §3b`: tabloya **yalnız kabul edilmiş satır** girebiliyor (dört anahtar `NOT NULL` +
dört `CHECK`) ⇒ kolonun anlamı **daraldı**.

```
tabloya YALNIZ geçerli satır girebiliyorsa  →  KOLON SADELEŞİR
   ⛔ durum TAŞIMAYAN bir durum kolonu = ÖLÜ VAAT (`tier_roles` sınıfı)
PENDING_REVIEW ancak GERÇEK BİR ÜRÜN AKIŞI varsa doğar
   ("import edildi ama planner ONAYLAMADI")
   ⇒ o akış ÜRÜN SAHİBİNİN HÜKMÜ; kolon onu BEKLEYEREK DOĞMAZ  (İlke 1)
```

**Red kayıtlarının evi:**
```
SORGULANACAKSA  →  AYRI TABLO   (teşhis raporu satır-bazlı filtrelenir — MUHTEMELEN evet)
yalnız GÖSTERİLECEKSE  →  jsonb
```
⛔ **Ölç ve seç** — ve seçimini **hangi tüketiciye** dayandırdığını yaz.

---

## `§5c` · ⛔ PARSER UYARLAMASI — `W2` TUZAĞININ **PARSER HÂLİ**

*"Yeni parser yazılmaz"* (`§1`) doğru, ama **yetersiz**:

> ### **`off-invoice-parser`'IN KENDİ VARSAYIMLARI — KOLON DÜZENİ · TARİH FORMATI · UOM —**
> ### **BASELINE DOSYASINA **SESSİZCE** TAŞINMASIN.**

```
UYARLAMA =  PAYLAŞILAN ÇEKİRDEK          +   DOSYA TİPİ ŞEMASI
            (hücre okuma · serial-date        (kolon düzeni · zorunlu alanlar ·
             · red raporu kanalı)              tarih/sayı formatı · UOM)
            ⇒ ORTAK                          ⇒ AYRI
```
⛔ **Bir parser iki dosya tipini TEK ŞEMAYLA okumaya başlarsa, ikisinden birinin sapması
ötekini KIRAR.** `W2` tuzağının (*"aynı taşıyıcı, iki farklı soru"*) parser tarafı.

---

## `§6` · UYGUNLUK — `Z80`, ZEMİN HAZIR

`T-346` indi (`867fbc0`): `resolveMechanicEligibility` **tek resolver**, negatif yarı
yerinde, `decidedBy` taşınıyor. ⇒ `BL-2` **uygunluk mantığı yazmaz**, gerekiyorsa
**çağırır**.
⚠️ Ve bugünün körlüğü **adıyla**: `applicable_*` alanları **`0/6` dolu** ⇒ ilk tohum
girilene kadar o dallar **koşmuyor**. Import bir tohum getirecekse **fixture kalıcı değer
taşır**.

---

## `§7` · ⛔ İKİNCİ ATEŞLEME DALGASI — `Z68 §3b`

> ### **VERİ-SIFIR DÜNYADA YEŞİL OLAN HER ŞEY,**
> ### **İLK GERÇEK DEĞER-DAĞILIMINDA YENİDEN SINANMAMIŞ DEMEKTİR.**

`BL-2` **ilk gerçek satırları** getiren adım. Bilinen adaylar: `T-347` (blok yorumu beyaz
listeyi geçiyor) · `T-102` · `T-099`. **Yeni bir aday görürsen ADIYLA raporla** — düzeltme
bu adımın işi **değil**, ama **görünmez kalması** da kabul değil.

---

## `§8` · DUR LİSTESİ

```
⛔ MIGRATION YAZMA — 1821 tahsisli ve data-engineer'ın; gerekirse DUR ve bildir
⛔ docs/brd-v2/ DONMUŞ (okuma serbest)
⛔ git stash · git checkout ile geri alma · git add -A · commit — HEPSİ YASAK
⛔ --fix YOK · konteynere DOKUNMA · .env okuma YOK
⛔ DB'ye KALICI YAZMA: yalnız migration/seed yoluyla; ölçüm için ROLLBACK kullan
⛔ /Users/…/Code/TTM ve /Users/…/Code/TPM — tek bayt yazma, komut çalıştırma YOK
⛔ exit kodunu boruya sokma: cmd > /tmp/x.log 2>&1; echo $?
⛔ e2e KİLİTLİ (T-325): ikinci koşum 30 dk BEKLER. Paralel e2e BAŞLATMA.
⛔ improved-KAPISI (Z82): `improved` satırı çıkarsa guard exit 1 verir —
  baseline'ı AYNI turda düşür, AYRI commit'te, kod commit'inden SONRA
⛔ negatif sonuç POZİTİF KONTROLSÜZ raporlanamaz
⛔ arama terimi ARANAN YERİN DİLİYLE — KASA dâhil (LTAAgreement ≠ LtaAgreement: 0 ↔ 28)
⛔ bir belgede "çelişki buldum" demeden önce DOSYANIN SONUNA kadar bak
⛔ "kapılar yeşil" demeden ÖNCE hangi kapıları koştuğunu ADLA say
  (tsc · unit · TAM e2e · npm run guards · money-float --ratchet · lint-ratchet --ratchet)
```

## `§9` · KANIT

```
round-trip pini      TZ=UTC ↔ TZ=America/New_York, AYNI sonuç — ve ÖNCE KIRMIZI görülmüş
kısmi kabul pini     eksik satır YOK · tam satır VAR, AYNI koşumda
kolon tipi           üç adayın round-trip davranışı AMPİRİK ölçülmüş, ürün sahibine hazır
kapılar              tsc · unit · hedefli e2e · guards · iki ratchet — exit koduyla
```
**Tam e2e Team Lead'de.** *"Ölçemedim"* meşru bir çıktıdır; **"flaky" değildir.**
