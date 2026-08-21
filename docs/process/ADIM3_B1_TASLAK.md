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

## SAYIM — `28` otomatik çözülüyor · `31` KARAR gerektiriyor

⚠️ **`1g` (`logout`) `DUR`'a TAŞINDI** (ürün sahibi, 2026-08-21) — kanıtı statikti,
davranışsal koşum yok. Bkz. `2f`.

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

**Karar:** rol kümesi + **kapsam uygulanacak mı**. İkisi ayrı katman.

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

⚠️ **Ama davranışsal koşum hâlâ eksik.** `T-256`'nın dersi tam da *"statik kanıt yeter
sanıldı"* idi. Karar ürün sahibinde: bu iki argüman yeterli mi, yoksa koşum mu gerekli?

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

⚠️ **Tek sütunlu bir liste `B2`'yi yanlış bitirir:** `59 → 0` olur, ratchet yeşile
döner, ve kapsamsız uçlar **korunmuş sayılır**.

📌 Ve ölçülmüş emsal: `T-253`'ün `/users/dashboard-summary`'si `@Roles`'lu **beş rol**
taşıyordu — ve kapsam katmanı olmadığı için iki farklı kapsamlı `PLANNER`'a **birebir
aynı** yanıtı veriyordu.
