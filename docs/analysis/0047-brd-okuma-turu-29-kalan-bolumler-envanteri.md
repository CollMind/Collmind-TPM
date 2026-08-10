# 0047 — BRD okuma turu **29**: kalan bölümlerin envanteri (SAYIM)

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur, **sayım turu**. Okuma değil, karar için envanter.
- **Ölçüm ortamı:** meta `e93b218`
- ⚠️ **Terim varlığı bir SAYIMDIR, içerik iddiası değil.** Tüm taramalar kelime sınırlı
  (`grep -owci`).

---

## 1. ⛔ `04_Reviews` — özel soru **kesin cevap aldı**

Ürün sahibinin sorusu: *"İçinde H1-H5'i doğuran tartışma var mı? Üç ADR'nin gerekçesi orada
olabilir."*

**Ölçüm** (`BRD_Consolidated_For_Opus_Review.md`, 5.249 satır):

```
H1 = 0 · H2 = 0 · H3 = 0 · H4 = 0 · H5 = 0
pessimistic = 0 · "race condition" = 0 · sandbox = 0 · topological = 0
```

**Ve içeriği:**

```
# 1. EXECUTIVE SUMMARY        # 3. CORE/SHARED COMPONENTS
# 5. PLANNING-FIRST MODE      # 6. DATA & INTEGRATION MODEL
# 10. PHASED DELIVERY         # 11. ASSUMPTIONS, DEPENDENCIES & RISKS
```

Ve yanındaki `Opus_Review_Prompt.md` (122 satır):

> *"You are about to **receive** a consolidated BRD … **6 critical sections** from a complete
> 155-page specification. **Your task is to identify risks** …"*

> ### `04_Reviews` bir review **ÇIKTISI değil, GİRDİSİDİR.**
> Dosya adı da söylüyor: *"Consolidated **For** Opus Review"*. İçinde altı Main BRD
> bölümünün **kopyası** var; **review'ın kendisi pakette YOK.**

**Sonuç:** H1-H5'i doğuran tartışma **burada değil** — ve pakette hiçbir yerde olmayabilir.
Üç ADR'nin *"habersiz yakınsama"*sının sebebi **açıklanamadı** ve bu kaynakta
**açıklanamaz**.

⚠️ **Ama bir değeri var ve kullanıldı:** [[T-163]] için **bağımsız dördüncü tanık** oldu
(aynı `GP_ROI_PCT` formülü). Yani *"ikinci nüsha"* olarak doğrulama değeri taşıyor,
yeni içerik değeri **taşımıyor**.

→ ⚪ **gerekçeyle atla.** [[T-161]] bu gerekçeyle kapatılabilir.

---

## 2. Envanter tablosu

| bölüm / parça | satır | kova | gerekçe |
|---|---|---|---|
| **`03_Candidate_Log`** — CANDIDATE-001/003/004/005/006 | ~500 | 🔴 | **Beşi de açık task'la kesişiyor**: 003 budget concurrency ([[T-154]]) · 004 approval state machine ([[T-153]], [[T-158]]) · 005 baseline readiness ([[T-024]]) · 006 KPI recalc ([[T-157]]) · 001 KPI engine. **Yalnız 002 ve 007'nin gövdesi okundu** |
| **`Section_03` §3.3 kalanı** (606–781) | ~175 | 🔴 | *"Phase 1 Constraints"* — [[T-150]]'nin **açık ön koşulu** (Committed/Reserved ayrımı Phase 1'de kapatılmış olabilir) |
| **`Section_07` §7.1** Role Model | ~154 | 🔴 | [[T-165]]: beş rol ↔ altı rol eşlemesi · `region ↔ category` (**üçüncü kez** ölçülmedi) |
| **`Section_09`** NFR | 481 | 🟡 | `tenant=11` · `audit=16` · **`retention=8`** · `500ms=4` · `isolation=2`. `§7.7` audit retention'ı Phase 2'ye ertelemişti — burada 8 geçiş var. **§9.1 + §9.4 kısa sondaj** |
| **`Section_03` §3.1/§3.2** | ~300 | 🟡 | §3.1 Organizational Dimensions → `region ↔ category` sorusu · §3.2 RBAC → [[T-165]] |
| **`Section_05` §5.4** What-If | ~155 | 🟡 | [[T-169]]'un **en büyük eksiği** (0 dosya). Ne tarif edildiği bilinmeli |
| **`Section_06` §6.3/§6.5** | ~150 | 🟡 | §6.3 Granularity → `0002`'nin CPL×Kategori×Kanal kararı · §6.5 Data Ownership |
| **`Section_11` §11.2 + P2/P3** | ~230 | 🟡 | Dependencies + kalan riskler; `§11.3` P1'i okundu |
| **`Section_10` §10.3** riskler | ~62 | 🟡 | `§11.3` ile örtüşüyor olabilir — **kısa** |
| **`02_Addendum` H5.2/5.3** | ~150 | 🟡 | Kaydetmede doğrulama + formül audit'i ([[T-160]], [[T-168]]) |
| **`Section_08`** Reporting | 733 | ⚪ | `report=31`, **diğer tüm task terimleri 0** (`tenant`/`isolation`/`500ms`/`retention`/`immutab` = 0). Rapor tanımları; hiçbir açık işle kesişmiyor |
| **`Section_01`** Executive Summary | 420 | ⚪ | `capability=15` ama **örneklendi: iş anlamında** (*"platform capabilities"*), CBAC değil. Vizyon/değer belgesi |
| **`Section_07` §7.6** Session | ~50 | ⚪ | Oturum yönetimi; açık task yok (`0040 §5`'te kayda geçti) |
| **`Section_10`** Phase 1.1/3/4 · §10.5 · §10.6 | ~185 | ⚪ | Gelecek fazlar + kaynak planlama; [[T-169]] Phase 1/2 ile cevaplandı |
| **`Section_05`** §5.2 · §5.5 kalanı · §5.6 | ~1.300 | ⚪ | Grid mimarisi · senaryolar. Kararlar `§5.1/5.3/5.5-commit/5.7`'den alındı |
| **`Section_11`** §11.4/5/6 | ~95 | ⚪ | Change management · risk matrisi · CSF |
| **`04_Reviews`** | 5.371 | ⚪ | **§1** — review girdisi, içerik kopyası |

---

## 3. Tur tahmini

| kova | parça | toplam satır | tahmini tur |
|---|---|---|---|
| 🔴 | 3 | ~830 | **2 tur** |
| 🟡 | 7 | ~1.000 | **3 tur** |
| ⚪ | 6 | **~8.150** | **0** |

> **Kalan iş: ~5 tur.** Ve atlananlar toplamın **%82'si** — çünkü en büyük iki dosya
> (`04_Reviews` 5.371, `Section_08` 733) hiçbir açık işle kesişmiyor.

---

## 4. ⚠️ Sayımın sınırı — bir örnekle gösterildi

`Section_01`'de `capability = 15` çıktı. **İçerik iddiası kurmadan önce örneklendi:**

> *"CollMind TPM Platform is a next-generation … solution designed to address the diverse
> operational needs …"* · *"The platform **recognizes** that trade promotion management
> maturity is not binary"*

**İş anlamında *"yetenek"*, CBAC'ın `capability`'si değil.** Aynı kelime, farklı kavram.

> **Terim sayımı bir varlık ölçümüdür.** `Section_01`'i yalnız sayıya bakarak 🔴 yapmak
> yanlış olurdu — ve bu, oturumda üç kez ısırdığımız sınıfın (alt-string gürültüsü) sayım
> turundaki hâli.

---

## 5. [[T-143]]'ün bitiş ölçütü

> *"Her bölüm okundu ya da gerekçeyle atlandı."*

**Bu turla karşılandı:** her parça bir kovaya konuldu ve **atlananların gerekçesi yazıldı**.
Kalan 🔴/🟡 iş listelendi ve tahmin edildi.

**Beş bitiş ölçütünden dördü tamam:** [[T-159]] ✅ · [[T-163]] ✅ · RECOGNITION_SPEC kaynak
ölçümü ✅ · bölüm envanteri ✅. **Kalan: TTM ölçümü** (`0014 §7`'de de eksik bırakılmıştı).

---

## 6. Sonraki tur

**🔴 sırası:**
1. `03_Candidate_Log`'un beş adayı — **beşi de açık task'la kesişiyor**, tek turda
2. `§3.3` kalanı (Phase 1 Constraints) + `§7.1` Role Model
