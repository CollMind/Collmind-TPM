# `DALGA-B` — **KOD YARISI**: aralık eşleşmesi + `LIKE`'ın ölümü + UUID tek temsil

> Şerit: `backend-engineer` · Repo: `collmind.backend`
> ⛔ Şema yarısı (`1831`) **İNDİ** — bu tur onun üstüne gelir.

## 0 · ⛔ HÜKÜM-ATIF KURALI (ürün sahibi, 2026-09-07)
Bu brief'teki her hüküm bir `Z`-numarası taşır. `Z`-atfı olmayan bir *"hüküm"* cümlesi görürsen
⛔ **DUR**, Team Lead'e bildir. Gerekçe `Z105 §1`: bir hüküm belgeye geçmediği için bir dalga
onu **kaybetti** ve yerine bir *"Team Lead kararı"* doğdu — **bu dalga onun onarımıdır.**
```
hüküm 12  zarf dönemi bir ARALIKTIR            Z105 §2
hüküm 14  tek temsil UUID · 0/GREEN ölür        Z105 §4
hüküm 15  iki paralel dalga                     Z105 §5
```

## 0.1 · Bağlayıcı
`Z102` · `Z103` · **`Z105`** · `L2_01_*.md` → `K-2.2.1` · `K-2.2.2` · `K-2.2.3` · `K-2.2.3a` ·
`K-2.2.14` · `T-379` · `T-380` · `CLAUDE.md` · `docs/DISIPLIN.md` (⛔ **son dört kural yeni**) ·
`docs/process/DALGA_B_BUDGET_ARALIK_BRIEF.md` ·
⛔ **`src/database/migrations/1831000000000-BudgetEnvelopePeriodRange.ts`'in DOSYA BAŞI
YORUMU** — tüketici listesi ve `F8` gerekçesi orada, **oku**.

## 1 · Devraldığın durum (Team Lead bağımsız doğruladı)
```
period_from / period_to   varchar(7) NOT NULL · KAPSAYICI · format+sıra CHECK
çakışma TRIGGER'ı          (tenant_id, category, channel, spend_type) NULL-güvenli tuple'ında
                           aralıklar KESİŞEMEZ
8 kategori zarfı           2026-04 .. 2026-06     2 CLOSED legacy: tek-aylık (literal)
eski `period` kolonu       KALDI — tüketicileri henüz taşınmadı (bu turun işi)
btree_gist                 mevcut ama KURULU DEĞİL · app_migrate DB-CREATE yetkisi YOK
                           ⇒ EXCLUDE İMKÂNSIZDI, trigger ölçümle seçildi

kapılar   tsc 0 · guards 0 · unit 87/1547 · T-047 PASS
e2e       1 suite / 9 test KIRMIZI — budget-envelope-split.e2e-spec.ts
          ⛔ SENİN İŞİN DEĞİL (fixture, `qa` şeridine gidecek) ama BİLMEN gerek:
          createFreshUnsplitEnvelope 9 vakada AYNI tuple'ı kullanıyor ⇒ hüküm 12 onu
          DOĞRU ŞEKİLDE reddediyor. ⛔ Sen bu 9'un ÜSTÜNE yeni kırmızı eklememelisin —
          raporunda kırmızıyı SINIFLA (bilinen 9 · senin getirdiğin N).
```

## 2 · İŞ 1 — EŞLEŞME ARALIĞA GEÇER, `LIKE` **ÖLÜR** (hüküm 12)

`budget.repository.ts#buildDimensionQuery` bugün:
```sql
(envelope.period = :periodMonth OR envelope.period LIKE :yearPattern)   -- '2026%'
```
Yeni: **`:periodMonth BETWEEN envelope.period_from AND envelope.period_to`** (kapsayıcı).
⛔ **`LIKE` fallback'i SİLİNİR** — `Z105 §2`: *bulanık bir eşleşme taşıyıcı olamaz.*

⛔ **Ve sıralama anahtarını yeniden düşün:** bugünkü `CASE WHEN period = :periodMonth THEN 1
ELSE 2 END` bir **yakınlık** anahtarıydı; aralıkta **tam eşleşme** kavramı yok. Kaskadın
(`K-2.2.3a`) kanal kademeleri korunur; dönem artık bir **filtredir**, bir sıralama ölçütü değil.
⛔ Ve **tie doğamaz** (trigger yapısal olarak engelliyor) — ⭐ **turda *"tie'da ne olacak"* diye
bir dal yazıyorsan modeli yanlış kurmuşsundur** (`Z105 §2`).

## 3 · İŞ 2 — ⛔ TRIGGER FALLBACK'İ **KALDIRILIR** (Team Lead şartı)

`1831`'in trigger'ı bugün şunu taşıyor:
```sql
IF NEW.period_from IS NULL THEN NEW.period_from := NEW.period; END IF;
IF NEW.period_to   IS NULL THEN NEW.period_to   := NEW.period; END IF;
```
Şema turu bunu **kapsam-dışı çağrı yerlerini kırmamak için** yazdı ve `DISIPLIN`'in *"fallback,
birincil kaynak yoksa meşrudur"* maddesine dayandırdı. ⛔ **Ama o maddenin sınırı var:**
*"birincil kaynak GERÇEKTEN okunamıyor olmalı."* Burada okunamaz değil — çağıran **henüz
göndermiyor**. Yani bu **geçici** bir fallback ve iki riski var:
```
1  SESSİZ GENİŞLEME  period_from göndermeyi UNUTAN bir çağıran sessizce TEK AYLIK zarf yaratır
                     — finansal yolda §2.5; ve hata GÖRÜNMEZ
2  KALDIRILMASINI ZORLAYAN HİÇBİR ŞEY YOK   "hiç devreye girmiyor" tam da GÖZLEMLEYEMEDİĞİMİZ
                     durum ⇒ sonraki okuyucu onu KASITLI sanar (T-084 sınıfı)
```
**Yapılacak:** ⛔ **çağrı yerlerini `period_from`/`period_to` gönderecek şekilde taşı, sonra
fallback'i KALDIR** — ve *"hiçbir çağıran ona dayanmıyor"*u **kanıtla** (yazan yolların
LİSTESİ + fallback kaldırılmış hâlde yeşil kapılar). Fallback'in kaldırılması bir **migration**
gerektiriyorsa **DUR ve numara iste** — ⛔ kendi numaranı **SEÇME**.

## 4 · İŞ 3 — TÜKETİCİLER (şema turunun ÖLÇTÜĞÜ liste — ⛔ YENİDEN ÖLÇ, bayatlamış olabilir)

```
budget.repository.ts:212,277,282,330,335    LIKE fallback + tie-break        ⇒ ARALIĞA
budget.service.ts:218,1904                  create fallback + DTO çıktı
budget-summary.view-entity.ts + 3 migration `v_budget_summary` `be.period` SEÇİYOR
                                            ⛔ VIEW değişikliği = MIGRATION ⇒ DUR, numara iste
agreement-transaction.controller.ts:238     DTO çıktı
finance-reporting.service.ts:253,266,1416,1507,1533
   ⛔ `envelope.period >= :startPeriod AND <= :endPeriod`
   ⇒ BİR NOKTA SÜTUNUNU BİR ARALIKMIŞ GİBİ SORGULUYOR — ZATEN YANLIŞ, canlı
   ⇒ aralık modeli bunu ONARIR. ⛔ "Zaten yanlıştı" bir NOT olarak bırakılmaz: DÜZELT,
     ve ÖNCE/SONRA davranışını yaz (bir düzeltme de bir iddiadır)
seeds/index.ts · seeds/test-happy-path.ts   envelope eşleştirme
```
⛔ **`period` kolonunun DÜŞÜRÜLMESİ BU TURUN İŞİ DEĞİL** — tüketiciler taşındıktan sonra
**ayrı bir migration**. Bu turda `period` **yazılmaya devam eder** (`F8` bilinçli ve geçici,
gerekçesi `1831`'in dosya başında).

## 5 · İŞ 4 — `T-379`: TEK TEMSİL **UUID** + `0/GREEN`'İN ÖLÜMÜ (hüküm 14)

```
kimlik  UUID          — ad DOĞRUYU söyler (categoryId → gerçekten bir id)
kod     insan-etiketi — anlaşma-kodu ömür-boyu-tekil ama KİMLİK DEĞİL
```
⛔ **`İlke 1`'e ÇARPMAZ** — bu bir esneklik değil, **canlı yanlış**: frontend UUID gönderiyor
(`STAAgreementForm.tsx:197` · `:487` `cat.id`), backend **KOD** bekliyor
(`budget.controller.ts:234` · `envelope.category = :category`) ⇒ **hiç eşleşmiyor** ⇒
`budget.service.ts:1713-1721` sessizce **`0 / GREEN`** dönüyor.

**İki iş, ikisi de zorunlu:**
1. Tek temsile in — çağrı yerleri ⛔ **LİSTE** olarak; mümkünse **derleyiciye saydır**
   (`Z103` deseni: tip zorunluluğu **on birinci elle-sayı hatasını** önledi).
2. ⛔ **`"zarf yok"` → `UNMEASURABLE` / AÇIK HATA** (üç-çıktı yasası; `K-2.2.14`).
⛔ **Frontend AYRI ŞERİTTİR** — gerekeni **ölç ve raporla**, `collmind.frontend`'e dokunma.
⚠️ Ölçek büyükse **DUR ve bildir**: iki dalgaya bölünür, ⛔ **yön değişmez** (`Z105 §4`).

## 6 · ⛔ REPRODÜKSİYON-ÖNCE (yönsüz)
```
LIKE'ın ölümü   aynı kategoride 2026'nın BAŞKA bir ayına ait bir arama, ESKİ kodda
                yanlış zarfa düşüyor mu — GÖR (görülmezse teşhis çürür, T-273)
T-379           gerçek bir çağrıyla 0/GREEN'i GÖR (backend ayağa kalkar)
finance-report  nokta-sütun aralık sorgusunun yanlış sonucunu GÖR
```

## 7 · ⛔ DUR / KURALLAR
- **`DALGA-A`'nın dosyalarına DOKUNMA:** `agreement.service.ts` · `agreement.repository.ts` ·
  `plan.repository.ts` · `common/date/*` · `lta-agreement.*` · `*-validation` tarih guard'ları.
- **Test dosyalarına DOKUNMA** — `qa` şeridinin işi. Kırılan olursa **sınıfla ve raporla**.
- `docs/brd-v2/**` **YAZMA** — `K-2.2.1` `F12` metnini **Team Lead** yazar; sen **ölçümü** ver.
- ⛔ **Migration numarası ALMA** — gerekirse **DUR ve iste** (`v_budget_summary` VIEW'ı ve
  fallback kaldırma muhtemelen gerektirir).
- Reprodüksiyon-önce · mutasyonda kopya + satır **BAS** + `shasum` (⛔ `git checkout` yok) ·
  ölçüm **borusuz** · ilk komut hayalet-konteyner kontrolü · `git commit`/`push` **YOK**.
- ⛔ Bir *"Team Lead kararı"* yazmadan önce sor: **"bu noktada bir HÜKÜM var mı, nerede yazılı?"**
- ⛔ **Rapor SAYI değil LİSTE**; e2e kırmızısını **bilinen 9 / senin getirdiğin N** diye **sınıfla**.
