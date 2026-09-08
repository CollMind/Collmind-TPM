# `Z109 ADIM 2` — E2E İKİ KATMAN: `e2e:core` (~2 dk) · `e2e:full` (~15 dk)
### Şerit: `qa-engineer` · Hüküm: `Z109 §2` (ürün sahibi hükmü 25, 2026-09-08)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]` taşır.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.**
> ⛔ **Raporunda da etiket kullan, ve ARAÇ NOTLARINI yaz.**

---

## 0 · OKUMA SIRASI (ZORUNLU)

```
1  docs/process/BRIEF_SABLONU.md                    ← sözleşmen (§2 tarama desenleri DAHİL)
2  docs/process/FAZ1_KAPANIS_BEYANI.md §2           ← 5-HALKA MÜHRÜ — türetmenin KAYNAĞI
3  docs/brd-v2/04_KARAR_KAYDI.md → Z109 §2 · Z83
4  docs/DISIPLIN.md → "Bir KAPI, ölçümün BAŞARISINI hata sayamaz"
                      "Sinyal sabitse, sinyal değildir"
                      "Bir liste vermek, EVRENİ tanımlamak değildir"
5  CLAUDE.md §2.6 · §2.7 · §4.2
6  collmind.backend/scripts/e2e-run-locked.sh · test/jest-e2e.json
   test/global-setup.js · test/global-teardown.js
7  .claude/backlog/tasks/T-325.md                   ← tek-çalıştıran kilidi
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | nerede |
|---|---|---|
| `Z109 §2` | hüküm 25 — iki katman · **elle seçim YASAK, türetilir** · core **push yetkisi vermez** | tamamı |
| `Z83` | kapı doğum kuralı: bilinen-yeşil **ve** bilinen-kırmızı | `§4` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — tek cümle

> ### Tam e2e **~15 dk**. Bir şerit tur içinde **üç kez** ölçmek isterse, **45 dakikası**
> ### bekleyerek geçiyor — ve bu yüzden **ölçmüyor**.

⛔ **Ve çözüm bir KAPI DARALTMASI DEĞİL, bir KOŞUM EKONOMİSİDİR** (`Z109 §2`):
```
core   şerit-içi HIZLI geri bildirim      ⛔ PUSH YETKİSİ VERMEZ
full   dalga-sonu birleşme + push-order   ⛔ TEAM LEAD koşar
```

> ### ⛔ Hiçbir kapı kalkmıyor. `full` **hâlâ zorunlu**; yalnız **ne zaman** koşulduğu
> ### değişiyor.

---

## 2 · ⛔ `core` LİSTESİ **TÜRETİLİR** — ELLE SEÇİM YASAK

Gerekçe: elle seçilmiş bir liste, seçenin **o günkü aklını** yansıtır ve **denetlenemez**.
Türetilmiş bir liste, **kaynağıyla birlikte yaşar** — kaynak değişince liste de değişir.

### `2.1` · TÜRETME KURALI

```
core = { 5-HALKA MÜHRÜNÜN kanıt olarak ADINI VERDİĞİ e2e dosyaları }
       ∪ { çekirdek döngünün altı çapası }
```

⛔ **Ve arama terimi, ARANAN YERİN DİLİYLE seçilir** — genel alan kelimeleriyle
(`on-invoice`, `settlement`, `DEBIT`) değil, **mührün kendi tanımlayıcılarıyla**.

```
[ÖLÇÜLDÜ: rg -l "on-invoice|onInvoice" test/*.e2e-spec.ts]        → 16 dosya  ⛔ GÜRÜLTÜ
[ÖLÇÜLDÜ: rg -l "BR-E2E-02" test/*.e2e-spec.ts]                   →  3 dosya  ✅ ÇAPA
```

### `2.2` · ÖLÇÜLMÜŞ ÇAPALAR — Team Lead'in ön taraması

```
[ÖLÇÜLDÜ: rg -l "BR-E2E-02" test/*.e2e-spec.ts]
  settlement.e2e-spec.ts · settlement-budget-release.e2e-spec.ts · reversal.e2e-spec.ts
     ⇒ halka 4 (settlement→release, cap semantiği) VE halka 5 (defter yön ayrımı)

[ÖLÇÜLDÜ: rg -l "INV-R-001|INV-R-002" test/*.e2e-spec.ts]
  on-invoice-ledger-invariants.e2e-spec.ts                    ⇒ INV-R-001/002

[ÖLÇÜLDÜ: rg -l "RAG" test/*.e2e-spec.ts]
  formula-canon-turnover-niv-and-rag-quadrant.e2e-spec.ts · role-journey.e2e-spec.ts
     ⇒ RAG üç-dünya

[ÖLÇÜLDÜ: FAZ1_KAPANIS_BEYANI §2 halka 1]
  role-journey.e2e-spec.ts  A1–A21                            ⇒ plan yaşam döngüsü
```

⛔ **AÇIK KALAN İKİ ÇAPA — `[ÖLÇÜLMEDİ — ölçülecek: SENİN İŞİN]`:**
```
1  "plan→submit→onay→REZERVASYON"  hangi dosya bunu UÇTAN UCA taşıyor?
   aday: budget-reserve-canonical-path.e2e-spec.ts (adı iddialı) — ⛔ ADI KANIT DEĞİL, AÇ VE OKU
2  "coverage-KAPISI"                hangi dosya?
   [ÖLÇÜLDÜ: rg -l "coverage" test/*.e2e-spec.ts] → DÖRT aday
     plan-scale-validation · optimistic-locking · baseline-volume-diagnostics-surface
     · formula-canon-turnover-niv-and-rag-quadrant
   ⛔ Dördü de "coverage" kelimesini geçiriyor; hangisi KAPI, hangisi sadece BAHSEDİYOR —
     AYIR. Ve ayırt edici ölçütünü YAZ.
3  "on-invoice → KATEGORİ ZARFI"    aday: on-invoice-split-envelope · budget-envelope-split
   ⛔ İkisi de mi core'a girer, biri mi — GEREKÇESİYLE seç
```

### `2.3` · ⛔ TÜRETME KOMUTU RAPORDA YAZILI OLUR
Liste bir dosyaya **elle yazılacak** (jest yapılandırması ya da bir `.txt`), ama
**nasıl türetildiği** raporda **çalıştırılabilir komut** olarak durur. Bir sonraki el
listeyi **yeniden üretebilmeli**.

### `2.4` · BEDAVA GELEN — `T-047`
```
[ÖLÇÜLDÜ: rg -ln "T-047" test/global-setup.js test/global-teardown.js]  → İKİSİNDE DE
```
⇒ `T-047` net-sıfır invaryantı `globalSetup`/`globalTeardown`'da yaşıyor, yani **her** jest
çağrısında koşuyor. **`core` onu bedavaya taşır** — ayrı bir iş **yok**.
⛔ Ama **doğrula**, devralma: `core` koşumunun çıktısında `[T-047 invariant]` satırını **BAS**.

---

## 3 · ÜRÜN

```
npm run e2e:core    hedef ~2 dk    şerit koşar
npm run e2e:full    hedef ~15 dk   TEAM LEAD koşar (dalga-sonu + push-order)
npm run test:e2e                   ⛔ KIRILMAZ — bugünkü anlamı (TAM koşum) KORUNUR
                                     e2e:full ona eşit olabilir; ölç ve söyle
```

⛔ **İkisi de `T-325` tek-çalıştıran kilidini kullanır** (`scripts/e2e-run-locked.sh`) —
`core` kilidi **atlamaz**. İki koşum aynı DB'yi paylaşır.

### `3.1` · ⛔ `core` PUSH YETKİSİ VERMEZ — ve bu MEKANİK olarak görünür olur

`push-order` beyanına bir satır:
```
koşuldu:    core
koşulmadı:  full
```
⛔ **Bu bir DÜRÜSTLÜK SATIRIDIR**, bir kapı değil. `push-order.sh`'ı **değiştirmen
gerekmiyor** — ama gerekiyorsa **DUR ve sor** (o script bir hüküm taşıyor).

---

## 4 · ⛔ DOĞUM ŞARTI (`Z83`) — `core` BUNLARSIZ BİR KAPI DEĞİL

```
BİLİNEN-YEŞİL    core bugünkü HEAD'de YEŞİL, ve ~2 dk (DUVAR SAATİ — ölç, tahmin etme)

BİLİNEN-KIRMIZI  ⛔ ÇEKİRDEK DÖNGÜYÜ bozan bir mutasyon core'u KIRMALI.
                 Öner: ledger yön ayrımını boz (yön-bağımsız SUM) — halka 5'in
                 mühründe "bu mutasyon consumed'ı ARTIRIRDI" diye YAZILI
                 ⇒ core KIRMIZI vermezse, core ÇEKİRDEĞİ KAPSAMIYOR demektir
                 ⛔ mutasyonu SATIR NUMARASIYLA hedefle ve DEĞİŞTİRDİĞİN SATIRI BAS
                 ⛔ geri alma: kopya + shasum -a 256 -c  (git checkout YASAK)

AYIRT EDİCİLİK   ⛔ ve TERS YÖN: core'un KAPSAMADIĞI bir yeri bozan bir mutasyon
                 core'u KIRMAMALI, full'ü KIRMALI. İkisi aynı şeyi ölçüyorsa
                 core bir EKONOMİ değil, sadece FULL'ün YAVAŞ bir kopyasıdır.
```

> ### ⛔ *"Sinyal sabitse, sinyal değildir."* Bir `core` hep yeşilse de hep kırmızıysa
> ### **yoktur**. İki farklı girdide **iki farklı çıktı** vermelidir.

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ ÜRÜN KODU      DOKUNMA. Bu tur: package.json · test/jest-e2e*.json · scripts/e2e-*.sh
⛔ TEST İÇERİĞİ   Bir e2e testinin İÇİNİ değiştirme — bu tur SEÇİM işidir, düzeltme değil
⛔ push-order.sh  Değiştirmen gerekiyorsa DUR ve SOR
⛔ MIGRATION      YAZMA
⛔ docs/brd-v2/** YAZMA
⛔ KİLİT          test/.e2e-run.lock — başka bir koşum varken BAŞLATMA
                  ⛔ ŞU AN Z109 ADIM 3 (migration harness) DB'yi kullanıyor olabilir —
                     İLK İŞİN kilidi kontrol etmek, ve doluysa BEKLEMEK
⛔ GERİ ALMA      git checkout YASAK — kopya + shasum -a 256 -c
⛔ COMMIT/PUSH    YOK
```

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
collmind.backend/package.json
collmind.backend/test/jest-e2e.json           (ya da yeni bir jest-e2e-core.json)
collmind.backend/scripts/e2e-run-locked.sh    (GEREKİYORSA)
```

## 7 · E2E KATMANI
```
Bu turun KENDİSİ e2e katmanını KURUYOR ⇒ kapanışta İKİSİ DE koşulur:
  core  (yeni)  → yeşil + süre
  full  (mevcut) → yeşil + süre   ⛔ taban 64 suite / 887 test · T-047 PASS
```

## 8 · KAPANIŞ ÇIKTISI (bu başlıklarla)

```
1  TÜRETME              — kural + ÇALIŞTIRILABİLİR komut + sonuç LİSTE (sayı değil)
                          ⛔ §2.2'nin ÜÇ açık çapası KAPATILMIŞ, ayırt edici ölçütüyle
2  core LİSTESİ         — dosya dosya, her biri HANGİ halkaya/çapaya bağlı
3  SÜRE                 — core ve full DUVAR SAATİ (hedef ~2 dk / ~15 dk; ⛔ ÖLÇ)
4  DOĞUM ŞARTI          — bilinen-yeşil · bilinen-kırmızı · AYIRT EDİCİLİK (ters yön)
                          üçünün de ÇIKTISI yapıştırılır
5  T-047                — core çıktısındaki [T-047 invariant] satırı
6  push-order BEYANI    — "koşuldu/koşulmadı" satırının nereye yazılacağı
7  KAPI                 — tsc 0 · guards 0 · core yeşil · full yeşil
8  ⛔ NE ÖLÇEMEDİN       — "ölçemedim" MEŞRU bir çıktıdır
```
