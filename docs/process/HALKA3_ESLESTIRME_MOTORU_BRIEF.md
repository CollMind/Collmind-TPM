# Halka-3 — **EŞLEŞTİRME MOTORU** brief'i

> **Okunan HEAD:** meta `98a7698` · be `1c7030f` · fe `b391857` — **push'lu**
> **Girdi kaydı:** `Z96 §6` (kapsam) · `Z98` (sözleşme) · `Z99` (halka-2 sınırları) ·
> `Z100` (**match-ready**, üç sütun)
> ⚠️ Bu brief **halka-2'nin `açıldı` sütunundan** doğdu — her maddesi orada **adıyla** var.

## `§0` · NEREDEN DEVRALIYORUZ
```
halka-2 ÜRETTİ    match-ready satır: fiscalPeriod · cplId · fuId (NOT NULL) · skuId? · invoiceNo?
                  red sözlüğü 14 üye, Record<Reason,string> tip-zorlamalı
                  resolver ARAYÜZÜ: Matched{key} | NotMatched{reason}
halka-2 BIRAKTI   reason tipi KASITLI BOŞ (`never`) — Z91 randevusu
                  ActualsGrainPolicy.targetGrain — persiste KAYNAĞI YOK
                  agregasyon GÖVDESİ yok
```
> ### **HALKA-2 *"MATCH-READY"* ÜRETTİ. HALKA-3 *"MATCHED"* ÜRETİR.**

## `§1` · İLK MADDE — TENANT GRAIN POLİTİKASI ALANI (`tanım → yazar → kısıt`)

`ActualsGrainPolicy.targetGrain` bugün **yalnız tip seviyesinde** yaşıyor; **persiste
edilmiş kaynağı yok**. `Z98 §3` sırası burada **yeniden** uygulanır:
```
tanım   alan doğar (NULLABLE ya da varsayılanlı)
yazar   konfigürasyon yüzeyi / seed / migration varsayılanı — HANGİSİ, ölç ve yaz
kısıt   ancak yazar indikten SONRA
```
⛔ **KARAR NOKTASI — ölç, seçme:** `tenants.settings` **jsonb** olarak zaten var
(`tenant.entity.ts:90`). Grain politikası **ayrı bir kolon** mu, `settings` **içinde** mi?
```
ayrı kolon   tip güvenliği · CHECK mümkün · migration gerekir
settings     migration yok · ama şemasız, CHECK yok, "sessiz varsayılan" riski (§2.5)
```
`settings`'in bugün **ne taşıdığını** ve **kimin yazdığını** ölç; emsal ara (`§7`).
**Ürün sahibi kararı** — ajan seçmez.

⚠️ **Varsayılan `FU × CPL × Ay`** (`Z96 §6`). Ama *"varsayılan"* nerede yaşıyor —
kolon `DEFAULT`'u mu, kod sabiti mi? İkisi **`F8` riski**: aynı değer iki yerde.

## `§2` · `GRAIN_MISMATCH` — ÜYE **ÜRETİCİSİYLE** DOĞAR (`Z91`)

`NotMatchedReason` bugün `never`. Halka-3 **ilk üyeleri** açar — ve `Z91` mutlaktır:
> ### **BİR ENUM ÜYESİ EKLEYEN TUR, ÜRETİCİSİNİ AYNI TURDA BAĞLAR — YA DA DUR.**

İlk üye `GRAIN_MISMATCH`; üreticisi **agregasyon sözleşmesinin reddi** (aşağı). Başka üye
eklenecekse **her biri** üreticisiyle gelir.
⛔ Tip **`Record<Reason, string>`** teşhis sözlüğüyle bağlanır (halka-2 emsali:
`sales-actuals-validation.service.ts` — `tsc` eksik üyeyi **yakalar**, canlı kanıtlandı).

## `§3` · AGREGASYON SÖZLEŞMESİ — MOTORUN ÇEKİRDEĞİ
```
girdi-grain  ≤  hedef-grain
ALT katman ÜST katmana TOPLANIR:   fatura → SKU → FU → CPL × Ay
```
> ### ⛔ **TERS YÖN YASAK: FU-BAZLI GELEN VERİ SKU'LARA *DAĞITILMAZ* — UYDURMADIR (`§2.5`).**
Girdi hedeften **KABA** ise ⇒ **AÇIK RED** (`GRAIN_MISMATCH`), sessiz düşme **DEĞİL**.

**`GU`'nun yeri** (`Z98 §7`): toplama hedefi **DEĞİL**, kategori-türetme **ara katmanı**
(`FU → GU → category`). **Tenant grain menüsünde `GU` YOKTUR** (`FU` · `SKU` · `fatura`).

## `§4` · `summarizeByFu` ROTASI — KOVA + HÜCRE KARARI
Servis/repository **canlı**, rota **bağlanmadı** (`Z100`: `blocked-unreachable`).
`route-cell-map` + `scope-ratchet` **ürün kararı** istiyor (`T-266`).
**Emsal `BL-4`:** kova **C** · okuma yetkisi `MASTER_DATA_READ` — ama **ölçümle gelsin**,
kopyalanmasın: bu uç bir **rapor** ucu, hangi hücre?

## `§5` · ⛔ RETURN ÜYESİ — **BU BRIEF'TE DOĞMAZ**
İade cevapları **gelmedi** (ürün sahibi bekletiyor). `sales_actuals.event_type` tek üyeli
(`SALE`), **nullable** — şema **değişmeyecek** (`Z98 §4`).
```
RANDEVU DAMGASI: "KAPANMIŞ DEĞİL, BEKLEYEN"
iade hükmü gelince: halka-3'ün İÇİNDE ya da hemen ardından AYRI KÜÇÜK DALGA
üye + ÜRETİCİSİ birlikte (Z91)
```
⛔ `T-084` tuzağı: bu satır *"iade kapsam dışı"* diye okunmamalı — **bekliyor**.

## `§6` · DEVRALINAN AÇIK BORÇLAR — halka-3 bunları **KAPATMAZ**, bilir
```
T-373  P0  kategori-kör zarf eşleşmesi        ← ayrı şerit (koşuyor)
T-374  P0  `type:'date'` + `Date`, 12 alan     ← ayrı şerit (koşuyor)
T-351  ⛔  sku.gu_id ↔ fu.gu_id, eşitleyen kısıt 0 — ACİLİYET ARTTI
           ⚠️ HALKA-3'Ü DOĞRUDAN İLGİLENDİRİR: motor FU→GU→category'ye GÜVENİYOR;
             ana veri tutarsızsa eşleştirme de tutarsız olur. Import katmanı satır
             bazında reddediyor ama bu bir SEMPTOM TEDAVİSİ.
```

## `§7` · PİNLER — hepsi **aynı koşumda ayrışmalı**
```
PİN 1  girdi FU · hedef FU        ⇒ Matched, key = CPL × FU × Ay
PİN 2  girdi SKU · hedef FU       ⇒ Matched (SKU'lar FU'ya TOPLANDI — toplam doğrulanır)
PİN 3  girdi FU  · hedef SKU      ⇒ NotMatched{GRAIN_MISMATCH}  ← TERS YÖN, AÇIK RED
PİN 4  girdi fatura · hedef FU    ⇒ Matched (iki kademe toplama)
PİN 5  tenant politikası YOK      ⇒ varsayılan FU×CPL×Ay — ve varsayılanın KAYNAĞI TEK
PİN 6  GRAIN_MISMATCH üreticisi   ⇒ grep: üye ATANAN yol ≥ 1 (Z91 kapısı)
```
⚠️ `PİN 2`/`PİN 4`'te **toplamın kendisi** doğrulanır — `Σ girdi == Σ çıktı`, kuruşu kuruşuna.

## `§8` · ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- ⛔ **`mode-split`:** `src/modules/modes/**` altına **YENİ DOSYA açılamaz** — ortak yardımcı
  mevcut dosyaya ya da `src/common/`/`src/modules/shared/` altına
  (`scripts/guards/mode-split.sh` başlığını **oku**)
- **Migration yalnız `data-engineer`** — gerekiyorsa **DUR**, numara Team Lead'den
- Container'a dokunma · `.env` okuma · **commit/push YAPMA** · `git add -A` YASAK
- `git stash`/`git checkout`/`git reset` YASAK · geri alma `shasum -a 256 -c` ile
- İzole `git worktree` · DB **5434** / şema **`main`** · DB'ye yazdığını **bas ve temizle**
- TTM/TPM dizinlerine dokunma · exit kodunu boruya sokma · `grep -c` sıfırda exit 1
- **Testini sen yazmazsın** (`§3`) · **tam e2e KOŞMA**
- ⛔ **SAYI YAZMA, LİSTE YAZ** (`Z100 §5`: onuncu vaka)
- **`ölçemedim` meşru, `flaky` DEĞİL**
