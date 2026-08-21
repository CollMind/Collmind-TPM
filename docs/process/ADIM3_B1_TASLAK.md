# `ADIM 3` `B1` — taksonomi TASLAĞI (Team Lead, 2026-08-21)

> ⛔ **BU BİR ÖNERİDİR, KARAR DEĞİL.**
> `Z18`: *"hiçbir hücre-rol çifti **union gerekçesiyle** yaşayamaz."* Bir taslak
> **gerekçe üretemez** — yalnız **gerekçe ADAYI** üretir.

## Gerekçe kaynakları — üçünden biri olmalı, yoksa `DUR`

```
rol TANIMI          K-2.6.4 rol kataloğu — "bu rol tanım gereği bunu yapar"
KARDEŞ uç           aynı controller'da aynı sınıftan bir uç zaten @Roles taşıyor
ölçülmüş DAVRANIŞ   servis kapsam uyguluyor mu (ÖLÇÜM 1/2)
```

### `K-2.6.4` rol kataloğu — taslağın dayanağı

```
YÖNETİCİ         tanımlar, kural yönetimi
PLANLAMACI       plan · taktik · hacim girişi · gönderim — GÜNLÜK KULLANICI
KATEGORİ MÜDÜRÜ  KATEGORİ BÜTÇE SAHİBİ: onay + zarf yönetimi
FİNANS           eşik üstü onay/bildirim · transfer · mutabakat · içe aktarma
İZLEYİCİ         salt görüntüleme   (K-2.6.4c: bir "salt-okur bayrağı" DEĞİL,
                                     bir İZLEME YETENEKLERİ SETİ)
```

---

## SAYIM — `29` otomatik çözülüyor · `30` KARAR gerektiriyor

⚡ **`S1` KARARA BAĞLANDI** (`Z19a`) — `11` uç `B2`'de kalıyor, rol katmanı uygulanıyor.
**Kalan gerçek karar: `S2` (`7`) · `S3` (`10`).**

✅ **`1g` (`logout`) ÇÖZÜLDÜ** — koşum yapıldı, izolasyon tutuyor. Yan bulgular → [[T-264]].

⚠️ **Beklenenden fazla `DUR`** (beklenti: *"çoğu kardeşle çözülür, azınlık gelir"*). Ve
sebebi tek bir yapısal olguda toplanıyor — aşağıda `§3`.

---

## 1 · OTOMATİK ÇÖZÜLENLER (`29`)

### 1a · `master-data` düz CRUD okuma (`18` uç) — `modül-READ`, **5 rol**

`brands` · `categories` · `channels` · `cpls` · `forecasting-units` ·
`generic-units` · `regions` · `skus` · `tactics` — her birinde `GET` liste + `GET :id`.

| kardeş | rol |
|---|---|
| `POST` · `PATCH` · `DELETE` (dokuzunda da) | **`ADMIN`** |

**Gerekçe adayı: rol TANIMI — ve her rol için AYRI cümle** (`Z18` şartı):

```
YÖNETİCİ         "tanımlar" — bu veriyi O yazıyor
PLANLAMACI       "plan · taktik · hacim girişi" — SKU/kategori/taktik OKUMADAN yapılamaz
KATEGORİ MÜDÜRÜ  "kategori bütçe sahibi" — kategori kataloğunu okumak zorunda
FİNANS           "mutabakat · içe aktarma" — kalem eşleştirmek için katalog gerekir
İZLEYİCİ         "salt görüntüleme" — K-2.6.4c: izleme YETENEKLERİ seti
```

📌 **Bu bir union çöküşü DEĞİL:** beş rolün beşi için **ayrı bir cümle** yazılabildi.
`Z18`'in şartı tam olarak buydu.

⚠️ **ŞERH (ürün sahibi): `master-data` YAZMA uçları `5/5` OLAMAZ — ve olmuyor.**
Doğrulandı: `1a`'nın tamamı **`GET`**. Dokuz controller'ın filtresizleri yalnız
`GET` liste + `GET :id`; `POST`/`PATCH`/`DELETE` **kardeş** sütununda ve **`ADMIN`**.

📌 **Ve ürün sahibinin testi uygulandı — *"bir rolü çıkarsak ne kırılır?"*:**

```
İZLEYİCİ çıkarılırsa   K-2.6.4c "izleme yetenekleri seti" — bir raporu okumak
                       için katalog gerekiyor              → cümle YAZILABİLİYOR
FİNANS çıkarılırsa     mutabakat yaparken CPL/kategori ADINI görmesi gerekiyor
                                                           → cümle YAZILABİLİYOR
```

Yani `5/5` burada **meşru** — çünkü her elemanın **kendi cümlesi** var, ve
çıkarıldığında **ne kırılacağı** söylenebiliyor.

### 1b · `kpi` okuma (`3`/5) — `modül-READ`, **5 rol**

`GET /master-data/kpis` · `/kpis/:id` · `/kpis/calculable` → `1a` ile **aynı gerekçe**.
Kardeş: beş yazma ucu **`ADMIN`**.

### 1c · `mechanic` okuma (`2`/4) — `modül-READ`, **5 rol**

`GET /master-data/mechanics` · `/mechanics/:id` → `1a` ile aynı. Kardeş: beş yazma
**`ADMIN`**.

### 1d · `/users/me` ailesi (`3`) — **`READ_OWN`** + self-write

```
GET   /users/me            READ_OWN
PATCH /users/me            self-write
PATCH /users/me/password   self-write
```

**Gerekçe: ölçülmüş DAVRANIŞ** (`ÖLÇÜM 2`) — yüklem `req.user.sub`, JWT'den, istemci
kontrol **edemez**. Ve `Z18` `READ_OWN`'ı zaten bir sınıf olarak tanımladı.

⚠️ **Rol kısıtı YOK ve olmamalı** — her kimliklenmiş kullanıcı kendi kaydına erişir.
Kardeş `GET /users/:id` **`ADMIN`**'dir ve **farklı hücredir** (`T-255` kararı).

### 1e · `GET /tenants/:id/stats` (`1`) — `modül-READ`, **`ADMIN`**

**Gerekçe: KARDEŞ uç** — `tenant.controller`'ın **yedi** kardeşinin yedisi de
`@Roles(ADMIN)`. Tek istisna bu uçtu.

### 1f · `GET /actuals-first/settlements/summary` (`1`) — **`ÖZET`**, 5 rol

**Gerekçe: ölçülmüş DAVRANIŞ** (`ÖLÇÜM 1`, pozitif referans):

```
planner → 1 · planner2 → 0     ← servis içeride resolveScope çağırıyor
```

📌 **`ÖLÇÜM 1`'in kanıtladığı şey:** `@Roles` **olmadan da** kapsam uygulanabiliyor. Bu
uç, `ÖZET` hücresinin **doğru** örneği.


---

## 2 · KARAR GEREKTİRENLER (`30`)

### 2a · `customer` okuma (`10`) ⛔ — sebep **KAPSAM**, rol değil

```
GET /customers · /search · /channel/:channel · /channel-id/:channelId
    /city/:city · /vip · /:id · /code/:code · /:id/stats · /cpl/list
kardeş: POST·PATCH·DELETE·activate·deactivate·import  →  ADMIN,PLANNER
```

**Rol sorusu kardeşten çözülebilir** (`ADMIN,PLANNER` + okuma için diğerleri). **Ama
asıl soru rol değil:**

> ⚠️ **Müşteri verisi `CPL`'e bağlı** (`/customers/cpl/list`). Kapsamı `11` CPL olan bir
> `PLANNER`, **tüm** müşterileri görmeli mi?

`T-253`/`T-254` gösterdi ki kapsam **her yerde uygulanmıyor**. Bu uçlara *"5 rol"*
demek, kapsam katmanı yoksa **herkes her şeyi görür** demek.

### ✅ `S1` KARARI (ürün sahibi, 2026-08-21) — `Z19a`

```
11 uç B2'DE KALIR, rol katmanı UYGULANIR
```

**Reddedilen `(c)` (uçları çıkar):** *"çıkarmak onları **tamamen filtresiz** bırakır;
`(a)` en azından **bir** katmanı kapatır."*

📌 **Rol katmanı gereksiz değil — YETERSİZ.** Tür-düzeyi koruma, kapsam gelse **de**
gerekli.

### ⚠️ RİSK SINIFI DÜZELTİLDİ — ölçüldü

```
customer.service.ts   tenantId               →  37 atıf
                      tenantId'siz `where:`  →  YOK   (pozitif kontrollü)
```

Risk **tenant-içi AŞIRI GÖRÜNÜRLÜK**, **dış sızıntı DEĞİL.**

> *"Kanayan yara değil, **yanlış-teminat**."*

⚠️ Ve bu ayrım analizi değiştiriyor: `S1` bir **güvenlik açığı** değil, bir **koruma
iddiasının fazla geniş olması**.

### 2b · `budget` (`10`) ⛔ — kardeşler **ÇELİŞİYOR**

```
budget-allocation.controller (5 filtresiz)
   GET /budget-allocations · /:id · /reports/utilization
   POST /check-availability · /reports/forecast          ← hesaplama, yazma DEĞİL
   kardeşler:  create/update  ADMIN,FINANCE
               reserve/release ADMIN,CATEGORY_MANAGER
               commit/adjust   ADMIN,FINANCE

budget.controller (5 filtresiz)
   GET /budget/envelopes · /:id · /:id/reserved · /:id/transactions · /status
   kardeşler:  envelopes POST  ADMIN,FINANCE
               reserve         ADMIN,PLANNER
               split           ADMIN,FINANCE
```

⛔ **Kardeş gerekçesi TEK BİR CEVAP VERMİYOR** — aynı controller'da üç farklı rol kümesi
var (`FINANCE` · `CATEGORY_MANAGER` · `PLANNER`). Bu `§5`'in **dal 3**'ü (*"kümeler
FARKLI → GENİŞLEME listesi, tek tek"*).

⚠️ Ve `K-2.6.4` üç rolü de bütçeye bağlıyor: `KATEGORİ MÜDÜRÜ` *"kategori bütçe
sahibi"*, `FİNANS` *"eşik üstü onay · transfer"*, `PLANLAMACI` rezervasyon yapıyor. Yani
her biri için cümle **var** — ama sonuç yine `5/5`'e yakın, ve `Z18`'in uyardığı **şekil**
bu.

📌 **İki `POST` ayrıca sorulmalı:** `check-availability` ve `reports/forecast` **yazma
değil hesaplama** — `WRITE` hücresine mi, `modül-READ`'e mi?

### 2c · `lta` (`6`) ⛔ — üçü **hesaplama** ucu

```
GET  /lta-agreements · /:id · /cpl/:cplId/active     ← okuma
POST /context/rates                                   ← hesaplama
POST /calculate/base-spend                            ← hesaplama
POST /calculate/planned-spend                         ← hesaplama
kardeşler: create/update/activate/terminate  →  ADMIN
```

⚠️ **`0072` bu üç `POST`'u *"hesaplama uçları"* diye ayrıca işaretlemişti.** Ve
`T-249`'un `spend-calculation` kararında hesaplama tetikleyen uçlar **daha dar**
tutulmuştu (`ADMIN,PLANNER`).

**Karar:** hesaplama uçları okuma mı yazma mı? Ve `/cpl/:cplId/active` **kapsam**
sorusu taşıyor (`2a` ile aynı aile).

### 2d · `kpi` grid (`2`) ⛔ — **plan kapsamlı**

```
GET /master-data/kpis/grid/:planId     ← PLAN kimliği alıyor
GET /master-data/kpis/grid
```

Diğer `kpi` uçları düz katalog (`1b`); bu ikisi **bir planın** verisini döndürüyor.
`master-data` altında ama **master-data değil**.

⚠️ **`T-255`'in dersi tam burada:** *"sınıflandırma uç bazında değil, VERİ SINIFI
bazında."* Bu iki uç **plan verisi** döndürüyor → `plan` uçlarıyla aynı hücrede olmalı,
kardeşleriyle değil.

### 2e · `mechanic` hesaplama (`2`) ⛔

```
POST /master-data/mechanics/applicable
POST /master-data/mechanics/check-combination
```

`2c` ile aynı soru: hesaplama ucu hangi hücrede? Kardeşleri (`ADMIN`) yazma uçları.

### 2f · `POST /auth/logout` (`1`) ⛔ — kanıt STATİK, davranışsal koşum YOK

Taslağın ilk hâli bunu **otomatik** saymıştı. **Ürün sahibi `DUR`'a taşıdı:**

> *"`T-256`'nın dersi: `@CurrentUser()` **kırıktı**, ve *'yüklem var'* denilebilirdi.
> `logout` `@CurrentUser`'a bağlıysa aynı sınıfta — **ölçülsün**, otomatik sayılmasın."*

**Ölçüm yapıldı (2026-08-21) — ve `T-256`'nın sınıfında DEĞİL:**

```
async logout(@Request() req)  →  req.user.sub        ← @CurrentUser('id') DEĞİL
@Post('logout')                →  :id parametresi YOK
```

📌 İki bağımsız argüman:
1. `req.user.sub` — `/users/me`'nin **doğrulanmış** deseni (`ÖLÇÜM 2`), JWT'den gelir,
   istemci kontrol edemez
2. **URL'de başkasını adlandıracak bir girdi YOK** — yüklem sorusundan **daha güçlü**:
   saldırı yüzeyi yok

### ✅ ÇÖZÜLDÜ — koşum YAPILDI (2026-08-21)

Ürün sahibi *"koşum gerekli"* dedi, ve ölçüm ucuzdu:

```
A logout                →  204
A logout SONRASI B      →  200   ✅ İZOLASYON TUTUYOR
A logout SONRASI A      →  200   ⚠️ POZİTİF KONTROL
```

**`2f` çözüldü → `1g`'ye geri döner** (otomatik, `28 → 29`).

⚡ **Ama pozitif kontrol İKİ BULGU daha çıkardı** → [[T-264]]:
`logout` yalnız `refreshToken`'ı siliyor, **ve** `.env.example` kodun **okumadığı** bir
değişken belgeliyor (`JWT_EXPIRES_IN` ↔ `JWT_EXPIRATION`, sessizce `1h`).

📌 **Pozitif kontrol, asıl sorunun cevabını değil, YANINDAKİ kusuru buldu.**

---

## `S2` ÖLÇÜMÜ (2026-08-21) — ve soru YENİDEN ÇERÇEVELENDİ

### Ölçüm 1 · YAN ETKİ — `7/7` YAZMA YOK

```
checkAvailability · getForecastReport · getLTAForPlanContext
calculateBaseLTASpend · calculatePlannedLTASpend
getApplicableMechanics · checkCombinationValidity      →  YAZMA: 0
POZ.KONTROL  reserveBudget → 1 · mechanic.create → 1   →  desen ÇALIŞIYOR
```

⚡ **Ve bu `T-249` emsalinin gerekçesini netleştiriyor:**

```
T-249'un distributeMechanicSpend'i   →  YAZMA: 3  (ölçüldü)
```

Yani `T-249`'un dar rolleri (`ADMIN,PLANNER`) **kalıcılaştırma** yüzünden dardı,
*"hesaplama"* olduğu için değil. **Emsal bu yedi ucu yazma sınıfına KOYMUYOR.**

### Ölçüm 2 · `500ms` BÜTÇESİ — bu uçlara UYGULANMIYOR

⚠️ **Ve `K-2.4.8` bu kural DEĞİL** (ölçüldü — o *"boş bırakmak ile sıfır yazmak"*
kuralı). Doğrusu **`EK_B §3`**, ve tanımı **dar**:

> *"Kullanıcının bir hücreye değer girmesinden **güncellenmiş göstergeleri
> görmesine** kadar geçen toplam süre."*

Yani bütçe **grid düzenleme yolunun**; genel bir uç bütçesi değil. Bu yedi uç o yolda
**değil** (aşağı bkz.).

📌 Ve `EK_B §3`'ün kendi notu: hedef **bugün karşılanmıyor** (`52` SKU'da `~540ms`,
eşzamanlıda `~1100ms`) ve **telemetri yok** — yani uyum **iddia edilemez**.

### ⚡ Ölçüm 3 · ASIL BULGU — `7/7` TÜKETİCİSİZ

```
check-availability · reports/forecast · context/rates
calculate/base-spend · calculate/planned-spend · check-combination   →  0 tüketici

mechanics/applicable   →  endpoints dosyasında TANIMLI (getApplicable)
                          ama mechanicEndpoints.getApplicable ÇAĞIRANI: 0
                          POZ.KONTROL: mechanicEndpoints. → 3 dosyada kullanılıyor
```

⚠️ **`§7.1` uygulandı:** modülün import edilmesi fonksiyonun çağrıldığı anlamına
gelmiyor. İlk ölçüm *"1 tüketici"* demişti — **fonksiyon adıyla arayınca `0`.**

## ⛔ `S2`'NİN GERÇEK SORUSU BAŞKA

Soru *"hesaplama ucu hangi hücrede"* değil — **`T-063`/`T-225`/`T-257` ailesinin
DÖRDÜNCÜ vakası:**

> **Bu yedi ucun var olma gerekçesi ne?**

| şık | sonucu |
|---|---|
| **rol ata, `B2`'de kalsın** | `T-257`'nin dersi: *"silinecekse bile **silinene kadar** açık kalamaz"* |
| **`T-063` deseniyle karara bağla** | üç dalın işi önceden yazılır; ama `B2`'yi **bekletir** |
| **ikisi birden** | `B2`'de rol atanır **ve** ayrı bir kader task'ı açılır — `B2` beklemez |

📌 **Önerim `(ikisi birden)`:** `T-257`'de `(c)` seçilebildi çünkü uçlar `K-2.5.6`'yı
**ihlal ediyordu**. Burada ihlal **yok** — yalnız tüketici yok. Yani silme gerekçesi
`T-257`'deki kadar güçlü **değil**, ve `B2`'yi bekletmeye değmez.

---

## 3 · ⚠️ `DUR` SAYISININ SEBEBİ TEK BİR YAPISAL OLGU

`30`'un `30`'u **üç soruya** indirgeniyor:

```
S1  KAPSAM mı, ROL mü?          customer 10 · lta 1  (= 11)
    Rol sorusu çözülebilir, ama kapsam katmanı olmadan "5 rol" = herkes her şeyi görür

S2  HESAPLAMA ucu hangi hücrede?  budget 2 · lta 3 · mechanic 2  (= 7)
    Yazma değil, ama düz okuma da değil — girdi alıp hesaplıyor

S3  KARDEŞLER ÇELİŞİYOR           budget 8 · kpi grid 2  (= 10)
    Aynı controller'da üç farklı rol kümesi; ve kpi grid VERİ SINIFI olarak
    kardeşlerine ait değil
```

`11 + 7 + 10 = 28`, artı `2f` (`logout`) = **`29`**. ⚠️ Kalan `2`: `budget`'ın iki hesaplama `POST`'u hem `S2` hem `S3`'te
sayıldı — **tekil sayım `30`**, ve örtüşme burada.

📌 **Yani `59` ucun `30`'u için ayrı ayrı karar gerekmiyor — ÜÇ karar yetiyor.** Üçü
verilince `30` uç mekanik olarak çözülür.

---

## 4 · Bu taslağın SINIRLARI

- ⛔ **Gerekçe adayları ÖNERİDİR.** `Z18`: taslak gerekçe üretemez.
- ⚠️ `1a`/`1b`/`1c`'nin **5 rol** sonucu `5/5`'e varıyor. Her rol için ayrı cümle
  **yazıldı** (`Z18`'in şartı), ama **şekil** `Z18`'in uyardığı şekil — gözden geçirilmeli.
- ⚠️ `1g` (`logout`) **davranışsal doğrulanmadı** — başkasının oturumunu sonlandırıp
  sonlandıramadığı ölçülmedi.
- ⚠️ Bu taslak **rol** atıyor; **kapsam** ayrı bir katman ve `T-253`/`T-254` onun her
  yerde uygulanmadığını gösterdi. `S1` bu yüzden var.

## 5 · ⛔ `B2`'NİN KABUL KRİTERİNE — İKİ AYRI SÜTUN (ürün sahibi, 2026-08-21)

> *"`B2` bir ucu `@Roles`'a bağlayınca o uç **korunmuş görünür** — ama kapsamsızsa bir
> `PLANNER` **tüm tenant'ı** görür."*

```
uç  ·  @Roles durumu  ·  KAPSAM durumu      ← İKİSİ AYRI SÜTUN
```

### ⛔ VE KAPSAM SÜTUNU KENDİ RATCHET'İNİ ALIR (`Z19b`)

İki sütun **yetmez** — çünkü ikinci sütun bir **metin notu** olarak kalabilir:

> *"**'Adresle'** fiilinin yumuşaklığı — adres bir metin notuysa, `59→0` olduğunda
> ratchet **yeşillenir** ve kapsamsız uçlar **korunmuş sayılır**."*

```
@Roles sütunu    59 → 0        B2 KAPATIR
kapsam sütunu    AYRI RATCHET  bugün ❌ olanların LİSTESİ, tek yön AŞAĞI
                 T-253/T-254 kapanışları listeyi ERİTİR
```

⛔ **`B2`'nin *"bitti"* tanımı İKİYE AYRILIR:**

> **`B2`'nin yeşili YALNIZ `@Roles` sütununu kapatır.**

Kapsam sütunu **ayrı bir kapanış** ister, ve `T-252`'nin desenini izler: **liste, sayı
değil** · **yalnız artış kırmızı** · **baseline `0` → kapıya terfi**.

⚠️ **Tek sütunlu bir liste `B2`'yi yanlış bitirir:** `59 → 0` olur, ratchet yeşile
döner, ve kapsamsız uçlar **korunmuş sayılır**.

📌 Ve ölçülmüş emsal: `T-253`'ün `/users/dashboard-summary`'si `@Roles`'lu **beş rol**
taşıyordu — ve kapsam katmanı olmadığı için iki farklı kapsamlı `PLANNER`'a **birebir
aynı** yanıtı veriyordu.
