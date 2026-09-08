# `DALGA-A` — AGREEMENT / TARİH (`1830` · `T-383` · `T-378`)

> Şerit: `backend-engineer` (+ `data-engineer` migration için) · Repo: `collmind.backend`
> ⛔ `DALGA-B` ile **PARALEL** koşar — dosyalar **ayrık**. Birleşme-anı kuralı:
> **tam-e2e TEK**, şema ↔ entity **aynı turda**.
> Migration **`1830000000000`** (tahsisli). ⛔ Kendi numaranı SEÇME.

## 0 · ⛔ HÜKÜM-ATIF KURALI (ürün sahibi, 2026-09-07)

**Bu brief'teki her hüküm bir `Z`-numarası taşır.** Bir yerde *"hüküm"* diyen ama `Z`-atfı
olmayan bir cümle görürsen ⛔ **DUR** — uygulama, Team Lead'e bildir.
Gerekçe: `Z105 §1` — bir hüküm belgeye geçmediği için bir dalga onu **kaybetti** ve yerine bir
*"Team Lead kararı"* doğdu. **Atıfsız hüküm, kaybolmuş hükmün habercisidir.**

```
hüküm 11  "bugün" = tenant saat dilimi           Z104 §1
hüküm 13  kalıcı kimlikler: geçmiş DEĞİŞMEZ      Z105 §3
hüküm 15  iki paralel dalga · T-378 ≡ 1830       Z105 §5
```

## 0.1 · Bağlayıcı kaynaklar
`docs/brd-v2/04_KARAR_KAYDI.md` → **`Z102`** · **`Z103`** · **`Z104`** · **`Z105`** (hüküm 13/15)
`docs/brd-v2/03_IS_KURALLARI/L2_01_*.md` → `K-2.2.1` · `K-2.2.3a` · `K-2.2.3b` · `K-2.2.16`
`.claude/backlog/tasks/` → `T-375` · **`T-378`** · **`T-383`** · `T-382`
`CLAUDE.md` · `docs/DISIPLIN.md` — ikisi de **BAĞLAYICI**

## 0.2 · ⛔ ORTAM DEĞİŞTİ — BU BRIEF `Z107` + `Z108` SONRASI GÜNCELLENDİ (2026-09-08)

Bu brief `DALGA-B` ile **paralel** koşmak üzere yazılmıştı. `DALGA-B` **indi ve push edildi**;
ardından `Z107` (demo Q3) ve `Z108` (üç hüküm) geldi. ⛔ **Aşağıdakiler artık VARSAYIM DEĞİL,
ORTAMDIR** — brief'in eski metnini bunlara göre oku:

```
[ÖLÇÜLDÜ: backend fcfef5c · origin/staging]
  zarflar         period_from '2026-07' … period_to '2026-09'   (aralık modeli CANLI, 1831/1832)
  period LIKE     ÖLDÜ — tek kaskad, aralık eşleşmesi
  manager         findEnvelopeByDimensions(Strict) artık manager? ALIYOR
  e2e tabanı      64 suite / 887 test · unit 87 / 1547 · tsc 0 · guards 0 · T-047 PASS
  MIGRATION       sıradaki boş numara 1833 — ⛔ AMA BU ŞERİDİN NUMARASI HÂLÂ 1830 (tahsisli)
```

⛔ **VE `DALGA-B` ARTIK PARALEL DEĞİL — İNDİ.** `§6`'nın *"`DALGA-B`'nin dosyalarına DOKUNMA"*
yasağı **kalkmadı ama SEBEBİ DEĞİŞTİ**: çakışma riski değil, **`§7.1` riski**. O dosyalar
`Z107`'de üç blocker üretti; dokunuyorsan **kardeş yolları SAY**.

⛔ **VE `§6`'nın *"izole worktree"* şartı DURUYOR** — sebebi yine değişti: `T-385` şeridi
**aynı ağaçta** koşuyor (`test/` altında).

### ⛔ YENİ İŞ — `İŞ 5`: `manager` **TİP KAPISI** (hüküm 19 · `Z108 §2`)

`T-387 🟡-5` bir **karar** bekliyordu; ürün sahibi verdi: **TİP KAPISI.**

```
karar    manager: EntityManager   ⛔ OPSİYONEL DEĞİL
gerekçe  "disiplin" = BİR ÇAĞIRAN UNUTUR — ve UNUTTU DA: sekiz kardeşten biri
çizgi    "kapı tek noktada, TİP onu zorlar"
         emsaller: SKUContext markası · toFiniteNumber · targetRoi çözümleyicisi
emsal    T-322 — NotificationRepository tx-manager'ı almıyordu → ROLLBACK-ARTIĞI doğdu
         ⇒ sınıf YENİ DEĞİL; Z107'nin P1 bulgusu onun İKİNCİ vakasıydı
```

**ŞEKİL (bağlayıcı):**
```
tx-içi okuma yapabilen HER repository metodu  →  manager: EntityManager  ZORUNLU
tx-DIŞI çağıranlar                            →  AÇIKÇA this.dataSource.manager geçer
                                                 ⛔ YAZILI — sessiz-default DEĞİL (§2.5)
zorlayan                                      →  DERLEYİCİ
mutasyon-kanıtı                               →  bir çağıranda parametre SİLİNİR → tsc KIRMIZI
```
📌 `Z83` doğum kuralı burada **gerekmez**: bu bir guard değil bir **tip** —
bilinen-kırmızısı **derleyicinin kendisi**, bilinen-yeşili `tsc 0`.

⛔ **ÖNCE EVREN, SONRA DEĞİŞİKLİK** (`§7.1`):
```
[ÖLÇÜLMEDİ — ölçülecek]  "tx-içi okuma YAPABİLEN repository metodu" kaç tane?
   ⇒ ŞARTI ÖNCE TANIMLA, sonra tara. ⛔ DISIPLIN: "bir TANIMIN evreni, tanımın
     ŞARTIYLA seçilemez" — 'manager alanlar' diye tarama, o SONUÇ değil GİRDİ olur.
[ÖLÇÜLDÜ: Z107 turu]  budget.repository'de sekiz kardeş metot manager ALIYORDU,
   findEnvelopeByDimensions(Strict) ALMIYORDU ⇒ bu tur ikisine de eklendi (OPSİYONEL olarak)
[ÖLÇÜLDÜ: T-387 🟡-4]  checkEnvelopeAvailability (budget.service.ts:1491-1502) HÂLÂ
   manager'sız çağırıyor ⇒ checkPlanBudgetAvailability transaction-KÖR
[ÖLÇÜLMEDİ — ölçülecek]  aynı ŞEKİL başka repository'lerde var mı — agreement · plan ·
   ledger · notification (T-322'nin dosyası!) ⇒ SAYI DEĞİL LİSTE
```

⚠️ **Ve `envelopeFound?: boolean` AYNI ŞEKLİN İKİNCİ ÜYESİ** (`budget-availability-message.ts:55,61`):
üretici bir dalda yazmayı unutursa *"zarf YOK"* sessizce *"zarf var, yetersiz"* olur ve
`K-2.2.14` mesajı **kaybolur**. ⛔ **Aynı hamle ona da uygulanır** — `envelopeFound: boolean`.

⛔ **KAPSAM SINIRI:** `T-387`'nin diğer maddeleri (`🟡-1` `23P01` üçüncü üretici · `🟡-2`
DTO format · `🟡-3` pin) **BU ŞERİDİN İŞİ DEĞİL** — `T-387` kendi turunda kapanır. Burada
**yalnız `🟡-5`** (+ `🟡-4`, çünkü aynı imzadan geçiyor). Ayrılamıyorsa **DUR ve bildir**.

### ⛔ VE BU BRIEF `Z108 §3` (HÜKÜM 20) ALTINDADIR

**Her iddia bir etiket taşır:** `[ÖLÇÜLDÜ: <kaynak>]` ya da `[ÖLÇÜLMEDİ — ölçülecek]`.
Etiketsiz bir iddia görürsen ⛔ **DUR ve brief'i İADE ET.**
⚠️ **Bu brief'in `§1`–`§5`'i hüküm 20'den ÖNCE yazıldı** — oradaki dosya:satır listeleri
`Z104` review'ında **ölçülmüştür** (`[ÖLÇÜLDÜ: T-383 task dosyası, code-reviewer 2026-09-07]`),
ama **TARİHLİDİR**: `DALGA-B` o dosyalardan bazılarına dokundu. ⛔ **Her satırı YENİDEN doğrula**
— `DISIPLIN`: *"ölçüm ortamının bayatlığı da bir maskeleme sınıfıdır."*
**Kendi raporunda da etiket kullan.**

## 1 · ⛔ ÖNCE: BU DALGANIN İLK İŞİ BİR **EVREN TANIMI**, BİR LİSTE DEĞİL

`DISIPLIN`: *"Bir liste vermek, evreni tanımlamak değildir."* Bu kural **`T-383`'ün kendisinden**
doğdu ve şimdi **onu kapatan tura** uygulanıyor. Listeden **ÖNCE** iki satır yazılır:

```
"bugün" / "şu an" kaç FARKLI ŞEKİLDE sorulabilir?   ← şekilleri ADLANDIR
her şekil için tarama deseni nedir?                  ← her desen AYRI ölçülür
```

Bilinen üç şekil (⛔ **bunlar bir başlangıç, bir sınır DEĞİL** — dördüncüyü ara):
```
ŞEKİL 1  new Date() + takvim alanı (getFullYear/getMonth/getDate)
  plan.repository:401-402      generatePlanCode      → PLAN-<yıl>-Q<çeyrek>  ⛔ KALICI KİMLİK
  agreement.repository:275     generateAgreementCode → <tip>-<yıl>           ⛔ KALICI KİMLİK
  dashboard.service:411        period='ALL'          → <yıl>-01-01..12-31    ⛔ FİNANSAL PENCERE
ŞEKİL 2  new Date() + setHours + KARŞILAŞTIRMA
  off-invoice-validation:203-204  \  ⛔ KELİMESİ KELİMESİNE KOPYA
  on-invoice-validation:241-242   /     → SUNUCU-yerel `today` ↔ UTC-parse `invoiceDate`
ŞEKİL 3  new Date() → DB KARŞILAŞTIRMASI
  lta-agreement.service:447/457/547 → repository:112-114  `effectiveDate <= :date`
  ⇒ takvim sınırı DB OTURUM TZ'sine düşer — ÜÇÜNCÜ taban
  lta-agreement.controller:187  `date ? new Date(date) : new Date()`  ← ÖLÇ: anlık mı, takvim mi
```
⛔ **Rapor SAYI değil LİSTE**: her yer, **hangi şekil**, **meşru mu kaçak mı**, ve *"meşru"*
diyorsan **neden** (TZ'den bağımsız by construction mı?).

## 2 · İŞ 1 — `T-383`: KAÇAK OLANLAR TENANT-TZ TABANINA (**hüküm 11** · `Z104 §1`)

`tenantTodayIsoDate` / `calendarDayFromDateOrInstant` zaten var (`common/date/local-today.ts`,
`Z104`). ⛔ **Yeni yardımcı AÇMA** — `common/date/` altındakileri **ölç ve kullan**.

⛔ **`off-invoice` / `on-invoice` validation'daki KOPYA guard tek mekanizmaya iner**
(`§2.7 #8`: *kopya, orijinaldeki regresyonu görmez — ikisi birlikte bozulur*).

**Pin:** `T-333` harness'i (child-process, üç `TZ`). ⛔ **Emsali BUL ve YENİDEN KULLAN**
(`excel-serial-date.spec.ts` / `local-today.spec.ts`), üçüncü kopya yazma.
⚠️ Ve `Z104 §4`'ün ölçülmüş sınırını bil: sınır anında sunucu TZ'si tenant TZ'siyle
çakışırsa mutant **tesadüfen doğru** günü üretir — **tek bir sabit an ile üç zone'u aynı anda
ayırt eden bir instant YOKTUR.** Pinin sınırını **yaz**, gizleme.

## 3 · İŞ 2 — KALICI KİMLİKLER (**hüküm 13** · `Z105 §3`)

```
yeni üretim   TENANT gününden türer
geçmiş kod    ⛔ DEĞİŞMEZ — yeniden-adlandırma turu AÇILMAZ (kod bir KİMLİKTİR,
              referanslarıyla yaşar; append-only ruhu, K16 ailesi)
```
⛔ **VE ÖLÇÜM ZORUNLU:** üretilmiş kodlarda **yanlış-yıl var mı** — **SAYILIR**.
Beklenti sıfır (`plans` 2 · `agreements` 5, hepsi Ağustos–Eylül; pencere yalnız
**31 Aralık 21:00–24:00 UTC**) — ⛔ ama *"muhtemelen sıfır"* **YAZILMAZ**, sorgu **koşulur**.
Varsa: `F12` notu (*"kod `X`, üretim-anı `Y`, tenant-günü `Z` olmalıydı"*), **değiştirilmez**.

## 4 · İŞ 3 — `1830`: `agreements.category_id` **`NOT NULL`** (**hüküm 15** · `Z105 §5`; sıra `Z98 §3`)

`tanım → yazar → kısıt`'ın son halkası. Yazar (`CreateAgreementDto.categoryId` zorunlu) **indi**
(`Z103`); kısıt bu turda gelir. `Z100` şablonu bağlayıcı: üç-durum assert · şema-nitelendirme
(`main`) · `run→revert→run` bayt-birebir · **şema ↔ entity aynı turda**.

## 5 · İŞ 4 — ⛔ `T-378` İLE `1830` **AYNI SORUDUR** (**hüküm 15** · `Z105 §5`)

`agreement.service.ts:337` (`T-028e`) bir zamanlar şunu yasaklıyordu: *"**DO NOT backfill**
`agreements.category_id` — a copied value goes **stale** the moment the FU's category
assignment changes upstream."* `1828` onu yaptı; `Z102 §4` gerekçeyi düzeltti
(**beyan ≠ kopya**, `K-2.2.3b` çapraz-doğruluyor). Ama **bayatlama riski durdu**.

⛔ **Bu turda karara bağlanacak tek soru:**
```
FU YENİDEN SINIFLANDIRILIRSA resolver ne yapar?
  (a) CANLI TÜRETİM  — kategori her okumada fu → gu → category'den türer (saklanan yalnız BEYAN)
  (b) SAKLI          — saklanan değer geçerlidir; sapma bir KAPIYLA görünür kılınır
```
⛔ Ve `resolveEffectiveCategoryId`'nin **FU-fallback'i**: `1830` (`NOT NULL`) indikten sonra
**ulaşılamaz** hâle gelir mi — **ÖLÇ**. Ulaşılamazsa *"mekanizma var, yol yok"* sınıfının yeni
üyesidir: **gerekçesiyle ÖLDÜR**, ya da onu yaşatan yolu **göster**. Yeni task **AÇMA**,
`T-378`'e yaz.

**Sapma tespiti (kapı adayı):** `agreements.category_id ≠ fu → gu → category` olan satırlar.
⛔ Bir kapı doğacaksa **`Z83` doğum kuralı**: **bilinen-yeşil VE bilinen-kırmızı** üretilmeden doğmaz.

## 6 · ⛔ DUR / KURALLAR
- **`DALGA-B`'nin dosyalarına DOKUNMA:** `budget.repository.ts` · `budget.service.ts` ·
  `budget.controller.ts` · `budget-envelope.*` · zarf dönem/kategori temsili.
  Çakışma görürsen **DUR ve bildir**.
- `docs/brd-v2/**` **YAZMA** (yalnız Team Lead). Yeni task **AÇMA** — mevcutlara yaz.
- Reprodüksiyon-önce, **yönsüz** · mutasyonda kopya + `sed -n '<n>p'` ile satır **BAS** +
  `shasum -a 256 -c` (⛔ `git checkout` **YASAK**) · kırmızı bir **assertion** olmalı.
- Ölçüm **borusuz**: `cmd > log 2>&1; echo $?`. İlk komut: hayalet-konteyner kontrolü.
- ⛔ **Doğrulamanı izole bir `git worktree`'de yap** — `DALGA-B` **aynı ağaçta** koşuyor;
  paylaşılan ağaçta `--fix`/mutasyon/`git checkout` **çalıştırma**.
- `git commit` / `git push` **YOK**. Belirsizlikte **DUR**.
- ⛔ Bir *"Team Lead kararı"* yazmadan önce sor: **"bu noktada bir HÜKÜM var mı, nerede yazılı?"**
  (`Z105 §1` — bu dalganın doğuş sebebi.)

## 7 · Doğrulama
`tsc 0` · `guards 0` · `npm test 0` · `npm run test:e2e 0` · `[T-047 invariant]` **birebir** ·
`run→revert→run` bayt-birebir. ⛔ **Rapor SAYI değil LİSTE.**
