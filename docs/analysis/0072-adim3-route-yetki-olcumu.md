# 0072 — `ADIM 3` ölçümü: route × yetki dağılımı

> **Mod:** SALT-OKUNUR · sabit yazımı bir sonraki tur
> **Ölçen:** Team Lead · **Tarih:** 2026-08-17 · **Kaynak:** `collmind.backend/src/**/*.controller.ts`
> **Neden ölçüm önce:** yetenek adları route dağılımına göre şekillenir. **Uydurulmuş bir
> taksonomi, 237 ucun yarısına uymaz.**

---

## 0 · Yöntem ve sınırı — önce okunur

**Dekoratör tarandı, dosya adı değil** (`find-entity` dersi). Ve iki tuzak ölçümle kapatıldı:

### ⚠️ İlk iki ölçümüm GEÇERSİZDİ — ve ikisi de "temiz" görünüyordu

| tur | yöntem | sonuç | neden yanlış |
|---|---|---|---|
| 1 | route'tan geriye bitişik satır taraması | **kapsanmış `0`** | döngü koşulu hemen kırılıyordu |
| 2 | dekoratör bloğu, satır-satır | **toplam `93`** | **çok satırlı dekoratörler** (`@ApiOperation({…})`) bloğu sıfırlıyordu |
| 3 | **parantez dengeli** dekoratör bloğu | **`237` / `160` / `77`** | ✅ ham sayımlarla **birebir** |

**Pozitif kontrol** (üçüncü turu doğrulayan): ham `@(Get|Post|Put|Patch|Delete)(` sayımı
**237**, ham `@Roles(` sayımı **160** — ikisi de parser'ın sonucuyla **tam eşleşti**.

> `0` ve `93` sonuçları **hiçbir hata vermedi**. Onları yakalayan tek şey, beklenen büyüklüğü
> **önceden** bilmekti (`~236` / `~159`).

### ⚡ Çıkarma endişesi ÇÖZÜLDÜ

```
sınıf seviyesi @Roles taşıyan controller:  0
→ hiçbir route hem sınıf hem metot seviyesinden kapsanmıyor
→ ÇİFT SAYIM İMKÂNSIZ, dolayısıyla 237 − 160 = 77 GEÇERLİ
```

### `236 → 237` farkı bizim

`T-214`'ün `PATCH /approval-policies/:id` ucu (`b92a725`): **+1 route, +1 `@Roles`**.
Yani `0056`'nın `159`'u bayat değil — **kaydedildiği günden bu yana bir uç eklendi.**

### ⛔ `DUR` koşulu TETİKLENMEDİ — ve cevabı öğretici

`isPublic` işareti **var** (`jwt-auth.guard.ts:19,24` — reflector ile okunuyor), ama
**hiçbir controller onu kullanmıyor** (`--include='*.controller.ts'` → `0`).

> **Yani `77` ucun hiçbiri BİLİNÇLİ AÇIK değil — yalnız İŞARETSİZ.** Mekanizma var, kullanan
> yok. Bu, kapının *"herkese açık"* olmasının bir **karar** değil bir **boşluk** olduğunu
> söylüyor — ve `K-2.6.6`'nın ölçülmüş hâliyle birebir uyuşuyor.

---

## 1 · TABLO — `77` filtresiz uç: modül × HTTP metodu

```
modül                     GET  POST  PATCH  PUT  DEL   TOP
master-data                25     2      0    0    0    27
shared                     17     7      0    0    0    24
customer                   10     0      0    0    0    10
user                        2     3      2    0    0     7
modes                       1     2      0    0    0     3
notification                2     1      0    0    0     3
tenant                      2     0      0    0    0     2
other                       1     0      0    0    0     1
TOPLAM                     60    15      2    0    0    77
```

### Teşhis: **desen yokluğu**, unutma değil

`8` modüle dağılmış. Tek modülde toplansaydı bir **unutma** olurdu; dağınık olması
*"kural hiç kurulmamış"* demek.

⚠️ **Ve `60/77` `GET`** — yani filtresizliğin ağırlığı **okuma** tarafında.
📌 Bu, `K-2.6.9`'un ölçümüyle **aynı yöne** bakıyor: kapsam filtresi de bugün kapalı. İkisi
birlikte, *"bir kullanıcı ne görebilir"* sorusunun **hiçbir katmanda** cevabı olmadığını
gösteriyor.

⚠️ **`PUT`/`DELETE` sütunları `0`** — ve bu iyi haber: **yıkıcı uçların hepsi kapsanmış.**
Filtresizlik okuma ve `POST` tarafında.

---

## 2 · TABLO — `160` kapsanmış ucun rol kümeleri

```
rol kümesi                                                    uç    modüller
ADMIN                                                         56    admin · master-data · shared · tenant · user
ADMIN · PLANNER                                               26    customer · modes · shared
ADMIN · FINANCE_MANAGER                                       20    modes · shared · user
ADMIN · CATEGORY_MANAGER · FINANCE_MANAGER · PLANNER · READONLY  14    modes · shared · user
ADMIN · FINANCE_MANAGER · PLANNER                             12    modes
ADMIN · CATEGORY_MANAGER · FINANCE_MANAGER · READONLY           9    modes · shared
ADMIN · CATEGORY_MANAGER                                       5    modes · shared
(READ_ROLES sabiti)                                            4    modes
ADMIN · CATEGORY_MANAGER · FINANCE_MANAGER                     3    modes
ADMIN · FINANCE_MANAGER · PLANNER · READONLY                   3    modes
ADMIN · FINANCE_MANAGER · READONLY                             3    shared
CATEGORY_MANAGER                                               2    shared
(WRITE_ROLES sabiti)                                           1    modes
ADMIN · CATEGORY_MANAGER · READONLY                            1    modes
ADMIN · CATEGORY_MANAGER · PLANNER · READONLY                  1    modes
```

### ⚡ `FARKLI KÜME SAYISI: 15` — `ROLE_CAPABILITIES` haritasının gerçek boyutu

Beş rol var, ama **15 farklı küme** kullanılıyor. Ve dağılım **çok çarpık**:

```
ADMIN tek başına        56 uç   (%35)
en çok kullanılan 3 küme 102 uç  (%64)
kuyrukta 8 küme          ≤3 uç   (her biri)
```

📌 **Kuyruk uzun ve ince** — sekiz küme üçer uçtan az. Bu, yetenek adlandırmasının
**küme başına** değil **işlem sınıfı başına** yapılması gerektiğini söylüyor; yoksa
`15` yetenek adı doğar ve yarısı birer uca hizmet eder.

### Rol başına geçiş (bir uç birden çok rolde sayılır)

```
ADMIN             153        CATEGORY_MANAGER   35
FINANCE_MANAGER    64        READONLY           31
PLANNER            56
```

### ⚠️ `R2a` kalıntı kontrolü — ölçüldü

```
APPROVER   0      MANAGER   0      (eski) FINANCE   0        ✅ TEMİZ
```

**Ama enum KEY'i duruyor:** `FINANCE_MANAGER = 'FINANCE'` (`user.entity.ts`). Ve bu bir
kalıntı **değil** — kayıtlı bir erteleme:

> `EK_C`: *"Enum KEY'i `R2b`'ye ertelendi (2026-08-13). … **Değer doğru, key kozmetik —
> dalgayı büyütmeye değmez.**"*

⛔ **AMA `ADIM 3`'te kozmetik olmaktan ÇIKAR.** `ROLE_CAPABILITIES` haritası rollerle
anahtarlanacak; `UserRole.FINANCE_MANAGER`'ın değeri `'FINANCE'` olduğu için harita
**anahtarı ile veri değeri ayrışır**. `EK_C`'nin kendi uyarısı bunu zaten adlandırıyor:
*"ad benzerliği ile anlam ayrışması — bu turda **iki kez** ısırdı."*

→ **`ADIM 3`'ün `DUR` listesine girmeli**, ve kararı ürün sahibinin.

---

## 3 · TABLO — modül × işlem sınıfı (tüm `237`)

```
modül                  okuma   yazma   onay/iş-akışı   yönetim   TOP
modes                     37      19              12         2    70
master-data               25      37               0         2    64
shared                    33      18               5         1    57
customer                  10       3               0         4    17
user                       4       9               0         2    15
tenant                     3       4               0         1     8
notification               2       1               0         0     3
admin                      2       0               0         0     2
other                      1       0               0         0     1
TOPLAM                   117      91              17        12   237
```

⚠️ **Sınıflandırma yöntemi:** metot adından türetildi (`approve|reject|submit|escalate|
return|cancel|close|reverse|settle|commit|release` → onay/iş-akışı; `seed|import|bulk|
activate|deactivate|assign|config|clone` → yönetim; kalan `GET` → okuma; kalan → yazma).
**Bu bir sezgisel**, ve bir sonraki tur adlandırma yaparken **madde madde doğrulanmalı**.

### `77` filtresizin işlem sınıfı

```
okuma 60  ·  yazma 15  ·  onay/iş-akışı 2  ·  yönetim 0
```

⚠️ **`onay/iş-akışı`'nda 2 filtresiz uç var** — bunlar en riskli olanlar, çünkü onay
akışı `K-2.5.12`/`K-2.5.16`'nın konusu. Bir sonraki tur bu ikisi **adıyla** listelenmeli.

### Taksonomi büyüklüğü

```
üst sınır      9 modül × 4 sınıf   = 36 yetenek
fiilen dolu hücre                   = 24
```

⚠️ **`0056`'nın *"20 yetenek"*i `§7.2`'den geliyor ve DOĞRULANMADI.** Bugünkü ölçüm
`24` dolu hücre gösteriyor — yakın, ama **aynı şey değil**: `§7.2` bir **kaynak listesi**,
bu bir **kod dağılımı**. Bir sonraki tur ikisi **yan yana** konmalı ve fark **madde madde**
gerekçelendirilmeli.

---

## 4 · Bir sonraki tura taşınanlar

| # | ne | neden |
|---|---|---|
| 1 | `onay/iş-akışı` sınıfındaki **2 filtresiz uç** adıyla listelensin | en riskli alt küme |
| 2 | `§7.2`'nin `20` yeteneği ↔ ölçülen `24` hücre **yan yana** | fark gerekçelendirilmeli |
| 3 | `FINANCE_MANAGER` key'i `ADIM 3`'ün `DUR` listesine | `ADIM 3`'te kozmetik olmaktan çıkıyor |
| 4 | işlem sınıfı sezgiseli **madde madde** doğrulansın | adlandırmanın tabanı |
| 5 | `READ_ROLES`/`WRITE_ROLES` sabitleri açılsın | 5 uç bu iki sabitin arkasında |

## 4b · ⚡ SONRAKİ TUR ÖLÇÜLDÜ — *"77 uç korumasız"* İDDİASI NİTELENDİ

Ürün sahibinin sorusu: *"`77`'nin kaçı başka bir guard taşıyor?"* — ve iddia
`K-2.6.6`'nın **ihlal gerekçesi** olduğu için ölçülmesi zorunluydu.

```
72   kimlik doğrulanmış, ROL KISITI YOK        ← K-2.6.6'nın GERÇEK ihlali
      (70 · JwtAuthGuard + RolesGuard   ·   2 · JwtAuthGuard)
 2   ALAN guard'ı taşıyor                      ← korumasız DEĞİL
      ReversalGuard · SettlementGuard
 3   hiçbir guard yok                          ← ve DOĞRU
      POST auth/login · POST auth/refresh · GET / (health check)
```

### ⚡ Ve default-deny'ın TAM YERİ bulundu

```ts
// roles.guard.ts:11-18
const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, [...]);
if (!requiredRoles) {
  return true;          // ← @Roles YOKSA HERKESİ GEÇİRİYOR
}
```

> **`K-2.6.6`'nın istediği tersine çevirme TEK BİR YERDE:** `roles.guard.ts:16-18`.
> Ama o üç satırı çevirmek **72 ucu aynı anda** kapatır — `report-only` fazının
> gerekçesi tam olarak budur.

### İddianın düzeltilmiş hâli

- ❌ *"77 uç korumasız"* — **yanlış**: 2'si alan guard'lı, 3'ü **bilinçli ve doğru** açık.
- ✅ *"**72** uç kimlik doğrulanmış ama **rol kısıtı yok** — yani **herhangi bir oturum
  açmış kullanıcı** erişebilir."*

📌 Fark küçük görünüyor ama `K-2.6.6`'nın gerekçesi bu cümlenin üstünde duruyor. Ve
`3` bilinçli-açık uç, `isPublic` işaretinin **kullanılmamasının** bedelini gösteriyor:
doğru davranıyorlar ama **işaretsiz**, yani bir sonraki okuyucu onları da ihlal sayar.

### GET-olmayan `17`'nin dağılımı (ürün sahibinin sorusu)

```
15 POST · 2 PATCH        (60 GET ile toplam 77)
```

Ve **`13`'ü `JwtAuthGuard + RolesGuard`** taşıyor — yani yazma yapan korumasız uçlar
**var**, ve `GET`'ten farklı bir risk sınıfı: `spend-calculation/distribute/…` ·
`spend-calculation/recalculate-on-volume-change/…` · `budget-allocations/…` gibi
**hesaplama tetikleyen** uçlar bunların içinde.

⚠️ Ve `2` onay/iş-akışı ucu tam da **alan guard'ı taşıyan ikisi** — yani en riskli
görünen alt küme aslında **korunuyor**. Bu, ölçüm yapılmadan yazılan bir *"en riskli"*
etiketinin nasıl yanılabileceğinin örneği.

---

## 4c · ⚡ SONRAKİ TUR ÖLÇÜLDÜ — `5/5` rol taşıyan route'lar ve **`A`/`C` sınıf ayrımı**

> **Ölçen:** Team Lead · **Tarih:** 2026-08-17 · **Bağlam:** `ADIM 3 Faz A` union turu
> **Neden burada:** bu ayrım `§3`'ün `modül × işlem` ekseninde **görünmüyor** ve
> yalnız `capabilities.ts` başlığında yaşıyordu — kanonik ölçüm belgesine taşındı.

### Sayı düzeltmesi: `14` değil **`18`**

İlk parser iç içe sabiti tek geçişte çözemedi:

```ts
const WRITE_ROLES = [UserRole.ADMIN, UserRole.FINANCE];
const READ_ROLES  = [...WRITE_ROLES, PLANNER, CATEGORY_MANAGER, READONLY];
```

`@Roles(...READ_ROLES)` gövdesi bir kez genişletilince `WRITE_ROLES` **hâlâ
çözülmemiş** kalıyor → `sales-actuals`'ın dört rotası `{PLANNER, CATEGORY_MANAGER,
READONLY}` sanıldı ve `5/5` listesinden **düştü**. **Fixpoint** ile düzeltildi;
çözülemeyen sabit **`0`**.

⚠️ **Ve düşen dördü tam olarak hipotezi çürüten kanıttı** — ilk sayımla raporlansaydı
hipotez *doğrulanmış* görünürdü. `§0`'ın *"ilk iki ölçümüm geçersizdi"* dersinin
üçüncü vakası, ve aynı sınıf: **desen çalıştı, evren eksikti.**

### `18`'in sınıf kırılımı — `@Roles` yüzeyinden AYNI, davranışta ÜÇ AYRI

| sınıf | mekanizma | route |
|---|---|---|
| **`A`** — aktör kapsamı **servis katmanında** | `@CurrentUser` → `resolveScopeForFilter(actor)` (`plan.service.ts:385`) | `approval` `my-requests`·`:id` · `plan` `findAll`/`findOne`/`:id/analysis`/`:id/approval-history` · `agreement` `findAll`/`findOne`/`tactics/available` · `dashboard` `summary`/`pending-tasks`/`cpl-status` — **11** |
| **`B`** — **ölü ikiz** | `@deprecated`, `GET /dashboard/summary`'nin ikizi (`user.controller.ts:116`) | `user` `dashboard-summary` — **1** |
| **`C`** — kapsam **YOK**, özet **DEĞİL** | yalnız `tenantId`; `@CurrentUser` yok | `sales-actuals` `batches`·`batches/:batchId`·`batches/:batchId/rows`·`summary` · `finance-reporting` `plan-performance` — **6** |

📌 **`sales-actuals` `READ_ROLES` bir ÖZET DEĞİL** — dördünün yalnız biri (`/summary`)
özet; `batches/:batchId/rows` **satır düzeyinde gerçekleşen satış verisi** döndürüyor.
Dosyadaki tek `@CurrentUser` kullanımı `:65`, **upload** rotasında.

### ⛔ Bunun taksonomiye sonucu

`A` ve `C` **`@Roles` yüzeyinden ayırt edilemez** — ikisi de `5/5`. Ayrım yalnız
**servise** bakınca çıkıyor.

> Bu, `§3`'ün *"işlem sınıfı metot adından türetildi"* sınırının kardeşi ve
> `POST = yazma` varsayımının aynı şekli: **dekoratör bir yüzey, DAVRANIŞ başka.**

Yani `modül × işlem` ekseni bir üçüncü boyutu (**kapsam**) taşımıyor, ve üç `READ`
hücresinin çöküşü tam olarak oradan geliyor. Reklasifikasyon **yapılmadı** —
`§2.4`: ölçüm şartı sağlanmadan yetenek adı yazılmaz.

---

## 5 · Ölçümün sınırları

- **Yalnız `*.controller.ts`.** Bir route başka bir yerde tanımlıysa (dinamik kayıt,
  `RouterModule`) sayılmadı — böyle bir yol **aranmadı**.
- **`@Roles` dışındaki yetki mekanizmaları sayılmadı** — `settlement.guard.ts` ·
  `reversal.guard.ts` · `admin-restrictions.guard.ts` gibi guard'lar var (`K-2.6.9`
  ölçümünde görüldü) ve bir ucu `@Roles`'suz da koruyabilirler. **`77`'nin bir kısmı bu
  guard'larla korunuyor olabilir.**
- İşlem sınıfı **metot adından** türetildi, gövdesinden değil.


---

## ⚡ ÇAPRAZ SINAMA — `§4c`'nin `A`/`C` ayrımı bağımsız bir yoldan doğrulandı (2026-08-21)

`Z18`'de `ADIM 3`'ün üç `READ` hücresi **taksonomi** ekseninden çözüldü (union
çöküşünün sebebi aranırken), `§4c`'nin sınıf ayrımına **bakılmadan**. İki yol aynı
yere vardı:

```
READ_OWN + ÖZET   ⊂   A sınıfı   (servis kapsamı VAR)
sales-actuals     =   C sınıfı   (kapsam YOK)
```

⚠️ **Ve `§4c`'nin AÇIK bıraktığı soru bu turda cevaplandı:** `sales-actuals`
`SHARED_READ`'in **meşru sakini değil** — kapsamsız ham finansal veri. Adresi
`ADIM 4`.

📌 **İki bağımsız yolun aynı taksonomiye varması güçlü bir sinyaldir** — ve
`CLAUDE.md`'nin *"bir hipotezi DOĞRULAYAN ölçüm, ÇÜRÜTEN ölçümden daha fazla
doğrulama ister"* maddesinin karşılandığı hâl: ikinci ölçüm **farklı bir yüzeyden**
geldi, aynı ölçümün tekrarı değil.

⚠️ **Ve bu belgede bayat bir satır var** (`capabilities.ts`'in *"Filtresiz 4"* listesi
üzerinden): `POST /spend-calculation/distribute/...` ve
`.../recalculate-on-volume-change/...` artık **filtresiz DEĞİL** — `T-249` onlara
`@Roles` ekledi (`SPEND_WRITE_ROLES = {ADMIN, PLANNER}`). Bugünkü sayım:
**`238` rota · `172` `@Roles`'lu · `66` filtresiz** (`3` `@Public` + `2` alan-guard'lı
+ **`61` gerçek boşluk**).
