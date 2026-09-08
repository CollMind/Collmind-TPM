# `DALGA-B` — **qa TURU**: iki `DUR`'un test tarafı + kırmızının kapanışı

> Şerit: `qa-engineer` · Repo: `collmind.backend`
> ⛔ Bu tur **iki `DUR`'u açar** — kod turu onları test dosyalarına dokunamadığı için
> düzeltmeyi **geri almak zorunda kaldı**. Yani bu turun çıktısı, bir sonraki kod turunun
> **ön şartıdır**.

## 0 · ⛔ HÜKÜM-ATIF KURALI
`Z`-atfı olmayan bir *"hüküm"* cümlesi görürsen ⛔ **DUR** (`Z105 §1`).
```
hüküm 12  zarf dönemi bir ARALIKTIR        Z105 §2
hüküm 14  tek temsil UUID · 0/GREEN ölür    Z105 §4
K-2.2.14  zarf bulunamazsa SESSİZCE GEÇİLMEZ — "tek bir BİLDİRİLMİŞ POLİTİKA"
```

## 1 · Devraldığın durum
Şema (`1831`) + kod yarısı indi (**commit edilmemiş** — senin **TABANIN**, geri alma).
```
tsc 0 · guards 0 · unit 87/1547 · T-047 PASS
e2e  1 suite / 9 test KIRMIZI — budget-envelope-split.e2e-spec.ts
     ⛔ kod turu bu 9'un ÜSTÜNE yeni kırmızı EKLEMEDİ (ölçüldü)
```

## 2 · İŞ 1 — 9 KIRMIZI: `createFreshUnsplitEnvelope` AYNI TUPLE'I TEKRAR KULLANIYOR

Şema turunun ölçümü: yardımcı **9 vakada** aynı
`(category='E2E-SPLIT-DEFAULT', channel='E2E-SPLIT-CHANNEL', period='2026-01', spend_type=NULL)`
tuple'ını kullanıyor; yalnız `code` benzersiz. **Hüküm 12** (aralıklar kesişemez) bunu artık
**DOĞRU ŞEKİLDE** reddediyor.

⛔ **Bu bir kusur değil, hükmün BEKLENEN sonucudur** — testi *"yeşile döndürmek"* için hükmü
gevşetme. Yardımcıya **benzersiz bir `category`** ver (`code`'un zaten yaptığı gibi).
⛔ Ve her düzeltmede sor: *"bu testin AYIRT ETME GÜCÜ hâlâ duruyor mu?"* (`§2.7 #6`).

## 3 · İŞ 2 — ⛔ `DUR 1`'İN AÇILMASI: `on-invoice.service.spec.ts`'in HAM `INSERT`'ü

Kod turu trigger fallback'ini (`period_from IS NULL → period`) **kaldırmayı denedi** ve
**geri almak zorunda kaldı**: `on-invoice.service.spec.ts`'in *"T-373 GERÇEK DB"* suite'i
`main.budget_envelopes`'a **ham SQL `INSERT`** yapıyor (`:463` · `:482` · `:595`) ve
`period_from`/`period_to` **göndermiyor** ⇒ fallback kalkınca `NOT NULL` ihlaliyle **7 test**
`beforeAll`'da patlıyor.

⛔ **Yapılacak:** üç `INSERT`'e `period_from`/`period_to` **açıkça** eklenir (tek-aylık
fixture'lar için `period_from = period_to = period`). Fallback'in kaldırılması **bir sonraki
kod turunun** işi — sen yalnız **önünü açıyorsun**.

> ### 📌 Ve kayda: bu suite, `S2`'nin ERTELENMİŞ kalemidir (gerçek-DB testi bir BİRİM
> ### spec'inin içinde). **Ertelenmiş bir temizlik, iki dalga sonra bir `§2.5` düzeltmesini
> ### ENGELLEDİ.** `S2`'yi kapatmak artık bir hijyen değil, bir **borç**.

## 4 · İŞ 3 — ⛔ `DUR 2`'NİN AÇILMASI: `SP-E2E-10`'un SÖZLEŞMESİ

Kod turu `getBudgetStatus`'un sessiz `0/GREEN`'ini **açık hataya** çevirmeyi denedi
(`NotFoundException`) ve geri aldı: `SP-E2E-10` **`200` bekliyor**, `404` aldı.

**Team Lead adjudikasyonu (`K-2.2.14`'ten türetilmiş, ölçümle):**
```
kural       "tek bir BİLDİRİLMİŞ POLİTİKA" istiyor — bir İSTİSNA değil
ihlal       0 döndürmek DEĞİL;  GREEN döndürmek — GREEN bir YARGI ("bütçe rahat")
            ve kaynağı bir YOKLUK
çözüm       İSTİSNA DEĞİL, BİLDİRİLMİŞ BİR DURUM:
            UtilizationStatus'a "zarf yok" üyesi · sayılar 0 değil null
⇒ SP-E2E-10 ile ÇATIŞMA ÇÖZÜLÜR: o test 404 değil 200 bekliyor;
  `200 + status:<zarf-yok>` İKİSİNİ DE sağlar
```
⛔ **Enum üyesini ve üreticiyi SEN yazmıyorsun** — bir sonraki **kod turu** yazar (`Z91`:
*üye ekleyen tur üreticisini aynı turda bağlar*). Senin işin: `SP-E2E-10`'un iddiasını
**yeni sözleşmeye** göre yeniden yaz ve **pinle** — `200` **ve** `status` alanının *"zarf yok"*
olduğu; ⛔ **ve bu pin, `GREEN` dönerse KIRMIZI vermeli** (ayırt edicilik).
⚠️ Üye adı henüz **yok**: kod turu koymadan pini yazamıyorsan **DUR ve bildir** — uydurma.

## 5 · İŞ 4 — `SP-E2E-09`/`SP-E2E-10`'un ÖNCÜLLERİNİ ÖLÇ

⛔ **`SP-E2E-10`'un tüm senaryosu yıl-`LIKE` fallback'ine dayanıyordu** (*"aynı kanal+yılda
split edilmiş BAŞKA bir dönem"* ancak `LIKE '2026%'` sayesinde aday olabilirdi). `LIKE` **öldü**
⇒ o senaryo **artık üretilemiyor olabilir**. **ÖLÇ:** test hâlâ kurduğu şeyi kuruyor mu, yoksa
**boşa mı koşuyor**? Boşa koşuyorsa bu bir `§2.7 #6` vakasıdır — *kapsam var, ayırt etme gücü yok*.
⛔ Sonucu **ne olursa olsun yaz**: hâlâ ayırt ediyorsa **neden**, etmiyorsa **ne yapılmalı**.

## 6 · ⛔ DUR / KURALLAR
- **Üretim kodu DEĞİŞTİRME.** Bir kırmızı üretim kusuruna işaret ediyorsa **DUR ve bildir**.
- ⛔ Bir testi yeşile çevirmek için **hükmü gevşetme** — hüküm 12 kesişmeyi yasaklıyor,
  test ona **uyar**.
- `docs/brd-v2/**` **YAZMA** · yeni task **AÇMA** · `git commit`/`push` **YOK**.
- `mode-split`: `src/modules/modes/` altına **yeni dosya YOK**; `test/`'ten `modes/`'a **yeni
  referans** da ihlaldir (`Z102 §7`, ampirik).
- Reprodüksiyon-önce · ölçüm **borusuz** · ilk komut hayalet-konteyner kontrolü.
- ⛔ **Rapor SAYI değil LİSTE**; kırmızıyı **bilinen / senin getirdiğin** diye **sınıfla**.

## 7 · Hedef
`tsc 0` · `guards 0` · `npm test 0` · `npm run test:e2e` **0** · `[T-047 invariant]` birebir.
