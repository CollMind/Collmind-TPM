# `T-385` — ZAMANLI KIRMIZI: takvim, testin girdisi olmaktan ÇIKAR
### Şerit: `qa-engineer` · Hüküm: `Z108 §1` (ürün sahibi hükmü 18, 2026-09-08)

> ## ⛔ BU BRIEF `Z108 §3` (HÜKÜM 20) ALTINDA YAZILMIŞTIR
> **Her iddia satırı bir etiket taşır. Etiketsiz bir iddia görürsen: DUR ve brief'i İADE ET.**
> ```
> [ÖLÇÜLDÜ: <kaynak>]      → doğrulayabilirsin, kaynak yazılı
> [ÖLÇÜLMEDİ — ölçülecek]  → BU SENİN İŞİN. Bir hipotez, bir sonuç DEĞİL.
> ```
> 📌 Bu kural bu dalganın **üç blocker'ının** kökünden doğdu: bir brief'e
> *"(ölçüldü)"* yazıldı, ölçülmemişti, ve o kelime bir sonraki eli **yeniden ölçmekten
> alıkoydu**. Yazan **Team Lead'di**. `DISIPLIN`: *"brief'te her iddia bir etiket taşır."*

---

## 0 · OKUMA SIRASI (ZORUNLU, bu sırayla)

```
1  docs/brd-v2/04_KARAR_KAYDI.md  →  Z107 (§1 · §3)  ve  Z108 (§1 · §1.1 · §3)
2  docs/DISIPLIN.md               →  "SEED bir DEMO'dur, FIXTURE bir SÖZLEŞMEDİR"
                                     "SEED GÖRELİDİR, FIXTURE SABİTTİR — ikisi ZIT yöne gider"
                                     "Brief'te her İDDİA bir ETİKET taşır"
                                     "Bir LİSTE vermek, EVRENİ tanımlamak değildir"
3  .claude/backlog/tasks/T-385.md →  ⛔ ÖZELLİKLE `F12` BLOĞU (evren listesi DÜZELTİLDİ)
4  CLAUDE.md §2.6 · §2.7          →  ölçüm disiplini
```

---

## 1 · PROBLEM — TEK CÜMLE

> ### `Z107` demo dönemini **2026 Q3** (`2026-07 … 2026-09`) yaptı. Bu **canlı** bir demo —
> ### yani *"tenant-bugününü İÇEREN"*. **2026-10-01'de içermemeye başlar.**

```
[ÖLÇÜLDÜ: docs/brd-v2/04_KARAR_KAYDI.md Z107 §2 · migration 1832000000000]
   8 zarf  period_from '2026-07'  period_to '2026-09'
[ÖLÇÜLDÜ: Z107 code-reviewer turu]
   role-journey A13 / A13b — computeBudgetUtilization VARSAYILAN penceresi "BUGÜN"
   ⇒ 2026-10-01'de zarf bulunamaz ⇒ 200 değil 404
   ⚠️ ve bu tur o assertion'ı 404'ten 200'e ÇEKTİ (F12 ile) — yani bomba BU COMMIT'in
```

> ### ⛔ **1 Ekim 2026'da suite'ler birden kırmızıya döner — ve sebebi ÜÇ HAFTA ÖNCEKİ
> ### bir dönem hizalamasıdır. O gün kimse buraya bakmaz.**

**Ürün sahibi hükmü (`Z108 §1`):** böyle bir tarihi kuyrukta bekletmek, ay-sonu kusurlarını
*"flaky"* sanma vakasının (`T-328`) **PLANLI hâlidir**. ⇒ `DALGA-A`'dan **ÖNCE**.

---

## 2 · EVREN — ⛔ **ŞEKİL ÖNCE, SONRA TARAMA**

`DISIPLIN`: *"bir liste vermek, evreni tanımlamak değildir."* Bu task'ın kendi listesi
**zaten bir kez yanlış çıktı** (`T-385` `F12`: beş dosya denmişti, **üçü** doğruydu; iki
`cash-flow` dosyası bir **yorum** eşleşmesiyle listeye girmişti).

⛔ **Bu yüzden: önce ŞEKİLLERİ adlandır, sonra her şekli AYRI AYRI tara.**

### ŞEKİL 1 — `isoToday()` / `isoPlusDays()` yerel yardımcısı
```
[ÖLÇÜLDÜ: grep -rc "isoToday(\|isoPlusDays(" test/*.ts | grep -v ":0$"]
  test/formula-canon-turnover-niv-and-rag-quadrant.e2e-spec.ts    7
  test/lta-parent-lifecycle-status-gate.e2e-spec.ts               7
  test/lta-lifecycle-bond-and-base-chain.e2e-spec.ts             11
[ÖLÇÜLDÜ: grep -n "function isoToday" test/*.ts]
  yardımcı DÖRT KEZ tanımlı — lta-parent-lifecycle'da İKİ KEZ (:85 ve :416)
  ⇒ §2.7 #8 ailesi: kopya, orijinaldeki regresyonu görmez
```

### ŞEKİL 2 — VARSAYILAN PENCERE (parametre vermeyen çağrı)
```
[ÖLÇÜLDÜ: Z107 review]  role-journey A13 / A13b
⛔ Bu şekil GREP'LE BULUNMAZ — çağrıda "bugün" kelimesi GEÇMEZ, YOKLUĞU "bugün" demektir.
[ÖLÇÜLMEDİ — ölçülecek]  BAŞKA hangi uçların varsayılan penceresi "bugün"?
   ⇒ ÜRÜN tarafından tara: varsayılanı new Date()/tenantTodayIsoDate olan HER parametre,
     sonra o ucu çağıran testler. SAYI DEĞİL LİSTE.
```

### ŞEKİL 3 — testte doğrudan `new Date()` → **API'ye giden TARİH ALANI**
```
[ÖLÇÜLDÜ: grep -rc "new Date()\|Date.now()" test/*.ts]  33 dosya eşleşiyor
⛔ AMA BU SAYI BİR TEŞHİS DEĞİL, BİR ENVANTERDİR. Çoğu ZARARSIZ:
   süre ölçümü · optimistic-locking damgası · log zaman damgası · YORUM İÇİ
[ÖLÇÜLMEDİ — ölçülecek]  33'ün her biri iki kutuya AYRILACAK:
   (a) TAKVİM ALANI  → postingDate · effectiveDate · expiryDate · transactionDate
                       · period · startDate/endDate  ⇒ ⛔ ZAMANLI KIRMIZI ADAYI
   (b) ANLIK         → süre/versiyon/log            ⇒ meşru, DOKUNMA
⛔ (b) diyorsan NEDEN meşru olduğunu YAZ (CLAUDE.md §7.1)
```

### ŞEKİL 4 — **SEED ZARFINA** bağımlılık (kendi zarfını KURMAYAN test)
```
[ÖLÇÜLDÜ: Z107 §3]  ensureBudgetEnvelope (test/helpers/seed-e2e.ts) bu tur DOĞDU;
                    üretim kaskadının KOD KOLONLARIYLA eşleşiyor, idempotent
[ÖLÇÜLMEDİ — ölçülecek]  Z107 ON suite'i düzeltti. Bütçe yoluna giren AMA
   ensureBudgetEnvelope ÇAĞIRMAYAN suite kaldı mı? Kaldıysa o suite hâlâ
   SEED'İN DÖNEM KARARINA bağımlıdır ve 1 Ekim'de düşer.
```

> ### ⛔ DÖRT ŞEKLİN DÖRDÜ DE TARANIR. Üçünü tarayıp *"evren bu"* demek, bu task'ın
> ### **zaten bir kez düştüğü** hatadır.

---

## 3 · DÜZELTME — SINIF DÜZEYİNDE, ÜÇ PARÇA (hüküm 18)

```
1  Her etkilenen suite KENDİ FIXTURE'INI kurar    ensureBudgetEnvelope deseni (Z107 §3)
2  SABİT tarih                                     ⛔ göreli tarih YASAK (T-329 / T-333)
3  "bugün" ENJEKTE EDİLİR                          clock-injection
⇒ TAKVİM, TESTİN GİRDİSİ OLMAZ.
```

### `3.1` — clock-injection: ⛔ **EMSALİ YENİDEN KULLAN, KOPYA YAZMA**

```
[ÖLÇÜLDÜ: src/common/date/local-today.ts]
   tenantTodayIsoDate(timezone, now?)  →  İKİNCİ PARAMETRE ZATEN VAR
[ÖLÇÜLDÜ: src/common/date/local-today.spec.ts:205]
   "tenantTodayIsoDate — `now` enjekte edilebilir, zamana bağlı DEĞİL" bloğu ZATEN KOŞUYOR
[ÖLÇÜLDÜ: T-333 harness'i]  üç TZ · child-process deseni MEVCUT
```
⇒ **Yeni bir mekanizma GEREKMİYOR.** Gereken: var olanın **e2e'den erişilebilir** kılınması.

⛔ **[ÖLÇÜLMEDİ — ölçülecek] ve bu ŞERİDİN İLK KARARI:** e2e'de "bugün"ü sabitlemenin
**kaç yolu var** ve hangisi bu kod tabanına uyuyor —
```
(a) fixture'ı SABİT tarihe çek       → en ucuz, ama "varsayılan pencere" şeklini çözmez
(b) tenantTodayIsoDate'e now enjekte  → ŞEKİL 2'yi çözer; ⛔ üretim imzası DEĞİŞİR Mİ, ölç
(c) child-process + sahte sistem saati → T-333 deseni; ⛔ DB'nin now()'ı DA kayar mı, ölç
```
⛔ **Seçimi ÖLÇÜMLE yap, tercihle değil** — ve seçmediklerini **neden** seçmediğini yaz.
⚠️ **`(c)` için özellikle:** Postgres `now()` sistem saatinden gelir; container'ın saati
child-process'in `TZ`/sahte saatinden **etkilenmez**. Bu bir **ölçüm sorusudur**, varsayım değil.

### `3.2` — ŞEKİL 1'in kopyası
`isoToday` **dört kez** yazılmış (`§2`). ⛔ Düzeltme onu **çoğaltmasın**: ya hepsi ölür
(sabit tarih), ya **tek bir yardımcıya** iner. `§2.7 #8`.

---

## 4 · DEMO-SEED — AYRI SORU, AYRI CEVAP (hüküm 18, `Z108 §1.1`)

```
HÜKÜM  demo-seed tenant-bugüne göre "İÇİNDE BULUNULAN ÇEYREĞİ" üretir  →  demo HEP CANLI
       ⛔ ürün-sahibi imzalı TUTAR TABLOSU SABİT — Σ 2.300.000, DOKUNULMAZ
```

> ### ⛔ VE İKİ TARAF **ZIT YÖNE** GİDER — bu bir çelişki değil, sınıfın kendisi:
> ```
> seed    GÖRELİ  (demo canlı kalsın)              ← VERİ kararı, DEĞİŞİR
> fixture SABİT   (sözleşme takvimden bağımsız)     ← DAVRANIŞ kararı, DEĞİŞMEZ
> ```

**[ÖLÇÜLMEDİ — ölçülecek] ve bu bir KARAR gerektirir, Team Lead'e gelir:**
```
1  seed BUGÜN nasıl dönem seçiyor?  budget-envelope seed'i · agreement.seed.ts · plan seed'i
   ⇒ SABİT string mi, türetilmiş mi — LİSTE
2  GÖRELİ hâle getirmek bir MIGRATION mı ister, yoksa yalnız SEED KODU mu değişir?
   ⛔ 1832 zaten canlı veriyi Q3'e taşıdı; göreli seed YENİDEN KURULUMDA devreye girer
   ⇒ mevcut canlı satırlar NE OLACAK — bu bir hükümdür, sen VERME, ÖLÇ ve SOR
3  ⛔ K-2.2.1b KESİŞME invaryantı: göreli üretim, çakışan aralık üretebilir mi
```
⛔ **Bu bölüm bu şeridin işi DEĞİL, bu şeridin ÖLÇÜMÜDÜR.** Seed'i değiştirme — **ölç ve
raporla**; kararı ürün sahibi verir.

---

## 5 · KAPANIŞIN TEK GERÇEK KANITI

> ### ⛔ Sistem saati **`2026-10-01`**'e alınmış bir koşum **YEŞİL** kalmalı.
> ### Bu yoksa, aynı bomba **yeniden kurulmuş** olur.

```
⛔ AYIRT EDİCİLİK ŞARTI (§2.7 #6):
   düzeltmeden ÖNCE aynı koşum KIRMIZI olmalı — yani BOMBAYI ÖNCE GÖR.
   [ÖLÇÜLMEDİ — ölçülecek]  bugün 2026-10-01'de kaç suite düşüyor? ⇒ REPRODÜKSİYON ÖNCE.
   "Altı" sayısı bir TAHMİNDİR ve bu task'ın listesi zaten bir kez YANLIŞ ÇIKTI.
```

📌 Ve bu, `Z83` doğum kuralının bu turdaki hâli: **bilinen-kırmızı** = 2026-10-01 koşumu
düzeltme öncesi · **bilinen-yeşil** = aynı koşum düzeltme sonrası.

---

## 6 · SINIRLAR (ZORUNLU)

```
⛔ ÜRÜN KODU  yalnız clock-injection GEREKTİRİYORSA ve GEREKÇESİYLE. Davranış DEĞİŞMEZ.
⛔ MIGRATION  YAZMA. Gerekiyorsa DUR → Team Lead → data-engineer (CLAUDE.md §3)
⛔ L2 / BRD   DOKUNMA. Kural metnini YALNIZ Team Lead yazar (CLAUDE.md §3)
⛔ HÜKÜM      Numarasız bir hüküm görürsen DUR — Team Lead'e gelir
⛔ DOĞRULAMA  izole `git worktree`'de. Paylaşılan ağaçta --fix / mutasyon / git checkout YOK
⛔ ÖLÇÜM      exit kodunu boruya SOKMA (§2.6) · `docker ps --filter
              "label=com.docker.compose.project=tpm"` → hayalet varsa DURDUR (§4.2 birinci madde)
```

---

## 7 · KAPANIŞ ÇIKTISI (bu başlıklarla raporla)

```
1  DÖRT ŞEKLİN taraması              — her biri SAYI DEĞİL LİSTE
2  2026-10-01 REPRODÜKSİYONU         — düzeltme ÖNCESİ kırmızı LİSTESİ
3  Düzeltme                          — dosya dosya, ne değişti
4  2026-10-01 KOŞUMU                 — düzeltme SONRASI yeşil
5  Tam kapı                          — tsc · guards · unit · e2e · T-047
6  DEMO-SEED ÖLÇÜMÜ (§4)             — üç soru, üç cevap, KARAR YOK
7  ⛔ NE ÖLÇEMEDİN                    — "ölçemedim" MEŞRU bir çıktıdır (kapının üçüncü hâli)
```

⛔ **Ve her iddian bir etiket taşısın** — bu brief'in sana uyguladığı kuralı **raporunda da**
uygula. `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ]`.
