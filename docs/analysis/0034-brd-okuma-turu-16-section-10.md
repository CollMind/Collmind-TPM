# 0034 — BRD okuma turu **16**: §10.2 Phase Gates · §10.4 "Will Not Build"

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_10_Roadmap.md` §10.2 (323–375) · §10.4 (438–500)
- **Ölçüm ortamı:** meta `4bded38` · backend `99ee9e6`

---

## 1. ✅ §10.4 "Will NOT Build" — [[ADR 0010]] **doğrulandı ve keskinleşti**

Kanonik kapsam-dışı listesi, beş kategori:

```
❌ Financial System   : General Ledger · Accounts Payable · Accounts Receivable · ERP replacement
❌ Supply Chain       : demand forecasting · inventory · production · logistics
❌ CRM                : CRM · pipeline · opportunity · contact
❌ BI/Data Warehouse  : SQL builder · data lake · ETL · ML platform
❌ Campaign Execution : marketing automation · digital ads · social · CMS
```

**Aradığımız altı terim burada da yok** — `claim` · `settlement` · `accrual` ·
`reconciliation` · `recognition` · `gross-to-net`.

### ⚠️ Ama bu liste bir ŞEY söylüyor, ve ADR 0010'u keskinleştiriyor

BRD sınırını **GL / AP / AR** hattında çiziyor — ve `§3.6` bunu aynen tekrarlıyor:
*"Ledger … does not replace **GL accounting, accounts payable processing**, or ERP financial
modules."*

> **Muhasebe tarafındaki uzlaştırma açıkça dışarıda. TPM'in kendi claim/recognition katmanı
> ise ne içeride ne dışarıda.**
>
> Yani boşluk, CollMind'ın **ilan ettiği alanın İÇİNDE** ve tanımsız. Bu, ADR 0010'un
> sonucunu değiştirmiyor — **güçlendiriyor**: kaynak sınırını çizmiş, ve recognition o
> sınırın içinde kalmış ama yazılmamış.

**Dördüncü kapsam listesi**, ve dördü de aynı sonucu veriyor (§4.10 ×2, §5.7, §10.4).

---

## 2. ⛔ §10.2 Gate 2 ↔ Addendum H4 — **çelişiyorlar**, ve turu 10'daki iddiam yanlıştı

### 2.1 Ölçüm

| | **Addendum H4** (`0028`) | **§10.2 Gate 2** (bu tur) |
|---|---|---|
| baseline kapsama | **MVB-2 = %80** → *"Phase 2 launches as designed"* | **≥%95 SKU coverage** |
| agreement sayısı | 50+ | 50+ ✅ |
| uptime | %99 | ≥%99 (4 hafta) ✅ |
| **CI/CD perf regresyonu** | ✅ **zorunlu** | **hiç geçmiyor** |
| **10 eşzamanlı kullanıcı yük testi** | ✅ **zorunlu** | **hiç geçmiyor** |

### 2.2 ⚠️ Turu 10'daki iddiam düzeltiliyor

`0028 §2`'de şunu yazmıştım:

> *"Glossary'nin **≥95% SKU coverage** ifadesi **tam kapasite hedefidir, fırlatma kapısı
> değil.** Fırlatma kapısı **MVB-2 (%80)**."*

**Bu, tek kaynağa (Addendum H4) dayanan bir genellemeydi.** Ölçüm:

| kaynak | ne diyor |
|---|---|
| Glossary `Baseline` | *"≥95% SKU coverage **for plans to be approved** (data quality gate)"* |
| **§10.2 Gate 2** (kanonik roadmap) | **≥95%** |
| Addendum H4 | MVB-2 **%80** = *"launches as designed"* |

> **İki kaynak %95 diyor, biri %80.** Ve ben Addendum'u okuduğum için onu kanonik saymıştım
> — tam olarak bu oturumun defalarca yakaladığı sınıf: **bir kaynağı okuyup genelleme.**

**Doğru ifade:** bu bir **çelişkidir**, çözülmüş bir soru değil. → [[T-159]]'un **beşinci**
vakası, ve ilki ki **iki "FOR IMMEDIATE USE" belgesi** arasında (`01_Main_BRD` ↔
`02_Addendum`), Candidate Log değil.

### 2.3 Ve CI/CD tersine dönüyor

`§10.2`'nin **hiçbir kapısında** CI/CD performans regresyonu ya da 10-kullanıcı yük testi
**yok**. O ölçütler **yalnız Addendum'dan** geliyor.

> [[T-157]]'nin *"Phase 2 kapısının bir ölçütü yapısal olarak imkânsız"* bulgusu **duruyor**
> — ama artık biliniyor ki o ölçüt **kanonik roadmap'te değil**, Addendum'un eklemesi.
> Yani *"kapı geçilemez"* değil, **"iki kapı var ve biri daha sıkı"**.

---

## 3. 🔴 §10.2 Gate 3 — [[T-163]]'ün sapması bir **kapıyı kolaylaştırıyor**

```
Gate 3 (Phase 2 → Phase 3):
  ✅ 70%+ plans achieve Green status (ROI ≥20%)
```

`GP_ROI_PCT` bizde `INCR_GP / INCR_SPEND`, BRD'de `INCR_GP / TOTAL_PLANNED_SPEND`.
`INCR_SPEND ≤ TOTAL_PLANNED_SPEND` → **bizim ROI'miz sistematik olarak daha yüksek** →
daha çok plan **Yeşil**.

> **Bir faz kapısı, yanlış paydayla ölçülünce daha kolay geçilir.** T-163 artık yalnız bir
> gösterge sapması değil: **bir GO/NO-GO kararının girdisi.**

⚠️ Yön önemli ve **ölçülmedi**: `INCR_SPEND`'in gerçek tanımı bilinmediği için farkın
büyüklüğü bilinmiyor. Ama **işareti** yapısal: payda küçük → oran büyük → kapı gevşek.

T-163'e eklendi.

---

## 4. 📌 Gate 1'in ölçütü de bizde yok

```
Gate 1: ✅ All Phase 1 features deployed to production
        ✅ 10+ agreements created in production
        ✅ Performance targets met (response time <2s)
```

`agreements` **3 satır** (dev), **üretim ortamı yok** (CLAUDE.md §1). Yani **Gate 1 bile
açık**.

Bu, [[T-157]]'nin kapsamını genişletiyor: sorun *"Phase 2 kapısı"* değil, **faz kapısı
zincirinin tamamı** ölçülemez durumda — ve sebebi tek: **deploy edilmiş ortam yok.**

---

## 5. Okunmayan

`§10.1` faz tanımları (27–323, **dört fazın içeriği**) · `§10.3` teslimat riskleri
(376–438) · `§10.5` kaynak planlama · `§10.6` başarı metrikleri · **`Section_11` tamamı**
(465 satır).

**Section_10: ~120 / 567 (%21).** `Section_11` **hiç açılmadı**.

---

## 6. Sonraki tur

1. **`Section_11 Assumptions, Dependencies & Risks`** (465) — hiç açılmadı; `§11.1
   Assumptions` ve `§11.3 Risks` bizim ADR'lerimizin varsayımlarıyla kesişebilir
2. `§10.1` faz tanımları + `§10.3` riskler
3. `Section_02` (1026)
4. `04_Reviews` (5249) — [[T-161]], statüsü [[T-159]]'a bağlı
