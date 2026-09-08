# `Z107` BLOCKER-2 — kapı, **üreticisini saymadan** kondu

> Şerit: `backend-engineer` · Repo: `collmind.backend`
> ⛔ `1831` **push edilmedi** — aynı dosyada revize edilebilir; **ölç**, varsayma.
> Yeni numara gerekirse **DUR ve iste**.

## 0 · ⛔ Bu turun tek cümlesi — ve hatası **Team Lead'indir**

Bir önceki brief `B1(b)`'yi şöyle gerekçelendirdi:
> *"DTO **yeni** metadata-boyutlu zarfı reddeder ⇒ `F8` (iki temsil) **BÜYÜMEZ**; mevcut iki
> `CLOSED` satır tarihsel kalır."*

⛔ ***"Büyümez"* bir ÖLÇÜM DEĞİL, bir VARSAYIMDI.** Ölçüm (Team Lead, doğruladı):

```
plan.service.ts:1904 · 1933 · 1963
    category: categoryCode        →  ADANMIŞ KOLON
    metadata: { channel: channelCode, autoCreated: true, createdForPlanId: plan.id }
                                  →  METADATA          ⛔ AYNI LİTERALDE ASİMETRİ
canlı rota   plan.controller.ts:439/450  →  POST /plans/:id/approve  body.autoCreateBudget
e2e kapsamı  grep -rn "autoCreateBudget" test/  →  0 satır
tek unit testi  plan.service.spec.ts:148  createEnvelope: jest.fn()   ⇒ MOCK, kapı hiç koşmuyor
```

> ### ⇒ O üç çağrı, metadata-boyutlu zarfın **BUGÜNKÜ CANLI ÜRETİCİSİDİR.**
> ### Kapı inseydi `autoCreateBudget=true` ile yapılan **HER ONAY `400`** alacaktı —
> ### ve `approve`'un dış `catch`'i transaction'ı **geri alıp** hatayı yükseltiyor.

📌 `§7.1` (*düzeltmeden önce say*) bu oturumda **yedinci** kez, ve yine bir Team Lead brief'inde.
📌 Ve kapıların görmeme sebebi ölçüldü: **mock'lu tek test + sıfır e2e** — *"verinin yokluğu örter"*.

## 1 · İŞ 1 — ⛔ ASİMETRİYİ KAPAT: `channel` **adanmış kolona**

Üç çağrı yerinde `channel: channelCode` **metadata'dan çıkar, kolona geçer**;
`autoCreated`/`createdForPlanId` **metadata'da kalır** (bunlar boyut değil, **köken bilgisi**).

⛔ **Davranış eşdeğerliğini ÖLÇ ve YAZ:**
```
SPECIFIC kademesi   `channel = :v OR metadata->>'channel' = :v`  ⇒ ikisi de eşleşir, EŞDEĞER
GENERAL kademesi    `channel IS NULL AND metadata->>'channel' IS NULL`
                    ⇒ metadata'lı satır bugün de GENEL DEĞİL, kolonlu satır da değil ⇒ EŞDEĞER
```
Eşdeğer **değilse** ⛔ **DUR ve bildir** — bu bir davranış kararıdır, sessizce yapılmaz.

⇒ Bu iniş `B1(b)` kapısını **doğru** kılar (üretici artık kolonu kullanıyor) ve `F8`'in
büyümesini **kaynağında** durdurur.

## 2 · İŞ 2 — ⛔ *"AYNI BOYUT"* TEK İFADEYE İNER (`🟡-1` + `🟡-2`)

Bugün üç farklı tanım yaşıyor (review ölçtü):
```
kaskad WHERE      budget.repository.ts:208,222   kolon = :v OR metadata->>'..' = :v
trigger           1831:406-411                    COALESCE(kolon, metadata->>'..')
narrowing         budget.repository.ts:347-353    YALNIZ kolon
B2 assert         1831:320-322                    YALNIZ kolon (ham)
```
⛔ **Dördü de aynı ifadeyi kullanır** — `§2.7 #8`: *bir kontrolü sınayan/kuran şey, o kontrolün
ikinci bir kopyasını çalıştırmamalı.* Tek türetim noktası.
📌 Bugün ayrışmıyorlar (review ölçtü: `RAW 0` = `COALESCE 0`) — ama **İŞ 1 bu veriyi
değiştiriyor**, yani ayrışma **yaşayan** hâle gelmeden kapatılmalı.

## 3 · İŞ 3 — 🟡-4 / 🟡-5 (ucuz, aynı turda)
```
🟡-4  describeBudgetUnavailability FIRLATIYOR; çağıranlardan biri sonucu validationErrors'a
      PUSH ediyor (plan.service:1126-1131) ⇒ o iki dalda submit'in "200 + success:false +
      TÜM hata listesi" sözleşmesi tek bir 400'e dönüşür ve TOPLANMIŞ DİĞER HATALAR KAYBOLUR
      ⇒ dönüş-değeri mi istisna mı — BİLİNÇLİ seç ve YAZ
🟡-5  plan.service.ts:1554-1560 · :1567-1573 · :1694-1700 — ÜÇ ÇIPLAK `throw new Error`
      U5 tam olarak bunu düzeltti (komşu dosyada) ⇒ aynı turda İKİ STANDART kalmasın:
      InternalServerErrorException + `code`, ya da BadRequestException — gerekçesiyle
```

## 4 · ⛔ DUR / KURALLAR
- **Test dosyalarına DOKUNMA** — pinler `qa` şeridinin işi (⛔ ve `autoCreateBudget`'ın
  **sıfır e2e**'si o turda kapanacak; sen yalnız **ölç ve raporla**).
- **`collmind.frontend`'e DOKUNMA** · `docs/brd-v2/**` **YAZMA** · yeni task **AÇMA**.
- ⛔ **Migration numarası ALMA** — **DUR ve iste**.
- ⛔ **Reprodüksiyon-önce, yönsüz:** İŞ 1'den **ÖNCE**, `B1(b)` kapısının
  `autoCreateBudget=true` yolunu **gerçekten 400'e çevirdiğini GÖR** (mevcut kodla, canlı ya da
  entegrasyon düzeyinde). Görülemezse ⛔ **DUR** — teşhis çürür ve bu da bir sonuçtur.
- Mutasyonda kopya + satır **BAS** + `shasum` (⛔ `git checkout` yasak) · ölçüm **borusuz** ·
  ilk komut hayalet-konteyner kontrolü · `git commit`/`push` **YOK**.
- ⛔ **Ölçüm izolasyonu:** `migration:revert`/`run` ile `test:e2e`'yi **AYNI ANDA koşturma** —
  paylaşılan DB; bir önceki tur tam bu yüzden `18 suite/89 test` sahte kırmızı ölçtü.
- ⛔ Hedef: `tsc 0 · guards 0 · npm test 0 · npm run test:e2e 0 (877/877)`.
- ⛔ **Rapor SAYI değil LİSTE.**
