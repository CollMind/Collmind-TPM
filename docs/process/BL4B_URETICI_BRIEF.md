# `BL-4b` — `BASELINE_MISSING` ÜRETİCİSİ · brief

> **Okunan HEAD:** meta `626bd1d` · backend `676e568` (ikisi de **push'lu**)
> **Hüküm kaynağı:** `Z90 §2/§3` (ürün sahibi) · `Z91 §3` · `DISIPLIN` → *"bir enum
> üyesi ekleyen tur, üreticisini aynı turda bağlar"*

## `§0` · NEDEN AÇIK

```
BASELINE_MISSING   tanımlı  ✅  rag-quadrant.ts:104
                   tanınan  ✅  parseRagExclusionReason:185
                   ATAYAN   ⛔  0   ← BU ŞERİT
```
⛔ **`"uçtan uca canlı"` cümlesi bu şerit inmeden KURULMAZ.**

## `§1` · HÜKÜM (ürün sahibi, `Z90`)

```
baseline YOK (NULL)  ⇒  iVol · iTO · iGP · uplift · ROI = NOT_EVALUABLE
                     +  ragExclusionReason: BASELINE_MISSING
baseline SIFIR (0)   ⇒  MEŞRU DEĞER: uplift = PLANLANAN HACMİN TAMAMI
ETKİLENMEZ           GSV · spend · bütçe REZERVASYONU · settlement
                     (hepsi PLANNED-VOLUME tabanlı)
```

> ### ⛔ **`0` ≠ `NULL` — VE İKİSİ AYNI KOŞUMDA AYRIŞMALI.**
> `Z77` sessiz `0` **üretmeyi** yasaklıyordu; bu, gerçek bir `0`'ı `NULL` **sanmayı**
> yasaklıyor. Dal seçimi **`=== null`** ile yapılır, **truthiness ile DEĞİL**.

⛔ **MIGRATION GEREKMİYOR** (`Z90 §2`, ölçüldü): kolon `varchar`, `CHECK` yok — `1819`
bunu **bilerek** yaptı (*"sınıfın tek kanonik yeri TypeScript"*).

## `§2` · YÜZEY — ölçülmüş çapa noktaları

```
rag-quadrant.ts:148   resolveRagQuadrant(incrTo, incrGp, incrPromoSpend)
                      sıra: 1 KAPSAM (incrPromoSpend===0 ⇒ LTA_ONLY)
                            2 VERİ   (incrTo/incrGp null ⇒ renk yok, sebep NULL)
                            3 kadran
                      ⇒ BUGÜN "baseline yok" ile "başka bir sebeple null"
                        AYIRT EDİLEMİYOR — sebep her ikisinde de null
kpi-engine.service.ts:126,194,242,265,307   rag.ragExclusionReason'ı taşıyor
plan.service.ts:2868, 2960, 3122, 3186      kalıcılaştırma + geri okuma
```

### ⛔ DUR ŞARTI — bu bir TASARIM KARARI olabilir
`resolveRagQuadrant` bugün **üç sayı** alıyor. *"Baseline yoktu"* bilgisi o üç sayıda
**taşınmıyor** — çağıran (`kpi-engine`) biliyor, fonksiyon bilmiyor.

**Eğer** sinyali fonksiyona taşımanın tek yolu imzayı/sözleşmeyi değiştirmekse ve bunun
birden fazla makul şekli varsa (**ör.** dördüncü parametre · ayrı bir `resolve` sarmalayıcı ·
çağıranda karar) → **DUR, ölçümü ve seçenekleri raporla, kendin seçme** (`CLAUDE.md §2.4`).
Tek makul şekil varsa uygula ve **neden tek olduğunu ölçümle yaz**.

## `§3` · İKİNCİ İŞ — ÖLÜ METOT

`baseline-volume.repository.ts` → `findRowsByBatchId` · **üretim çağıranı 0** (`code-reviewer`
ölçtü: 6 eşleşmenin 3'ü farklı sınıf, 1 tanım, 3 spec mock alanı).
Tek çağıranı `service.getBatchRows` idi; `BL-4a` onu `findImportBatchRows`'a taşıdı.
⇒ **ÖLÜR** (`T-267` emsali: bir uç ya tüketici kazanır ya ölür).
`baseline-volume.service.spec.ts`'teki mock alanları da temizlenir (artık ölçmediği bir
şeyi taklit ediyor).

## `§4` · TÜKETİCİ TARAFI — bugün YANLIŞ CÜMLE verecek
`submission-checks.ts:259-273`: yalnız `LTA_ONLY` ayrı cümle alıyor; `else` dalı
*"RAG hesaplanamadı: plan KPI kapsaması tam değil…"* diyor.
`Z90 §2` `BASELINE_MISSING`'i **tanımlı-yokluk** olarak konumluyor (*"sebep GÖRÜNÜR"*)
⇒ **kendi cümlesini alır**, jenerik dala düşmez.

## `§5` · PİNLER — raporda AYNI KOŞUMDAN sayı ile
```
PİN 1  baseline NULL  ⇒ ragExclusionReason === 'BASELINE_MISSING'   (görülmeli)
PİN 2  baseline 0     ⇒ uplift === plannedVolume, sebep NULL        (AYNI koşumda)
PİN 3  GSV/spend/rezervasyon   İKİ DURUMDA DA DEĞİŞMEZ             (ölçülmeli)
PİN 4  submission-checks BASELINE_MISSING için KENDİ cümlesini verir
PİN 5  findRowsByBatchId  →  `grep -rn` sonucu 0                    (silindikten sonra)
```
⚠️ **Reprodüksiyon şartı YÖNSÜZDÜR:** önce fixture kur → beklenen davranışın
**BUGÜN OLMADIĞINI GÖR** → sonra düzelt. Görülmezse hipotez elenir ve **bu da bir sonuçtur**.

## `§6` · ORTAK YASA
- `docker ps --filter "label=com.docker.compose.project=tpm"` **boş** olmalı — ilk madde
- Doğrulamanı **izole bir `git worktree`'de** yap; paylaşılan ağaçta `--fix`/mutasyon/
  `git checkout` **çalıştırma** (paralel şerit var)
- `git stash` **YASAK** · `git add -A` **YASAK** · `.env` **okuma**
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **tek bayt yazma, komut koşma**
- Exit kodunu **boruya sokma**: `cmd > log 2>&1; echo $?`
- **`ölçemedim` meşru bir çıktıdır. `flaky` DEĞİLDİR** — ya adlandırılmış bir mekanizma ya `ölçemedim`
- **`[ÖLÇÜLDÜ]` damgası bir kümenin BOŞ olduğu iddiası için de gerekir**
