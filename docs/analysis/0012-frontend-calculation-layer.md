# 0012 — Frontend hesap katmanı (PlanningGridEnhanced)

**Tarih:** 2026-08-04 · **frontend SHA:** `5cf0bd2` · **backend SHA:** `0b6518e`
**Kaynak bulgu:** `docs/analysis/0011-integer-minor-unit-feasibility.md`
**Mod:** salt-okunur analiz — hiçbir kaynak dosya değiştirilmedi

---

## Verdict

**Sınıf: tutarlılık riski (UX) — finansal sonuçlu BRD ihlali DEĞİL.** İki noktada kenar-durum
ayrışması var, biri onay ekranında.

Belirleyici ölçüm: grid'in **iki yazma yolu da yalnız ham girdi gönderiyor**
(`{version, baseVolume|plannedVolume}` ve `{tactics:{code:value}, version}`), ve backend DTO'ları
türetilmiş alan **kabul etmiyor** — `UpdateSkuVolumeDto` yalnız `baseVolume`/`plannedVolume`/
`version`, `UpdateFuTacticDto` yalnız `tactics`/`version` taşıyor. Dolayısıyla istemcide türetilen
NIV/Turnover/INCR/uplift değerleri **kalıcılaşmıyor**; sunucu her yazmadan sonra recalc ile kendi
değerlerini üretiyor. Grid'in gösterdiği **harcama** zaten istemcide türetilmiyor: sunucunun
`promoOnInvoiceSpend`/`promoOffInvoiceSpend` alanları okunuyor. **RAG da sunucudan** geliyor
(`planFu.ragStatus`, `planSku.ragStatus`) — istemci yalnız render ediyor. Submit/approve
edilebilirlik istemci hesabına bağlı değil (`disabled` koşulları yalnız `isEditable` ve mutation
durumu).

Yani `CLAUDE.md` §2.3'ün koruduğu şey — *hesap dinamik formülden gelir, bütçe/karar ondan etkilenir* —
**ihlal edilmiyor**. Ama "frontend sadece sonucu render eder" cümlesinin lafzı ihlal ediliyor:
grid, sunucunun ürettiği ham alanlardan **kendi görüntüleme değerlerini türetiyor** ve bu türetimde
sunucudan **iki noktada ayrışıyor** (aşağıda R1, R2).

---

## S1 — Türetilen değerler

### S1.1 Envanter (`PlanningGridEnhanced.tsx`, `getSkuValue` / `getFuValue`)

| Değer | Formül (istemci) | file:line |
|---|---|---|
| `VOL_UPLIFT_PCT` | `((planVol − baseVol) / baseVol) × 100` | `:86-89` |
| `BASE_GSV` | `baseVol × unitPrice` | `:93-96` |
| `PLAN_GSV` | `planVol × unitPrice` | `:98-101` |
| `INCR_GSV` | `planGsv − baseGsv` | `:103-105` |
| `BASE_NIV` | `baseGsv − baseLtaOnInvoiceSpend` | `:196-198` |
| `PLAN_NIV` | `planGsv − (plannedLtaOn + promoOnInvoiceSpend)` | `:199-205` |
| `INCR_NIV` | `planNiv − baseNiv` | `:207-218` |
| `BASE_TO` | `baseNiv − baseLtaOffInvoiceSpend` | `:219-223` |
| `PLAN_TO` | `planNiv − (plannedLtaOff + promoOffInvoiceSpend)` | `:224-234` |
| `INCR_TO` | `planTo − baseTo` | `:235-...` |
| `INCR_GP%` | `(incrGp / incrTo) × 100` | `:333` |
| `ROI%` | `(incrTo / incrSpend) × 100` | `:365` |
| FU toplamları | `skus.reduce(...)` — hacim, GSV, spend | `:387-424`, `:489` |

### S1.2 Girdi zincirleri

Üç kaynak var:
1. **Kullanıcının girdiği ham değerler:** `baseVolume`, `plannedVolume` (grid hücresi), FU
   seviyesinde `tactics`.
2. **Sunucudan gelen hesaplanmış alanlar:** `promoOnInvoiceSpend`, `promoOffInvoiceSpend`,
   `baseLtaOnInvoiceSpend`, `baseLtaOffInvoiceSpend`, `plannedLtaOnInvoiceSpend`,
   `plannedLtaOffInvoiceSpend`, `ragStatus`.
3. **Master data:** `sku.unitPrice`.

Zincir: `unitPrice × volume → GSV → NIV (− LTA/promo on) → TO (− LTA/promo off) → INCR → ROI%`.
Yani **tek gerçek istemci-kaynaklı aritmetik `volume × unitPrice`**; gerisi sunucudan gelen
alanların çıkarmaları/oranlarıdır.

### S1.3 Backend karşılığı ve formül farkı

| Değer | Backend karşılığı | Aynı mı? |
|---|---|---|
| `BASE_GSV` | `main.kpis` → `BASE_VOL * BPTT` (`is_active=t`, `show_in_grid=f`) | **Yapısal olarak aynı** — `BPTT` çalışma zamanında SKU birim fiyatına çözülüyor (`plan.service.ts:2257` → `BPTT: unitPriceOrNull`; `kpi-engine.service.ts:20` yorumu: *"Base Price To Trade (unit price)"*) |
| `PLAN_GSV` | `PLANNED_GSV` → `PLAN_VOL * BPTT` | Aynı formül, **farklı KPI kodu** (`PLAN_GSV` vs `PLANNED_GSV`) |
| `BASE_TO` | `BASE_GSV - BASE_LTA_ON` | ⚠️ DB metni **yalnız ON** düşüyor; istemci ayrıca `baseLtaOffInvoiceSpend` de düşüyor (`:219-223`). *Doğrulanmalı:* migration 1780 açıklaması `BASE_GSV - BASE_LTA_ON - BASE_LTA_OFF` diyor ama DB'deki `formula_text` kısa — hangisinin canonical olduğu netleştirilmeli. |
| `PLAN_TO` | `PLANNED_TO` (`is_active=t`, **`show_in_grid=t`**) | Farklı kod; formül metni tam okunmadı |
| `INCR_*`, `*_NIV`, `VOL_UPLIFT_PCT`, `ROI%` | **DB'de yok** | Yalnız istemcide |
| Harcama (`promo*Spend`) | `spend-calculation` | İstemci **türetmiyor**, sunucudan okuyor |
| RAG | `plan_skus.rag_status` / `plan_fus.rag_status` | İstemci **türetmiyor** |

**Ölçüm:** `main.kpis` içinde grid'in 12 değerinden yalnız **4'ünün** karşılığı var
(`BASE_GSV`, `PLANNED_GSV`, `BASE_TO`, `PLANNED_TO`); üçünün `show_in_grid=false`.

---

## S2 — Kalıcılaşma ⟨belirleyici⟩

### S2.1 Kayıt yolu

| Yol | Endpoint | Gövde | file:line |
|---|---|---|---|
| Hacim | `updateSkuVolume` | `{ version, baseVolume? , plannedVolume? }` | `:969-991` |
| Taktik | `updateFuTactic` | `{ tactics: {code: value}, version }` | `:1017-1035` |
| FU ekle/çıkar | `addFu` / `removeFu` | `{ fuId, planVersion }` | `:944-953`, `:1061-1063` |
| Recalc | `recalculate` | gövde yok | `:1079-1080` |

**Türetilmiş değer gönderen tek bir yol yok.**

### S2.2 Sunucu davranışı

DTO'lar türetilmiş alan **tanımlamıyor**:
`update-sku-volume.dto.ts` → `baseVolume?`, `plannedVolume?`, `version`
`update-fu-tactic.dto.ts` → `tactics?: Record<string, number>`, `version`
Gönderilse bile `ValidationPipe` tarafından taşınmaz. Sunucu her yazmadan sonra recalc çalıştırıp
`plan_skus`/`plan_fus`/`plans` kolonlarını **kendi** üretiyor.

### S2.3 Karar etkisi

| Karar | İstemci hesabına bağlı mı? | Kanıt |
|---|---|---|
| Submit/approve edilebilirlik | **Hayır** | `disabled` yalnız `isEditable` + mutation durumu (`:1568`, `:1708`) |
| Bütçe rezervasyonuna giden tutar | **Hayır** | Rezervasyon `plan.onInvoiceSpend`/`offInvoiceSpend` kolonlarından (T-056 adım 5) |
| RAG / eşik | **Hayır** | `RAGCell status={planFu.ragStatus}` — sunucu alanı (`:1557`, `:1695`) |
| Kullanıcının görüp onayladığı ekran | ⚠️ **EVET** | `PlanApprovalDetailModal.tsx` — aşağıda R2 |

### S2.4 `plan.totalSpend` zinciri

Grid'in gösterdiği harcama, `promoOnInvoiceSpend + promoOffInvoiceSpend` toplamı (`:180-191`) —
bunlar `spend-calculation`'ın yazdığı **sunucu alanları**. Bütçe rezervasyonu ise
`plans.on_invoice_spend`/`off_invoice_spend` kolonlarından besleniyor (T-056 adım 4/5) ve
`total === on + off` özdeşliği orada testle kilitli.

**Yani ekranda görülen harcama ile bütçeden düşülen tutar aynı kaynaktan geliyor.**
ADR 0005 K3'ün ele aldığı "bayat 0/0 kolon" sınıfı burada **yeniden üretilmiyor** — çünkü grid
kolonları okuyor, kendi harcamasını türetmiyor. Bayatlık riski varsa sunucu tarafındadır ve
K3'ün gürültülü reddi onu zaten yakalıyor.

---

## S3 — Yaygınlık

### S3.1 Diğer bileşenler

`unitPrice`/`listPrice` kullanan bileşen sayısı: **5** (STOP eşiği 10 — aşılmadı)

| Dosya | Durum |
|---|---|
| `PlanningGridEnhanced.tsx` | Ana grid — bu raporun konusu |
| `PlanningGrid.tsx` | ⚠️ **Ölü kod görünüyor** — hiçbir yerden import edilmiyor (ölçüldü) |
| `PlanApprovalDetailModal.tsx` | ⚠️ Onay ekranı — R2 |
| `SkuManagementPage.tsx` | Master data CRUD — finansal türetim değil |
| `ForecastingUnitManagementPage.tsx` | Master data CRUD |

### S3.2 Dinamik formül kuralıyla ilişki

BRD: *"KPI/ROI/Spend/Profit = Admin tanımlı dinamik formül."*

Grid'in 12 türetilmiş değerinden **8'inin `main.kpis`'te karşılığı yok** (`INCR_GSV`, `BASE_NIV`,
`PLAN_NIV`, `INCR_NIV`, `INCR_TO`, `INCR_GP%`, `ROI%`, `VOL_UPLIFT_PCT`). Bunlar TypeScript'te
**gömülü**.

**Sonuç:** admin `main.kpis` üzerinden bir formülü değiştirirse, grid'in gösterdiği bu 8 değer
**eski formülle hesaplanmaya devam eder** ve değişiklik sessizce yok sayılır. Karşılığı olan 4
değerde de senkron **kod tarafında elle** sağlanıyor, otomatik değil.

Bu, ihlalin **kalıcı** sınıfa girmesini engelleyen tek şeyin şu olduğu anlamına geliyor: bu değerler
hiçbir yere yazılmıyor ve hiçbir kararı etkilemiyor. Yazılmaya veya karara bağlanmaya başladıkları
an sınıf **finansal sonuçlu ihlale** döner.

---

## Risk sıralaması

### R1 — 🔴 Sessiz + finansal görünürlük: `unitPrice ?? 0` fabrikasyonu
`PlanningGridEnhanced.tsx:95, 100, 104, …` (13 yerde) ve `PlanApprovalDetailModal.tsx:376`
İstemci, birim fiyatı olmayan SKU'yu **0** sayıyor → GSV/NIV/TO **0** görünüyor.
Backend aynı yerde bilinçli olarak **null** tutuyor (`plan.service.ts:2257` `BPTT: unitPriceOrNull`)
ve gerekçesi kodda yazılı:
> *"Master data — null when not yet configured on the SKU (T-027: e.g. Wella SKUs seeded without
> COGS must not silently become 0, which would fabricate GP_ROI_PCT = 100% / RAG = GREEN)"*

Yani **T-027'de sunucuda düzeltilen fabrikasyon, istemcide aynen duruyor.** BRD "eksik veri → null"
kuralıyla doğrudan çelişiyor. Kullanıcı fark etmez: 0 ile "veri yok" ekranda ayırt edilemez.
Kalıcılaşmıyor, ama **karar destek değeri yanlış**.

### R2 — 🔴 Sessiz + onay ekranında: `incrementalGp` bilerek yanlış
`PlanApprovalDetailModal.tsx:104`
```js
const incrementalGp = planData.totalGp - baseVolume * 0; // Simplified - should calculate base GP properly
```
`× 0` yüzünden `incrementalGp === totalGp`. Kod yorumu hatayı **kabul ediyor**.
Bu, **onaylayan kullanıcının gördüğü** ekran — Category Manager artımlı GP diye toplam GP'yi
görüyor. Kalıcılaşmıyor ama **onay kararını besliyor**; S2.3'ün "kullanıcı X görüp onaylıyor"
maddesinin gerçekleşmiş hâli.

### R3 — 🟡 Gürültüsüz ama yapısal: 8 değer dinamik formül kapsamı dışında
S3.2. Admin formül değişikliği bu değerlere ulaşmıyor. Bugün zararsız (hiçbir yere yazılmıyor),
ama BRD'nin "dinamik formül" ilkesinin fiilen yalnız sunucuda geçerli olduğu anlamına geliyor.

### R4 — 🟡 `BASE_TO` formül metni belirsiz
DB `formula_text` = `BASE_GSV - BASE_LTA_ON`; migration 1780 açıklaması
`BASE_GSV - BASE_LTA_ON - BASE_LTA_OFF`; istemci **OFF'u da** düşüyor.
Üçü aynı şeyi söylemiyor. **Doğrulanmalı** — hangisi canonical?

### R5 — 🟢 `PlanningGrid.tsx` ölü kod
Hiçbir yerden import edilmiyor ama finansal aritmetik içeriyor. Bakım yükü + yanlış referans riski.

---

## Tetiklenen STOP koşulu

**#2 — kısmen tetiklendi.** "İstemci ve sunucu aynı değer için farklı formül kullanıyorsa."
Yapısal formüller **aynı** (BPTT = unitPrice, LTA düşümleri eşleşiyor), ama **kenar durumda
ayrışıyorlar**: null → istemci `0`, sunucu `null` (R1). Ayrıca R4'te üç kaynak arasında metin
uyuşmazlığı var. Bu yüzden analiz derinleştirilmedi, sınıflandırma raporlanıyor.

**#1 tetiklenmedi:** istemci değeri bütçe rezervasyonuna gitmiyor.
**#3 tetiklenmedi:** finansal hesap yapan bileşen sayısı 5 (< 10).

---

## Açık kalanlar

1. **R4** — `BASE_TO`/`PLANNED_TO`'nun canonical formülü: DB `formula_text`, migration açıklaması ve
   istemci üçlüsü uyuşmuyor. `PLANNED_TO`'nun tam metni okunmadı.
2. `PLANNED_TO`'nun `show_in_grid=true` olması ama grid'in `PLAN_TO`'yu **kendi** hesaplaması —
   `show_in_grid` bayrağının fiilen bir tüketicisi var mı, ölçülmedi.
3. `plan.service.ts:2196` `const unitPrice = unitPriceOrNull ?? 0` — sunucuda da bir `?? 0` var;
   hangi çıktıyı beslediği (legacy `planned_turnover` kolonu?) incelenmedi. R1'in sunucu tarafında
   da bir karşılığı olabilir.
4. FU seviyesi toplamların (`:387-424`) sunucudaki FU agregasyonuyla (`aggregation_method_fu`)
   tutarlılığı ölçülmedi.
5. Bu rapor düzeltme önermiyor — sınıflandırma yapıyor. Çözüm ayrı bir karardır.
