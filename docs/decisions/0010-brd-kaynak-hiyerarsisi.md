# ADR 0010 — BRD kaynak hiyerarşisi: paket bağlayıcı, PDF süperseded

- **Tarih:** 2026-08-10
- **Statü:** **Kabul edildi**
- **Karar veren:** ürün sahibi (Sertaç Tuzcu)
- **Kanıt:** `docs/analysis/0018-brd-kaynak-catismasi-olcumu.md` ([[T-142]])
- **İlgili:** CLAUDE.md §2.1 / §2.1.1 / §2.2 · `SYSTEM_INVARIANTS §9` D-06/D-07 ·
  `docs/analysis/0002` · ADR 0007 A4

---

## Soru

Repoda **iki BRD** vardı, ikisi de kendini `v1.0` diye tanıtıyor, kapsamları farklı — ve
hiçbiri diğerinden söz etmiyor. Hangisi bağlayıcı?

Altı aydır ikisi bir arada duruyordu; kaynak hiyerarşisi (CLAUDE.md §2.1) yalnız birini
tanıyordu ve o, ürünün **yarısını kapsamayan** olandı.

---

## Karar

> **`docs/brd/` (eski `collmind.backend/.cursordocs/`) bağlayıcı kaynaktır.**
> **`.cursor/CollMind_TPM_BRD_v1.0.pdf` süperseded'dir — arşiv, normatif değil.**

Ve: **ikisi birlikte bağlayıcı değildir.** Paket planning-first'ü de kapsıyor (`Section_05`),
yani PDF'in katkısı yok — yalnız **daha az söylüyor**. İkisini birlikte tutmak `rules.md`
vakasının tekrarı olurdu: iki kaynak, biri eksik, hangisinin kazandığı belirsiz.

### Gerekçe — ölçüm (`0018 §Ö-A`)

| | PDF | Paket |
|---|---|---|
| Tarih (belgenin kendi künyesi) | **2025-11-04** | **2026-01-07** |
| Kendini nasıl adlandırıyor | **"Initial BRD"** | **"Final · LOCKED & PRODUCTION-READY"** |
| Mod kavramı | **yok** (`actuals-first`/`planning-first` hiç geçmiyor) | Section_04 + Section_05 |
| Hacim | 62 sayfa | ~200 sayfa |

**Belirleyici olan `"Initial BRD"` ibaresidir:** belge kendini bir **başlangıç noktası**
olarak adlandırıyor. İki ay sonra gelen, üç kat hacimli, ürünün iki modunu birden kapsayan
bir paket varken bu ibare tek başına yeterlidir.

### Bilinen kayıt boşluğu — ve neden kararı değiştirmiyor

Paketin indeksi `05_ARCHIVE/ [DEPRECATED]` diye bir klasör sayıyor; **o klasör repoda yok**.
Yani PDF'in "arşivlenmiş taslak" olduğu paketin **kendi beyanıyla** doğrulanamıyor.

**Bu bir kayıt boşluğudur, kanıt karşıtı değildir** — tarih, kapsam ve belgenin kendi
"Initial" ibaresi bağımsız olarak aynı yöne işaret ediyor.

---

## Sonuçlar

### 1. Paket meta'ya taşındı

`collmind.backend/.cursordocs/` → **`docs/brd/`**. Gerekçe CLAUDE.md §"Doküman yeri":
*kodun okuduğu artefaktlar submodule'de, ölçüm/karar/sözleşme dokümanları meta'da.* Bir BRD
kod tarafından okunmaz; ve ona atıf veren her şey (ADR'ler, `SYSTEM_INVARIANTS`, analiz
dokümanları) zaten meta'da.

Taşıma **birebir**: 23 dosya, her biri `cmp` ile bayt-bayt doğrulandı.

⚠️ **Bir istisna bilinçli olarak taşındı:** `04_Reviews/Opus_Review_Prompt.md` bir **prompt
şablonu**dur ve §"Doküman yeri" prompt şablonlarını geriye dönük taşımıyor. Paketin kendi
indeksi ona atıf verdiği için **paket bütünlüğü** korundu; ayrıştırmak indeksin göreli
bağlantılarını kırardı.

### 2. PDF silinmedi

`.cursor/` altında kalıyor. Silmek, "neden bu karar verilmişti" sorusunun cevabını yok
ederdi — ADR 0007'nin v3 metnini silmemekle aynı gerekçe. **Ama normatif değildir**, ve
CLAUDE.md §2.1 bunu yazar.

### 3. ⛔ RECOGNITION_SPEC bu kararla **açılmıyor**

`recognition` kelimesi **tüm pakette sıfır** kez geçiyor. D-07 — gerçekleşen bir indirimin
taktikler arasında paylaştırılması — **hiçbir BRD'de** tanımlı değil: ne PDF'te, ne pakette,
ne Addendum'da.

> **Kaynak değişikliği bir boşluğu kapatmadı — boşluğun gerçekten boşluk olduğunu
> kanıtladı.**

Ve bu bir kazanımdır: `INV-R-007`'nin `min(actual, expected)` kuralı tasarlanırken
*"Addendum V2'nin iki sürümü çelişiyor"* denmişti. Şimdi biliniyor ki o çelişki dışında
**hiçbir normatif kaynak yok**. Yani kural bir **yorum** değil, **yeni bir ürün kararı**
olacak — ve §2.4 uyarınca ürün sahibinin.

### 4. D-06'nın atfı düzeltilir

`SYSTEM_INVARIANTS §9` D-06 satırı *"Addendum V2 §5.2"*ye atıf veriyor. Üç yerde arandı,
**bulunamadı**; mevcut Addendum "Technical Clarifications"tır ve içinde `settlement`
**sıfır** kez geçiyor.

Yani bir invariant **var olmayan bir belgeye** dayanıyordu — K14 ailesinin bir üyesi daha
(*"ADR olmayan bir korumayı var gibi anlatıyor"*).

Yerine `Section_04`'ün iki somut, **mekanik başı** tabanı konur:

```
Off-Invoice Rebate:  250 units × 15 TL     ← hacim × birim tutar
Turnover Rebate:     125,000 × 5%          ← oran × tutar
```

Üç frozen tip yok; D-06 bunun üzerine **yeniden kurulur**.

### 5. `0002` ve A4'ün gerekçeleri yenilenir

- **`0002`** (*"actuals = tutar agregası, hacim yok"*): karar **doğrulandı** ve gerekçesi
  **güçlendi** — BRD'nin ekonomisi hacimli, **girdisi** hacimsiz; per-unit aritmetiği
  müşteri tarafında yapılıyor, sisteme fatura tutarı giriyor. Modun var olma gerekçesi de
  bunu söylüyor: *"Volume forecasting is impractical or unreliable."*
- **ADR 0007 A4** (`agreements.mechanic_value` dondurulur): karar **geçerli**, gerekçe
  **değişiyor**. Eskisi veri boşluğuna dayanıyordu (*"3/3 NULL, tamamlanmamış yol"*); BRD onu
  tasarım gereği polimorfik tanımlıyor (`-- e.g., 15.00 (TL per unit) or 10.5 (%)`).
  **"Kullanılmıyor" ile "spec'i var, henüz yazılmadı" farklı şeylerdir** — ve bu fark, bir gün
  *"neden dondurulmuştu"* diye sorana cevap verecek.

---

## Bu kararın KAPATMADIĞI

| | |
|---|---|
| `Section_04`'ün içeriği | 2038 satır, **henüz okunmadı**. Bu tur yalnız üç soruyu ölçtü |
| Diğer on bir bölüm | **hiç açılmadı** (~17.800 satır) |
| Paket ↔ kod uyuşması | ayrı ve büyük bir iş; ilk iki sinyal `mechanic_value` ve import şablonu |
| "Addendum V2 §5.2"nin nerede olduğu | bulunamadı; var olmayabilir |
| D-07 | **hiçbir kaynakta yok** — ürün kararı gerekiyor |
