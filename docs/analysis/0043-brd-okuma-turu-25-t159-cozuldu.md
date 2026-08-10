# 0043 — BRD okuma turu **25**: [[T-159]] çözüldü — Candidate Log, Addendum'dan **TÜRETİLMİŞ**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `00_BRD_PACKAGE_INDEX.md` (186–260) · `03_Candidate_Log` CANDIDATE-002 (106–155)
  ve CANDIDATE-007'nin künyesi
- **Ölçüm ortamı:** meta `7be581d` · backend `99ee9e6` · dev DB `main`

---

## 1. ⛔ **Çelişki hiç yokmuş** — iki aday da Addendum'u KAYNAK gösteriyor

```
CANDIDATE-002: KPI Formula Execution Sandbox
  Source:  BRD Addendum §H5 – Formula Engine Security Controls   ← ⚠️
           BRD v1.0 Section 9 – NFR (Security)

CANDIDATE-007: KPI Engine SLA & Performance Targets
  Source:  BRD Addendum §H1 – KPI Engine Performance Validation  ← ⚠️
           BRD v1.0 Section 9.1 – Performance Requirements
```

> **`03_Candidate_Log`, `02_Addendum` ile çelişmiyor — ondan TÜRETİLMİŞ.** Her aday,
> kaynağı olarak ilgili Addendum maddesini **adıyla** gösteriyor.
>
> Yani T-159'un aradığı **öncelik kuralı gereksiz**: iki belge arasında bir **hiyerarşi**
> değil, bir **türetme ilişkisi** var.

### Ve ertelenen şey **uygulama**, doğrulama değil

`CANDIDATE-002` — *Reason for Deferral*:

```
❌ No formula execution in Phase 1 (Actuals-First has no KPI engine)
❌ Security model must be validated with real formulas and threat modeling
❌ Performance implications of sandboxing unknown
```

**Ama `Validation Required` tablosu tümüyle Phase 1'de:**

| iş | ne zaman |
|---|---|
| Sandbox yaklaşım seçimi (3 seçenekli spike) | **Phase 1 Week 3** |
| Formül doğrulama mantığı (AST parser PoC) | **Phase 1 Week 4** |
| Yürütme zaman aşımı (kasıtlı sonsuz döngü testi) | **Phase 1 Week 4** |
| Audit logging bütünlüğü | **Phase 1 Week 5** |
| Penetrasyon testi | Phase 1.1 |

Ve Addendum H5'in kendi zamanlaması: **Phase 1 Week 3-4**. **Aynı iş, aynı hafta.**

`CANDIDATE-007` — *Reason for Deferral*:

```
❌ Phase 1 KPIs are simple aggregates (no complex formulas)
❌ Advanced SLAs depend on Phase 2 architecture (client vs server calculation)
❌ Performance targets are indicative only (not contractually binding)
```

---

## 2. ✅ T-159'un **beş vakasının beşi de** düştü

| # | vaka | nasıl çözüldü | tur |
|---|---|---|---|
| 1 | H5.4 ↔ CANDIDATE-002 | **CANDIDATE-002'nin Source'u = H5**; ertelenen uygulama, doğrulama Phase 1 | **25** |
| 2 | H1 ↔ CANDIDATE-007 | **CANDIDATE-007'nin Source'u = H1**; aynı yapı | **25** |
| 3 | `priority` yönü (§3.3 ↔ §3.4) | `§2.6`: *"lower = higher priority"* — iki-bir | 18 |
| 4 | auto-reject ↔ conditional routing | `§7.7`: ikisi **farklı kavram**, biri Phase 1 biri Phase 2 | 23 |
| 5 | baseline %80 ↔ %95 | `§11.3 R3`: **hedef + contingency** | 17 |

> **Beş "çelişki" iddiasının beşi de ölçümle düştü.** Hiçbiri gerçek bir çelişki değildi;
> her seferinde uzlaştıran bir belge vardı.

### 📌 Ve bu, T-159'un kendisi hakkında bir ders

T-159 *"§2.1 boşluğu: paket içi öncelik tanımsız"* diye **P1** açılmıştı. Sonuç:

> **Öncelik kuralı gerekmiyordu — çelişki iddialarının kendisi ölçülmemişti.**
>
> `§2.1.1`'in *"uzlaştıran üçüncü belgeyi ara"* kuralı **beş kez** işledi. Eksik olan bir
> hiyerarşi değil, bir **arama disiplini**ydi.

⚠️ Yine de §2.1'e küçük bir ekleme yararlı: **`03_Candidate_Log` türetilmiş bir belgedir;
her adayı kaynağını `Source:` alanında gösterir.** Bu, gelecekteki "çelişki" iddialarını
en başta keser.

---

## 3. ✅ `04_Reviews`'in statüsü **cevaplandı**

Paket indeksi:

```
### FOR IMMEDIATE USE:
  1. Main BRD          — ✅ LOCKED, "no changes without formal change request"
  2. BRD Addendum      — 🔴 MANDATORY, "must be addressed before implementation"
  3. Candidate Log     — ✅ ACTIVE, "updated weekly during Phase 1"

### FOR REFERENCE:
  4. Opus Review       — mimari değerlendirme
  5. Version History   — "deprecated drafts (archive only)"
```

> **`04_Reviews` = FOR REFERENCE.** Normatif **değil**, ama arşiv de değil — bir
> **değerlendirme belgesi**.

**[[T-161]]'in ön koşulu kalktı**, ve [[T-163]]'ün son kaynak adayı **okunabilir** —
gerekçe belgesi olarak, sözleşme olarak değil.

---

## 4. 🔴 Yeni ve önemli: **Phase 1 kapsamının ÖNÜNDEYİZ**

`CANDIDATE-002`: *"**No formula execution in Phase 1** (Actuals-First has no KPI engine)"*

**Ölçüm:** `main.kpis` → **27 KPI, 16'sı `expression`** — ve `formula-parser` çalışıyor.

Ve turu 19'un bulgusu: `tenant_features.planning_mode_enabled` BRD'de Phase 1'de **`false`**;
bizde ne tablo var ne bayrak, ve `modes/planning-first/` **çalışıyor**.

> **İki bağımsız sinyal aynı şeyi söylüyor: ürün, BRD'nin Phase 1 kapsamının ÖNÜNDE.**
>
> Bu, oturumun birçok bulgusunu **yeniden çerçeveliyor**: *"eksik"* dediğimiz bazı şeyler
> (politika tabloları, RLS, yetenek izinleri) **Phase 1 maddeleridir ve atlanmıştır** —
> Phase 2 özellikleri (KPI motoru, planning-first) inşa edilirken.

⚠️ **Bu bir kusur iddiası DEĞİL** — erken inşa bilinçli bir ürün kararı olabilir. Ama
**hiçbir yerde yazılı değil**, ve `§10.1` faz tanımları **okunmadı**. → [[T-169]]

---

## 5. 📌 İki somut madde

**(a) Yürütme zaman aşımı yok.** `CANDIDATE-002` *"Execution timeout (**1 second**)"* istiyor.
`kpi-engine` içinde tek `setTimeout` **önbellek tahliyesi** (60 sn). → [[T-160]]

**(b) `Math.*` beyaz listesi CANDIDATE-002'de de var:** *"Whitelist allowed functions
(**Math.***, arithmetic operators)"* — H5.1 ile aynı. T-160'ın *"sekiz fonksiyon
yazılamıyor"* bulgusu **ikinci kaynakla** doğrulandı; ama turu 13'ün ölçümü de duruyor
(**BRD'nin 34 formülünde hiç `Math.` yok**), yani bugün pratik engel değil.

**(c) `CANDIDATE-007`: *"Performance targets are indicative only (not contractually
binding)"*** → [[T-157]]'nin Phase 2 kapısı eleştirisi **yumuşuyor**: hedefler bağlayıcı
değil.

---

## 6. Sonraki tur

1. **`04_Reviews`** (5.249) — statüsü artık belli; [[T-163]]'ün son kaynak adayı
2. `§10.1` faz tanımları — [[T-169]]'un ön koşulu
3. `§7.1` Role Model — [[T-165]]
