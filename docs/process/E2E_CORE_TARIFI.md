# `E2E CORE` — BİR TARİF, BİR SCRIPT DEĞİL
### `Z109 §2` · hüküm 25 **GERİ ALINDI** (ürün sahibi, 2026-09-08)

> ## ⛔ BU BİR TÜKETİCİSİ OLMAYAN UÇ DEĞİL, BİR TARİFTİR
> `npm run e2e:core` **kaldırıldı**. Aşağıdaki türetme ve liste, ihtiyaç doğduğu gün
> bir script'e dönmek üzere **kanıtlarıyla birlikte** burada duruyor.

---

## 1 · NEDEN GERİ ALINDI — taşıyıcı gerekçe ÖLÇÜMLE ÇÜRÜDÜ

```
[İDDİA, ÖLÇÜLMEMİŞ]  "tam e2e ~15 dk · dalga başına 30-45 dk bekleme"
[ÖLÇÜLDÜ: date +%s farkı, Team Lead, 2026-09-08]
   npm run e2e:full  → 185 s   (64 suite / 887 test)   ⇒ ~3 dakika
   npm run e2e:core  →  89 s   ( 8 suite / 171 test)
   ⇒ kazanç: 96 s / koşum · dalga başına ~5 dk (3 koşum)
```

> ### ⛔ `Z69 §4c` — **TAŞIYICI ÇÜRÜYÜNCE HÜKÜM DARALMAZ, DÜŞER.**

Geriye kalan gerekçe (*"`full`'ün kimin işi olduğu yazılı olsun"*) zaten **push-order
beyanının `koşulmadı:` satırıyla** karşılanıyordu. `core` ona bir şey **eklemiyordu**.

### `1.1` · SÜZGEÇ SORUSU — koruduğu sınıf ne, maliyeti ne

```
KORUDUĞU   dalga başına ~5 dk  (3 × 96 s)

MALİYETİ   1. TÜRETİLMİŞ LİSTE BAKIMI — 5-halka envanteri değişince liste SESSİZCE bayatlar
           2. İKİ KOMUT — hangisinin koşulduğu her raporda ayrıca sorulmalı
           3. ⛔ SESSİZ-YEŞİL RİSKİ — "core yeşil" bir ajan raporunda "e2e yeşil" diye OKUNUR
              ⇒ T-325'in gizlediği "koşulmadı"nın YENİ BİR KILIĞI
```

⇒ **96 saniye bunu hak etmiyor.** Ve `185 s` bir tam suite ara-doğrulamada da kabul edilebilir.

📌 `T-267` sınıfı: **tüketicisi olmayan bir uç**, bakım borcu üretir ve yanlış okunur.

---

## 2 · TÜRETME KOMUTU — kaynağıyla birlikte

```bash
cd collmind.backend && {
  echo test/role-journey.e2e-spec.ts                          # halka 1 — FAZ1_KAPANIS_BEYANI §2
  rg -l "BR-E2E-02" test/*.e2e-spec.ts                        # halka 4+5 — settlement/release/reversal
  rg -l "INV-R-001|INV-R-002" test/*.e2e-spec.ts              # halka 2 — on-invoice ledger invariant
  rg -l "RAG" test/*.e2e-spec.ts | grep -v role-journey       # RAG üç-dünya
  echo test/baseline-volume-diagnostics-surface.e2e-spec.ts   # coverage-KAPISI
  echo test/budget-envelope-split.e2e-spec.ts                 # on-invoice → kategori-zarfı split
} | xargs -n1 basename | sort -u
```

⛔ **Arama terimi, ARANAN YERİN DİLİYLE seçildi** — genel alan kelimeleriyle değil,
mührün **kendi tanımlayıcılarıyla**:
```
[ÖLÇÜLDÜ: rg -l "on-invoice|onInvoice" test/*.e2e-spec.ts]  → 16 dosya   ⛔ GÜRÜLTÜ
[ÖLÇÜLDÜ: rg -l "BR-E2E-02"           test/*.e2e-spec.ts]   →  3 dosya   ✅ ÇAPA
```

### `2.1` · SONUÇ LİSTESİ (8 dosya)

| dosya | halka / çapa |
|---|---|
| `role-journey.e2e-spec.ts` | halka 1 — plan yaşam döngüsü (`A1`–`A21`) |
| `settlement.e2e-spec.ts` | halka 4+5 — `BR-E2E-02` |
| `settlement-budget-release.e2e-spec.ts` | halka 4+5 — `BR-E2E-02` |
| `reversal.e2e-spec.ts` | halka 4+5 — defter **yön ayrımı** |
| `on-invoice-ledger-invariants.e2e-spec.ts` | halka 2 — `INV-R-001/002` |
| `formula-canon-turnover-niv-and-rag-quadrant.e2e-spec.ts` | RAG üç-dünya |
| `baseline-volume-diagnostics-surface.e2e-spec.ts` | **coverage KAPISI** |
| `budget-envelope-split.e2e-spec.ts` | on-invoice → kategori-zarfı **split** |

### `2.2` · ÜÇ ÇAPANIN AYIRT EDİCİ ÖLÇÜTLERİ — kayıt değeri BUNLARDA

**`coverage-kapısı` — dört aday, biri kapı:**
```
plan-scale-validation              "QA coverage for C3"      ❌ test JARGONU (yorumda)
optimistic-locking                 "ZERO test coverage"      ❌ test JARGONU (yorumda)
formula-canon-turnover…            "coverage = 1"            ❌ matematiksel ORAN (yorumda)
baseline-volume-diagnostics        GET /master-data/baseline-volumes/coverage   ✅ GERÇEK ROTA
```
⛔ **Ayırt edici ölçüt:** üçü kelimeyi **yalnız yorumda** taşıyor; yalnız biri onu bir
**HTTP rotasının kendisinde** taşıyor ve o rotayı **bağımsız bir SQL sorgusuyla** çapraz
doğruluyor.

**`plan→submit→onay→REZERVASYON` — adı iddialı dosya reddedildi:**
`budget-reserve-canonical-path.e2e-spec.ts` **girmedi**. Kendi docstring'i
(`:1-19`) *"Bu suite ikisini de TEKRAR test ETMEZ (role-journey zaten kapsıyor)"* diyor;
kapsadığı şey **kaldırılan bir ucun 404 regresyonu**. ⛔ **Bir dosya ADI bir kanıt değildir.**

**`on-invoice → kategori-zarfı` — iki aday, biri:**
`on-invoice-split-envelope` **girmedi** — koruduğu regresyon (`postingDate` → `POSTED`
ledger) zaten `on-invoice-ledger-invariants` tarafından ölçülüyor. `budget-envelope-split`
**girdi** — `POST /budget/envelopes/:id/split`'in kendisi, örtüşmeyen bir mekanizma.

---

## 3 · ⛔ KANIT — BOŞA GİTMEDİ, TARİFİN KANITIDIR

Bu liste bir **kapı** olsaydı `Z83` doğum şartını sağlaması gerekirdi. **Sağladı** — ve
kanıt burada duruyor, çünkü tarif bir gün script'e dönerse **yeniden üretilmesi gerekmesin**:

```
BİLİNEN-YEŞİL     [ÖLÇÜLDÜ] 8 suite / 171 test · 89 s · [T-047 invariant] PASS

BİLİNEN-KIRMIZI   mutasyon: ledger.repository.ts:118 sumByAgreementId  '-' → '+'
                            (yön-bağımsız SUM — halka 5 mühründe "consumed'ı ARTIRIRDI" YAZILI)
                  [ÖLÇÜLDÜ] core EXIT 1 · reversal.e2e-spec.ts:304
                            "Expected: < 35000   Received: 40000"     ⇒ mühür DOĞRULANDI

AYIRT EDİCİLİK    mutasyon: versioned-update.helper.ts:44  `version: expectedVersion` SATIRI SİLİNDİ
                            (CAS tamamen devre dışı — core'un KAPSAMADIĞI yer)
                  [ÖLÇÜLDÜ] core                 EXIT 0 · 8/8 · 171/171   ⇒ KIRMADI ✅
                  [ÖLÇÜLDÜ] optimistic-locking   EXIT 1 · 9 failed / 46   ⇒ KIRDI   ✅
                  ⇒ core, full'ün YAVAŞ BİR KOPYASI DEĞİLDİ. Ölçüldü.
```
Geri almalar: **kopya + `shasum -a 256 -c`** (`git checkout` kullanılmadı), ikisi de `OK`.

### `3.1` · ⛔ VE BİR MUTASYON VAKASI — "SATIRI BAS" ÜÇÜNCÜ KEZ YAKALADI

Team Lead ayırt ediciliği bağımsız ölçerken **mutasyon hiç uygulanmadı**: eşleştirme
metni **8 boşluk** varsayıyordu, dosyada **6** vardı; `assert` düştü, dosya yazılmadı, ve
iki koşum da **mutasyonsuz** koda karşı yeşil çıktı.

> ### ⛔ *"Ayırt edicilik kanıtlanamadı"* diye yazılabilirdi. Yakalayan şey **değiştirilen
> ### satırı BASMAK** oldu — çıktıda `version: expectedVersion,` hâlâ duruyordu.

Ayrıca şerit **kendi** ilk denemesinde `TS2345` derleme hatasına düşmüştü — *"derlenmeyen
bir mutasyon hiçbir şey kanıtlamaz"*. İkisi de **davranışsal** bir hedefe taşındı.

---

## 4 · OLAY-TETİKLEYİCİ — bu tarif ne zaman SCRIPT'e döner

```
⛔ KOŞUL: bir CI / PR-gate doğduğu gün — yani e2e'nin bir İNSANIN beklemesi değil,
          bir BORU HATTININ süresi olduğu gün.
```
O gün üç şey **birlikte** gelir, ve üçü de bugünkü maliyet kalemlerinin cevabıdır:
```
1  liste bayatlamasına bir KAPI    (5-halka envanteri ↔ liste eşleşmesi mekanik denetlenir)
2  "core yeşil"i "e2e yeşil"den AYIRAN bir beyan  (sessiz-yeşil riskinin panzehiri)
3  Z83 doğum şartı YENİDEN         (§3'teki kanıt BAYATLAR — mutasyon noktaları kayar)
```

⚠️ Ve `§3`'ün kanıtı **tarihlidir**: `2026-09-08`. `ledger.repository.ts:118` ve
`versioned-update.helper.ts:44` **kayabilir** — o gün satır numaraları değil,
**mekanizma adları** aranır.
