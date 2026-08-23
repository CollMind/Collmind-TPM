# `ADIM 3` `Faz B` — plan (Team Lead, 2026-08-20)

> **Neden ayrı belge:** `FAZ1_PLAN §5` `ADIM 3`'ün **tarihçesini** taşıyor, ama bu
> oturumdaki **beş revizyonu** taşımıyor. Onu okuyan bir ajan `report-only` önerir
> (orada yazılı) ve `Faz A`'yı yeniden planlar (zaten indi).
>
> ⚠️ **Bu belge `§5`'in yerine geçmez** — kararların gerekçeleri orada. Bu, **bugünkü
> duruma** ve **kalan işe** dair.

---

## 0 · `FAZ1_PLAN §5`'in TAŞIMADIĞI beş revizyon

| # | revizyon | kaynak |
|---|---|---|
| 1 | **`report-only` ÇÜRÜTÜLDÜ** — değersizleştiren girdi *"eksik harita"* değil **trafik yokluğu**. İkiye bölündü: **statik kapsama guard'ı** (şimdi, kapı) + dinamik telemetri (deploy sonrası) | `0073 §3` |
| 2 | `FINANCE_MANAGER` key → `FINANCE` — **çözüldü**, tel değeri değişmedi | `Z7` |
| 3 | `77`'nin kırılımı: **`72` gerçek boşluk · `3` bilinçli açık · `2` alan-guard'lı** | `0072`/`0074` |
| 4 | **`ADIM 3` BÖLÜNDÜ:** yetenek+default-deny `Faz 1`; `UNRESTRICTED` kod dalı temizliği **ERTELENDİ** | `FAZ1_PLAN §5` sonu |
| 5 | **`T-249`/`markAsRead` deliği `ADIM 3`'e bağlandı** — `GRANT` verildi, delik artık **erişilebilir** | `T-249` · `FAZ1_PLAN §5` |

📌 Ve **`Faz A` ZATEN İNDİ**: `src/common/authorization/capabilities.ts` — `24`
`CAPABILITIES`, `ROLE_CAPABILITIES` haritası, `4` hücre çözülü, `5` `DUR`.
**Sıfırdan planlayan bir ajan onu tekrar önerir.**

---

## 1 · BUGÜNKÜ DURUM — ölçüldü 2026-08-20

```
238 rota   (34 controller dosyası, src/**/*.controller.ts)
172 @Roles'lu
 66 filtresiz
     ├─  3  @Public          health · auth/login · auth/refresh      → BİLİNÇLİ
     ├─  2  alan-guard'lı    ReversalGuard · SettlementGuard          → KORUNUYOR
     └─ 61  GERÇEK BOŞLUK
```

### Tabanla uzlaşma — sayı bayatlamadı, uzlaştı

```
belgede (0072)   237 rota · 160 @Roles · 77 filtresiz
bugün            238 rota · 172 @Roles · 66 filtresiz

+1  rota    T-242a'nın PATCH /users/:id/scope
+12 @Roles  T-249 (notifications 3 + spend-calculation 8) + T-242a 1
-11 boşluk  aynı 11
```

⚠️ **Pozitif kontrol:** `237` tabanı bağımsız parser'la yeniden üretildi (`src/modules`
kapsamıyla) — `0072`'nin sayısıyla **birebir**. Fark yalnız `app.controller.ts`'in
kapsama alınması (+1) ve bu oturumun eklemeleri.

### `2` alan-guard'lı uç — ⛔ DEFAULT-DENY ONLARI KESER

```
reversal.controller.ts:28    @UseGuards(JwtAuthGuard, ReversalGuard)   ← CONTROLLER seviyesi, 1 rota
settlement.controller.ts:77  @UseGuards(SettlementGuard)               ← ROTA seviyesi
```

İkisi de `{ADMIN, CATEGORY_MANAGER}`'ı **guard'ın içinde** zorluyor (`reversal.guard.ts:19-21`
`REVERSAL_ALLOWED_ROLES` · `settlement.guard.ts:19-21` `SETTLEMENT_ALLOWED_ROLES`),
`@Roles` ile değil.

> **Yani bunlar `@Roles`'suz ama KORUNUYOR.** Default-deny bunu bilmezse **çalışan iki
> ucu kırar** — ve kırılma `403` olduğu için *"default-deny çalışıyor"* diye okunur.

⛔ **Statik kapsama guard'ının çıktısında AYRI işaretlenmeliler** — *"filtresiz"*
kovasına düşerlerse sayı yanlış olur ve düzeltme yanlış yere gider.

---

## 2 · AÇIK KARARLAR — ürün sahibine

> ### ✅ GÜNCELLEME (2026-08-21) — `K1` KARARA BAĞLANDI, `K2`/`K3` KAPANDI
>
> | # | durum |
> |---|---|
> | `K1` | ✅ **KARAR: `READ` üçe ayrılır** — `Z18` |
> | `K2` | ✅ **kendiliğinden kapandı** — `K-2.5.12`: onay yetkisi rol kümesi değil, **şablonun kademesi**. `APPROVE` hücreleri `@RequireCapability` **almaz** |
> | `K3` | ✅ **ZATEN KAPALIYDI** — ölçüldü: `capabilities.ts:206` *"UNION'DAN ÇIKARILDI (2026-08-17)"*, canlı controller `@Roles(ADMIN)`. ⚠️ Plan `§5`'in **uyarısını** okumuş, `capabilities.ts`'in **çözümünü** okumamıştı |
> | `K4` | ✅ **CEVAPLANDI: kademeli** — ve `B0` ratchet'i onu **zorluyor** (aşağı bkz.) |
>
> **`K1` kararı (`Z18`):**
> ```
> READ_OWN      işlem ekseninin SÖZLÜK GENİŞLEMESİ — dördüncü eksen DEĞİL
> ÖZET          kendi hücresi — çapraz-modül yüzey
> modül-READ    kalan, YENİDEN ÖLÇÜLÜR
>
> UNRESTRICTED  koşulsuz sabit → KAYITLI rol özelliği (küme aynı, STATÜ değişir)
>               ADMIN · READONLY → tanımsal (K-2.6.4)
>               FINANCE          → savunulabilir ama BUGÜN KAYITSIZ ⚠️ kilit
>
> ⛔ HİÇBİR hücre-rol çifti UNION gerekçesiyle yaşayamaz
> ```
>
> 📌 **Dördüncü eksen yok, ve zemin değişimi kararı GÜÇLENDİRDİ:** yeteneğe kapsam
> taşımak artık **çalışan** bir katmanı kopyalamak olurdu (`İlke 4`).
>
> 📌 **Çapraz sınama:** `0072 §4c` ile örtüştü — `READ_OWN + ÖZET ⊂ A`,
> `sales-actuals = C`. İki bağımsız yol aynı taksonomiye vardı.

### `K1` · Üç `READ` hücresi — **kapı ARTIK AÇIK**

```
MODES_READ · SHARED_READ · USER_READ    union = 5 rolün 5'i → ÇÖKÜŞ
```

`§5`'in bağlayıcı sırası: *"üç `READ` hücresinin union'ı **`T-235` kapanmadan
değerlendirilmez**."* — **`T-235` bugün kapandı.**

**Ve o kararın gerekçesi de değişti.** Engel şuydu:

```
o gün      kapsam filtresi 5 rolün 1'inde aktif  →  @Roles TEK kapı  →  union onu gevşetir
bugün      bayrak AÇIK → PLANNER de kapsamlı     →  ikinci kapı ÇALIŞIYOR
```

⚠️ **Ama tam çözüm değil:** `UNRESTRICTED_ROLES = {ADMIN, FINANCE, READONLY}` hâlâ
**koşulsuz** — yani `5` rolün `3`'ünde kapsam katmanı kapalı. Union'ı değerlendirirken
soru: *"bu üç rol için `@Roles` gerçekten tek kapı mı, ve union onu gevşetiyor mu?"*

📌 Ve `§5`'in kendi teşhisi duruyor: çöküş **union'ın kusuru değil** — o hücrelerde zaten
`5/5` taşıyan bir route var (`dashboard-summary` · `approval my-requests` ·
`sales-actuals READ_ROLES`). Soru **taksonomi**: *"bu geniş route'lar dar olanlarla aynı
hücreye mi düşmeli?"*

### `K2` · İki `APPROVE` hücresi

```
MODES_APPROVE · SHARED_APPROVE   →  K-2.5.12'ye bağlı
```

`§5` bunları *"onay yeteneği"* diye ayırdı ve `K-2.5.12`'ye havale etti. **Karar
verilmedi.**

### `K3` · `PATCH /approval-policies/:id` — özel işaretli

Bugün `@Roles(ADMIN)`. Union onu **3 role daha** açıyor. Bir onay **politikası**
konfigürasyon ucu — davranışsal ağırlığı `yazma` sınıfından büyük.

### `K4` · Sıra — `61` uç aynı anda mı?

`roles.guard.ts`'in default-deny'a çevrilmesi **tek bir değişiklik** ve `61` ucu **aynı
anda** etkiliyor. Kademeli bir yol var mı, yoksa tek dalga mı?

---

## 3 · ÖNERİLEN SIRA

> ### ⛔ DÜZELTME (ürün sahibi, 2026-08-21) — `B0` KAPI DEĞİL, **RATCHET** doğar
>
> ```
> ilk plan   "sayaç değil kapı: 'sıfır mı'yı sorar"
> bugün      61
> sonuç      KALICI KIRMIZI  →  §2.7 #9: sinyal sabitse, sinyal DEĞİLDİR
> ```
>
> Ve bu `T-113`'ün **ölçülmüş** vakası: `108`'i sıfırlamak `Faz 1`'i öteler, ve kapı
> bir hafta içinde **devre dışı bırakılır**.
>
> ```
> B0   baseline 61 — LİSTE, sayı DEĞİL · yalnız ARTIŞ kırmızı
> B2   baseline DÜŞÜRÜLÜR, her uç bağlandıkça, AYRI COMMIT
> B4   baseline 0  →  guard KAPIYA TERFİ EDER
> ```
>
> 📌 `mode-split`'in dersi: **yeni guard'lar kapı doğmaz, kapıya terfi eder.**
>
> ⚠️ **Ve `T-246`'nın borcu burada BAŞTAN çözülür:** baseline düşürülmesi `B2`'nin
> **kabul kriteridir**, unutulan bir bakım değil. `T-246`/`T-234` ailesinin
> (*"baseline azaldıkça güncellenmiyor, kapanan her hata bir açık bütçe bırakıyor"*)
> tekrarı **yapısal olarak** engellenir.
>
> ⚡ **Ve bu `K4`'ü cevaplıyor: KADEMELİ** — `B4` ancak baseline `0`'da mümkün, yani
> ratchet tek-dalgayı **imkânsız** kılıyor. Karar bir tercih değil, bir **sonuç**.

```
B0  statik kapsama RATCHET'i          ← 0073'ün "şimdi" yarısı
      her rota ya @Roles ya @Public ya alan-guard'lı
      baseline = 61'in LİSTESİ · yalnız ARTIŞ kırmızı
      ⚠️ üç kovayı AYRI sayar — 2 alan-guard'lı "filtresiz" DEĞİL
      ve İKİ GİRDİ İKİ ÇIKTI ile sınanır (§2.7 #9)

B1  K1/K2/K3 kararları                ← ürün sahibi
      üç READ hücresi · iki APPROVE · approval-policies

B2  61 ucun @Roles'a bağlanması       ← B0 baseline'ı DÜŞERKEN, ayrı commit'ler
      her uç: hangi yetenek hücresi · hangi roller · GEREKÇE
      ⚠️ 59'u EKSİK DEKORATÖR, 2'si guard zinciri de yok — aşağı bkz.

B3  @RequireCapability + 172 @Roles göçü
      ⚠️ İlke 4: iki mekanizma AYNI ANDA yaşamamalı

B4  roles.guard.ts default-deny       ← B0 baseline 0 OLDUKTAN sonra; guard KAPIYA terfi eder
      ve markAsRead deliği (T-249) BU ADIMDA kapanır
```

⚠️ **`B0` neden önce:** default-deny'ı sayaç sıfırlanmadan çevirmek `§5`'in `(d)`
şıkkının reddedilme gerekçesinin ta kendisi — *"çevrildiği an eşlenmemiş her uç
kırılır."*

⚠️ **Ve `B4` bir davranış değişikliği**: `T-249`'un açtığı `markAsRead` deliği burada
kapanır, yani bu adım **bir borcu ödüyor** — kayıtlı ve adresli.

---

## 4 · KABUL KRİTERLERİ — karar gerektiren noktalar

| # | kriter | karar gerekiyor mu |
|---|---|---|
| 1 | `B0` guard'ı `run-all.sh`'e bağlı, iki-girdi-iki-çıktı kanıtlı | hayır — `T-250` deseni |
| 2 | `61` ucun **her biri** için rol kümesi + gerekçe yazılı | hayır |
| 3 | `2` alan-guard'lı uç ayrı kovada, ve default-deny sonrası **hâlâ çalışıyor** | hayır |
| 4 | Üç `READ` hücresinin taksonomisi | ⛔ **`K1`** |
| 5 | İki `APPROVE` hücresi | ⛔ **`K2`** |
| 6 | `approval-policies` genişlemesi | ⛔ **`K3`** |
| 7 | `61` uç tek dalga mı, kademeli mi | ⛔ **`K4`** |
| 8 | `@Roles` ↔ `@RequireCapability` **aynı anda yaşamaz** (`İlke 4`) | hayır — `§5`'te karar var |

## 4b · ⚡ `B2`'NİN KAPSAMI YENİDEN ÇERÇEVELENDİ — `59/61` (T-252 ölçümü, 2026-08-21)

`B0` ratchet'i baseline'ı çıkarırken bir ayrım ölçüldü:

```
59 rota   JwtAuthGuard, RolesGuard ZİNCİRİ BAĞLI  ·  @Roles metadata'sı YOK
 2 rota   guard zinciri de yok
```

**Sebep koddadır:** `roles.guard.ts:16-18` metadata **yokken `true` döndürüyor** — yani
zincir koşuyor ve **hiçbir şey ayırt etmiyor**.

> **`§2.7 #9`'un rota tarafındaki hâli, ve `59` vakayla:** *"sinyal sabitse, sinyal
> değildir."* Guard her istekte çalışıyor ve her isteğe `true` diyor.

📌 **`GUARD'IN VARLIĞI KORUMA DEĞİLDİR.**

### Ve bu `B2`'nin kapsamını KÜÇÜLTÜYOR

| | |
|---|---|
| ⛔ **değil** | mimari değişiklik — guard zinciri, metadata okuma, `Reflector` altyapısı **zaten yerinde** |
| ✅ **evet** | **eksik dekoratör** — her uç için bir `@Roles(...)` satırı |

**Ama iş yine de ucuz değil:** her uç için **hangi roller** sorusu bir **karar**, ve
`Z18` gereği *"hiçbir hücre-rol çifti union gerekçesiyle yaşayamaz."* Yani `59` satırın
her biri **gerekçeli** yazılır.

⚠️ **Ve `2` istisna ayrı ele alınır** — guard zinciri de olmayan uçlar. Onlarda
`@Roles` eklemek **yetmez**, `@UseGuards` de gerekir. `B2`'nin listesi ikisini
**ayırmalı**.

## 4c · ⛔ İKİ ÖLÇÜM DÖRT BLOCKER ÇIKARDI — SIRA (ürün sahibi, 2026-08-21)

```
T-256   READ_OWN'ın TABANI çürük        ← B1'DEN ÖNCE, EN ACİL
T-255   kimlik materyali sızıntısı      ← B1'DEN ÖNCE, P0 sayılabilir, RLS'ten önce
T-253   dashboard-summary bypass        ← B2 ile
T-254   [] iki katmanda zıt             ← B2 ile
```

**`T-256`/`T-255` neden `B1`'den önce:** ikisi de `B1`'in **sınıflandırmasını**
doğrudan etkiliyor — `READ_OWN`'ın ne olduğu (`T-255`: etiket URL'e takılı, veri
sınıfına değil) ve `Z18`'in *"tam örnek"* dediği ucun çalışıp çalışmadığı (`T-256`:
bugün `500`).

## 4d · ✅ `B2`'NİN EMSALİ — `settlements/summary`

> **Eksiklik *"yapılamaz"* değil, *"yapılmamış"*.**

```
GET /actuals-first/settlements/summary
  @Roles YOK (bilinçli)
  ama servis içeride resolveScope çağırıp GERÇEK farkı üretiyor
  davranışsal: planner → 1 · planner2 → 0
```

📌 **Ve gösterdiği şey `B2` için kritik:** `@Roles` olmadan da **kapsam uygulanabiliyor.**
Yani `B2`'nin işi yalnız *"dekoratör ekle"* değil — bazı uçlarda doğru cevap
**servis içinde kapsam** olabilir, rota filtresi değil.

⚠️ İkisi **farklı katman**: `@Roles` *"kim çağırabilir"*, kapsam *"neyi görür"*.
`B2`'nin listesi her uç için **hangisinin gerektiğini** ayırmalı — ve bazılarında
**ikisi birden** gerekir (`T-255`'in `GET /users/:id`'si tam bu: rol · sahiplik ·
DTO, üçü ayrı).

## 4e · ⚡ `B1`'İN ÜÇÜNCÜ GİRDİSİ — kuyruğun SAHİBİ (`0075` `Boşluk 4`)

`0076` `0075`'in `18` boşluğunu `L2 2.13`'e karşı ölçtü; `9`'u **gerçek boşluk**
çıktı. Sekizi `Faz 2`'ye gitti (`docs/process/FAZ2_ACIK_KARARLAR.md`) — **biri
buraya**:

```
Boşluk 4   Kuyruğun SAHİBİ / SLA / eskalasyon
L2 sınırı  K-2.13.13   "kaybolmaz, elle çözülür"
           K-2.13.12a  kimin ONAYLAYAMAYACAĞINI söyler,
                       kimin SAHİP olduğunu SÖYLEMEZ
```

**Neden `Faz 2`'ye ertelenemez:** `B1`'in taksonomisi kuyruğu **bir yetenek hücresine
koyacak**. Yani *"kuyruğa kim bakar"* sorusu `ADIM 3`'ün **zaten cevaplamak zorunda
olduğu** bir soru — ertelenirse hücre **gerekçesiz** doldurulur.

⚠️ Ve `Z18` burada bağlayıcı: **hiçbir hücre-rol çifti union gerekçesiyle yaşayamaz.**
Kuyruğu bir hücreye koyarken *"union böyle dedi"* **yetersizdir** — sahiplik bir
**ürün kararıdır**.

## 4f · ✅ `B1` TASLAĞI ÇIKTI — `docs/process/ADIM3_B1_TASLAK.md` (2026-08-21)

```
59 uç sınıflandırıldı
 → 28  OTOMATİK   (rol TANIMI · KARDEŞ uç · ölçülmüş DAVRANIŞ)
 → 31  KARAR      ve BU 31, ÜÇ SORUYA iniyor
```

⚡ **`31` ayrı karar değil — üç karar:**

```
S1  KAPSAM mı ROL mü?          11 uç   customer 10 · lta 1
S2  HESAPLAMA ucu nerede?       7 uç   budget 2 · lta 3 · mechanic 2
S3  KARDEŞLER ÇELİŞİYOR        10 uç   budget 8 · kpi grid 2
    + 2f logout (kanıt statik)   1 uç
```

📌 **`T-255`'in dersi bir uçta doğrudan işe yaradı:** `GET /master-data/kpis/grid/:planId`
`master-data` altında ama **plan verisi** döndürüyor — uç bazında sınıflandırılsaydı
kardeşleriyle (`ADMIN`) aynı hücreye giderdi. **Veri sınıfı bazında** bakınca `plan`
uçlarına ait.

## 4g · ⛔ `B4`'ÜN ÖN KOŞULU — DÖRDÜNCÜ KOVA: `SELF` (ürün sahibi önerisi, 2026-08-21)

`B4`'ün şartı `FILTRESIZ = 0`. Bugün **`3`**: `/users/me` ailesi (`GET` · `PATCH` ·
`PATCH me/password`).

⚠️ **Ve onlar `@Public` DEĞİL** — kimlik **gerektiriyorlar**, yalnız **rol**
gerektirmiyorlar.

```
@Public       kimlik GEREKMİYOR              health · auth/login · auth/refresh
SELF          kimlik gerekli, rol GEREKMİYOR  /users/me ailesi          ← YENİ
alan-guard    kendi guard'ı                   reversal · settlement
@Roles        rol gerekli
```

**Default-deny `SELF`'i TANIYARAK geçirir** — bir dekoratörle (`@SelfScoped()` ya da
eşdeğeri).

### ⛔ Yoksa İKİ KÖTÜ SEÇENEK kalır

```
(a) @Roles(5 rol) yazılır      →  UNION, ve Z18'in AÇIK ihlali
(b) default-deny onları keser  →  /users/me KIRILIR
```

📌 **Ve bu karar `B3`'TEN ÖNCE verilmeli**, çünkü `@RequireCapability` göçü o
dekoratörü **de taşıyacak**. Sonradan eklemek göçü iki kez yaptırır.

⚠️ Sıradaki yeri: `T-254` → `T-265` → **`SELF` kararı** → `B3`.

> ### ⛔ BAĞIMLILIK YÖNÜ AÇIK YAZILIR (ürün sahibi, 2026-08-23)
>
> **`SELF` kararı `B3`'ün GİRDİSİDİR, ÇIKTISI DEĞİL.**
>
> `B3` (`@RequireCapability` göçü) **`172` `@Roles`**'u taşırken `/users/me` ailesinin
> **hedef hücresi belirsizse**, göç iki kötü sonuçtan birini üretir:
>
> ```
> ya onları ATLAR              →  kalıntı: iki mekanizma yan yana
> ya GEÇİCİ bir sınıfa koyar   →  İlke 4'ün "iki mekanizma" uyarısı TAM BURADA
> ```
>
> 📌 **Karar küçük:** `Z18`'in `READ_OWN` sınıfı zaten **yarısını verdi**; kalan soru
> **self-WRITE'ın bir yetenek mi yoksa bir YÜKLEM mi** olduğu
> (`PATCH /users/me` · `PATCH /users/me/password` — `Z20`'nin `SELF` kovası).
>
> ⚠️ Ve `Z20` `SELF`'i **`B4`'ün `FILTRESIZ = 0` ön koşuluna** bağladı: o üç uç `@Roles`
> almaz, `SELF` alır. Yani `SELF` kararı **iki** kapıyı birden açıyor — `B3`'ün göç
> hedefini ve `B4`'ün ön koşulunu.

## 5 · `B1`'İN GİRDİSİ — iki ölçüm ÖNCE

```
ÖLÇÜM 1   dashboard-summary KAPSAMLI roller için scope-aware mi?
          ⚠️ kapsamsız bir özet, kapsam katmanını ARKA KAPIDAN boşaltır

ÖLÇÜM 2   READ_OWN adayları: başkasının kaydını isteyene BOŞ/403 mü?
          ⚠️ yüklem yoksa SINIF SAHTE — "kendi kaydı" diye adlandırılan şey
             aslında "herkesin kaydı"dır
```

Ve `B1`'in girdisi bir **liste**:

```
hücre başına kalan rotalar  ×  mevcut @Roles kümeleri  ×  [öz-okuma | özet | modül]
```

⚠️ **Ve *"union kayda değer daralır"* bir HİPOTEZDİR** — sayı değil, **ölçümle**
çözülür. `CLAUDE.md`: *"bir hipotezi DOĞRULAYAN ölçüm, ÇÜRÜTEN ölçümden daha fazla
doğrulama ister."*

## ⚠️ Ölçümün sınırı

`61` sayısı **bugünkü** kod tabanından. `B1`/`B2` sırasında yeni rota eklenirse sayı
değişir — bu yüzden `B0` guard'ı bir **sayaç** değil bir **kapı** olmalı: sayıyı değil,
*"sıfır mı"*yı sorar.


---

## `SELF` KOVASI İNDİ (2026-08-24, `Z26`/`Z27`/`Z28`)

```
FILTRESIZ  3 → 0        SELF 7      PUBLIC 3    ALAN_GUARD 2    ROLES 211 / 223
```

`Z28`'in **üç sayacının** ikisi tuttu, üçüncüsü (guard tanıma) **iki-girdi-iki-çıktı ile
kanıtlandı** — ve kanıtın şekli `SELF_OLCUM_RAPORU §4`'ün `v1` sessizliğinin **tersi**:
tanıma kanalı mutasyonla kırılınca rota **sessizce `FILTRESIZ`'e düşüyor**.

⚠️ **Baseline UYGULANMADI** — aşağıdaki `DUR` yüzünden.

### ⛔ AÇIK KARAR — ratchet'in "TAMAMLANDI" durumunu nasıl temsil edeceği

`route-scope.sh:343`:

```bash
if [ ! -s "$BASE_KEYS" ]; then
  echo "SETUP HATASI: baseline dosyası var ama SIFIR 'F ' satırı ayrıştı"
  exit 2
fi
```

Bu kontrol **bozuk baseline** yakalamak için yazıldı, ve *"ratchet TAMAMLANDI"*
durumundan **ayırt edemiyor**. `FILTRESIZ` bugüne kadar hiç `0` olmadığı için bu dal
**hiç koşmamıştı** — `SELF` turu ona ilk kez ulaştı.

📌 `§`: *"Bir kuralın doğru olduğunu kırmızıya dönmemesinden çıkarma — önce sor: o
kuralın reddedeceği girdi ona ULAŞIYOR mu?"* **Ulaşmıyordu.**

| # | seçenek | değerlendirme |
|---|---|---|
| **a** | baseline'a açık **sentinel** (`# ratchet: COMPLETE`) | açık, kendini belgeler; yeni biçim alanı |
| **b** | kontrolün **NİYETİNİ** düzelt — *"ayrıştırma çalıştı mı"* sorusu `F` sayısıyla değil **başlık biçimiyle** cevaplanır | ✅ **Team Lead önerisi** — kontrol zaten **yanlış soruyu** soruyordu |
| **c** | üç bayat `F` satırı kalsın | ⛔ ratchet **yalan söyler**, `İYİLEŞTİ` gürültüsü kalıcılaşır |

⚠️ **`(b)` seçilirse `§`'nin kuralı geçerli:** gerçekten bozuk bir baseline hâlâ
`exit 2` vermeli, boş-ama-geçerli `exit 0` — **iki farklı girdi, iki farklı çıktı**.

### 📌 VE BU KARAR `B3b`'Yİ DE İLGİLENDİRİYOR

`B3b`'nin **kalan-`@Roles` baseline'ı da bir gün sıfıra inecek** ve **aynı duvara
çarpacak**.

> **Yani `(b)` bir kerelik düzeltme değil, `B3b`'nin ratchet'inin ÖN KOŞULU.**
