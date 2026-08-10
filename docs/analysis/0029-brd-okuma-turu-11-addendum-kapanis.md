# 0029 — BRD okuma turu **11**: Addendum kapanışı — Sprint 0 · Phase 2 Gate · Escalation

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/02_Addendum/BRD_Addendum_Technical_Clarifications.md` (1017–1153)
- **Ölçüm ortamı:** meta `96923f2` · backend `99ee9e6`

---

## 0. Okundu / okunmadı

✅ Sprint 0 Checklist · Phase 2 Gate Criteria (Revised) · Escalation Policy · Sign-off ·
References (1017–1153, tamamı)

⛔ **H5 Action 5.2 / 5.3** (810–959, ~150 satır) — *"validation on save"* ve *"audit logging
for formula changes"*. **Addendum'un tek okunmayan yeri.**

**Addendum: ~900 / 1153 (%78).**

---

## 1. 🔴 Sprint 0 Checklist, **altı aylık körlüğün mekanizmasını satır satır yazmış**

Checklist'in *"Documentation"* bloğu:

```
Documentation:
  ✅ This addendum added to Engineering Pack
  ✅ Cursor rules updated with addendum reference     ← ⚠️
  ✅ Confluence page created with sprint 0 decisions
```

**Ölçüm:** `.cursor/rules.md`'de `addendum` · `cursordocs` · `Section_0` → **hiçbiri yok**
([[T-142]]'de tüm paket için ölçülmüştü: `grep -rn "cursordocs" CLAUDE.md docs/ .claude/`
→ **boş**).

> **BRD, kendi görünmez kalma riskini öngörmüş ve karşı önlemi bir Sprint 0 maddesi olarak
> yazmış. O madde uygulanmamış — ve tam olarak öngörülen sonuç oldu.**

Bu, [[ADR 0010]]'un hikâyesinin **kaynak tarafındaki** hâli: paket altı aydır repodaydı,
`rules.md` ondan hiç söz etmiyordu, ve `rules.md` bizim tek giriş noktamızdı.

⚠️ Ve düzeltme **zaten yapıldı** — ADR 0010 + CLAUDE.md §2.1/§2.1.1 bu maddeyi geriye dönük
karşılıyor. Ama **kaydedilmeli**: bu bir tesadüf değil, atlanmış bir kontrol maddesiydi.

### Infrastructure bloğu

```
✅ Database provisioned (PostgreSQL 14+)     → var (16)
✅ Development environment setup             → var
✅ CI/CD pipeline configured                 → ❌ YOK  ([[T-157]])
✅ Monitoring/logging tools installed        → ölçülmedi
```

`CI/CD` üçüncü kez aynı yere çıkıyor: `SYSTEM_INVARIANTS §10` (iki guard `CI` diye
etiketlenemedi), H1 Action 1.3 (Phase 2 kapısı), ve şimdi **Sprint 0'ın ön koşulu**.

---

## 2. Phase 2 Gate Criteria (Revised) — açık task'larla birebir eşleşiyor

Konsolide kapı, beş H + Phase 1 tamamlanma. **Her satırın bizdeki karşılığı:**

| Kapı satırı | bizde | task |
|---|---|---|
| H1 prototip <500ms (100 SKU) · yük testi · **CI/CD regresyon** · fallback | ❌ hiçbiri | [[T-157]] |
| H2 eşzamanlı kullanıcı testi · izolasyon doğrulaması · retry testi | ❌ (karar ✅, kanıt yok) | [[T-154]] |
| H3 state machine · budget side effects · **expiration job (7 gün)** | kısmi; `EXPIRED` yok | [[T-158]] |
| H4 **MVB-2 (%80)** · import · degraded-mode testi | ❌ | [[T-024]] |
| H5 sandbox · kaydetmede doğrulama · **audit logging** · güvenlik incelemesi | sandbox ✅ (farklı şekil); audit **ölçülmedi** | [[T-160]] |
| **50+ agreement üretimde** · **%99 uptime** | ⛔ **üretim ortamı yok** | — |

> Son satır yapısal: CLAUDE.md §1 zaten kaydediyor — *"CTPM bugün yalnızca lokal geliştirme
> ortamında koşuyor. Deploy edilmiş staging/production **yok**."*
> **Phase 2 kapısının iki ölçütü, ölçülecek ortam olmadığı için ölçülemez.**

Bu, [[T-157]]'nin *"yapısal olarak imkânsız ölçüt"* bulgusunun **ikinci ve üçüncü** üyesi.

---

## 3. 📌 Escalation Policy — her H'nin bir **geri çekilme yolu** var

| Item | Alternatif (BRD'nin kendi yazdığı) |
|---|---|
| H1 Performans | *"Reduce Phase 2 scope (**manual ROI calc**)"* |
| H2 Eşzamanlılık | *"**Single-user approval mode** (workaround)"* |
| H3 State machine | *"Simplify workflow (**remove multi-level approval**)"* |
| H4 Baseline | *"Launch with **MVB-1** (50% coverage)"* |
| H5 Güvenlik | *"**Disable custom formulas (hardcoded KPIs only)**"* |

⚠️ **Sonuncusu [[T-160]] ve [[T-156]] için önemli bir nüans:**

BRD, güvenlik çözülemezse **hardcoded KPI'lara dönmeyi** meşru bir kaçış yolu sayıyor. Yani
*"KPI = admin tanımlı dinamik formül"* ilkesi **koşulsuz değil** — güvenlik onun önünde.

**Ama bu bir varsayılan değil, bir escalation.** T-156'nın (konfigürasyon katmanı yazılmamış)
çerçevesi geçerli kalıyor: BRD'nin izin verdiği şey *"güvenlik gerekçesiyle, CISO+CTO
onayıyla geri çekilmek"*, *"hiç yazmamak"* değil.

Ve H3'ün alternatifi (*"remove multi-level approval"*) ile [[T-153]] kesişiyor: çok seviyeli
onayı **basitleştirmek** meşru; **politika tablosunu hiç yazmamak** ondan farklı.

---

## 4. 📌 Sign-off — beş imza satırı, repodaki kopyada **boş**

> *"This addendum is mandatory. **Implementation cannot begin without sign-off.**"*
> Product Owner · Engineering Lead · CTO/VP Eng · **CFO** (bütçe bütünlüğü) · **CISO** (güvenlik)

Repodaki kopyada beş satır da imzasız.

⚠️ **Bunu bir bulgu olarak yazmıyorum:** repodaki kopya bir şablon olabilir ve imzalar başka
yerde (Confluence, PDF) bulunabilir. **Ölçülemez.** Kayda geçiyor çünkü belgenin kendi
statüsü buna bağlı — ve `03_Candidate_Log`'un yönetişim notu (*"explicit Product sign-off"*)
ile aynı aileden.

---

## 5. 🆕 References — paketin **en büyük okunmamış dosyası** işaret ediliyor

> *"**Architectural Review:** CollMind_BRD_Review_md.pdf (**Opus senior engineering
> assessment**)"*

Bu, `docs/brd/04_Reviews/BRD_Consolidated_For_Opus_Review.md` — **5.249 satır**, paketin en
büyük tek dosyası ve **hiç açılmadı**.

Bir *"senior engineering assessment"*, Addendum'un H1-H5'ini **doğuran** belge olabilir. Ve
`0025 §1.3`'te not ettiğimiz *"habersiz yakınsama"*ların bir kısmının **kaynağı** orada
olabilir — yani bizim bağımsız vardığımız kararlar orada da tartışılmış olabilir.

→ [[T-161]]

---

## 6. Addendum kapanış skoru

| | |
|---|---|
| Okunan | **%78** (900/1153) |
| Okunmayan | H5 5.2/5.3 (~150 satır) + başlık blokları |
| Beş MANDATORY madde | **dördü tam okundu**, H5'in yarısı |
| Dayanak denetimi | **3 yakınsama** (H2/H1/H3) + **1 blokaj kaldırma** (H4) |
| Yeni task | [[T-154]] · [[T-157]] · [[T-158]] · [[T-159]] · [[T-160]] · [[T-161]] |

**Addendum'un en büyük getirisi ölçülebilir:** bir P1'in blokajı kalktı ([[T-024]]), üç ADR
kaynakla doğrulandı, ve altı aylık körlüğün **mekanizması** belgelendi (§1).

---

## 7. Sonraki tur

1. **`Section_05_Planning_First_Mode`** (2013) — en büyük okunmamış ana bölüm; **mod ayrımının
   üçüncü ölçümü** ve KPI motoru orada
2. H5 5.2/5.3 (~150) — Addendum'u bitirir
3. `04_Reviews` (5249) — [[T-161]]
4. `Section_02` (1026) · `Section_10/11`
