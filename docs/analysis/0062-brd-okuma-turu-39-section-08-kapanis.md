# 0062 — BRD okuma turu **39**: `Section_08 §8.2–§8.6` (bölüm kapandı)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `Section_08_Reporting.md` **490–733** (§8.2 mode-aware · §8.3 drill-down ·
  §8.4 export · §8.5 non-goals · §8.6 Phase 1 kapsamı) — **`Section_08` bu turla bitti**
- **Ölçüm ortamı:** meta `5cff8c1`. Submodule'ler checkout **edilmemiş** — ürün-tarafı canlı
  ölçüm yok.

---

## 1. §8.5 — **dışlama listesi ailesi TAMAMLANDI** (ve sayı hafızadan değil, ölçüldü)

`0036` (turu 18) *"beşinci kapsam listesi"* demişti ve o gün doğruydu. Bugün ailenin
**tamamı** enumere edildi — `CLAUDE.md`'nin *"bir enumerasyona dayanan her karar,
enumerasyonun kendisi ölçülene kadar bir tahmindir"* kuralı gereği hafızadan sayılmadı:

```
grep -rn "Explicitly NOT in Phase 1|Explicit Non-Goals|Will Not Build|
          Non-Goals & Explicit Exclusions|NOT in Phase 1 (Deferred)"  docs/brd/
```

| # | yer | okundu |
|---|---|---|
| 1 | `Section_02:671` §2.7 Non-Goals & Explicit Exclusions | `0036` |
| 2 | `Section_03:759` §3.3 Phase 1 Constraints | `0049` |
| 3 | `Section_04:1914` §4.10 | `0021` |
| 4 | `Section_05:1956` §5.7 | `0033` |
| 5 | `Section_06:558` §6.7 | `0053` |
| 6 | `Section_07:574` §7.7 | `0041` |
| 7 | `Section_09:454` §9.8 | `0050` |
| 8 | `Section_10:99` §10.1 Phase 1 | `0045` |
| 9 | `Section_10:438` §10.4 Will Not Build | `0054` |
| **10** | **`Section_08:636` §8.5** | **bu tur** |
| **11** | **`Section_08:710` §8.6** | **bu tur** |

> **Aile on bir üyeli ve bugün itibarıyla hepsi okundu.** *"Beş"* rakamı bayat bir sayıydı —
> ve tam olarak `CLAUDE.md`'nin *"dokümanda sayı yazma"* kuralının öngördüğü şekilde bayatladı.

---

## 2. ADR 0010 — **onuncu ve on birinci** bağımsız doğrulama, aynı sonuç

Seri ölçümü `Section_08` üzerinde tekrarlandı, **hem kelime sınırlı hem gövdeyle**
(`-w` çoğulları ve ekli hâlleri keser — `CLAUDE.md`'nin ölçülmüş tuzağı):

```
kelime sınırlı (-owci):  recognition 0 · claim 0 · accrual 0 · settlement 0 · reversal 0
gövde         (-oci):    recogni     0 · claim 0 · accru   0 · settle     0 · revers   0
```

**Sıfırlar iki yöntemle de sıfır** — yani bu bir `-w` yan etkisi değil.

### Ve seri artık bir DESEN gösteriyor: kavramlar **yerelleşmiş**

| terim (gövde) | `Section_04` | `Section_03` | `Glossary` | `Section_08` |
|---|---|---|---|---|
| `claim` | **2** | 0 | 0 | 0 |
| `accru` | **3** | 1 | 0 | 0 |
| `settle` | **22** | 0 | 3 | 0 |
| `recogni` | 0 | 0 | 0 | 0 |

> Paket bu kavramları **yalnız `Section_04`'te** (actuals-first mod bölümü) kullanıyor;
> raporlama, çekirdek bileşenler ve sözlük **kullanmıyor**. `§2.1.1`'in dersinin doğrudan
> kanıtı: *bir kavramın yokluğu, hangi bölümde arandığına bağlıdır.*

**ADR 0010 açısından:** karar `.cursor` PDF'inin **daha az söylediği** (mod kavramı hiç yok)
ölçümüne dayanıyordu. `Section_08` o kararı **on birinci kez** aynı yönde besliyor: paketin
kapsam beyanları birbiriyle tutarlı, ve hiçbiri PDF'in taşımadığı bir kavram ailesine
gizlice dayanmıyor.

⚠️ **İddia edilmeyen:** `recognition`'ın **tüm pakette 0** olması, o kavramın gerekli
olmadığı anlamına gelmez — `0055`'in TTM ölçümü tam da bu boşluğu konu ediyordu. Ölçülen
şey **kaynağın sessizliği**, ürünün ihtiyacı değil.

### 📌 Ve sessizlik mutlak değil: kavram **kelimesiz** duruyor

`Section_08` para tanımayı **tanımlıyor**, yalnız adını koymuyor:

```
:117  Consumed Budget (actual spend occurred)
:118  Available = Allocated − Reserved − Committed − Consumed
:521  Consumed: 62.000 TL (invoices posted)          ← tanıma anı: FATURA
```

> Yani *"recognition"* kelimesi yok ama **kuralı var**: tüketim, **fatura kaydedildiğinde**
> gerçekleşir. Bu, `0023`'ün açık `ACCRUAL` sorusuyla (tahakkuk ne zaman yazılır) doğrudan
> ilgili ve onu **daraltıyor** — `Consumed` faturaya bağlıysa, tahakkuk `Consumed` değildir.
> **Karar değil, bir girdi** (`§2.1.2`); `OPEN_DECISIONS` → `0023` satırı açık kalıyor.

---

## 3. §8.2 — mod ayrımı: **rapor seviyesinde ayrı, para seviyesinde ortak**

```
Reserved  = Actuals-First agreements
Committed = Planning-First plans
Consumed  = invoices posted
Both consume from the SAME budget envelopes
```

Ve *"Trade Spend Summary: **no differentiation needed** (spend is spend, regardless of
origin)"*.

📌 Bu, `ADR 0004`'ün (On-Invoice / Off-Invoice ayrı değerlendirilir) **farklı bir eksen**
olduğunu gösteriyor: ADR 0004 **taktik türü** ekseninde ayırıyor, `§8.2` **mod** ekseninde
birleştiriyor. Çelişki değil — `0036`'nın uzlaştıran-okuma disiplini burada da geçerli.

⚠️ **Phase 1 stratejisi açıkça "ayrı raporlar":** birleşik "Promotional Performance" raporu
**Phase 2+**. Yani bugünkü ürünün ayrı `/agreements` ve `/plans` yüzeyleri kaynağa **uygun**.

---

## 4. §8.3 / §8.4 — iki mimari şart ve bir saklama kuralı

**§8.3 Drill-Down — performans notu bir mimari şart içeriyor:**
- *"Pre-aggregated summaries (**materialized views**)"*

📌 `0054 §5` ölçmüştü: `main` şemasında **materialized view yok**, yalnız normal
`v_budget_summary`. Orada bu bir **risk azaltması** (uygulanmamış olması kusur değil);
burada bir **drill-down performans şartı** olarak tekrar ediyor. İkisi aynı mekanizmaya
işaret ediyor — [[T-157]] bağlamına eklenmeli.

**§8.4 Export — üç biçim, üç limit, bir saklama süresi:**

| biçim | limit | not |
|---|---|---|
| Excel `.xlsx` | **50 MB** | çok sayfalı (Summary/Detail/Metadata), gömülü grafik |
| PDF | **20 MB** | sayfalanmış, baskıya hazır |
| CSV | **100 MB** | ham veri, tek tablo |

- **>10K satır → arka plan işi**, bitince **bildirim** (e-posta veya in-app)
- **Dosya 7 gün sonra siliniyor** (indirme linki expire)
- **Gömülü metadata zorunlu:** rapor adı · üretim tarihi · **uygulanan filtreler** ·
  **üreten kullanıcı** · veri tazeliği damgası

⚠️ İki bağlantı:
1. *"Arka plan işi + bildirim"* → `MC-002`'nin 6 olayında **export bildirimi YOK**
   (`0060 §4`). Yani iki kaynak aynı ürünün bildirim kümesini farklı sayıyor.
2. **7 günlük dosya ömrü** bir **saklama kuralıdır** → [[T-170]] (7 yıl audit · KVKK)
   kapsamının dışında kalan, ayrı ve çok daha kısa bir süre. Kaydediliyor.

---

## 5. §8.6 ↔ §8.1 — kaynak kendi içinde **bir raporu düşürüyor**

`§8.1` **sekiz** rapor tanımlıyor. `§8.6`'nın *"✅ Phase 1 Reporting Features"* listesi
**yedi** sayıyor:

```
✅ Trade Spend Summary · Budget Utilization · Agreement Status · Plan Performance
✅ Planner Performance · Spend by Tactic · Executive Dashboard
```

**Eksik olan `Report 7: Variance Analysis`** — ve bu **tutarlı**: `§8.1`'in kendi notu
*"(Phase 2 feature, included for completeness)"* diyor, `§8.6`'nın ❌ listesi de
*"Variance analysis (Phase 2, requires actuals import)"* diyor.

> **Yani sayı farkı bir çelişki değil, bilinçli bir ayrım.** Ama *"8 standard reports"*
> ifadesi (`§8.1:28`) Phase 1 için **yanıltıcıdır** — Phase 1'de **yedi** rapor vardır.
> Yeni BRD'de bu sayı bir yerde tekrar edilecekse, **fazın adıyla birlikte** yazılmalı.

📌 `§8.5`'in *"Scope (**8 standard reports** sufficient for MVP)"* gerekçesi de aynı sayıyı
tekrar ediyor — yani hata değil, **tutarlı bir gevşeklik**.

---

## 6. Bu turun sınırları (ZORUNLU)

- **Ürün karşılaştırması yapılmadı.** §3'ün *"bugünkü ürün kaynağa uygun"* cümlesi
  `0058`'in kayıtlı rota listesine dayanır; bu turda hiçbir ekran açılmadı.
- **Export'un ürün tarafı hiç ölçülmedi** — üç biçim, limitler, arka plan işi, 7 günlük
  ömür ve gömülü metadata: hiçbiri için *"var/yok"* denmedi.
- `§8.3`'ün drill-down yolları (`Path 1/2/3`) ürünün rota yapısıyla **karşılaştırılmadı**.
- `materialized view` yokluğu `0054`'ten **alıntıdır**, bu turda yeniden ölçülmedi.
