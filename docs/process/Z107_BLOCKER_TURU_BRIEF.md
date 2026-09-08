# `Z107` — BLOCKER TURU: `K-2.2.1b` invaryantı **KANITLANMADAN** bir koruma silinmişti

> Şerit: `backend-engineer` (+ migration revizyonu) · Repo: `collmind.backend`
> ⛔ `1831` **push EDİLMEDİ** — aynı dosyada revize edilebilir. ⛔ Bunu `git log`/`git status`
> ile **ÖLÇ**, varsayma. Yeni numara gerekirse **DUR ve iste**.

## 0 · ⛔ HÜKÜM-ATIF
`Z`-atfı olmayan bir *"hüküm"* cümlesi ⇒ **DUR** (`Z105 §1`).
```
hüküm 12   dönem bir ARALIKTIR                     Z105 §2 · K-2.2.1a
K-2.2.1b   aynı kategori×kanal×tip: aralıklar KESİŞEMEZ  — ⛔ ve bu maddenin
           "eşdeğer güçte" cümlesi BUGÜN F12 ile DÜZELTİLDİ (aşağıya bak)
K-2.2.3a   TEK kaskad · gizli tie-break YASAK
```

## 1 · Kök — ve bu turun tek cümlesi

`budget.repository.ts:312-330` ve `:276-295`, `K-2.2.1b`'yi **yapısal invaryant** kabul edip
ona **dayanarak** iki şeyi sildi: `sameDimensionAsWinner` narrowing'i (iki kez ölçülmüş
yanlış-pozitif düzeltmesi) ve dönem tie-break anahtarı.

> ### ⛔ **Silinen koruma, KANITLANMAMIŞ bir cümleye dayanarak silindi.**
> ### `:326-329`'un *"spend_type başına EN FAZLA bir satır"* iddiası bir **ölçüm değil, bir ÇIKARIM**.

Ve çıkarım **üç yerden** kaçıyor:

```
B1  trigger tuple'ı  ADANMIŞ kolonlara bakıyor   (category, channel, spend_type)
    kaskad WHERE'i   İKİ TEMSİLE birden bakıyor  (kolon OR metadata->>'...')
    ⇒ metadata-boyutlu satır FARKLI bir trigger tuple'ı ama AYNI sorgu adayı
    ⛔ TEAM LEAD ÖLÇTÜ: metadata->>'channel'/'category' taşıyan satır = 2
       (ENV-2026-NKA-Q1/Q2, kolon NULL, metadata 'NKA')
       ⇒ ikisi de CLOSED ⇒ kaskad (status=ACTIVE) onları BUGÜN aday almıyor
       ⇒ SINIF GİZLİ, ama ÜRETİCİ CANLI: metadata çağıran-kontrollü
         (create-budget-envelope.dto.ts `metadata?: Record<string,any>`
          → budget.service.ts `{...createDto}` ile DOĞRUDAN persist)
       ⇒ T-273: VERİNİN YOKLUĞU ÖRTÜYOR

B2  1831 mevcut veride kesişme YOKLUĞUNU HİÇ DOĞRULAMIYOR — ve sıra ölçüldü:
       backfill :233  →  trigger fonksiyonu :284  →  trigger :339
    ⇒ backfill bir NOKTAYI ÜÇ AYLIK ARALIĞA genişletiyor ve trigger HENÜZ YOK
    ⇒ backfill'in KENDİSİ bir kesişme üretse bile SESSİZCE kalıcı olur

U1  BEFORE ROW trigger'ı EXCLUDE ile EŞDEĞER DEĞİL (commit edilmemiş satırı görmez;
    çok satırlı tek INSERT'te kördür) — ⛔ ve kanıtı bu diff'in İÇİNDE:
    test/helpers/seed-e2e.ts:672-687 YARIŞ İÇİN RETRY yazmış
    ⛔ L2_01'deki "eşdeğer güçte" cümlesi BUGÜN Team Lead tarafından F12 ile DÜZELTİLDİ —
      OKU, çünkü bu turun gerekçesi orada
```

## 2 · İŞ — üç kalem

### `2.1` ⛔ **`B2`: `1831`'e backfill-SONRASI, trigger-ÖNCESİ kesişme ASSERT'i**
`Z100` üç-durum: **hiç kesişme yok** → devam · **kesişme VAR** → ⛔ **İPTAL** + çakışan
çiftleri **listele** (kod/kod, aralık/aralık) · **ölçemedim** → exit 2 dili.
⛔ Sorgu `deleted_at IS NULL` + `IS NOT DISTINCT FROM` (NULL-güvenli) + şema-nitelendirilmiş.
📌 Bu, invaryantı bir **iddia** olmaktan çıkarıp **ölçüm** yapar — `1831`'in `Z100` standardını
kendi **ana invaryantı** için uygulamamış olması bu turun düzelttiği şeydir.

### `2.2` ⛔ **`B1`: trigger tuple'ı, kaskadın ÇÖZÜMLEDİĞİ boyutu kapsar**
Üç parça, **üçü de**:
```
(a) trigger tuple'ı ETKİN değere geçer:
    COALESCE(channel, metadata->>'channel')  ·  COALESCE(category, metadata->>'category')
    ⇒ trigger'ın kapsamı = sorgunun kapsamı
(b) DTO YENİ metadata-boyutlu zarfı REDDEDER (açık 400):
    metadata.channel / metadata.category verilmişse ⇒ "kanal/kategori adanmış kolona yazılır"
    ⇒ F8 (iki temsil) BÜYÜMEZ; mevcut iki CLOSED satır tarihsel kalır
(c) ⛔ sameDimensionAsWinner NARROWING'İ ve dönem tie-break anahtarı GERİ GELİR
```
⛔ **`(c)` tartışmaya açık değil, ve gerekçesi şu:** o narrowing **iki kez ölçülmüş** bir
yanlış-pozitifin düzeltmesiydi (2026-08-02 · 2026-08-04). `(a)`+`(b)` invaryantı
**tek-yazar** altında sağlar; **eşzamanlılıkta sağlamaz** (`U1`). ⛔ **Ölçülmüş bir koruma,
bir çıkarımla silinmez** — invaryant **eşzamanlılıkta da** kanıtlandığı gün, o turun kanıtıyla
kaldırılabilir. Bugün değil.
📌 Geri getirirken **eski gerekçe yorumunu da geri getir** (`F12`: neden silinmişti, neden geri geldi).

### `2.3` 🟡 `U5` — `describeBudgetUnavailability`'nin `throw new Error` dalı
`parts.length === 0` ⟺ her iki bacak `requested === 0` ⟺ **aşırı-taahhüt edilmiş UNSPLIT zarf**.
Bugün `plan.service.ts:1119` toplama döngüsünden **çıplak `Error`** kaçıyor ⇒ **500**
(öncesinde `400` + mesaj). ⛔ `BadRequestException` yap **ve** `available < 0` durumunu
**adıyla** anlat.

## 3 · ⛔ DUR / KURALLAR
- **Test dosyalarına DOKUNMA** · **`collmind.frontend`'e DOKUNMA** (`T-384`).
- `docs/brd-v2/**` **YAZMA** — `L2_01`'in `F12`'si **bugün Team Lead tarafından yazıldı**, oku.
- ⛔ **Migration numarası ALMA** — `1831` push edilmedi, **ölç**; gerekirse **DUR ve iste**.
- ⛔ **Reprodüksiyon-önce, yönsüz:** `2.1` için kasıtlı bir kesişme kurup assert'in
  **DURDURDUĞUNU GÖR**; `2.2(c)` için narrowing'siz hâlde yanlış-pozitifi **ÜRET**.
- Mutasyonda kopya + satır **BAS** + `shasum` (⛔ `git checkout` yasak) · ölçüm **borusuz** ·
  ilk komut hayalet-konteyner kontrolü · `git commit`/`push` **YOK**.
- ⛔ Hedef: `tsc 0 · guards 0 · npm test 0 · npm run test:e2e 0 (877/877)`.
- ⛔ **Rapor SAYI değil LİSTE**; e2e kırmızısı çıkarsa **bilinen 0 / seninki N** diye sınıfla.
