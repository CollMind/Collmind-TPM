# `BL-4` — YÜZEY (kapı rotası + teşhis ekranı)

> **Yazıldı:** 2026-09-03, **push'lu `HEAD`'den** (`53984c5` / `83ea7cd`) — *yarım-devir
> yasası: brief çalışma ağacını değil **push'lu `HEAD`'i** okur.*
> **Girdiler:** `Z79 §4` · `Z85 §3` · `Z86` · `Z87` + `§F12` · `Z88`
> **Kapandığında:** baseline hattı **uçtan uca canlı** —
> `yükle → kabul/red → coverage → planlama kapısı`. **İlk gerçek dosya o gün.**

---

## `§0` · HAT

```
ön iş  ✅ T-333 TZ ölçümü                                    676ff7f
BL-1   ✅ ŞEMA (baseline_volumes + batches)                  d6c83e7 · Z84 + Z85
BL-2   ✅ GİRİŞ (upload + parser + iki pin + BASELINE_WRITE)  3c6d23b · Z86
BL-3   ✅ DOĞRULAMA (import_batch_rows + kapı + tek sözlük)   eeda8b3 · 53984c5 · Z87/Z88
BL-4   ⬅ YÜZEY                                               BU BELGE
```

**`BL-3`'ün bıraktığı iki açık — bu adımın işi:**
```
1  coverage servisi CONTROLLER'A BAĞLI DEĞİL   (kova kararı bekliyordu — ARTIK VAR, §2)
2  sourceMatchRatio SORGUSU yazılı, SERVİSE bağlı değil
```

---

## `§1` · ⭐ İLK MADDE **ÖLÇÜLDÜ VE KAPANDI** — `PLANNER` OKUYABİLİYOR

Kova hükmü bir **şart** taşıyordu: *"`PLANNER` bu yeteneği taşıyor mu — **ÖLÇ**."*
Team Lead ölçtü (2026-09-03):
```
PLANNER    MASTER_DATA_READ: true   | BASELINE_WRITE: false
FINANCE    MASTER_DATA_READ: true   | BASELINE_WRITE: true
ADMIN      MASTER_DATA_READ: true   | BASELINE_WRITE: true
```
⇒ **`Z86` refleksi TETİKLENMEDİ.** `MASTER_DATA_READ` yeterli; **yeni hücre GEREKMİYOR**,
`BASELINE_READ` **açılmaz**.
📌 `D2`'nin planner anlamı (*"baseline hazır mı, planlayabilir miyim"*) **bugün karşılanıyor**.

⛔ **Ve bu bir ÖLÇÜM, bir varsayım değil** — `[ÖLÇÜLDÜ]` damgası hükmün parçası
(`Z87 §F12a`).

---

## `§2` · KOVA KARARI — **`C`** (ürün sahibi, 2026-09-03)

```
coverage kapısı (GET) + teşhis raporu (GET batch/rows)
  →  AYNI KOVA: BL-2'nin ÜÇÜYLE BİRLİKTE — TENANT-GENEL, KAPSAM EKSENİ YOK (C)
```

**TAŞIYICI:**
> **Coverage TENANT-GENEL bir ölçümdür** (katalog × CPL × dönem, **tüm tenant**).
> *"FINANCE kendi kapsamının coverage'ını görür"* diye bir şey **yok** — kapı, **tenant'ın**
> planlamaya hazır olup olmadığını söyler, **kişinin** değil.
> **Veri-ekseni (CPL) ≠ erişim-ekseni** (`Z85` ayrımı) — **ikinci uygulaması**.

**DESTEKLEYİCİ:** teşhis **yükleyenin yüzeyidir**; `BL-2` rotalarıyla **aynı kovada
olmazsa** *"yükledi, coverage'ını göremiyor"* doğar.

⛔ Rotalar açıldıktan sonra `scope-c.txt`'ye **gerekçesiyle** eklenir; `scope-ratchet`
`exit 2` (**SETUP HATASI / ölçüm yapılmadı**) verirse **karar zaten burada** — sınıflandır,
`T-266`'ya takılma.

---

## `§3` · İŞ 1 — COVERAGE KAPISI ROTASI

`BaselineVolumeCoverageService.computeCoverageGate(tenantId)` **hazır ve test edilmiş**
(`BL-3`, 11 test). Bu adım onu **yüzeye bağlar**.

```
GET master-data/baseline-volumes/coverage      MASTER_DATA_READ
```
**Dönen şey ÜÇ DEĞERLİ** (`Z88 §2`):
```
GREEN       coverageRatio >= 0.95
RED         coverageRatio <  0.95    → teşhis raporuna YOL göster
UNMEASURABLE katalog evreni BOŞ      ⛔ "TEMİZ" DEĞİL
```
> ### **`0/0` BİR ORAN DEĞİLDİR. BOŞ EVRENDE `%100` DE `%0` DA YANLIŞTIR.**

⛔ **Üç değer de yüzeye ÇIKAR** — istemci `UNMEASURABLE`'ı `%0` ya da *"yeşil"* diye
**okuyamamalı**. `DISIPLIN`: *"bir beyan üç değer taşır"*.

📌 **Bugünkü gerçek cevap `RED`** (`0 / 59.160 = %0`) — `Z88 §2`'de ölçülü. Rota
bağlandığında **ilk çağrı bunu döndürmeli**; `GREEN` ya da `UNMEASURABLE` dönerse
**bağlama yanlıştır**.

---

## `§4` · İŞ 2 — TEŞHİS EKRANI: `batch → satırlar → NEDEN`

`BL-2`'nin iki okuma ucu **zaten var** (`batches/:batchId` · `batches/:batchId/rows`).
Bu adım onları **kullanılabilir bir yüzeye** çevirir.

```
filtrelenebilir:  reason (yedi üye) · status · row_no
her satır:        DÜZELTME EYLEMİ cümlesi taşır  → baseline-volume-remediation.ts
```
⛔ **Yedi cümle `BL-3`'te yazıldı ve TİPLE ZORLANDI** (`Record<Reason,string>`) — **yeniden
yazma, ÇAĞIR** (`F8`).
⛔ `NEGATIVE_VOLUME` (*"değeri düzelt"*) ≠ `INVALID_VOLUME_FORMAT` (*"biçimi düzelt"*) —
ayrım **ekranda görünmeli**, yoksa `Z87 §F12`'nin enum'u `7`'ye çıkarma gerekçesi **boşa
gider**.

---

## `§5` · İŞ 3 — `sourceMatchRatio` BAĞLAMA

`BL-3` sorguyu yazdı, **servise bağlamadı**:
```sql
SELECT COUNT(*) FILTER (WHERE status='ACCEPTED')::numeric / COUNT(*) AS source_match_ratio
FROM main.baseline_volume_import_batch_rows WHERE batch_id = $1;
```
⛔ **ÖZET KOLON AÇMA** (`INV-B-009`) — **sorguyla** türer, batch'e `accepted_count` benzeri
bir kolon **yazılmaz**. *(Batch immutable olsa bile **tek-kaynak** ilkesi.)*

### `5a` · İKİ METRİK **EKRANDA DA KARIŞMAZ** (`Z87 §3`)
```
sourceMatchRatio   BATCH BAŞLIĞINDA   eşleşen satır / DOSYA satırı   → TEŞHİS
coverageRatio      AYRI YERDE          kabul edilmiş / KATALOG evreni → KAPI
```
⛔ Aynı ekranda iki oran varsa **hangisinin KAPI olduğu YAZILI** olmalı.
⚠️ Ve `sourceMatchRatio` **`0/0` verebilir** (boş batch) — aynı üç-değer disiplini.

---

## `§6` · DUR LİSTESİ

```
⛔ YENİ RBAC HÜCRESİ AÇMA — §1 ölçüldü, MASTER_DATA_READ yeterli.
  Yine de gerektiğini düşünüyorsan DUR (Z86: hüküm UÇ LİSTESİYLE verilir, ADIYLA değil)
⛔ MIGRATION YAZMA — gerekirse DUR (numara Team Lead'in)
⛔ ÖZET KOLON AÇMA (INV-B-009)
⛔ 1822/1823'e DOKUNMA · docs/brd-v2/ DONMUŞ
⛔ commit/push YOK · git stash · git checkout ile geri alma · git add -A · --fix YASAK
  (`npm run lint` --fix İÇERİR — dosya hedefli `npx eslint <yol>` kullan)
⛔ konteynere DOKUNMA · .env okuma YOK
⛔ e2e KİLİTLİ (T-325): ikinci koşum 30 dk BEKLER — paralel e2e BAŞLATMA
⛔ improved-KAPISI (Z82) · new-table-rls KADEME 1 (Z85) CANLI
⛔ elle kapı koşumu: bash scripts/gate.sh <be|fe|meta> <komut>  (pwd'yi BASAR)
⛔ TZ kuran test CHILD-PROCESS ile kurar (baseline-volume-file-parser.service.spec.ts emsali)
⛔ her CHECK negatif kontrolünde bir NULL-girdi vakası ZORUNLU
⛔ exit kodunu boruya sokma: cmd > /tmp/x.log 2>&1; echo $?
⛔ /Users/…/Code/TTM ve /Users/…/Code/TPM — tek bayt yazma, komut çalıştırma YOK
⛔ "kapılar yeşil" demeden önce hangi kapıları koştuğunu ADLA say
```

## `§7` · PİNLER
```
1  ÜÇ DEĞER     GREEN · RED · UNMEASURABLE — üçü de yüzeye ÇIKIYOR, aynı koşumda ayrışıyor
2  BUGÜNKÜ CEVAP ilk çağrı RED döndürüyor (0/59.160) — GREEN/UNMEASURABLE dönerse BAĞLAMA YANLIŞ
3  YEDİ CÜMLE   ekranda yedi AYRI düzeltme eylemi; ikisi aynı cümleyi taşımıyor
4  İKİ METRİK   sourceMatchRatio batch başlığında · coverageRatio ayrı yerde · KAPI olan YAZILI
5  RBAC         PLANNER coverage'ı OKUYABİLİYOR · BASELINE_WRITE'a DOKUNAMIYOR
```

## `§8` · KANIT
```
kapılar   gate.sh ile, ADLA + exit kodu · TAM e2e Team Lead'de
kova      rotalar scope-c.txt'ye GEREKÇESİYLE eklendi · scope-ratchet exit 0
route-cell-map REGENERATE (elle DEĞİL) — beklenti ÖNCEDEN yazılır, sapma varsa DUR
```
*"Ölçemedim"* meşru bir çıktıdır; **"flaky" değildir.**
