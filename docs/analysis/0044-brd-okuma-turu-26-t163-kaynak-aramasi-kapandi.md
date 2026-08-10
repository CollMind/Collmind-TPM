# 0044 — BRD okuma turu **26**: [[T-163]] kaynak araması **kapandı** — sapma bir *"BRD paritesi düzeltmesi"* olarak girmiş

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `04_Reviews/BRD_Consolidated_For_Opus_Review.md` (FOR REFERENCE) ·
  `collmind.backend/src/database/migrations/1780000000000-FixKpiBrdFormulas.ts`
- **Ölçüm ortamı:** meta `0574b3c` · backend `99ee9e6`

---

## 1. ✅ Dördüncü kaynak da aynı paydayı veriyor — **arama bitti**

`04_Reviews`, KPI tanımı (INSERT bloğu):

```sql
'GP_ROI_PCT',
'(INCR_GP / TOTAL_PLANNED_SPEND) * 100',
'["INCR_GP", "TOTAL_PLANNED_SPEND"]',
```

ve Edge Case bölümünde **iki kez daha**:

```
- Formula: `GP_ROI_PCT = (INCR_GP / TOTAL_PLANNED_SPEND) * 100`
- Solution: `IF(TOTAL_PLANNED_SPEND = 0, NULL, ...)`
```

Ve **`INCR_SPEND` orada da ayrı bir KPI**:

```sql
'INCR_SPEND',
'TOTAL_PLANNED_SPEND - TOTAL_BASE_LTA',
```

### Dört bağımsız kaynak, tek payda

| # | kaynak | payda |
|---|---|---|
| 1 | `Section_05 §5.3` KPI kütüphanesi | `TOTAL_PLANNED_SPEND` |
| 2 | Glossary `GP ROI` maddesi | `TOTAL_PLANNED_SPEND` |
| 3 | Glossary `ROI` maddesi | `TOTAL_PLANNED_SPEND` |
| 4 | **`04_Reviews`** (üç geçiş) | `TOTAL_PLANNED_SPEND` |

> **Kaynak araması TÜKENDİ.** Paket'in hiçbir yerinde `INCR_SPEND` paydası **yok**.
> Sapmanın kaynakta bir dayanağı **bulunamadı** — ve artık bakılmamış yer kalmadı.

---

## 2. ⛔ Sapmanın kaynağı bulundu: **`migration 1780000000000`**

Turu 13'te T-163'e şu maddeyi koymuştum: *"`FixKpiBrdFormulas` adı 'BRD formüllerini
düzeltiyor' diyor — **o migration neye göre düzeltmiş?**"*

**Cevap, migration'ın kendi başlık yorumunda:**

```
/**
 * T-008 — KPI/ROI BRD Parite Fix Migration
 *
 * 1. GP_ROI_PCT formula_text'ini BRD kanonik formüle günceller:
 *    YANLIŞ (önceki): GP / TACTIC_SPEND * 100
 *    DOĞRU (BRD):     INCR_GP / INCR_SPEND * 100      ← ⚠️
 */
```

Ve uygulaması:

```sql
UPDATE "main"."kpis"
SET formula_text    = 'INCR_GP / INCR_SPEND * 100',
    depends_on_kpis = '["INCR_GP","INCR_SPEND"]'::jsonb
WHERE kpi_code = 'GP_ROI_PCT'
```

### 🔴 Üç katmanlı bir bulgu

**(a) Sapma bir düzeltme turunda GİRDİ.** Önceki formül `GP / TACTIC_SPEND * 100`'dü ve
**gerçekten yanlıştı**. Migration onu düzeltti — ama **yanlış hedefe**.

**(b) Sapma *"DOĞRU (BRD)"* diye ETİKETLENDİ.** Bu, `INCR_GP / INCR_SPEND`'in BRD kanonik
formülü olduğu **iddiasıdır** — ve dört kaynak onu **yalanlıyor**.

**(c) ⚠️ Ve aynı migration `TOTAL_PLANNED_SPEND`'i KPI olarak EKLİYOR.** Başlık yorumunun
2. maddesi: *"Eksik BRD KPI'larını ekler: … **`TOTAL_PLANNED_SPEND`**, `BASE_TOTAL_SPEND`,
**`INCR_SPEND`**, …"*

> **Doğru payda aynı migration tarafından veritabanına eklendi — ve kullanılmadı.**

---

## 3. 📌 Bu, oturumun merkezî dersinin kanonik vakası

CLAUDE.md **§2.1.2** (bu oturumda yazıldı): *"Bağlayıcı kaynak bir **girdi**dir, kanıt
değil."*
CLAUDE.md **§7.1** (T-084 vakası): *"**Bir hatayı belgelemek, onu koruma altına alır.**"*

Bu vaka **ikisini birden** taşıyor, ve bir üçüncüsünü ekliyor:

| kural | bu vakada |
|---|---|
| *"başka bir bileşen hakkındaki iddiayı ölç"* | *"DOĞRU (BRD)"* — **BRD okunmadan** yazılmış bir iddia |
| *"belgelemek koruma altına alır"* | Migration'ı okuyan herkes formülün BRD'ye uygun olduğuna **inanır** |
| 🆕 **düzeltme turu sapma üretebilir** | Gerçek bir kusur düzeltilirken **yeni bir sapma** girdi |

> **Sessiz bir sapma değil — *"uygunluk"* diye belgelenmiş bir sapma.** İkincisi daha
> tehlikelidir: sessiz olan bir gün fark edilir, belgelenmiş olan **sorguyu kapatır**.

⚠️ Ve bu oturumun kendi zincirleriyle aynı şekil (baseline eşiği, auto-reject):
**bir düzeltme de bir iddiadır ve o da yanlış olabilir.** Burada düzeltme **koda** girdi,
yorumumuza değil.

---

## 4. Ne DEĞİŞMİYOR

- Migration'ın **diğer işleri** sorgulanmıyor: 17 eksik KPI ekledi, `PLAN_TURNOVER →
  PLANNED_TO` hizalaması yaptı. **Bu doküman yalnız `GP_ROI_PCT` maddesini ölçtü.**
- Önceki formül (`GP / TACTIC_SPEND`) **gerçekten yanlıştı** — düzeltme gerekliydi.
- **Hangi formülün doğru olduğu bir ürün kararıdır** ([[T-163]]): kaynak
  `TOTAL_PLANNED_SPEND` diyor, ama `§2.1.2` gereği *"BRD böyle demiş"* tek başına yeterli
  değil. İki metriğin **iş anlamı** farklı ve seçim ürün sahibinin.

---

## 5. [[T-143]]'ün bitiş ölçütlerinden biri tamamlandı

> *"[[T-163]]'ün son kaynak adayı `04_Reviews`. Bulunmazsa **'kaynakta yok'** diye kapanır."*

**Bulundu — ve tersini söylüyor.** T-163'ün kaynak araması **kapandı**:
sapma kaynaksızdır, ve **nereden geldiği de belli**.

---

## 6. Sonraki tur

1. `§10.1` faz tanımları — [[T-169]]'un ön koşulu (**oturumun en geniş açık sorusu**)
2. `§7.1` Role Model — [[T-165]]
3. `04_Reviews`'in kalanı (5.249 satır, yalnız hedefli tarama yapıldı) — bir
   *"architectural review"*, ve H1-H5'in gerekçesi orada olabilir ([[T-161]])
