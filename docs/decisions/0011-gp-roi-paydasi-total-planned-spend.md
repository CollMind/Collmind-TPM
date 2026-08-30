# 0011 — `GP_ROI_PCT` paydası `TOTAL_PLANNED_SPEND`'tir

- **Durum:** Kabul edildi (Accepted)
- **Geçerlilik tarihi:** 2026-08-10
- **Karar veren:** Sertaç Tuzcu (ürün sahibi)
- **Kapsar:** [[T-163]] · `migration 1780000000000-FixKpiBrdFormulas`
- **Ölçüm:** `docs/analysis/0055 §2.3` · `0051 §3` · [[T-143]] BRD okuma turları

## Bağlam

Ürünün ana metriği iki farklı paydayla tanımlanmış durumda:

| kaynak | formül |
|---|---|
| BRD `§5.1` · `§5.3` · Addendum `H1` · `04_Reviews` | `(INCR_GP / **TOTAL_PLANNED_SPEND**) * 100` |
| CTPM `GrandTotals.tsx:64` **yorumu** | `(Incremental GP / **Total Spend**) * 100` |
| **TTM** `seed.ts:1145` + `plans.kpis.spec.ts:212,:487` | `(INCR_GP / **TOTAL_PLANNED_SPEND**) * 100` |
| **CTPM `migration 1780`** | `INCR_GP / **INCR_SPEND** * 100` — ve *"DOĞRU (BRD)"* diye etiketli |

Altı tanık bir tarafta, bir tanık diğer tarafta — ve o bir tanık, kendini **BRD paritesi
düzeltmesi** olarak tanımlıyor. Aynı migration `TOTAL_PLANNED_SPEND`'i bir KPI olarak
**birkaç satır ötede** ekliyor.

## Karar

**`GP_ROI_PCT = (INCR_GP / TOTAL_PLANNED_SPEND) * 100`.**

`migration 1780`'in paydası geri alınır. Yeni bir migration yazılır
(**`data-engineer`**; numara `MIGRATION_SEQUENCE.md`'den tahsis edilir) — `1780` **geriye
dönük düzenlenmez**, çünkü uygulanmış bir migration'ın gövdesini değiştirmek çalışan
veritabanına ulaşmaz.

## Gerekçe

### Asıl gerekçe tanık sayısı değil — **eşikler o paydaya göre kalibre edilmiş**

```
ROI ≥ %20                      → RAG yeşil eşiği
Gate 3                         → "planların %70'i yeşil"
auto_reject                    → gp_roi_pct_lt: 5
Finance onay eşiği             → < %15
```

Dört eşiğin dördü de `TOTAL_PLANNED_SPEND` paydası varsayılarak yazıldı.

> **Paydayı küçültmek ROI'yi şişirir — yani her eşik gevşer, ve `%70 yeşil` kapısı
> kendiliğinden geçilir.**

Yani sapma yalnız bir sayıyı değiştirmiyor; **ürünün kabul kapılarını** de facto devre
dışı bırakıyor.

### `INCR_SPEND` savunulabilir, ama **başka bir metrik**

| | anlamı |
|---|---|
| `INCR_GP / TOTAL_PLANNED_SPEND` | *"taahhüt edilen her lira başına artımsal kâr"* |
| `INCR_GP / INCR_SPEND` | *"artımsal harcanan her lira başına artımsal kâr"* |

İkincisi geçerli bir finansal metriktir. Ama onu **`GP_ROI_PCT` adıyla** kullanmak, o adla
kalibre edilmiş dört eşiği yanlış bir dağılıma uygular. Seçilseydi **tüm eşiklerin yeniden
kalibre edilmesi** gerekirdi — ve bunun için bir gerekçe yok.

⚠️ `CLAUDE.md §2.1.2` gereği bu karar *"BRD böyle diyor"* diye verilmedi. BRD bir
**girdi**dir. Kararı belirleyen şey, **eşiklerin hangi paydaya göre yazıldığıdır** — ve
o ölçülebilir bir olgudur.

## Sonuçları

1. **`migration 1780`'in yorumu düzeltilir.** *"DOĞRU (BRD): INCR_GP / INCR_SPEND"*
   satırı **her hâlükârda** yanlıştı: dört kaynak `TOTAL_PLANNED_SPEND` diyor.
   Yeni migration'ın yorumu bu ADR'ye atıf yapar.
2. **`GrandTotals.tsx:64` yorumu doğrulanır** — bugün BRD'nin paydasını tarif ediyor ve
   backend öyle hesaplamıyordu. Karardan sonra yorum **doğru** olur; yine de
   `CLAUDE.md`'nin atıf kuralı gereği ADR referansı eklenir.
3. `%70 yeşil` gibi ölçütler **ancak bu düzeltmeden sonra** anlamlı ölçülebilir.
4. Estate hizalanır: TTM zaten bu formülü hem seed'inde hem **testinde** taşıyor.

## Bu kararın ikinci dersi

`ADR 0001`'in kapsamı genişledi: **TTM yalnız akış kaynağı değil, doğrulama kaynağı da.**

> `1780` yazılırken TTM'e bakılsaydı cevap oradaydı — hem seed'de hem teste pinlenmiş
> hâlde. Bir CTPM kararı şüpheliyse, TTM'de karşılığı olup olmadığına bakılabilir.

Ve `CLAUDE.md §2.7`'nin *"bir DÜZELTME de bir iddiadır"* maddesinin en pahalı vakası
buydu: sapma **bir uygunluk etiketi altında** koda girdi, ve etiket sorguyu kapattı.

---

## ⚠️ `F12` NOTU — **KALEM BÖLÜNDÜ** (2026-08-30, `Z66 §1`)

> **Bu ADR'nin kararı GERİ ALINMADI — kapsamı DARALDI.**
> *(Eski metin **silinmedi**; append-only iz.)*

```
BÜTÇE    TOTAL_PLANNED_SPEND    ← OLDUĞU GİBİ KALIR (LTA DAHİL)
                                  zarf GERÇEK PARAYI rezerve eder ⇒ total DOĞRU
ROI      INCR_PROMO_SPEND       ← AYRI KALEM (yalnız promo · LTA hariç · incremental)
```

**Gerekçe:** dört kayıt arasındaki çelişki *(canlı/BRD · Excel · `Z62 §6-3` · ölü kod)*
**iki ekseni tek kaleme sıkıştırmaktan** doğuyordu — `(LTA dahil mi)` × `(total mı
incremental mı)`. Bu ADR'nin `INCR_SPEND → TOTAL_PLANNED_SPEND` değişikliği **bütçe
ihtiyacı için doğruydu ve öyle kalır**; yanlış olan **ROI'nin BÜTÇE kalemini okumasıydı**.

⇒ **Finansal yayılım SIFIR:** bütçe yolu dokunulmuyor, yalnız ROI'nin **okuma adresi**
değişiyor. Tanım **tek noktadan** okunur: `src/common/kpi/roi-denominator.ts` (`B4`).

**Uygulama:** `T-334` (formül-kanon düzeltmesi).
**Kaynak:** `docs/brd-v2/04_KARAR_KAYDI.md` `Z66 §1`.
