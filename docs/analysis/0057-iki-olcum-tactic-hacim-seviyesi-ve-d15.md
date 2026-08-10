# 0057 — İki ölçüm: `0019 #2` (tactic/hacim seviyesi) ve `D-15` (hesaplanan sıfır KPI)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR — kod/şema/migration değiştirilmedi
- **Ajan:** architect
- **Ölçüm ortamı:** backend `5bc2787` · frontend `d9bedc5` · DB `collmind_tpm` (Docker, port 5434, şema `main`)
- **Kapsam:** `docs/decisions/OPEN_DECISIONS.md`'nin iki maddesi — `0019 #2` (`bayat?`) ve `D-15` (`açık`)

> Bu belge bir **uygunluk denetimi değildir.** Sorulan soru *"BRD'ye uyuyor mu"* değil,
> **"bugün ne oluyor"**. Uygunluk yorumu ürün sahibinin kararıdır (`CLAUDE.md §2.4`).

---

## 0. Ölçüm ortamının sınırı — önce yazılıyor

`main` şemasındaki plan tabloları **boş**:

```
$ docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm \
    -c "select relname, n_live_tup from pg_stat_user_tables
        where schemaname='main' and relname in
        ('plans','plan_fus','plan_skus','plan_mechanic_values');"

       relname        | n_live_tup
----------------------+------------
 plan_fus             |          0
 plan_mechanic_values |          0
 plan_skus            |          0
 plans                |          0
```

Sonuç: bu belgedeki her iddia **kod yolu** ve **şema** ölçümüdür. Çalışma zamanı davranışı
(özellikle §1.7-B ve §2.4-E) canlı veriyle **doğrulanmamıştır** ve öyle işaretlenmiştir.
`CLAUDE.md §2.7` gereği bu ayrım iddiaların yanında duruyor, sonuna gizlenmiyor.

---

# ÖLÇÜM 1 — `0019 #2`: bugün gerçekten "FU'da tactic, SKU'da hacim" mi?

## Kısa cevap

**Yazma yolu tarafında EVET, ve BRD'nin tarif ettiğinden daha katı.** Ters yönde hiçbir
yol yok: SKU'ya taktik girilemiyor, FU'ya hacim girilemiyor — ne API'de ne grid'de.

**Ama okuma/gösterim tarafında model UYGULANMAMIŞ.** Üç ayrı ölçüm:

1. Girilen taktik değeri FU hücresine **geri okunmuyor** (grid, artık var olmayan bir
   kolondan okuyor).
2. BRD'nin *"FU değerleri SKU'ya miras"* gösterimi grid'de **ölü kod** — `inherited: true`
   hiçbir kolonda yok, `InheritedCell` hiç render edilmiyor.
3. Grid'in FU seviyesinde düzenlenebilir 9 taktik kolonundan **7'sinin** karşılığı olan
   mekanik, deponun tek mekanik kaynağında (`mechanic.seed.ts`) **yok** — o hücrelere değer
   girmek 400 döndürür.

Yani `0019 #2`'nin danışman sorusu (*"tactic FU'da, hacim SKU'da — doğru mu?"*) **hâlâ
sorulabilir ve anlamlıdır**: karar veri modeline gömülmüştür ve doğrudur. Ama kararı
uygulayan **kullanıcı yüzeyi** bugün ölçülebilir biçimde kırık.

---

## 1.1 Yazma yolları — API (backend)

Plan grid'ini besleyen iki mutasyon rotası var, ve **tam olarak ikisi**:

| Rota | Seviye | Ne yazıyor | Dosya |
|---|---|---|---|
| `PATCH /plans/:id/fus/:fuId/tactics` | **FU** | `plan_fus.tactics` (JSONB) | `plan.controller.ts:258` |
| `PATCH /plans/:id/fus/:fuId/skus/:skuId/volume` | **SKU** | `plan_skus.base_volume` · `planned_volume` | `plan.controller.ts:308` |

**`plan_fus.tactics`'in tek yazarı var** — ölçüldü:

```bash
$ grep -rn "tactics:" collmind.backend/src --include="*.ts" | grep -v "\.spec\." | grep -v "dto/"
plan.service.ts:706        tactics: dto.tactics ? {...} : planFu.tactics      # ← tek YAZMA
plan.repository.ts:53      current: { tactics: current.tactics, ... }         # 409 gövdesi (okuma)
kpi-engine.service.ts:28   tactics: Record<string, number>;                   # tip
kpi-engine.service.ts:119  tactics: Record<string, number>,                   # parametre
```

İkinci bir yazma yolu **kasten kapatılmış**: `AddFuDto`'dan `tactics` alanı T-079 ile
kaldırılmış (`dto/add-fu.dto.ts:10-38`), ve `forbidNonWhitelisted: true` sayesinde hâlâ
gönderen bir istemci sessizce düşürülmek yerine **400** alıyor. Yani "iki yazma yolu"
sınıfı bu alan için zaten kapalı.

### İkinci taktik deposu — `plan_mechanic_values`, ve neden bir giriş yolu değil

Aynı FU-taktik bilgisi ikinci bir tabloda da yaşayabiliyor:
`plan_mechanic_values.entered_rate_pct` / `entered_unit_amount` / `entered_total_amount`
(`plan-mechanic-value.entity.ts:44-71`), `UNIQUE(plan_fu_id, mechanic_id)` —
yani yine **FU × mekanik**, SKU değil.

Bu tablonun tek yazarı `POST /spend-calculation/distribute/:planFuId/:mechanicId`
(`spend-calculation.controller.ts:45`), ve o rota bir değer **SET etmiyor**: satır yoksa
`0` ile yaratıp (`spend-distribution.service.ts:92-104`) mevcut değeri SKU'lara dağıtıyor.
`spend-calculation.service.ts:686-712`'nin doküman yorumu bunu açıkça söylüyor:

> *"the only writer is `POST /spend-calculation/distribute/...`, which DISTRIBUTES an
> already-set value FU→SKU; it never SETS one."*

İki kaynak **tek bir türetme noktasında** birleşiyor (`buildMechanicValues`,
`spend-calculation.service.ts:716`), çakışmada `tactics` kazanıyor. Bu, `CLAUDE.md §7`'nin
"aynı yetenek iki kez yazıldı" sınıfının **çözülmüş** bir örneği.

## 1.2 Şema — seviyeler kolonlarla sabitlenmiş

| Tablo | Taktik alanı | Hacim alanı |
|---|---|---|
| `main.plan_fus` | `tactics jsonb` (`plan.entity.ts:245-246`) | ❌ yok — `total_planned_volume` **türetilmiş** |
| `main.plan_skus` | ❌ yok | `base_volume` · `planned_volume` (`plan.entity.ts:335-351`) |
| `main.plan_mechanic_values` | `entered_*` (FU×mekanik) | ❌ yok |

`plan_fus.total_planned_volume` bir **kullanıcı girdisi değil**; yazarları:

```
plan.service.ts:325   totalPlannedVolume: 0        (FU yaratılırken sıfırlama)
plan.repository.ts:457 totalPlannedVolume: 0       (aynı)
plan.service.ts:2562  totalPlannedVolume: fuTotalPlannedVolume   (recalc türevi)
plan.service.ts:2623  totalPlannedVolume: planTotalPlannedVolume (recalc türevi)
```

Yani **FU'ya hacim girilemez**; FU'nun hacmi SKU'lardan toplanır.

`plan_skus`'ta taktik değeri tutan bir kolon yok. `tactic_spend` var
(`plan.entity.ts:374-381`) ama yorumunun dediği gibi *"Distributed from FU level"* —
**girdi değil, çıktı**.

## 1.3 Grid (frontend) — seviye ayrımı tek bir predicate'te

`column-definitions.ts` her kolona `editableAt?: 'FU' | 'SKU'` veriyor (`:30`):

| `editableAt` | Kolon sayısı | Kodlar |
|---|---|---|
| `'SKU'` | **2** | `BASE_VOL` (`:133`) · `PLAN_VOL` (`:143`) |
| `'FU'` | **9** | `CPP_ON_PCT` · `TPR_ON_PCT` · `WS_TPR_ON_PCT` · `CPP_OFF_PCT` · `WS_TPR_OFF_PCT` · `PRICE_SUPPORT` · `VISIBILITY_MTPH` · `VISIBILITY_GT` · `TPR_LUMPSUM` |

Dinamik mekanik kolonları da **her zaman** `editableAt: 'FU'` alıyor — dört üretim dalının
dördü de (`PlanningGridEnhanced.tsx:848, 879, 907, 929`). Yani bir mekanik kolonunun
SKU'da düzenlenebilir doğması **yapısal olarak** mümkün değil.

Render tarafında ayrım tek satır, iki yerde:

```
FU satırı  : PlanningGridEnhanced.tsx:1519   col.editable && canEdit && col.editableAt === 'FU'
SKU satırı : PlanningGridEnhanced.tsx:1634-5 col.editable && canEdit && col.editableAt === 'SKU'
```

`isEditable` false olduğunda hem `<TableCell onClick>` `undefined` oluyor hem
`EditableCell disabled` — yani hücre ne tıklanabilir ne açılabilir.

**Sonuç:** kullanıcı SKU seviyesinde taktik **giremiyor**, FU seviyesinde hacim
**giremiyor**. Ne UI'da, ne API'da (§1.1: böyle bir rota yok).

## 1.4 Miras nasıl çalışıyor — kod yolu

FU'ya girilen taktik SKU'lara **değer olarak değil, harcama olarak** iniyor. Zincir:

| # | Adım | `dosya:satır` |
|---|---|---|
| 1 | `PATCH .../tactics` → `plan_fus.tactics` JSONB'a **merge** (replace değil, T-080) | `plan.service.ts:706` |
| 2 | Aynı istek içinde recalc tetikleniyor | `plan.service.ts:723` |
| 3 | FU'nun iki taktik kaynağı tek haritada birleşiyor | `spend-calculation.service.ts:716-793` (`buildMechanicValues`) |
| 4 | Lumpsum mekanikler FU→SKU paylarına bölünüyor (kardeş SKU'ların hacmi gerekiyor) | `plan.service.ts:2307` (`computeLumpsumDistribution`) |
| 5 | Her SKU için harcama hesaplanıyor; sonuç `plan_skus.tactic_spend`'e yazılıyor | `plan.service.ts:2505` |
| 6 | SKU KPI'ları FU'ya toplanıyor; FU KPI'ları `planFu.tactics` context'iyle hesaplanıyor | `plan.service.ts:2527-2530` → `kpi-engine.service.ts:119` |

Yani **miras "kopyalama" değil, "uygulama"**: %10 CPP değeri SKU satırına yazılmıyor; her
SKU'nun kendi cirosuna uygulanıp SKU'ya düşen **para** yazılıyor. Bu, BRD'nin
`Section_05` §"Pattern 2" pseudo-kodunun yaptığı şeyle aynı şekildedir
(`docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md:366-395`).

Ayrıca FU eklenirken o FU'nun **tüm aktif SKU'ları otomatik ekleniyor**
(`plan.service.ts:524-531`) — yani SKU seviyesi opsiyonel değil, zorunlu.

## 1.5 Ters yön — ölçülmüş yokluklar

Bir yokluk iddiası, nerede ve hangi terimle arandığı yazılmadan geçersizdir
(`CLAUDE.md §2.7`). Aranan yerler:

| İddia | Nerede arandı | Sonuç |
|---|---|---|
| SKU seviyesinde taktik yazma rotası yok | `grep -rln "tactic" src --include="*.controller.ts"` → 4 controller; `plan.controller.ts`'in tüm rota listesi elle tarandı | `skus/:skuId/volume` dışında SKU altında yazma rotası **yok** |
| FU seviyesinde hacim yazma rotası yok | aynı liste + `grep -rn "totalPlannedVolume"` | kullanıcı yazması **yok**; 4 yazar da türev/sıfırlama |
| `plan_skus`'ta taktik kolonu yok | `plan.entity.ts` tam okuma + `\d main.plan_mechanic_values` | **yok** |
| Grid'de SKU'da düzenlenebilir taktik yok | `grep -rn "editableAt"` (11 tanım + 4 dinamik + 2 predicate, hepsi listelendi) | **yok** |

## 1.6 Kaynak tarafı — ve BRD kendi içinde iki farklı şey söylüyor

`Section_05` net:

```
Section_05_Planning_First_Mode.md:164-166
  **2. Plan FU (Forecasting Unit Level)**
  - Aggregation level for tactic definition
  - Tactics defined at FU level, distributed to SKUs

Section_05_Planning_First_Mode.md:168-170
  **3. Plan SKU (Stock Keeping Unit Level)**
  - Volume planning occurs at SKU level
  - Each SKU has: Base Volume, Planned Volume
```

`Section_03` aynı şeyi söylemiyor:

```
Section_03_Core_Components.md:110-113
  **Planning-First (Volume Planning):**
  - Primary planning level: **FU**
  - Plan structure: FU → SKU volumes (optional detail)
  - Volume forecasting: "10,000 units of 500ml Shampoo FU"

Section_03_Core_Components.md:287-289
  User selects Brand → Category → GU → FU
  └─ System shows: FU list with default volumes
     User selects FU → System expands to SKU list (optional detail)
```

> ⚠️ **`Section_03` FU seviyesinde hacim tahmini yapıldığını, SKU kırılımının ise
> "optional detail" olduğunu söylüyor. `Section_05` hacim planlamasının SKU'da
> gerçekleştiğini söylüyor. Bugünkü kod `Section_05`'i uyguluyor ve `Section_03`'ün
> "optional"ını da kapatıyor** (`addFu` tüm SKU'ları zorunlu ekliyor,
> `plan.service.ts:524-531`).

Bu bir uygunluk yargısı değil, bir **kaynak çatışması ölçümü**. Danışman sorusunun şekli
bundan etkilenir: soru *"tactic FU'da mı"* değil, **"hacmin doğruluk kaynağı FU mu SKU mu,
ve SKU kırılımı zorunlu mu?"** olmalıdır — çünkü BRD'nin iki bölümü bu noktada ayrışıyor.
`CLAUDE.md §2.1.1`'in bölüm kuralı burada tersine işliyor: çekirdek tanım (`Section_03`)
ile mod bölümü (`Section_05`) **aynı olguda** farklı şey söylüyor.

## 1.7 Üç bulgu — model uygulanmış, kullanıcı yüzeyi kırık

### A. Girilen taktik değeri FU hücresine geri okunmuyor

Yazma ve okuma **farklı alanlara** bakıyor:

```
YAZMA  PlanningGridEnhanced.tsx:1052-1053
       planEndpoints.updateFuTactic(planId, fuId, { tactics: { [mechanicCode]: value }, ... })
       → plan_fus.tactics

OKUMA  PlanningGridEnhanced.tsx:462-465
       const mechanicValue = planFu.planMechanicValues?.find(
         (pmv) => pmv.mechanic?.code === mechanicCode);
       return mechanicValue?.enteredValue ?? null;
```

Okuma tarafı **iki bağımsız sebeple** her zaman `null` üretiyor:

1. **`enteredValue` artık yok.** Entity'den kaldırıldı (migration
   `1797000000000-DropPlanMechanicEnteredValue.ts`), yerine üç kolon geldi. DB doğruladı —
   `\d main.plan_mechanic_values` çıktısında `entered_value` **yok**, `entered_rate_pct` /
   `entered_unit_amount` / `entered_total_amount` var. Backend `src`'de entity alanı olarak
   `enteredValue` **hiç geçmiyor** (yalnız yerel değişken adı ve spec fixture'ı olarak).
   Frontend tipi hâlâ taşıyor: `plans.endpoints.ts:182 enteredValue?: number;`
2. **`pmv.mechanic` yüklenmiyor.** `findById` ilişki listesi `planFus.planMechanicValues`
   ile bitiyor, `...planMechanicValues.mechanic` **yok**
   (`plan.repository.ts:89-103`). Dolayısıyla `pmv.mechanic?.code` her zaman `undefined`
   ve `find` hiçbir zaman eşleşmiyor.

Ve **frontend `planFu.tactics`'i hiç okumuyor** — ölçüldü:

```bash
$ grep -rn "\.tactics" collmind.frontend/src --include="*.ts" --include="*.tsx"
STAAgreementForm.tsx:272,993,994   # errors.tactics — anlaşma formu, ilgisiz
LTAAgreementForm.tsx:239,888,889   # aynı
```

Tip mevcut ve API onu döndürüyor (`plans.endpoints.ts:61 tactics?: Record<string, number>`),
**hiçbir tüketicisi yok**.

Mutasyon `onSuccess`'te `invalidateQueries(['plan', plan.id])` yapıyor
(`PlanningGridEnhanced.tsx:1058`), yani sunucudan taze veri çekiliyor ve iyimser bir yerel
kopya tutulmuyor. Sonuç: **planner FU hücresine %10 yazıyor, "Tactic güncellendi" toast'ını
görüyor, hücre boş dönüyor.** Hesaplama doğru çalışıyor (spend/ROI kolonları değişiyor);
kaybolan yalnız girilen değerin kendisi.

> **§7.1 notu:** bu, `plan_fus.tactics`'in bugün okunabildiği tek yerin bir **409 hata
> gövdesi** olması demek (`plan.repository.ts:53`, `planFuStaleConflict`). Bir alanın tek
> okuyucusunun bir çakışma mesajı olması, o alanın ürün yüzeyinde temsil edilmediğinin
> göstergesidir.

**Ölçüm statüsü:** kod yolu ölçüldü. Çalışma zamanı doğrulanmadı (DB'de 0 plan). Testlerle
de doğrulanmıyor — `grep -rn "CPP_ON_PCT\|tactics" collmind.frontend/tests/e2e/` yalnız bir
**yorum** satırı buluyor (`support/api.ts:101`), bir assertion değil. `04-grid-cell-kpi.spec.ts`
sadece `PLAN_VOL` düzenliyor.

### B. `InheritedCell` ölü kod — BRD'nin "FU→SKU mirası" gösterimi yok

SKU satırında taktik kolonları için ayrı bir render dalı var:

```
PlanningGridEnhanced.tsx:1685-1691
  ) : col.inherited && fuValue !== null ? (
      <InheritedCell value={...} parentValue={fuValue} parentLabel={planFu.fu?.name} />
```

Ama `inherited` hiçbir kolona **atanmıyor**:

```bash
$ grep -c "inherited: true" collmind.frontend/src/components/features/plans/column-definitions.ts
0
$ grep -rn "inherited" collmind.frontend/src --include="*.ts" --include="*.tsx"
numberUtils.ts:188                  # ilgisiz yorum
PlanningGridEnhanced.tsx:135        # yorum: "These are FU-level, inherited at SKU level"
PlanningGridEnhanced.tsx:1685       # kullanım (dal)
column-definitions.ts:32            # tip tanımı (opsiyonel alan)
```

Yani `col.inherited` **her zaman `undefined`** → dal hiç girilmiyor → SKU satırındaki
taktik hücreleri `getSkuCellValue`'nun döndürdüğü `null` ile
(`PlanningGridEnhanced.tsx:124-136`, yorumu tam olarak *"These are FU-level, inherited at
SKU level"*) devre dışı `EditableCell` olarak render ediliyor.

`CLAUDE.md`'nin *"mekanizma var, ona giden yol yok"* sınıfı — dokuzuncu vaka, ve bu sefer
frontend'de: `InheritedCell` (`grid-cells.tsx:490`) yazılmış, ihraç edilmiş, import
edilmiş, çağrı yerine konmuş — ve **koşulu hiçbir zaman sağlanmıyor**.

### C. Grid'in 9 FU-taktik kolonundan 7'sinin mekanik karşılığı yok

`BASE_COLUMNS`'un sabit taktik kolon kodları ile deponun tek mekanik kaynağının
(`collmind.backend/src/database/seeds/mechanic.seed.ts`) kodları karşılaştırıldı:

```bash
$ for c in TPR_ON_PCT WS_TPR_ON_PCT WS_TPR_OFF_PCT PRICE_SUPPORT VISIBILITY_MTPH \
           VISIBILITY_GT TPR_LUMPSUM CPP_ON_PCT CPP_OFF_PCT; do
    echo "$c -> $(grep -rl "$c" collmind.backend/src | wc -l) dosya"; done

TPR_ON_PCT     -> 0 dosya
WS_TPR_ON_PCT  -> 0 dosya
WS_TPR_OFF_PCT -> 0 dosya
PRICE_SUPPORT  -> 2 dosya   (yalnız spec + DTO örneği; seed'de YOK)
VISIBILITY_MTPH-> 1 dosya   (yalnız DTO @ApiProperty example; seed'de YOK)
VISIBILITY_GT  -> 0 dosya
TPR_LUMPSUM    -> 0 dosya
CPP_ON_PCT     -> 13 dosya  (seed'de VAR: mechanic.seed.ts:97)
CPP_OFF_PCT    -> 2 dosya   (seed'de VAR: mechanic.seed.ts:137)
```

Seed'in mekanik kodları: `CPP_ON_PCT` · `MEC-DISCOUNT` · `CPP_OFF_PCT` · `VIS_LS` ·
`DISPLAY_FEE` · `PRICE_SUP` (+ `TAC-*` taktik kodları).

`updateFuTactic` çözülemeyen bir kodu **yazmadan önce** reddediyor
(`plan.service.ts:639-646` — `describeUnresolvedMechanicCode` → 400). Bu doğru ve
kasıtlı: aynı fonksiyonun yorumu (`:613-623`) neden yazma öncesi reddedildiğini açıklıyor
(yazma ve recalc aynı transaction'da değil; yazılsaydı yetim anahtar kalıcı 400 üretirdi).
**Yani veri bozulmuyor.** Ama sonuç şu: grid'in FU seviyesinde açıp düzenlemeye izin
verdiği 9 taktik kolonundan **7'si**, mevcut mekanik setiyle her zaman 400 döndürür.

Ayrıca dinamik kolon üretiminde bir **kod eki asimetrisi** var: on/off-invoice indirim
mekanikleri için kolon kodu `${mechanic.code}_PCT` oluyor
(`PlanningGridEnhanced.tsx:841, 874`), lumpsum ve per-unit için ise **düz** `mechanic.code`
(`:898, 920`). Ve `handleCellSave` taktik anahtarı olarak **kolon kodunu** gönderiyor
(`PlanningGridEnhanced.tsx:1191 mechanicCode: field`). Seed'deki `MEC-DISCOUNT`
(`ON_INVOICE_DISCOUNT`, `mechanic.seed.ts:117`) `BASE_COLUMNS`'ta olmadığı için dinamik
kolon olarak doğuyor → kolon kodu `MEC-DISCOUNT_PCT` → gönderilen anahtar
`MEC-DISCOUNT_PCT` → mekanik kodu `MEC-DISCOUNT` → **eşleşmiyor** → 400.

Lumpsum/per-unit dalları bu ekle sakat değil, yani kusur **kategoriye göre** — bir dal
doğru, iki dal yanlış. `CLAUDE.md §7.1`: *"bir kusur sınıfı bulduğun dosyada, aynı sınıfın
diğer örneklerini ara"* — arandı, üç dal, ikisi bozuk.

---

# ÖLÇÜM 2 — `D-15` gerçekten açık mı, yoksa `ADR 0008` onu kapattı mı?

## Sonuç: ⚠️ **Farklı eksen, hâlâ açık.** Team Lead'in ayrımı doğrulandı.

Ve doğrulama hafızadan değil, **sözleşme metninden** geldi: ayrım zaten
`SYSTEM_INVARIANTS.md:681`'de yazılı duruyor.

## 2.1 `ADR 0008`'in kapsamı — kendi künyesinde yazılı

```
docs/decisions/0008-girilen-degerde-null-sifir-ayrimi-yoktur.md:6
  **Kapsam:** planner'ın girdiği mekanik değeri
             (`plan_fus.tactics`, `plan_mechanic_values.entered_*`)
```

Kararı (`:80`): *"Girilen değerde `null` ile `0` arasında anlam farkı YOKTUR."*
Gerekçesi iş anlamı (`:82-84`): *"%0 indirim ile indirim yok arasında ekonomik fark
yoktur."*

ADR üç yeri sayıyor ve üçü de **girdi** ekseninde: aritmetik yolundaki `?? 0`
(`mechanic-input.ts`), okuma/yazma asimetrisi (`checkEnteredScale` ↔
`buildMechanicValues`), ve tel protokolü (`update-fu-tactic.dto.ts`'te `null` = "değişiklik
yok").

ADR ayrıca **kendi sınırını da çiziyor** (`:113-124`): ADR 0006 Karar 2 ile çelişmediğini,
çünkü *"farklı eksen"* olduğunu açıkça yazıyor. Yani ADR 0008 eksen ayrımı yapan bir
belgedir ve kendi ekseninin dışına çıkmıyor.

## 2.2 `D-15`'in tam metni ve blokladığı

```
docs/contracts/SYSTEM_INVARIANTS.md:681
| **D-15** | Is a computed KPI of exactly zero the same as "no KPI"? |
  INV-N-002 (blocks the transformer phases) |
  Seven live sites flip direction the moment a `decimal` column stops arriving as a
  string: `"0.0000"` is truthy, `0` is not. ⚠️ **ADR 0008 does NOT cover this** — that
  decision was about a planner's ENTERED value; these are computed KPIs and rule
  ceilings. Different axis, separate decision. Measured in `docs/analysis/0014` |
```

Blokladığı: **`INV-N-002`** (parasal aritmetik kesindir; uygulama kodunda para float
değildir) — daha dar olarak, o invariant'ın kapanması için gereken **transformer yayılım
fazları**.

## 2.3 İkisi aynı eksende mi? — HAYIR, ve bu ölçülebilir

| | ADR 0008 | D-15 |
|---|---|---|
| Konu | **girilen** değer | **hesaplanan** KPI + **kural tavanı** |
| Alanlar | `plan_fus.tactics`, `plan_mechanic_values.entered_*` | `plans.overall_roi`, `plan_fus.gp_roi`, `plan_skus.gp_roi`, `calculated_kpis`, `mechanics.max_combined_discount_percentage` |
| Kim üretiyor | planner (klavye) | KPI motoru / admin konfigürasyonu |
| "Sıfır" ne demek | %0 indirim | ROI **gerçekten** sıfır (harcama var, kazanç yok) |
| "Yok" ne demek | girmedi | bağımlılık eksik (COGS yok) veya sonuç sonlu değil (0'a bölme) |
| Ekonomik sonuç | ikisi de aynı: sıfır harcama | **farklı**: sıfır ROI bir yargıdır, ROI yokluğu bir bilgi eksikliğidir |

ADR 0008 uygulandığında D-15 **kendiliğinden cevaplanmıyor.** Tersine: ADR 0008'in
`?? 0`'ı korumasının bir sonucu, girilmemiş bir taktiğin **sıfır harcama** üretmesi, onun
da bazı formüllerde **paydayı sıfırlayıp** KPI'ı `null` yapmasıdır
(`formula-parser.service.ts:255` — `!isFinite(result)` → `null`). Yani ADR 0008'in
kapattığı eksen, D-15'in ekseninde `null` **üretiyor**; kapatmıyor.

**Çelişki yok.** İki karar aynı anda geçerli ve birbirini gerektirmiyor.

## 2.4 Bugünkü kod: hesaplanan sıfır, `null`'dan ayırt ediliyor mu?

Katman katman ölçüldü. Cevap **katmana göre değişiyor**, ve iki katmanda ayrım
kayboluyor.

### A. KPI motoru — **AYIRT EDİYOR** ✅

`formula-parser.service.ts`:
- eksik bağımlılık → `null` (`:160-163`)
- `NaN` → `null` (`:170, :212`)
- sonlu olmayan sonuç (0'a bölme) → `null` (`:255-257`)
- gerçek `0` → `0` olarak geçiyor

Bu, `CLAUDE.md §2.1.2`'nin kayda geçirdiği **kasıtlı BRD sapmasıdır**: BRD'nin motor
pseudo-kodu `context.get(dep) || 0` diyor; bizimki `null` yayıyor ve daha doğru.

### B. Kalıcılaştırma — **AYIRT EDİYOR** ✅

`plans.overall_roi`, `plan_fus.gp_roi`, `plan_skus.gp_roi` üçü de `numeric(18,4)` **NULL
kabul eden** kolonlar (`plan.entity.ts:170-177, 276-283, 395-402`), ve yorumları bunu
söylüyor (*"null when a dependency (e.g. COGS) is missing"*). `calculated_kpis` JSONB'ın
tipi `value: number | null` (`plan.entity.ts:293, 412`).

Yani **veritabanı seviyesinde sıfır ile yokluk bugün farklı şeylerdir.**

### C. Backend okuma yolu — **KAZARA ayırt ediyor** ⚠️

`plan.entity.ts`'te **hiçbir** `DecimalTransformer` yok:

```bash
$ grep -c "DecimalTransformer" collmind.backend/src/database/entities/plan.entity.ts
0
```

Transformer'sız bir `decimal` kolonu çalışma zamanında **string** döner
(`docs/analysis/0014:197`'de ölçülmüş). Dolayısıyla:

- gerçek sıfır → `"0.0000"` → **truthy**
- KPI yok → `null` → **falsy**

`D-15`'in *"seven live sites"*'ı bugün de duruyor, satır numaralarıyla yeniden ölçüldü
(backend `5bc2787`):

| # | `dosya:satır` | İfade | Bugün |
|---|---|---|---|
| 1 | `finance-reporting.service.ts:427` | `if (planFu.gpRoi)` | `"0.0000"` truthy → sıfır ROI ortalamaya **giriyor** |
| 2 | `plan.service.ts:2806` | `plan.overallRoi ? Number(...) : null` | `0` dönüyor |
| 3 | `plan.service.ts:2885` | `planFu.gpRoi ? Number(...) : null` | `0` dönüyor |
| 4 | `approval-workflow.service.ts:916` | `plan.overallRoi ? Number(...) : undefined` | `0` dönüyor |
| 5 | `mechanic.service.ts:605` | `m.maxCombinedDiscountPercentage \|\| 100` | `"0.00"` truthy → tavan **0** korunuyor |
| 6 | `agreement.service.ts:1287-1290` | `if (agreement.mechanicValue)` | `MECHANIC_VAL` context'e giriyor |
| 7 | `plan.service.ts:774-776` | `dto.plannedVolume && planSku.baseVolume` | truthy dalda kalıyor |

**Yedisi de bugün doğru davranıyor — ama doğruluğu bir temsil kazasına dayanıyor.**
`DecimalTransformer` bu kolonlara uygulandığı gün yedisi de yön değiştirir. D-15'in
`INV-N-002`'yi blokladığı nokta tam burasıdır ve **hâlâ geçerlidir.**

### D. Finance reporting — **AYIRT ETMİYOR** 🔴 (D-15'in ekseninde canlı iki nokta)

`D-15`'in yedi noktalık listesi `finance-reporting.service.ts`'ten yalnız `:427`'yi
sayıyordu. Aynı dosyada `CLAUDE.md §7.1`'in *"kusurlar dosya bazlı kümelenir"* kuralıyla
tarandığında **iki kardeş** daha çıktı, ve ikisi de bugün — transformer olmadan —
**zaten ayrım yapmıyor**:

```
finance-reporting.service.ts:582   gpRoi: plan.overallRoi || 0,       ← GET /plan-performance
finance-reporting.service.ts:635   gpRoi: plan.overallRoi || 0,       ← GET /budget-at-risk
```

`|| 0`, `null`'ı **bugün** `0`'a çeviriyor: ROI'si hesaplanamamış bir plan, finans
raporunda **ROI = 0** olarak görünüyor. Bu bir temsil kazasına bağlı değil; her iki
temsilde de yanlış.

İki rota da canlı: `finance-reporting.controller.ts:109` ve `:135`.

Ve aynı iki satırın hemen yanında **üçüncü** bir çökertme var:

```
finance-reporting.service.ts:583   ragStatus: plan.ragStatus || 'GREEN',
finance-reporting.service.ts:632   ragStatus: plan.ragStatus || 'GREEN',
```

**`null` RAG → `'GREEN'`.** Bu, §2.5 ile birleşince D-15'i doğrudan ilgilendiriyor
(aşağıda).

### E. Frontend grid — **KISMEN, ve iki satır birbirinden ayrışmış** ⚠️

`CalculatedCell.formatValue` `null`/`undefined` için `'-'`, sayı için biçimlenmiş değer
basıyor (`grid-cells.tsx:437-454`). Yani **gösterim katmanı ayrımı taşıyabilir.**

Ama ona giden iki yol farklı:

```
SKU satırı  PlanningGridEnhanced.tsx:337-338   case 'GP_ROI_PCT': return planSku.gpRoi ?? null;
FU  satırı  PlanningGridEnhanced.tsx:712-713   case 'GP_ROI_PCT': return planFu.gpRoi ? Number(planFu.gpRoi) : null;
```

FU yolu `Number()` ile sayıya çeviriyor; SKU yolu **çevirmiyor** ve string'i olduğu gibi
geçiriyor. `formatValue` `format: 'percentage'` için `val.toFixed(decimals)` çağırıyor
(`grid-cells.tsx:447-449`, kolon tanımı `column-definitions.ts:688-695`), ve string'lerde
`toFixed` yok.

**Ölçüm statüsü:** bu **türetilmiş** bir sonuçtur, çalışma zamanında görülmemiştir —
DB'de 0 plan var ve bu yolu koşturan hiçbir test yok:

```bash
$ grep -rn "GP ROI\|GP_ROI\|gpRoi" collmind.frontend/tests/
(çıktı yok)
```

Doğrulanması gereken zincir: API `gp_roi`'yi string olarak mı döndürüyor?
(a) entity'de transformer yok — ölçüldü, `grep -c` = 0;
(b) global `ClassSerializerInterceptor` yok — ölçüldü, `main.ts`/`app.module.ts`'te
`useGlobalInterceptors` **yok**;
(c) controller ham entity döndürüyor — `plan.controller.ts:211-220`;
(d) frontend'de normalleştirme yok — `PlanDetailPage.tsx:67-73`, `res.data` doğrudan.
Dört adım da ölçüldü; eksik olan yalnız canlı bir istek.

> **Bu, D-15'in cevabından bağımsız bir kusurdur** ama D-15'in *"grid gösterimi ayırt
> ediyor mu"* sorusunun bugünkü cevabını belirsiz bırakıyor: FU satırı ayırt ediyor
> (0 → `"0,0%"`, null → `"-"`), SKU satırının ne yaptığı **ölçülmedi**.

## 2.5 `T-177`'nin etkisi — D-15'i cevaplamıyor, ama bir komşusunu açıyor

[[T-177]] `coverageRatio` ekledi ve RAG'ı tam kapsamaya bağladı
(`kpi-engine.service.ts:141, 175, 186-192, 308, 337`). Ürün sahibi kararı kod yorumunda
kayıtlı (`:184-189`).

**D-15'e doğrudan etkisi yok:** `coverageRatio` "değer kaç SKU'dan türedi" sorusunu
cevaplıyor; "değer sıfır mı yok mu" sorusunu değil. `value: number | null` ayrımı
değişmedi.

**Ama ikinci dereceden bir etkisi var ve ölçüldü:**

`coverageRatio` **kalıcılaştırılmıyor** — `calculated_kpis` JSONB'ın tipi onu içermiyor
(`plan.entity.ts:290-299, 409-418`) ve recalc onu yazmıyor (`plan.service.ts:2481-2489`,
alanlar: `value`, `displayFormat`, `decimalPlaces`, `ragStatus`, `calculatedAt`).

Tüketici sayımı:

```bash
$ grep -rl "coverageRatio" collmind.backend/src --include="*.ts" | grep -v kpi-engine
(çıktı yok — kpi-engine dışında 0 dosya)

$ grep -rn "coverageRatio" collmind.frontend/src collmind.frontend/tests
(çıktı yok)
```

Yani `coverageRatio` **motorun dışına hiç çıkmıyor**. Dışarıya çıkan tek etkisi
`ragStatus`'un `null` olması.

Sonuç — ve bu D-15 ile §2.4-D'nin kesişiminde duruyor:

> **`null` RAG'ın artık iki farklı sebebi var** — (a) KPI değeri `null`, (b) değer var ama
> kapsama < 1 — ve ikisini ayırt eden alan (`coverageRatio`) istemciye hiç ulaşmıyor.
> Üstelik `finance-reporting.service.ts:583, 632` o `null`'ı **`'GREEN'`** yapıyor.
>
> Yani T-177'nin *"kısmi kapsamada renk verme"* kararı, finans raporlama yolunda
> **yeşile** dönüşüyor. Bu, T-177'nin kapatmak istediği şeyin tam tersi.

Bu bir D-15 cevabı değil; **ayrı bir bulgu** ve ayrı bir task konusudur.

## 2.6 `D-15` için önerilen statü

| Sonuç | Karar |
|---|---|
| ✅ ADR 0008 kapsıyor | **HAYIR** |
| ⚠️ **Farklı eksen, hâlâ açık** | ✅ **BU** |
| 🔴 Üçüncü bir şey | hayır |

**Gerekçe (üç bağımsız kanıt):**

1. ADR 0008 kendi kapsamını künyesinde **girilen değerle** sınırlıyor (`0008:6`).
2. `SYSTEM_INVARIANTS.md:681` bu ayrımı **zaten yazmış**: *"ADR 0008 does NOT cover
   this … Different axis, separate decision."* Team Lead'in ayrımı bir hatırlama değil,
   sözleşmede kayıtlı bir cümledir.
3. Kod bugün D-15'i cevaplamamış durumda: yedi nokta doğruluğunu bir **string temsil
   kazasına** borçlu (§2.4-C), iki canlı finans rotası `null`'ı **`0`'a** çeviriyor
   (§2.4-D), ve `INV-N-002`'nin transformer yayılımı hâlâ bu karara bloklu.

`OPEN_DECISIONS.md`'de `D-15` satırı **`açık` kalmalı.** Öneri: "Neyi blokluyor"
sütunundaki `INV-N-*` daha dar yazılabilir — blokladığı şey `INV-N-002`'nin transformer
fazıdır, tüm `INV-N-*` ailesi değil (`SYSTEM_INVARIANTS.md:681`'in kendi metni de böyle
diyor).

---

# 3. Mimari değerlendirme (architect)

## 3.1 Karar / Onay

| Konu | Karar | Gerekçe |
|---|---|---|
| FU-taktik / SKU-hacim **veri modeli** | ✅ **uygun** | Tek yazar, tek türetme noktası, seviye ayrımı hem şemada hem tek bir predicate'te. `plan_fus.tactics`'in ikinci yazma yolu T-079 ile kasten kapatılmış. Modül sınırı temiz: giriş `modes/planning-first`, türetme `shared/spend-calculation`, KPI `shared/kpi-engine`. |
| FU-taktik **kullanıcı yüzeyi** | ❌ **uyumsuz** | Yazma ve okuma farklı alanlara bakıyor (§1.7-A); miras gösterimi ölü kod (§1.7-B); 9 kolonun 7'si mekaniksiz (§1.7-C). |
| `D-15` ↔ `ADR 0008` | ⚠️ **koşullu** | Çelişki yok, kapsama yok. D-15 açık kalmalı; transformer yayılımı bu karar verilmeden başlamamalı. |
| `finance-reporting`'in `|| 0` / `|| 'GREEN'` çökertmeleri | ❌ **uyumsuz** | `CLAUDE.md §2.5` sessiz sıfır yasağı. İki canlı GET rotası. T-177 kararını yeşile çeviriyor. |

## 3.2 Modül & bağımlılık etkisi

- **Bağımlılık yönü doğru:** `planning-first/plan` → `shared/spend-calculation` →
  `shared/kpi-engine`. Ters bağımlılık yok. `buildMechanicValues`'un tek türetme noktası
  olması (T-052) iki submit yolunun ayrışmasını kapatmış durumda.
- **Sızıntı:** `finance-reporting` (shared) doğrudan `PlanMechanicValue` repository'sine
  bağlanıyor (`finance-reporting.service.ts:98-99`) ve KPI/RAG semantiğini **yeniden
  yorumluyor** (`|| 0`, `|| 'GREEN'`). Bir raporlama modülünün domain semantiğini yeniden
  uygulaması, `CLAUDE.md §2.7 #8`'in ("kontrolü yeniden uygulayan test") üretim tarafındaki
  kardeşidir: motor `null` üretiyor, rapor onu `0`/`GREEN` diye okuyor.
- **Frontend ↔ backend sözleşmesi bayat:** `plans.endpoints.ts:182 enteredValue?: number`
  artık var olmayan bir kolonu tarif ediyor; `PlanFu.tactics` tipte var, tüketicisi yok.
  Tip kapısı (`type-check`) bunu yakalayamaz — iki repo, tek yönlü el yazımı tipler.

## 3.3 Somut öneriler (dosya/pattern düzeyinde)

Sıra riske göre; hiçbiri bu turda uygulanmadı (salt-okunur).

1. **`finance-reporting.service.ts:582, 635` (`|| 0`) ve `:583, 632` (`|| 'GREEN'`)** —
   `CLAUDE.md §2.5` ihlali, iki canlı rota. DTO alanları `number | null` /
   `RagStatus | null` yapılmalı; "veri yok"u istemciye taşımak, `0`/`GREEN` uydurmaktan
   ucuz. **Ayrı task.**
2. **Grid'in FU taktik okuması** — `PlanningGridEnhanced.tsx:462-465` `planFu.tactics`'ten
   okumalı (alan zaten API'de ve tipte var). `plans.endpoints.ts:182`'deki `enteredValue`
   kaldırılmalı. Alternatif (daha pahalı): `plan.repository.ts:89-103`'e
   `planFus.planMechanicValues.mechanic` eklenip üç `entered_*` kolonundan okumak — ama bu,
   `plan_fus.tactics`'in kanonik kaynak olduğu kararına ters düşer. **Önerilen: `tactics`.**
3. **`InheritedCell`** — ya 9 taktik kolonuna `inherited: true` verilip mekanizma
   canlandırılır, ya da bileşen ve dal silinir. Ölü bırakmak üçüncü seçenek değil
   (`CLAUDE.md`: mekanizma var, yolu yok = `blocked-unreachable`).
4. **Kolon kodu ↔ mekanik kodu sözleşmesi** — `PlanningGridEnhanced.tsx:841, 874`'ün
   `_PCT` eki ile `:1191`'in `mechanicCode: field` gönderimi çelişiyor. Kolon tanımına
   ayrı bir `mechanicCode` alanı eklenmeli (kolon kodu bir görünüm kimliği, mekanik kodu
   bir domain anahtarı — ikisi aynı string olmak zorunda değil). Aynı düzeltme
   `BASE_COLUMNS`'un 7 mekaniksiz kolonunu da görünür kılar.
5. **`coverageRatio` kalıcılaştırılmalı** — `calculated_kpis` JSONB'a eklenmezse T-177'nin
   ayrımı motorun dışına çıkamaz ve `null` RAG'ın iki sebebi ayırt edilemez. Şema değişikliği
   gerektirmiyor (JSONB), ama `data-engineer` kapsamında entity tipi değişir.
6. **`D-15` karara bağlanana kadar** `plan.entity.ts`'in `gp_roi` / `overall_roi`
   kolonlarına `DecimalTransformer` **uygulanmamalı.** §2.4-C'deki yedi nokta o gün yön
   değiştirir.

## 3.4 BRD ihlali riskleri

| Risk | Kaynak | Bugünkü durum |
|---|---|---|
| *"Grid: Plan→FU→SKU mirası"* | `CLAUDE.md §2.3` (özet), `Section_05:166` | Hesaplama tarafında **var** (§1.4); gösterim tarafında **yok** (§1.7-B) |
| *"RAG: hardcoded threshold YASAK"* | `CLAUDE.md §2.3` | `finance-reporting.service.ts:583, 632`'nin `\|\| 'GREEN'`'i bir eşik değil ama **hardcoded bir RAG sonucu** — aynı yasağın ruhu |
| *"KPI edge case: eksik veri → null"* | `CLAUDE.md §2.3` | Motor ve DB uyuyor (§2.4-A/B); **finans raporlama uymuyor** (§2.4-D) |
| Hacmin doğruluk kaynağı | `Section_03:112` ↔ `Section_05:169` | **BRD kendi içinde çelişiyor** (§1.6) — ürün sahibi kararı gerekiyor |

---

# 4. DUR ve bildir maddeleri

Görev tanımının üç DUR koşulundan **ikisi tetiklendi**:

### DUR-1 — `0019 #2`'nin iddiası bugün kısmen yanlış

İddia (*"Tactic FU seviyesinde, hacim SKU seviyesinde girilir"*) **yazma yolu için doğru**.
Ama iddianın dayandığı model (`Section_05`'in FU→SKU miras grid'i) **kullanıcı yüzeyinde
uygulanmamış**: girilen taktik geri okunmuyor, miras gösterimi ölü kod, ve grid'in taktik
kolonlarının çoğunun mekanik karşılığı yok.

**Bu, danışman sorusunu iptal etmez — şeklini değiştirir.** Danışmana *"FU'da taktik
girmek doğru mu"* diye sorulacaksa, sorulan şeyin bugün **hesaplama modelinde** var olduğu
ama **ekranda** olmadığı bilinmelidir; aksi hâlde danışmanın cevabı var olmayan bir UX
üzerine verilir.

### DUR-2 — BRD'nin iki bölümü hacim seviyesinde çelişiyor

`Section_03:112` (*"FU → SKU volumes (optional detail)"*, *"Volume forecasting: 10,000
units of ... FU"*) ile `Section_05:169` (*"Volume planning occurs at SKU level"*) aynı
olguda farklı şey söylüyor. Kod `Section_05`'i uyguluyor **ve** `Section_03`'ün
"optional"ını kapatıyor (`addFu` tüm SKU'ları zorunlu ekliyor).

`CLAUDE.md §2.4`: **BRD yorumu ürün sahibinin kararıdır.** Varsayılmadı, seçilmedi.

### DUR-3 — geri alınamaz karar: tetiklenmedi

Ölçüm, geri alınamaz bir kararın verildiğini göstermiyor. §3.3'ün altı önerisi de geri
alınabilir; en pahalısı (5) bir JSONB alanı ekliyor.

### Çelişki taraması — `D-15` ↔ `ADR 0008`

**Çelişki YOK.** Farklı eksenler; ADR 0008 kendi sınırını yazmış, `SYSTEM_INVARIANTS.md:681`
de ayrımı kayda geçirmiş. §2.3 tablosu ölçümü taşıyor.

---

# 5. Ölçülmeyenler — bu belgenin sınırları

`CLAUDE.md §2.7`: kanıt kurulumu ölçtüğün durumu değiştirmemeli, ve ölçülmeyen
**yazılmalı**.

1. **Hiçbir çalışma zamanı ölçümü yapılmadı.** DB'de 0 plan var; backend/frontend
   koşturulmadı. §1.7-A ve §2.4-E kod yolu türevleridir.
2. **`gp_roi`'nin tel üzerinde string olduğu doğrudan görülmedi.** Dört adımlı zincir
   ölçüldü (transformer yok · global serializer yok · ham entity dönüyor · frontend
   normalleştirmiyor), ama canlı bir HTTP yanıtı incelenmedi.
3. **Tenant mekanik setleri ölçülmedi.** §1.7-C `mechanic.seed.ts`'e karşı ölçüldü —
   deponun tek mekanik kaynağı odur. Üretimde bir tenant `TPR_ON_PCT` kodlu bir mekanik
   tanımlarsa o kolon çalışır. İddia: *"seed'e karşı 7'sinin karşılığı yok"*, daha geniş
   değil.
4. **`0019 #2` dışındaki tur-1 kuyruğu maddeleri taranmadı.** `OPEN_DECISIONS.md`'nin
   kendi uyarısı (*"kuyruğun tam envanteri çıkarılmadı"*) hâlâ geçerli.
5. **`D-15`'in yedi noktasının davranışı mutasyonla sınanmadı.** Satırların bugün var
   olduğu ve hangi ifadeyi taşıdığı ölçüldü; "transformer eklenince yön değiştirir"
   iddiası `docs/analysis/0014 §4.2`'nin ölçümüne dayanıyor, bu turda yeniden
   üretilmedi.
6. **`PlanningGrid.tsx` (ikinci grid bileşeni) incelenmedi** — hiçbir yerden import
   edilmiyor (`grep -rn "from './PlanningGrid'"` → çıktı yok) ve `tactic`/`inherit`/
   `editableAt` geçmiyor. Ölü görünüyor; ayrı bir tarama konusu.
