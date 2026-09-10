# `HALKA-3` İŞ-2 — ACTUALS **OLAY MODELİ**: bir ERP satırı, bir ya da iki olay; ayrı on-invoice bacağı ÖLÜR
### Şeritler: `data-engineer` (A · D) → `backend-engineer` (B) ∥ `qa-engineer` (C) · Hüküm: `Z111 §12` (`Z-K3 F12-2`), ürün sahibi + Fable 2026-09-10

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.** Raporunda da etiket kullan,
> **araç notlarını yaz**, son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

> ### ⛔ `§0.0`'I OKUMADAN HİÇBİR ŞERİT BAŞLAMAZ
> ~~Hükmün **altı öncülü/boşluğu** kayıt anında ölçüldü ve **ürün sahibinin cevabını bekliyor**.~~
> ⭐ `Z111 §13` (2026-09-10/11) blokelerin cevaplarını verdi — `§0.0` tablosu `§0.2`'nin ve `§3`'teki
> ilgili satırların **üstüne yazar**. Hâlâ bloke: **N1** (bedelsiz malın defter/eşleşme kısmı —
> bedelsiz-ürün taktiği yok). ⛔ **1835 ve sonrası migration'lar, harness enum-körlüğü şeridi
> (`docs/process/HARNESS_PG_ENUM_KORLUGU_BRIEF.md`) inmeden BAŞLAMAZ.**

---

## 0 · OKUMA SIRASI — ⛔ her yol 2026-09-10'da `ls`/`find`/`grep` çıktısında görüldü

```
1  docs/process/BRIEF_SABLONU.md
2  docs/brd-v2/04_KARAR_KAYDI.md → Z111 §12 (tamamı: §1–§6 hüküm · §12.1 öncüller · §12.2)
                                    Z111 §9–§11 (Z-K6 onay-anı deseni) · Z98 §3 (tanım → yazar → kısıt)
3  docs/process/HALKA3_IS1_KAPANIS.md          ← İŞ-1'in ölçtüğü evren, tüketiciler, K1–K6
4  docs/process/HALKA3_ACTUALS_SOZLESMESI_BRIEF.md §2 (Ş1–Ş7) · §11 (brief kusurları B1–B3)
5  docs/domain/ACTUALS_IMPORT_SOZLESMESI_v1.md  ← DIŞ-YÜZ taslağı; iç model buna UYAR
6  collmind.backend/src/database/entities/sales-actual.entity.ts · sales-actual-batch.entity.ts
7  collmind.backend/src/modules/modes/actuals-first/sales-actuals/
     sales-actuals.service.ts:170-340 (ingest + REPLACE) · sales-actuals.repository.ts
     services/sales-actuals-validation.service.ts (red kodları :76-90, sözlük :107)
8  collmind.backend/src/modules/shared/actuals-resolver/actuals-resolver.types.ts
9  collmind.backend/src/modules/modes/actuals-first/on-invoice/on-invoice.service.ts:417-610  ← ölecek yolun defter yazımı
10 collmind.backend/src/modules/modes/actuals-first/ledger/dto/create-ledger-entry.dto.ts · ledger.service.ts
11 collmind.backend/src/modules/modes/actuals-first/reversal/reversal.service.ts:59-170
12 collmind.backend/src/common/date/local-today.ts · src/common/row-parsing/pick-cell.ts
13 collmind.backend/src/database/entities/baseline-volume-import-batch-row.entity.ts  ← *_NOT_FOUND AİLESİ (Z87)
14 collmind.backend/src/modules/modes/actuals-first/agreement/agreement.service.ts:834 (approve)
   collmind.backend/src/modules/modes/planning-first/plan/plan.service.ts:1786 (approve)
15 docs/contracts/SYSTEM_INVARIANTS.md → INV-R-001..007 · INV-R-005b · INV-B-003/005/006 · INV-L-006
16 docs/brd-v2/03_IS_KURALLARI/L2_04_hakedis_ai_kurulum.md → K-2.13.14h6 + F12
17 .claude/backlog/MIGRATION_SEQUENCE.md → 1834 (enum geri-alınamazlık notu) · 1835 · 1836 · 1837
18 docs/decisions/0012-finansal-kayitlar-fiziksel-silinemez.md
19 collmind.backend/scripts/migration-verify.sh · scripts/mutate.sh · scripts/scan.sh
20 docs/DISIPLIN.md → F07 TANIM → YAZAR → KISIT · F05 "kuralın öncülü SEED'se …"
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | bu brief'te nerede |
|---|---|---|
| `Z111 §12 §1` | depolama = olay satırları; üyeler üreticileriyle; NET türetilir; olay tipi TÜREV | `§3.1` · `§3.2` |
| `Z111 §12 §2` | dosya sözleşmesi ERP-doğal; ürün/müşteri anahtarları; fatura-tarihi → dönem; iki grain | `§3.2` · dış-yüz belgesi |
| `Z111 §12 §3` | kabul kuralları (red sözlüğü, üye + üretici aynı turda) | `§3.3` |
| `Z111 §12 §4` | K-2.13.14h6 F12 · INV-R-005b · seed 3 satır düzeltmesi | `§3.6` · `§3.7` |
| `Z111 §12 §5` | anlaşma bağı · posting_date · NO_ENVELOPE · yeniden yükleme · CPL'siz müşteri · on-invoice ölümü | `§3.4` · `§3.5` · `§3.8` · `§3.9` |
| `Z111 §12 §6a` | bu brief: iki fixture seti · migration · Z-K1 anlaşma tekilliği | `§4` · `§3.10` |
| `Z111 §9` | Z-K6 onay-anı deseni | `§3.10` |
| `Z111 §11 Ö1` | NEGATIVE_AMOUNT | `§3.3` |
| `Z91` · `Z98 §3` · `Z83` | üretici yoksa üye yok · tanım→yazar→kısıt · doğum kuralı | her iş |

⛔ **Numarasız hüküm = DUR.**

## 0.0 · ⭐ `Z111 §13` — BLOKELERİN CEVAPLARI (2026-09-10/11) · ⛔ BU TABLO `§0.2`'NİN VE `§3`'TEKİ İLGİLİ SATIRLARIN **ÜSTÜNE YAZAR**

Bir satır `§0.2`/`§3` ile çelişirse **bu tablo kazanır**. Eski metinler iz için silinmedi.
```
blok  hüküm (Z111 §13)                                          açılan iş · brief yeri
U1    çift GERÇEK, defter taşıyor → DÜZELTME YOK; KAYITLI İSTİSNA   §3.10: tekillik İLERİYE DÖNÜK (onay-anı);
      (Z29 deseni, adıyla); motor o grain'de AMBIGUOUS_AGREEMENT     mevcut çifte DOKUNMA · §3.5: AMBIGUOUS_AGREEMENT
      → ASKI; çözüm Finans'ın (birini CLOSED/CANCELLED)              askı üyesi + ÜRETİCİSİ bu dalga
U2    net_amount / net_total ÖLMEZ = GİRDİ KAYDI; hesap NET'i TÜREV;  §3.1: kolon düşürme YOK · §3.3: eşitlik =
      ikisi EŞİT; INV-R-006 bu kısıtın invaryantı                     AMOUNT_RECONCILIATION (red, tolerans yok)
U3    "5." sayısı silindi — liste                                    yalnız kayıt
U4    MEVCUT SÖZLÜK KAZANIR: UNKNOWN_* kanonik; yeni kodlar o ada     §3.3 aşağıdaki kod tablosu
      uyar; *_NOT_FOUND AD-BORCU (T-351 EK 4); 7 mevcut kod KORUNUR
B1    BATCH = TEK DÖNEM; farklı dönem satırı → RED MIXED_PERIOD;     §3.8 AÇIK: süpersede batch-düzeyi, ters kayıt ·
      süpersede batch-düzeyi; kısmi UNIQUE GEÇERLİ, index DEĞİŞMEZ   §3.3 MIXED_PERIOD
      [ÖLÇÜLDÜ: sales-actuals.service.ts:141-172] ingest zaten kapsam başına grupluyor ⇒ uyumlu
B2    tenant.settings.match_grain (jsonb) — tanım + yazar (seed:     §3.3 GRAIN_MISMATCH AÇIK (üretici bunu okur)
      FU_CPL_MONTH) BU DALGA; kısıt/UI olay-tetikli                   [ÖLÇÜLDÜ: tenants.settings jsonb VAR]
B3    KANAL = CPL'İN KANALI (tek kaynak)                              §3.2 müşteri-kodu yolu AÇIK
      [ÖLÇÜLDÜ: customers ⋈ cpls ⋈ channels] 27 · eşit 27 · farklı 0 ⇒ çelişki yok
B4    BEDELSİZ MAL = TÜKETİM (trade-spend): değer adet × birim-fiyat  ⛔ N1 — HÂLÂ BLOKE (defter kısmı):
      → on-invoice bedelsiz-ürün taktiğiyle eşleşir → zarftan         [ÖLÇÜLDÜ: main.mechanics 6 · main.tactics 5]
      (planlı: rezervden; plansız: available'dan — Z-K5)              bedelsiz-ürün taktiği/mekaniği YOK ⇒ hedef tanımsız
                                                                     ⇒ depolama + türetme AÇIK; defter/eşleşme DUR
B5/B6 "fiyat = 0" KABUL EDİLMEZ → RED FREE_GOODS_UNPRICED;            §3.2: bedelsiz İKİ şekil (indirim = brüt · bayrak +
      sıfır-brüt reddi KORUNUR; iki şekil                             fiyat > 0) · §3.3 FREE_GOODS_UNPRICED · §4.1 fixture
ENUM  down() = TİPİ YENİDEN YARAT · harness enum-körlüğü şeridi       §3.1: ⛔ ŞERİT A 1835'e ancak HARNESS ŞERİDİ
      1834/1835'ten ÖNCE · ekleme ile kullanım AYRI dosya             İNDİKTEN SONRA başlar · 1835 YALNIZ üye ·
      [§13.2 N2: numara eşlemesi düzeltildi]                          kolonlar + match_* → 1838
DÖNEM actuals dönemi fatura-tarihinden (değişmedi) · off-invoice      bu brief'in DIŞI — halka-4 fatura-girişi girdisi
      fatura dönemi KULLANICI seçer
```

### `0.0.1` · §3.3 İÇİN KANONİK KOD TABLOSU (U4 · B1 · B5/B6 · U2)
```
MEVCUT — KORUNUR (7 + ilgili)   UNKNOWN_CPL · UNKNOWN_SKU · UNKNOWN_FU · SKU_WITHOUT_FU · FU_SKU_MISMATCH ·
                                UNKNOWN_CATEGORY · AMBIGUOUS_CATEGORY · CHANNEL_MISMATCH · FU_CATEGORY_MISMATCH ·
                                MISSING_REQUIRED_FIELD · INVALID_GROSS_AMOUNT · INVALID_NET_AMOUNT ·
                                INVALID_DISCOUNT_AMOUNT · NET_EXCEEDS_GROSS
                                ⚠️ kategori/kanal dosyadan kalkınca UNKNOWN_CATEGORY · AMBIGUOUS_CATEGORY ·
                                CHANNEL_MISMATCH'in DOSYA-TETİKLİ üreticisi kalmaz — hüküm "korunur" dedi ⇒
                                SİLİNMEZ; hangi yoldan tetiklenebildiğini ÖLÇ ve raporla (sessiz ölü kod DEĞİL, liste)
TERFİ                           AMOUNT_RECONCILIATION  uyarı → RED (tolerans yok)
YENİ — mevcut ada uyar          UNKNOWN_CUSTOMER · INVALID_DATE · MIXED_PERIOD · DISCOUNT_EXCEEDS_GROSS ·
                                HEADER_DISCOUNT_UNALLOCATED · DISCOUNT_WITHOUT_SALE · NEGATIVE_AMOUNT ·
                                FREE_GOODS_UNPRICED · GRAIN_MISMATCH
EŞLEŞME/ASKI (red DEĞİL)        NO_ENVELOPE · AMBIGUOUS_AGREEMENT — satırın match_status/match_reason'ında
```

## 0.2 · ~~⛔ BLOKE~~ → `§0.0` İLE CEVAPLANDI (N1 hariç) — ÖLÇÜLMÜŞ ÖNCÜL UYUŞMAZLIKLARI VE BOŞLUKLAR (`Z111 §12.1` + Team Lead brief-tasarım ölçümü)

Kaynağı `Z111 §12.1`; **B5/B6 bu brief yazılırken** hükmün iki maddesi yan yana okunarak bulundu.
```
kod  ne                                           bağlı iş                       durum
U1   çakışan APPROVED×APPROVED çift SEED DEĞİL     §3.10 çakışmayı "düzeltmek"    ⛔ BLOKE — STA-2026-003/004 defter
     (agreement.seed.ts:409 yorumu; ledger 1+2)                                   taşıyor; düzeltmek defteri geriye yazar
U2   net_amount / net_total kolonları BUGÜN VAR    §3.1 kolon ölümü · INV-R-006   ⛔ BLOKE (kolon düşürme); türetilen
     (hüküm "kolon YOK")                                                         NET sorgusu AÇIK
U4   red kodu adları iki ailede; 7 mevcut kodun    §3.3 yeniden adlandırma        ⛔ BLOKE (ad değişikliği); YENİ kodlar
     kaderi yazılı değil                                                         AÇIK
B1   batch-süpersede KAPSAMI — dönem satırdan       §3.8 yeniden yükleme ·         ⛔ BLOKE
     türeyince yeni dosya NEYİ süpersede eder       M-A batch şeması
     [ÖLÇÜLDÜ: pg_indexes] ux_sales_actual_batches_active_scope
     (tenant, fiscal_period, cpl, category, channel) WHERE ACTIVE ∧ deleted_at IS NULL
B2   GRAIN_MISMATCH'in tenant grain-politikası      §3.3 GRAIN_MISMATCH üretici    ⛔ BLOKE (üye DOĞMAZ — Z91)
     alanı YOK (tenants: yalnız timezone)
B3   müşteri yolunda kanal: customers.channel       §3.2 müşteri anahtarı yolu     ⛔ BLOKE (müşteri-kodlu satır);
     (metin) ↔ cpls.channel_id — hangisi, çelişirse                              CPL-kodlu satır AÇIK
B4   FREE_GOODS değerinin DEFTER etkisi            §3.4 FREE_GOODS deftere        ⛔ BLOKE (defter); depolama + türetme AÇIK
B5   bedelsizin "fiyat=0" şekli brüt=0 üretir ⇒    §3.2 FREE_GOODS türetmesi ·    ⛔ BLOKE (o şekil)
     "gross = 0 korumacı red durur" (§12 §3) onu   §3.3 gross=0
     REDDEDER
B6   "fiyat=0 ⇒ FREE_GOODS" + "değer = adet ×       §3.2 FREE_GOODS değeri         ⛔ BLOKE (o şekil)
     birim-fiyat (dosyadan)" ⇒ o şekilde değer = 0
```
> ### ⇒ Bloke olmayan **çekirdek** geniş: olay türetmesi (SALE / DISCOUNT / FREE_GOODS'un
> ### "indirim = brüt" ve "bedelsiz işaret" şekilleri) · CPL-kodlu ve SKU/FU-kodlu satır ·
> ### fatura-tarihi → dönem · yeni red kodları · posting_date · match_status/NO_ENVELOPE ·
> ### on-invoice tüketici taraması · Z-K1 anlaşma tekilliği (onay-anı) · seed 3 satır.

---

## 1 · PROBLEM — tek cümle

> ### Bir ERP satırının indirimi bugün **iki yerde, iki anlamda** yaşıyor: `sales_actuals.discount_amount`
> ### (deftere yazılmaz) ve `on_invoice_entries.discount` (deftere yazılır) — ürün **tek kaynak** istiyor.

```
[ÖLÇÜLDÜ: sales-actual.entity.ts:31-35,100-108]      actuals discount_amount — "asla ledger'a yazılmaz"
[ÖLÇÜLDÜ: on-invoice.service.ts:556-597]              ayrı bacak deftere yazar (sourceType MANUAL, agreementId YOK)
[ÖLÇÜLDÜ: pg_enum sales_actuals_event_type_enum]      {SALE} — olay alanı VAR, tek üye
[ÖLÇÜLDÜ: SELECT count(*) FROM main.on_invoice_entries] 0 · batches 0 · ledger LEDGER|ON_INVOICE|% 0
[ÖLÇÜLDÜ: SELECT gross-net-discount FROM main.sales_actuals] 25000 · 20000 · 18000 — 3/3 seed tutarsız
```

---

## 2 · EVREN — ⛔ şekiller ÖNCE, liste SONRA (`BRIEF_SABLONU §3.4`)

```
E1  İÇ-ALIM       dosya → satır → olay satırları (SalesActualsService.ingest + validation + repository)
E2  DEPOLAMA      sales_actuals · sales_actual_batches · event_type enum · kısmi UNIQUE index
E3  TÜREV OKUMA   NET · aylık toplama · summarize/summarizeByFu · batch totals (gross/net/discount_total)
E4  EŞLEŞTİRME    actuals-resolver.types.ts (bugün gövdesiz) · match_status/reason · NotMatchedReason
E5  DEFTER        ledger.service createEntry · LedgerSourceType · posting_date · reversal (CREDIT)
E6  ÖLEN BACAK    on_invoice_* — İŞ-1 §1 tablosu: backend 13 (i) dosyası · frontend 6 (i) dosyası ·
                  e2e 6 · spec 4 · capabilities.ts · app.module.ts · seed/teardown sayaçları
E7  SÖZLEŞME      INV-R-001/002/003/004/005/005b/006/007 · INV-B-003/005/006 · INV-L-006 · K-2.13.14h6 · K-2.1.8a1
E8  SEED/FIXTURE  seeds/data/actuals_2026-0{1,2}.csv · sales-actual.seed.ts · test/sales-actuals*.e2e-spec.ts
```
```
[ÖLÇÜLDÜ: grep -rln -F -e sales-actuals -e sales_actuals -e SalesActual collmind.backend/test]
  b3-exception-wave-cell-migrations · budget-tier-notification · customer-import-xlsx ·
  e2e-preflight-baseline-cleanup.ts · helpers/admin-datasource.ts · helpers/seed-e2e.ts ·
  modes-write-capability-boundary · on-invoice-ledger-invariants · role-journey ·
  sales-actuals-consumer-absence · sales-actuals
[ÖLÇÜLDÜ: find src/modules/modes/actuals-first/sales-actuals src/modules/shared/actuals-resolver -name "*.spec.ts"]
  sales-actuals.module.spec.ts (INV-R-005 sınır testi) · sales-actuals.service.spec.ts ·
  services/sales-actuals-validation.service.spec.ts
```
⛔ **`E6` İŞ-1 listesini DEVRALMA** — İŞ-1 raporu brief listesinin **eksik** olduğunu buldu (B2).
Ölüm öncesi tüketici taraması **yeniden** yapılır, **sembol + tablo adı + ham SQL + tırnaklı tablo
adı** (`"main"."on_invoice_entries"`) biçimleriyle; pozitif kontrolle.

---

## 3 · İŞLER

### `3.1` · DEPOLAMA — olay satırları (`§12 §1`) · ŞERİT A (tanım) → B (yazar)
```
event_type  SALE (var) + ON_INVOICE_DISCOUNT + FREE_GOODS   ⛔ RETURN EKLENMEZ
            ⛔ üye ÜRETİCİSİYLE aynı dalgada (Z91) — migration üyeyi açar, B aynı dalgada üretir
SALE                 grain + adet + brüt
ON_INVOICE_DISCOUNT  grain + tutar (adet YOK)
FREE_GOODS           grain + adet + tutar = 0 · değer = adet × birim-fiyat (DOSYADAN; BPTT hesabı YOK)
NET                  sorgu: Σ SALE − Σ ON_INVOICE_DISCOUNT — ⛔ kolon ölümü U2'ye BLOKE
```
⚠️ **Enum `ADD VALUE` geri alınamazlığı** `1834` ile AYNI sınıf:
```
~~[REVIEW İDDİASI — DOĞRULANMADI: ürün sahibi notu, MIGRATION_SEQUENCE 1834]
  Postgres'te enum DROP VALUE yok ⇒ down() üyeyi silemez ⇒ migration-verify.sh dört-durum assert'i çarpar~~
⭐ F12 — ÖLÇÜLDÜ 2026-09-10 (data-engineer sentetik deney + Team Lead bağımsız doğrulama):
[ÖLÇÜLDÜ: grep -c -F pg_enum scripts/migration-verify.sh → 0 · pozitif kontrol pg_constraint 3 · pg_indexes 1 · pg_trigger 1]
  ⛔ HARNESS'IN SNAPSHOT'I pg_enum'A HİÇ BAKMIYOR (kolonlar · kısıtlar · index · trigger · satır-hash)
[ÖLÇÜLDÜ: şerit, sentetik enum + migration-verify.sh, üç down() seçeneği]
  seçenek                                     harness            pg_enum geri mi   veri
  (i)   no-op down + düz ADD VALUE             KIRMIZI — ama       HAYIR             —
                                               assert'ten DEĞİL,
                                               PG 42710 "already exists"
  (i-b) no-op down + ADD VALUE IF NOT EXISTS   ⛔ SESSİZ YEŞİL      HAYIR             görünmez
  (ii)  tip yeniden yarat (rename→create→       YEŞİL (gerçek)      EVET, birebir     üyeyi taşıyan satır varsa
        ALTER COLUMN USING→drop)                                                     22P02 AÇIK HATA, ROLLBACK
[ÖLÇÜLDÜ: Team Lead, psql BEGIN; ALTER TYPE … ADD VALUE 'B'; SELECT 'B'::…; ROLLBACK]
  "unsafe use of new value … must be committed before they can be used" ⇒ AYNI migration dosyasında
  ADD VALUE + o değeri kullanan INSERT/UPDATE OLAMAZ
[ÖLÇÜLDÜ: src/config/typeorm.config.ts:125] migrationsTransactionMode: 'each' ⇒ tanım → yazar ayrımı ZORUNLU
⇒ ürün sahibinin iddiası KISMEN çürüdü: "çarpar" yalnız (i)'de ve YANLIŞ SEBEPTEN; (i-b) daha tehlikeli
⛔ ŞERİT A KURALI: (i-b) YASAK · down() ya (ii) ya da harness'ta açıkça adlandırılmış bir "irreversible-add" durumu
   — hangisi ürün sahibinin; harness'a pg_enum eklenmeden 1834/1835 migration-verify YEŞİLİ KANIT DEĞİLDİR
[ÖLÇÜLMEDİ — ölçülecek: (ii)'nin gerçek plans/sales_actuals boyutunda lock süresi · enum'a bağlı view/default
  bağımlılıkları (v_budget_summary vb.) — şerit yalnız 2 satırlık sentetik tabloda ölçtü]
```
`tanım → yazar → kısıt` (`Z98 §3`): `1835` **tanım** (nullable kolonlar, enum üyeleri);
`NOT NULL`/`CHECK` yazar indikten sonra **ayrı numarada** — ⛔ numara Team Lead'den.

### `3.2` · TÜRETME — ERP satırı → olay(lar) (`§12 §1/§2`) · ŞERİT B
```
her satır           → SALE (adet, brüt)
indirim > 0          → + ON_INVOICE_DISCOUNT (tutar = indirim)
indirim = brüt       → FREE_GOODS                     ✅ AÇIK
bedelsiz işareti     → FREE_GOODS                     ✅ AÇIK  [ÖLÇÜLMEDİ — ölçülecek: işaret alanının adı/değer
                                                               kümesi dış-yüz belgesiyle birlikte kesinleşir]
birim-fiyat = 0      → FREE_GOODS                     ⛔ BLOKE (B5 · B6)
```
```
ÜRÜN     sku_code → sku.fu_id ile FU  |  fu_code → FU   · FU'dan SKU ASLA (actuals-resolver.types.ts:19-23)
MÜŞTERİ  cpl_code → CPL ✅ AÇIK  |  customer_code → customers.cpl_id → CPL  ⛔ BLOKE (B3)
KANAL    [ÖLÇÜLDÜ: SELECT count(*),count(channel_id) FROM main.cpls WHERE deleted_at IS NULL] 29 · 29
         ⇒ CPL'den türer; dosyada kanal ALANI ARANMAZ
KATEGORİ [ÖLÇÜLDÜ: information_schema forecasting_units.gu_id · generic_units.category_id] FU → GU → kategori
DÖNEM    fatura-tarihi → 'YYYY-MM'  ⛔ tarih ayrıştırması common/row-parsing/pick-cell.ts deseniyle
         (new Date(kullanıcıGirdisi) YASAK — DISIPLIN "beş sessiz hata biçimi")
KARIŞIK  aynı dosyada SKU'lu ve FU'lu satır MEŞRU (satır bazlı türetme)
```
⚠️ **Mevcut `sales_actuals` kolonları sözleşmeyi taşımıyor:**
```
[ÖLÇÜLDÜ: information_schema.columns main.sales_actuals]
  VAR   fiscal_period · cpl_id · category_id · channel_id · fu_id (NOT NULL) · sku_id · gross_amount ·
        net_amount · discount_amount · volume · invoice_no · event_type · raw_row
  YOK   fatura-tarihi · birim-fiyat · müşteri kimliği · match_status · match_reason
```

### `3.3` · KABUL — red sözlüğü (`§12 §3`) · ŞERİT B · ⛔ üye + üretici AYNI TURDA
```
kod                          ne                                          durum
CPL_NOT_FOUND / SKU_NOT_FOUND master-data eşlemesi yok                   ⛔ ad değişikliği U4'e BLOKE — bugün
                                                                          UNKNOWN_CPL / UNKNOWN_SKU çalışıyor
INVALID_PERIOD / INVALID_DATE fatura-tarihi okunamıyor / geçersiz         ✅ AÇIK (baseline ailesinde emsali var)
MISSING_REQUIRED_FIELD        ürün anahtarı / müşteri anahtarı / birim-fiyat yok   ✅ AÇIK (mevcut kod, genişler)
AMOUNT_RECONCILIATION         net ≠ brüt − indirim, tolerans YOK — RED'E TERFİ     ✅ AÇIK
                              [ÖLÇÜLDÜ: sales-actuals-validation.service.ts:475-482] bugün UYARI
DISCOUNT_EXCEEDS_GROSS        indirim > brüt                              ✅ AÇIK (YENİ)
HEADER_DISCOUNT_UNALLOCATED   grain'siz indirim satırı                    ✅ AÇIK (YENİ)
NEGATIVE_AMOUNT               herhangi alan < 0 — "iade — bu sürümde kapsam dışı"  ✅ AÇIK (YENİ, Z111 §11 Ö1)
DISCOUNT_WITHOUT_SALE         aynı grain'de SALE olmadan indirim — batch-içi  ✅ AÇIK (YENİ)
GRAIN_MISMATCH                tenant politikası ince, satır kaba          ⛔ BLOKE (B2) — üye DOĞMAZ
gross = 0                     korumacı red DURUR                          ✅ (§12 §3) — ⛔ B5 ile çakışır
```
⛔ **Sessiz kabulleri kapat** — İŞ-1 probe'u ölçtü, Team Lead yeniden koştu:
```
[ÖLÇÜLDÜ: probe-return.ts yeniden koşum, exit 0]
  R5 gross+, net −50 KABUL · R5b gross+, net −50, discount 150 KABUL · R6 discount −10 KABUL (yalnız uyarı)
  R7 volume −5 KABUL (volume HİÇ OKUNMUYOR)
⇒ NEGATIVE_AMOUNT "herhangi alan < 0" bunların HEPSİNİ kapatır — ⛔ her biri için bir fixture
```
⛔ **Mesajı nereye yazdığın** (`HALKA3_IS1_KAPANIS.md §4`): statik sözlüğün (`:107`) **tüketicisi yok**;
yeni kodlar **ayrı dal** olmalı — "okunamadı" ile "negatif" ile "sıfır" **aynı koda düşmez**.

### `3.4` · DEFTER — `posting_date` ve kaynak tipi (`§12 §5`) · ŞERİT B
```
posting_date   DÖNEMİN SON GÜNÜ, tenant saat diliminde — deterministik; yeniden yükleme AYNI posting
               [ÖLÇÜLDÜ: local-today.ts:38,84,118,149] calendarDayInTimeZone · tenantTodayIsoDate ·
               tenantTodayAsUtcDate · calendarDayFromDateOrInstant — ⛔ YENİ YARDIMCI AÇMADAN ÖNCE ARA
               [ÖLÇÜLMEDİ — ölçülecek: "ayın son günü" yardımcısı var mı; addMonthsClamped (T-328) sınıfı]
kaynak tipi    [ÖLÇÜLDÜ: create-ledger-entry.dto.ts:15-19] LedgerSourceType = {AGREEMENT, PLAN, MANUAL}
               [ÖLÇÜLDÜ: information_schema ledger_entries.source_type] varchar ⇒ yeni üye DB migration'ı İSTEMEZ
               ⇒ actuals-türevi defter satırı için üye: [ÖLÇÜLMEDİ — ölçülecek: ad; source_type'ı okuyan
                 tüketiciler (ledger.controller, reversal, raporlar) yeni değeri nasıl karşılar]
cpl_id/fu_id   ⛔ NULL DEFTER SATIRI DOĞAMAZ (§12 §5) — [ÖLÇÜLDÜ: create-ledger-entry.dto.ts:68-75] bugün
               cplId?/fuId? opsiyonel ⇒ yeni yol ZORUNLU geçirir; DTO'yu daraltmak başka çağıranları kırar
               mı — ÖLÇ (liste)
FREE_GOODS     ⛔ BLOKE (B4)
```

### `3.5` · EŞLEŞMEME — `match_status` + `reason` (`§12 §5`) · ŞERİT A (kolon) → B (üretici)
```
NO_ENVELOPE    zarf bulunamadı ⇒ satır ASKIDA (ERROR DEĞİL) — ⛔ üretici BU DALGADA
               ⇒ INV-R-001'in "ERROR + validation_errors" üyesinin olay-modelindeki karşılığı
NotMatchedReason bugün never [ÖLÇÜLDÜ: actuals-resolver.types.ts:77] — NO_ENVELOPE ilk üye olur mu,
               yoksa satır-statüsü ayrı bir aile mi: [ÖLÇÜLMEDİ — ölçülecek: halka-3 İŞ-3 (NO_PLAN ·
               NO_AGREEMENT · GRAIN_MISMATCH) ile AYNI ENUM mu — iki aile doğarsa F8]
               ⛔ actuals-resolver.types.ts:74-75 NOT_AGGREGATABLE yorumu Z-K4'e hizalanır (Z111 §8)
```

### `3.6` · `INV-R-005` → `INV-R-005b` · ŞERİT B (sınır) + C (kanıt)
```
[ÖLÇÜLDÜ: SYSTEM_INVARIANTS.md INV-R-005b]  "indirim deftere YALNIZ kısıttan geçerek girer"
⛔ sales-actuals.module.spec.ts BUGÜN INV-R-005'i koruyor — yeni yol YEŞİL kalırken anlamı ÖLEBİLİR
   (HALKA3_IS1_KAPANIS.md §5 mimari uyarısı) ⇒ spec, YENİ yolu ADIYLA sınar; eski metin değil
```

### `3.7` · SEED — 3 tutarsız satır (`§12 §4`, Z107 emsali) · ŞERİT A
```
[ÖLÇÜLDÜ: awk gross/net/discount seeds/data/actuals_2026-01.csv + -02.csv] 3 veri satırı, gross 0/3, negatif 0/3
[ÖLÇÜLDÜ: SELECT gross-net-discount FROM main.sales_actuals] 25000 · 20000 · 18000
[ÖLÇÜLDÜ: sales-actual.seed.ts:4-9,74,142-145] seed CSV'yi SalesActualsService.ingest() ile yükler
⇒ CSV düzeltilir; canlı satırlar için 1836 (veri) mi, yeniden kurulum mu — ÖLÇÜLEREK seçilir
⛔ İmzalı TUTAR yok burada (zarf tablosu gibi değil) — ama hangi alanın düzeltileceği (net mi indirim mi)
   bir SEÇİMDİR ⇒ DUR, iki seçeneği sayıyla getir
⛔ DISIPLIN F05 "kuralın öncülü SEED'se": bu düzeltme K-2.13.14h6'nın ESKİ gerekçesini ortadan kaldırır —
   kabul listesine "K-2.13.14h6 F12 metni hâlâ doğru mu" satırı girer
```

### `3.8` · YENİDEN YÜKLEME — batch-süpersede → TERS KAYIT (`§12 §5`) · ⛔ BLOKE (B1)
```
hüküm   eski türev defter satırları TERS-KAYIT (append-only), silme YOK
[ÖLÇÜLDÜ: reversal/reversal.service.ts:88 reverseTransaction · :162 CREDIT]  anlaşma-işlemi tabanlı
[ÖLÇÜLDÜ: sales-actuals.service.ts:175-210,295-307]  REPLACE: findActiveBatchForUpdate → markReplacedStatus
⛔ KAPSAM (B1) çözülmeden: ne süpersede edilir · hangi defter satırları tersine döner — YAZILMAZ
```

### `3.9` · ON-INVOICE BACAĞININ ÖLÜMÜ (`§12 §5`) · ŞERİT B (kod) → D (şema, 1837)
```
ÖNCE     tüketici taraması LİSTE (§2 E6, yeniden) — sıfırlanmadan 1837 UYGULANMAZ
KOD      rota · servis · modül · capability · frontend yükleme sayfası/menü/uç — İŞ-1 §6 kırılan listesi
KANIT    INV-R-001/002 e2e kanıtı olay modeline TAŞINIR (kaybolmaz):
         [ÖLÇÜLDÜ: test/on-invoice-ledger-invariants.e2e-spec.ts:84,211] bugün on_invoice_* üstünde
         ⇒ yeni metin: "kabul edilen her ON_INVOICE_DISCOUNT olayı ya defter DEBIT'i ya NO_ENVELOPE askısı;
            Σ DEBIT == Σ eşleşmiş indirim" — ⛔ METNİ QA (C) önerir, Team Lead invaryant belgesine yazar
ŞEMA     [ÖLÇÜLDÜ: pg_constraint confrelid on_invoice_*] dışarıdan FK YOK · 0 satır
         ⛔ DROP mu yalnız kod ölümü mü: ADR 0012 + down()'ın veri geri getiremezliği ÖLÇÜLEREK (1837 satırı)
BRD      K-2.13.14l (anlaşma referansı eklediği yer gider) · K-2.1.8a1 (boşa düşer) — ⛔ L2 metnini
         YALNIZ Team Lead yazar; şerit liste getirir
FRONTEND ⛔ frontend-engineer şeridi GEREKİR (6 dosya, İŞ-1 §1) — bu brief'in şeritleri frontend'e DOKUNMAZ;
         Team Lead ayrı brief açar
```

### `3.10` · Z-K1 ANLAŞMA TEKİLLİĞİ (`§12 §5`, Z-K6 deseni) · ŞERİT B
```
kural    CPL × FU × dönem-aralığı için EN FAZLA BİR aktif anlaşma — ONAY-ANI kontrolü, AÇIK RED
yer      [ÖLÇÜLDÜ: agreement.service.ts:834 approve] · emsal plan tarafı [ÖLÇÜLDÜ: plan.service.ts:1786 approve]
         ⛔ plan tekilliği (İŞ-4b) ile AYNI YARDIMCI mı — iki kopya doğarsa F8; önce ara, sonra yaz
bugün    [ÖLÇÜLDÜ: agreements self-join daterange &&] 3 çakışan çift: LTA-2026-0001 DRAFT × STA-2026-0001 DRAFT ·
         LTA-2026-0001 DRAFT × STA-2026-0002 APPROVED · STA-2026-003 APPROVED × STA-2026-004 APPROVED
         ⛔ son çift SEED DEĞİL (U1) — kural İNDİĞİNDE bu çift "zaten ihlal" durumundadır: yeni onayları
            reddeder, mevcut çifte DOKUNMAZ (defter taşıyor) — ⛔ çiftin kaderi U1'e BLOKE
yarış    [ÖLÇÜLMEDİ — ölçülecek: iki eşzamanlı onay — uygulama kontrolü tek başına yeter mi, DB kilidi/trigger
         gerekir mi (1831 emsali: TRIGGER, btree_gist KURULU DEĞİL)] — TERCİHLE değil ÖLÇÜMLE
"aktif"  [ÖLÇÜLMEDİ — ölçülecek: AgreementStatus'ta hangi üyeler aktif sayılır — APPROVED · ACTIVE ·
         (CLOSED? CANCELLED hariç)] ⛔ Z-K6 plan tanımı anlaşmaya OTOMATİK taşınmaz — DUR, liste getir
```

---

## 4 · KAPANIŞIN KANITI — `Z83` · ŞERİT C (qa, AYRI EL)

### `4.1` · İKİ FIXTURE SETİ (`§12 §6a`) — her biri bilinen-yeşil + bilinen-kırmızı
```
SET-1  AYLIK TOPLAM     FU-kodu + CPL-kodu · bir satırda indirim, birinde yok
SET-2  FATURA SATIRI    SKU-kodu + CPL-kodu (⛔ müşteri-kodu B3'e BLOKE) · aynı ay birden çok fatura ·
                        aşağıdan yukarı toplama AYLIK TOPLAMLA AYNI sonucu vermeli (iki taraflı)
BEDELSİZ  üç şekil:     indirim = brüt ✅ · bedelsiz işaret ✅ · birim-fiyat = 0 ⛔ BLOKE (B5/B6)
KARIŞIK   aynı dosyada SKU'lu + FU'lu satır
RED       §3.3'ün her AÇIK kodu için bir satır · R5/R5b/R6/R7 sessiz kabullerinin her biri
```
⛔ **Ayırt edicilik `mutate.sh` ile** — her yeni red kodunun üretici satırı mutasyona uğrar →
`MUTASYON YAKALANDI` görülmeden kod "var" sayılmaz. `toHaveBeenCalledWith` **ayırt etmez** (DALGA-A).

### `4.2` · MIGRATION — `migration-verify.sh` ile (`Z109` hüküm 26)
```
bash scripts/migration-verify.sh <sınıf|dosya>   ⛔ K4 fixture'ı şerit yazar; yoksa ÖLÇEMEDİM
enum ADD VALUE geri alınamazlığı → §3.1 ilk iş; sonuç 1834 İŞ-4a ile PAYLAŞILIR
```

### `4.3` · DEFTER — sayıyla
```
kabul edilen DISCOUNT olayları Σ == Σ DEBIT (eşleşen) + Σ askı (NO_ENVELOPE)    ⛔ iki dal AYNI koşumda
posting_date == dönemin son günü, tenant TZ — ay sınırı vakası (Pacific/Kiritimati emsali, T-383 A2)
cpl_id / fu_id NULL defter satırı 0
```

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ §0.2 BLOKE listesindeki hiçbir işe GİRME — hüküm gelince brief F12'lenir
⛔ Migration YALNIZ data-engineer yazar · numaralar TAHSİSLİ: 1835 (M-A) · 1836 (M-B) · 1837 (M-C) —
   başka numara GEREKİRSE DUR, Team Lead'den
⛔ backend-engineer entity'ye dokunur, migration YAZMAZ — entity ↔ şema AYNI TURDA hizalanır
   (MIGRATION_SEQUENCE kural 6: iki şerit ayrı ayrı yeşil, çelişki birleşmede)
⛔ docs/brd-v2/** YAZMA (L2 metni ve invaryant metni Team Lead'in) · yeni task AÇMA · commit/push YOK
⛔ frontend'e DOKUNMA — ayrı şerit
⛔ bir ajan kendi kodunun testini YAZMAZ — C ayrı el
⛔ git checkout YASAK — kopya + shasum -a 256 -c; mutasyon scripts/mutate.sh ile
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" (Docker açılışında hayalet KENDİLİĞİNDEN kalkar)
   + collmind.backend/test/.e2e-run.lock varsa DB değiştiren koşum YOK
⛔ PARALEL ŞERİT = DOĞRULAMA İZOLASYONU: git worktree; paylaşılan ağaçta --fix / mutasyon / checkout YOK
⛔ KAPI İKİ ZİNCİR: npm run guards (backend) VE bash <kök>/scripts/run-all.sh (META)
```

### `5.1` · ARAÇ NOTLARI (bu oturumda ölçüldü)
```
zsh'de değişkene konmuş komut/yol listesi KELİMEYE BÖLÜNMEZ:
  P="docker exec …"; $P …  → command not found
  F="a.ts b.ts"; prettier $F → "No files matching" (exit 2 — ARAÇ HATASI, format bulgusu DEĞİL)
  ⇒ yolları AÇIK yaz; psql için heredoc
psql \echo içinde tek tırnak → "unterminated quoted string", sonraki çıktı YANLIŞ etikete yapışır
grep → ugrep: karmaşık -E "complexity limits" → grep -F -e … -e …
--include=*.ts zsh'de glob açılır → --include="*.ts"
scratchpad'den backend modülü koşmak: NODE_PATH=<backend>/node_modules + -r <backend>/node_modules/ts-node/register/transpile-only
git -C MUTLAK yolla · exit kodunu boruya sokma · kök script'leri MUTLAK yolla (cwd kayar)
```

---

## 6 · ŞERİTLER, SIRA, `touches`

```
A  data-engineer     ENUM GERİ-ALINAMAZLIK ÖLÇÜMÜ (ilk) → 1835 tanım (AÇIK kısımları) → 1836 seed kararı
                     touches: src/database/migrations/1835*, 1836* · seeds/data/actuals_*.csv ·
                             scripts/verification/check-fixtures/
B  backend-engineer  (A'nın 1835'i indikten SONRA) entity hizası · türetme · kabul · posting · match_status ·
                     INV-R-005b sınırı · on-invoice KOD ölümü · Z-K1 anlaşma tekilliği
                     touches: sales-actual.entity.ts · sales-actual-batch.entity.ts · sales-actuals/** ·
                             actuals-resolver/** · ledger/dto/create-ledger-entry.dto.ts · agreement.service.ts ·
                             on-invoice/** (silme) · app.module.ts · capabilities.ts
C  qa-engineer       (B ile PARALEL, worktree'de) iki fixture seti · red kodu mutasyonları · INV-R-001/002 taşıma
                     touches: test/sales-actuals*.e2e-spec.ts · test/on-invoice-ledger-invariants.e2e-spec.ts (taşıma) ·
                             sales-actuals/**/*.spec.ts
D  data-engineer     (B'nin tüketici listesi SIFIR olduktan SONRA) 1837
⛔ A→B sıralı (tanım → yazar). B∥C: dosya kesişimi YOK, DOĞRULAMA izolasyonu ŞART.
```

## 7 · E2E KATMANI
```
şerit   ilgili suite'ler + INV-R e2e (taşınan hâli)       ⛔ push yetkisi VERMEZ
full    Team Lead koşar — dalga sonu, T-047 invaryantı dahil, sonra code-reviewer → push-order → Z112
```

## 8 · KAPANIŞ ÇIKTISI (her şerit)
```
1  EVREN          — §2 E1..E8'den dokunduğun şekiller, LİSTE (sayı değil)
2  BLOKE SAYGISI  — §0.2'deki hangi işe GİRMEDİN, ve yolda YENİ bir blok çıktı mı
3  İŞ             — §3 maddeleri, her biri hükme atıflı
4  KANIT          — bilinen-kırmızı + bilinen-yeşil (+ mutate.sh YAKALANDI) · migration-verify.sh çıktısı
5  SÖZLEŞME       — hangi invaryant/L2 metni DEĞİŞMELİ (öneri; yazan Team Lead)
6  KAPI           — iki zincir + unit + ilgili e2e
7  ÜÇ METRİK      — tur süresi · review-tur · DUR sayısı
8  ⛔ NE ÖLÇEMEDİN — ve özellikle: "gerçek ERP export'uyla SINANMADI" (§12 §6c)
```
