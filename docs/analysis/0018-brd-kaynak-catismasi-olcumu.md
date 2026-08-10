# 0018 — İki BRD, aynı sürüm numarası, farklı kapsam: üç ölçüm

- **Tarih:** 2026-08-10
- **Task:** [[T-142]] — salt-okunur. Kod / migration / entity / doküman-taşıma **yok**.
- **Mod:** ölçüm. **Karar ürün sahibinin** — bu doküman karar vermez.
- **Tetikleyen:** RECOGNITION_SPEC turu. BRD'nin recognition bölümüne bakılmak istendi;
  `.cursor/` altındaki BRD'de öyle bir bölüm **olmadığı** görüldü, ve arama genişletilince
  ikinci bir BRD paketi bulundu.
- **Ölçüm ortamı:** meta `5dcb8ae` · backend `d7b6b76` · `poppler 26.08.0`
  (`pdftotext -layout`) · çalışma ağacı temiz

---

## 0. Bulgunun kendisi

```
.cursor/                                    (meta repo)
  CollMind_TPM_BRD_v1.0.pdf                 62 sayfa

collmind.backend/.cursordocs/               (backend submodule) — 23 dosya, git'te izleniyor
  01_Main_BRD/  Section_01 … Section_12      ~155 sayfa
    Section_04_Actuals_First_Mode.md         2038 satır, "Full Specification"
    Section_05_Planning_First_Mode.md
  02_Addendum/  BRD_Addendum_Technical_Clarifications.md   1153 satır
  03_Candidate_Log/  BRD_2.0_Candidate_Log.md
  04_Reviews/
```

İkisi de kendini **"v1.0"** diye tanıtıyor. Kapsamları farklı.

`grep -rn "cursordocs" CLAUDE.md docs/ .claude/` → **BOŞ.** Yani ikinci paket
CLAUDE.md §2.1'in kaynak hiyerarşisinde, dokuz ADR'de, `SYSTEM_INVARIANTS`'ta ve on yedi
analiz dokümanında **hiç geçmiyor.**

Paket `e9308da` ile **2026-02-08**'de commit edilmiş — altı aydır git'te.

---

## Ö-A — İki BRD'nin ilişkisi

### Ölçüm

| | `.cursor/CollMind_TPM_BRD_v1.0.pdf` | `collmind.backend/.cursordocs/` |
|---|---|---|
| Belgenin **kendi künyesi** | *"Version 1.0 · **2025-11-04** · Product Team · **Initial BRD**"* | *"BRD v1.0 **Final** · **January 7, 2026** · ✅ **LOCKED & PRODUCTION-READY**"* |
| PDF üretim tarihi (`pdfinfo`) | 2025-11-08, Creator: Chromium | — |
| Hacim | **62 sayfa** | ~155 (ana) + 30 (addendum) + 17 (candidate log) |
| Mod kavramı | **YOK** — `actuals-first` ve `planning-first` kelimeleri **hiç geçmiyor** | **VAR** — Section_04 + Section_05, iki ayrı mod |
| Kapsam bölümü | Promotion Planning · Approval · Budget · Reporting · Admin | 12 bölüm, iki mod |
| `claim` / `settlement` / `accrual` | **0 / 0 / 0** | 2 / 21 / 3 (yalnız Section_04'te) |

### Sonuç

**PDF, paketten iki ay ÖNCE tarihli ve kendini *"Initial BRD"* diye adlandırıyor.** Paket
*"Final"* ve *"LOCKED"* diyor. PDF'te ürünün iki modlu olduğuna dair **tek kelime yok**.

Yani ikisi **aynı belgenin iki fidelity'si değil**: PDF daha erken bir taslak, paket sonraki
ve kapsamı geniş sürüm.

⚠️ **Ve bu ölçümün sınırı:** paketin indeksi `05_ARCHIVE/ [DEPRECATED]` diye bir klasör ve
*"Version History — Deprecated drafts (archive only)"* diye bir madde sayıyor. **O klasör
repoda yok** (23 dosyanın hiçbiri arşiv değil). Yani PDF'in *"arşivlenmiş taslak"* olduğu
paketin kendi ifadesiyle **doğrulanamıyor** — çıkarım tarih + kapsam + belgenin kendi
"Initial BRD" ibaresinden geliyor.

⚠️ **`03_Candidate_Log` yanıltmasın:** o *"BRD **2.0** adayları"* listesidir — v1.0 kapsamı
**dışında** bırakılmış, Phase 1 doğrulamasına bağlı maddeler. Paketin süperseded olduğunun
değil, **ileriye dönük bir backlog**'un kanıtıdır.

---

## Ö-B — `Section_04` D-06 / D-07'yi cevaplıyor mu?

### D-06 (settlement base) — **kısmen, ve `SYSTEM_INVARIANTS`'ın tarifiyle UYUŞMUYOR**

`settlement base` · `settlement_base` · `list price` · `LIST_PRICE` araması Section_04 ve
Addendum'da → **sıfır eşleşme.** *"Üç tip, anlaşma başına donduruluyor"* diye bir yapı **yok**.

Onun yerine, **mekanik başına iki somut hesap tabanı** var (*"Settlement Calculation
Examples"*):

```
Örnek 1 — Off-Invoice Rebate
  Value: 15 TL per unit
  Total Month 1: 250 units × 15 TL = 3,750 TL        ← HACİM × BİRİM TUTAR

Örnek 2 — Turnover Rebate (LTA)
  Value: 5% of quarterly turnover
  Q1 Rebate: 125,000 × 5% = 6,250 TL                 ← ORAN × TUTAR
  Settlement: Single off-invoice invoice (April)
```

> ⛔ **`SYSTEM_INVARIANTS §9`'un D-06 satırı bu paketle uyuşmuyor.** Orada
> *"Addendum V2 §5.2 specifies three types frozen per agreement"* yazıyor. Bu paketteki
> Addendum *"Technical Clarifications"*tır (5 HIGH PRIORITY madde: KPI motoru performansı,
> bütçe rezervasyon yarışı, onay state machine…) ve `settlement` kelimesi içinde **hiç
> geçmiyor**.
>
> Yani D-06'nın atıf yaptığı belge **hâlâ bulunmuş değil** — ya repoda olmayan bir sürüm, ya
> da atfın kendisi yanlış. **Bu ölçüm onu çözmedi.**

### D-07 (recognition dağıtım kuralı) — **CEVAP YOK**

`allocat` · `apportio` · `pro-rata` · `prorate` · `distribut` · `attribut` araması: bulunan
her eşleşme **bütçe zarfı** tahsisi (`Available = Allocated − Reserved − Consumed`) ya da
düz metin. Gerçekleşen bir indirimin taktikler arasında **paylaştırılmasına** dair hiçbir
kural yok.

`recognition` kelimesi tüm pakette **sıfır** kez geçiyor.

> **D-07 bu paketten cevaplanamaz.** RECOGNITION_SPEC'in dayanağı burada **yok**.

---

## Ö-C — `0002`'nin kapsam kararı çelişiyor mu? **HAYIR — doğrulandı**

`0002` şunu demişti: *"CTPM'de actuals = CPL × Kategori × Kanal × Dönem TUTAR agregası.
FU/SKU ve hacim boyutu YOKTUR."*

Section_04'ün **off-invoice import şablonu**:

```
A: LTA_Code       B: Invoice_No     C: Invoice_Date
D: Amount         E: CPL_Code       F: Notes
```

**Altı kolon. Hacim yok, adet yok.**

Ve satır 1223 açıkça: `❌ Volume-weighted pricing`.

### ⚠️ Ama görünürdeki çelişkinin açıklaması önemli

Örnek 1 settlement'ı **adetten** hesaplıyor (`250 units × 15 TL`), oysa import **yalnız
tutarı** alıyor. Çelişki değil — **hesabın nerede yapıldığı** farkı:

> Per-unit aritmetiği **müşteri tarafında** yapılıyor; sisteme giren şey **fatura tutarı**.
> BRD'nin ekonomisi hacimli, **girdisi** hacimsiz.

Ve modun kendi gerekçesi bunu söylüyor (satır 20-22): *"Volume forecasting is impractical
or unreliable"* — Actuals-First'ün var olma sebebi zaten hacim tahmininin yapılamaması.

### D-16'ya etkisi

**`0013 §3.1`'in erteleme gerekçesi ayakta kalıyor:** recognition yolu **tutar-yalnız**.
`0016 §2.2`'nin *"`on_invoice_entries` hacim taşıyor"* bulgusu geçerli ama **BRD o kolonlara
bir settlement rolü vermiyor** — import şablonunda karşılıkları yok.

⚠️ Bu, D-16'yı kapatmıyor: `on_invoice_entries.quantity`'nin **neden var olduğu** ve nereden
dolduğu ayrı bir soru (bugün 0 satır — `0016 §7.5`).

---

## Yan bulgu — ADR 0007 **A4**'ün dayanağı zayıflıyor

Section_04'ün agreement şeması (satır 278):

```sql
mechanic_value NUMERIC(18,4),  -- e.g., 15.00 (TL per unit) or 10.5 (%)
```

ADR 0007 **A4** `agreements.mechanic_value`'yu **dondurmuştu**; gerekçe *"3/3 NULL, ayırıcısı
da NULL, tamamlanmamış bir yol"*du — yani **veri boşluğuna** dayanıyordu.

BRD onu **tasarım gereği polimorfik** bir alan olarak tanımlıyor (*"TL per unit **or** %"*) —
tam olarak Karar 4'ün `entered_value` için çözdüğü sınıf. A4'ün *"ölçek kontratına dahil
edilmez"* kararı, spec'e değil veriye bakılarak verilmişti.

**Bu ölçüm A4'ü geçersiz kılmıyor** — dondurma kararı hâlâ savunulabilir. Ama gerekçesi
yenilenmeli: *"kullanılmıyor"* ile *"spec'i var, henüz yazılmadı"* farklı şeyler.

---

## Ölçülemeyenler

| # | Ölçülemeyen | Neden |
|---|---|---|
| 1 | **PDF'in "arşivlenmiş taslak" olduğu** | Paketin saydığı `05_ARCHIVE/` klasörü repoda yok; çıkarım tarih + kapsam + "Initial BRD" ibaresinden |
| 2 | **D-06'nın atıf yaptığı "Addendum V2 §5.2"** | Repoda böyle bir belge bulunamadı; mevcut Addendum'da `settlement` **sıfır** kez geçiyor |
| 3 | `Section_04`'ün **içeriğinin tamamı** | Bu tur yalnız üç soruyu ölçtü; 2038 satırın tamamı okunmadı. Diğer on bir bölüm **hiç açılmadı** |
| 4 | Paket ile bugünkü kodun **uyuşması** | Ayrı ve büyük bir iş — ilk sinyal: `mechanic_value` (yan bulgu) ve import şablonu |

---

## Karara sunulan

**Soru:** `collmind.backend/.cursordocs/` bağlayıcı bir kaynak mı, süperseded bir taslak mı?

Ölçüm **bağlayıcı olduğuna işaret ediyor** (daha yeni, "Final/LOCKED", ürünün iki modunu da
kapsıyor, PDF kendini "Initial" diye adlandırıyor) — ama bu bir **çıkarımdır**, paketin kendi
arşiv beyanı doğrulanamadı (Ölçülemeyen #1).

**Her iki cevapta da kayda geçmesi gerekenler:**

| Cevap | Gereken |
|---|---|
| **Bağlayıcı** | CLAUDE.md §2.1'in kaynak tablosu düzeltilir; paket meta'ya taşınır mı diye karar verilir (§"Doküman yeri": kodun okumadığı doküman meta'da yaşar); `SYSTEM_INVARIANTS` D-06 atfı düzeltilir; `0002`'nin ve A4'ün gerekçeleri spec'e karşı yenilenir |
| **Süperseded** | CLAUDE.md'ye **açıkça yazılır** — yoksa bir sonraki ajan onu bulup bağlayıcı sanar. Ve o zaman actuals-first'ün normatif kaynağının **ne olduğu** sorusu açık kalır |

⚠️ **Üçüncü bir ihtimal ölçümle dışlanmadı:** ikisi de bağlayıcı olabilir — PDF planning-first
için, paket ürünün tamamı için. Bu durumda çakışan bölümlerde hangisinin kazandığı
yazılmalıdır.
