# `DALGA-B` — BÜTÇE: **DÖNEM-ARALIĞI** + **UUID TEK TEMSİL** (`T-380` · `T-379`)

> Şerit: `backend-engineer` (+ `data-engineer` migration için) · Repo: `collmind.backend`
> ⛔ `DALGA-A` ile **PARALEL** koşar — dosyalar **ayrık**. Birleşme-anı: **tam-e2e TEK**,
> şema ↔ entity **aynı turda**.
> ⛔ Migration numarasını **`.claude/backlog/MIGRATION_SEQUENCE.md`'den Team Lead tahsis eder** —
> ajan **kendi numarasını SEÇMEZ**. Numara yoksa **DUR ve iste**.

## 0 · Bağlayıcı kaynaklar
`docs/brd-v2/04_KARAR_KAYDI.md` → `Z102` · `Z103` · **`Z105`** (hüküm 12/14)
`docs/brd-v2/03_IS_KURALLARI/L2_01_*.md` → **`K-2.2.1`** · `K-2.2.3` · **`K-2.2.3a`** · `K-2.2.14`
`.claude/backlog/tasks/` → **`T-379`** · **`T-380`** · `T-375` · `T-382`
`CLAUDE.md` · `docs/DISIPLIN.md` — ikisi de **BAĞLAYICI**

## 1 · ⛔ ÖNCE OKU: BU DALGA BİR **HÜKÜM KAYBINI** ONARIYOR

Dönem-aralığı hükmü bir gün **önce** verilmişti ve **hiçbir belgeye taşınmamıştı**
(`grep period_from docs/ .claude/` → **sıfır**). Team Lead boşluğu tanımsızlık sandı ve yerine
`period='2026-04'` + yıl-`LIKE` fallback'i koydu — **bulanık bir eşleşme TAŞIYICI oldu**
ve `T-380` (sessiz tie riski) **oradan doğdu**. Tam hikâye: **`Z105 §1`**.

> ### Bu yüzden bu dalgada bir şey **özellikle** yasak: bir noktada belirsizlik görürsen
> ### **kendi kararını koyma** — önce sor: *"bu noktada bir HÜKÜM var mı, nerede yazılı?"*

## 2 · İŞ 1 — `T-380`: ZARF DÖNEMİ BİR **ARALIKTIR** (hüküm 12)

```
period_from / period_to      KAPSAYICI, 'YYYY-MM'         Q2 = 2026-04 .. 2026-06
eşleşme                      işlem-dönemi ∈ [from, to]
⛔ period LIKE 'YYYY%' fallback'i   ÖLÜR
tie                          YAPISAL OLARAK İMKÂNSIZ:
                             aynı kategori + kanal için aralıklar KESİŞEMEZ
```

⛔ **Kesişme kısıtı — `EXCLUDE` mi `CHECK`+uygulama mı: ÖLÇÜMLE seç.**
`EXCLUDE USING gist` bir uzantı (`btree_gist`) ister — **kurulu mu, ÖLÇ**; kurulu değilse
kurmak bir **karar**dır, sessizce yapılmaz. Alternatif: uygulama katmanında + kısmi
benzersizlik. ⛔ Hangisi olursa olsun **kanal `NULL`** (tanımlı-wildcard) durumu **düşünülmüş**
olmalı — `K-2.2.8c` dersi: **kısmi-tuple eşitliği**, `NULLS NOT DISTINCT`.

⭐ **Ve bu model iki şeyi GEREKSİZ KILAR** (`Z105 §2`): tie'da açık hata **gerekmez** (tie
doğamaz), 96 aylık zarf **gerekmez** (bir aralık çeyreği ifade eder). ⛔ Yani doğru model bir
kuralı **uygulamak** yerine **ortadan kaldırıyor** — bu turda *"tie'da ne olacak"* diye bir
dal yazarsan **modeli yanlış kurmuşsun** demektir.

**Göç:** bugünkü 8 zarf `period='2026-04'` taşıyor. Aralığa taşınırken **hangi aralık** —
⛔ `Q2 = 2026-04..2026-06` hükmü var, **uydurma**. `fiscal_year` ile ilişkisini **ölç**.

⛔ **`K-2.2.1`'e `F12`** — dördüncü ölçümlü düzeltme. Metni **Team Lead yazar**
(`CLAUDE.md §3`: `L2_*` tek yazar **ve** tek kanal). Sen **ölçümü** ver: kolon şekli, tüketici
listesi, göç kararı. ⛔ **`docs/brd-v2/**` YAZMA.**

## 3 · İŞ 2 — `T-379`: TEK TEMSİL **UUID**, VE `0/GREEN`'İN ÖLÜMÜ (hüküm 14)

```
kimlik    UUID          — ad DOĞRUYU söyler (categoryId → gerçekten bir id)
kod       insan-etiketi — anlaşma-kodu ÖMÜR-BOYU-TEKİL ama KİMLİK DEĞİL
backend   `id`'ye geçer
```

⛔ **`İlke 1`'e ÇARPMAZ, ve gerekçesi ölçülmüş:** bu bir esneklik değil, bir **CANLI YANLIŞ** —
frontend UUID gönderiyor (`STAAgreementForm.tsx:197` · `:487` `cat.id`), backend **kod**
bekliyor (`budget.controller.ts:234` · `budget.repository.ts` `envelope.category = :category`),
⇒ **hiç eşleşmiyor** ⇒ `budget.service.ts:1713-1721` **sessizce `0 / GREEN`** dönüyor.

> ### Bir **finansal ekranda** *"bütçe rahat"* yazıyor ve o cümlenin kaynağı bir **eşleşmeme**.
> ### Sessiz-yeşilin en tehlikeli türü.

**İki iş, ikisi de zorunlu:**
1. **Tek temsile in** — çağrı yerleri ⛔ **LİSTE** olarak (`T-373` deseni: elle sayma,
   mümkünse **derleyiciye saydır** — `Z103`'te tip zorunluluğu bunu yaptı ve **on birinci
   elle-sayı hatasını** önledi).
2. ⛔ **`"zarf yok"` → `UNMEASURABLE` / AÇIK HATA** (üç-çıktı yasası: *geçti · kaldı ·
   **ölçemedim***). `K-2.2.14`: zarf bulunamadığında işlem **sessizce geçmez**.

⛔ **Frontend değişikliği gerekiyorsa `collmind.frontend` AYRI BİR ŞERİTTİR** — bu brief
backend'dir. Gerekeni **ölç ve raporla**, kendin yapma.
⚠️ Ölçek büyükse **iki dalga** — ⛔ **yön değişmez** (ürün-sahibi kaydı).

## 4 · ⛔ REPRODÜKSİYON-ÖNCE, İKİSİ İÇİN DE
```
T-380  aynı kategori + 2026'nın İKİ ayı için iki zarf kur → SESSİZ SEÇİMİ GÖR
       (görülmezse teşhis çürür — T-273 dersi; ve o da bir sonuçtur)
T-379  gerçek bir çağrıyla 0/GREEN'i GÖR (backend ayağa kalkar)
```

## 5 · ⛔ DUR / KURALLAR
- **`DALGA-A`'nın dosyalarına DOKUNMA:** `agreement.service.ts` · `agreement.repository.ts` ·
  `plan.repository.ts` · `common/date/*` · `lta-agreement.*` · `*-validation.service.ts`'in
  tarih guard'ları. Çakışma görürsen **DUR ve bildir**.
- `docs/brd-v2/**` **YAZMA**. Yeni task **AÇMA** — mevcutlara yaz.
- `Z100` migration şablonu bağlayıcı · `Z87` NULL-collapse (`CASE`/`ELSE FALSE`) ·
  her `CHECK`'in negatif kontrolünde bir **`NULL` girdi** vakası **zorunlu**.
- Reprodüksiyon-önce, **yönsüz** · mutasyonda kopya + satır **BAS** + `shasum` (⛔ `git checkout` yok).
- Ölçüm **borusuz** · ilk komut hayalet-konteyner kontrolü · `git commit`/`push` **YOK**.
- ⛔ **Doğrulamanı izole bir `git worktree`'de yap** — `DALGA-A` **aynı ağaçta** koşuyor.
- ⛔ Belirsizlikte **DUR** — ve *"Team Lead kararı"* yazmadan önce **hükmü ara** (`Z105 §1`).

## 6 · Doğrulama
`tsc 0` · `guards 0` · `npm test 0` · `npm run test:e2e 0` · `[T-047 invariant]` **birebir** ·
`run→revert→run` bayt-birebir · kesişme kısıtının **pozitif + negatif + `NULL`** kontrolü.
⛔ **Rapor SAYI değil LİSTE.**
