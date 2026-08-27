# `ADIM 3` — KAPANIŞ RAPORU · `B3b-1` bilançosu + `B4` ön-koşul sayımı

**Tarih:** 2026-08-27 · **Hazırlayan:** Team Lead · **Karar:** ürün sahibi
**Tür:** ⛔ **KARAR-GİRDİSİ BELGESİ** — bir rapor değil
**Statü:** 🔒 **MÜHÜRLÜ** (2026-08-27) — `B4` hükmü verildi, `A′` indi

---

# 🔒 MÜHÜR — `ADIM 3` KAPANDI

> **`61` filtresiz uçla başladı; `210` rotalık gerekçeli envanter, `25` hücrelik
> davranıştan-türetilmiş yetenek haritası, `default-deny` çekirdeği (`A′`), kendi
> evrenlerini türeten `12+` kapı ve `15` satırlık adresli-sözleşmeli artıkla kapandı.
> **On bir dalga, sıfır beklenmeyen davranış değişikliği.** Kalan her satırın
> **kim-ne zaman-neyle** açacağı yazılı.**

## Son sabitlik satırı — taze ölçüldü

```
@Roles 15 + CAPABILITY 195 = 210          G4 çapraz-araç: satır=210
FILTRESIZ 0 · PUBLIC 3 · SELF 7 · ALAN_GUARD 2 · CAPABILITY 195 · ROLES 15
G1…G8 · G5b(25/0) · G5c(25/25/0) · G2b(12/12) · G7 BİREBİR · G8(0/0)
```

## `B4` HÜKMÜ — mühürlenen karar

```
B4 = A′ → B, SIRALI İKİ ADIM   (tek düğme DEĞİL — iki düğme ZIT sonuç verir)

A′  ✅ İNDİ   CapabilityGuard default-deny + üç ön-şart:
              @Public/@SelfScoped tanınır · muafiyet TÜRETİLMİŞ evrenden
              · kalan-@Roles ratchet'i (taban 15, DİP 2)
B   ⏳ BEKLER  RolesGuard'ın ölümü — tetiği TARİH değil OLAY: kalan-@Roles = 2
```

⛔ Ve mühre giren bir gerçek: ***"liste sıfırlanınca"* beklemesi SAĞLANAMAZ BİR
KOŞULDU** — iki satır **KALICI**. Sıfır bir tarih değil, **gelmeyecek bir olaydı**.
Bunu bir ölçüm değil, **bir sütun** ortaya çıkardı (`AÇILMA KOŞULU`).

## `A′` dalgasının bıraktığı dört kapı

| kapı | ne tutar |
|---|---|
| `roles-ratchet` | taban `15` · **dip `2`** |
| `alan-guard-ratchet` | taban `2` |
| `domain-guard-parity` | **çift-kayıt** — `route-scope` KAYNAK A ↔ guard KAYNAK B |
| kilitli-tenant pini | **CANLI** zincir, **TEK `it`**, negatif yarı içinde |

---

## 🔒 MÜHRE GİREN ÜÇ SATIR

### 1 · ⛔ KAPI DİSİPLİNİNİN KAPANIŞ TAŞI

> **BİR KAPI, ÖLÇEMEYECEĞİ DURUMDA YEŞİL DEĞİL, *SETUP HATASI* RAPORLAR.**

Bu, `G5`'in evren-boşalmasından başlayan zincirin **son halkasıdır** ve **dört vakayı
tek yasada** toplar:

```
1  BOŞALAN      G5     evren (@Roles rotaları) tükendi     → kapı hiç kırmızı veremez
2  DONAN        G5b    evren iki hücrede dondu             → yeni üye görünmez
3  KAÇIŞ-YOLLU  G2b    tip/ad ekseninden düşen tablo       → "otomatik" görünür, değil
4  ÖLÇEMEYEN    parity env set → KAYNAK A'nın ETKİN değeri → ölçüm ANLAMSIZ
```

> ### **BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR: `yeşil` · `kırmızı` · `"ölçemedim"`.**
> ### **SESSİZ-YEŞİL BUNLARIN HİÇBİRİ DEĞİLDİR.**

⇒ `ADIM 3`'ün **denetim-altyapısı mirası** (`G1–G8` + `G5b`/`G5c` + `G2b` +
`ALAN_GUARD` çifti + `roles-ratchet` + `domain-guard-parity`) **bu yasayla birlikte
devredilir.** `RLS` ve denetim adımları kapılarını **bu standarda** yazar.

### 2 · `constructor.name` — *"örtük varsayılana yaslanan denetim mekanizması"* sınıfı

`A′`'nın domain-guard muafiyeti sınıf **adına** bağlı. Minification açılsaydı yüklem
**sessizce çökerdi**: guard adları kısalır → tanınan küme **boşalır** → her `ALAN_GUARD`
rotası **default-deny**'a düşer.

Bugün `minimize: false` **gerekçesiyle yazılı** (önceden `@nestjs/cli`'nin **örtük**
`mode:'none'` varsayılanına yaslanıyordu, ve **hiçbir kapı onu tutmuyordu**).

⚠️ **Ama bu satır `Faz-2`/deploy hazırlığında bir KARAR NOKTASI olarak geri gelecek:**
prod build'de minification istenirse **yüklem ada değil TOKEN'a bağlanmalı.**
⇒ **İlk-deploy ön-koşul listesine tek satır:**
> *"Guard-tanıma yükleminin **minification-dayanıklılığı** doğrulanır."*

### 3 · `ADIM 3`'ün tek-paragraf özeti

*(Yukarıda, mührün ilk cümlesi — çünkü altı ay sonra ilk okunacak şey odur.)*

---

> ## Neden bu belge önce geliyor
>
> `B4` hükmü **bundan okunacak**, ve `T-304`'ün önceliklendirmesi de. Beşinci tarama
> satırı (`DISIPLIN`: *"KARAR-GİRDİSİ YÜZEYLERİ, KARARINDAN ÖNCE TARANIR"*) tam bunu
> emreder: **on dalganın dağınık kayıtları tek belgede toplanmadan** verilen bir karar,
> **bayat-parça riski** taşır.
>
> ⚠️ Bu risk bu oturumda **iki kez gerçekleşti** (`Z42 ADIM 0`'ın dört sapması ·
> `Z43 §0`'ın ölçüm-genellemesi). Belge o yüzden **taze ölçümle** kuruldu, hafızayla
> değil: her sayı bir komut çıktısından türedi.

---

# 1 · `B3b-1` — NİHAİ BİLANÇO

## 1.1 Tek satır

```
@Roles  211  →  15        ·  ON DALGA  ·  BEKLENMEYEN pin kırmızısı: SIFIR
```

## 1.2 Envanter tarihçesi — **her satır bir commit'ten ölçüldü**

| commit | tarih | `@Roles` | dalga |
|---|---|---|---|
| `47eee51` | 08-25 | `176` | `W4a` |
| `b560321` | 08-26 | `168` | `W4b` (`Z36`) |
| `00b8b33` | 08-26 | `168` | kaza `K1`+`K2` |
| `4282094` | 08-26 | `167` | `T-289` (`Z38`) — uç **kaldırıldı** |
| `94e51e8` | 08-26 | `165` | kaza `K4` P1 |
| `ad0ece2` | 08-26 | `148` | `W5` |
| `44b5a20` | 08-26 | `123` | `W6` |
| `02ecf83` | 08-26 | `78` | **`W7` — dalgaların EN BÜYÜĞÜ (45 rota)** |
| `b613cb6` | 08-26 | `61` | `W8` |
| `f433811` | 08-26 | `20` | **`W9` — `Z42` birebir (41 rota)** |
| `f19d176` | 08-27 | **`15`** | **`Faz-B` — `Z43` istisna (5 rota)** |

⚠️ **Toplam rota `211 → 210`:** tek düşüş `4282094`'te ve o bir **göç değil, bir
KALDIRMA** (`POST /budget/reserve`, `Z38`). Envanter *"eridi"* değil, **bir uç öldü**.

## 1.3 `§5` metrikleri — **kümülatif**

| metrik | değer | not |
|---|---|---|
| **Çürüyen iddia** | **her dalgada ≥1** | ve en pahalıları **Team Lead'indi** |
| **`DUR` sıklığı** | **her dalga ≥1 kalem** ürün sahibine | mekanik akış **karar üretmedi**, karara **taşıdı** |
| **Team Lead ölçüm hatası** | iki *"tutarsızlık"*ın **ikisi de** | ve **kendisi** buldu |
| **Kapı ağının kendi sağlığı** | **üç kez** ölçüldü | `G8` proaktif · `G5b` review · `G2b` **iki kez** |
| **Beklenmeyen pin kırmızısı** | **SIFIR** | on dalga boyunca |

### Çürüyen iddialar — **son üç dalganın en pahalıları**

| dalga | çürüyen | çürüten |
|---|---|---|
| kaza `K6` | *"`PLANNER` uydurma id ile POSTED satır üretebilir"* (dört durağan yüzey **doğruydu**) | repro pini: uç **her seferinde `500`** |
| `Z42` paketi | *"`LIST`/`POINT` ekseni yedi kümeyi açıklar"* | altı genel çiftin **altısında** küme aynı |
| `Z43` | *"tek tüketici `/finance`"* — **ölçüm-genellemesi** | `dashboard/summary`'nin tüketicisi `DashboardPage` |

📌 Ve `Z42`'nin çürüyen hipotezi **boşa gitmedi**: `APPROVAL_QUEUE` ailesini işaret etti
(`4/4`). *"Çürüyen hipotezin **işaret değeri**."*

## 1.4 Task dengesi

```
B3b-1 arkında AÇILAN     T-283 … T-305        (23 task)
  ├─ kapandı (done)       T-284 · T-285 · T-287 · T-288 · T-289 · T-294 · T-296
  │                       T-297 (W9'da indi) · T-299 (Z42/Z43'te çözüldü)      = 9
  ├─ review               T-283                                                = 1
  └─ DEVREDEN (todo)      T-286 · T-290 · T-291 · T-292 · T-293 · T-295 · T-298
                          T-300 · T-301 · T-302 · T-303 · T-304 · T-305        = 13
```

> ⛔ **Devreden 13'ün hiçbiri `B3b-1`'in ARTIĞI değil** — hepsi **bu arkın ölçümlerinin
> ÜRETTİĞİ** yeni bilgi. Bir göç turu, kendi kapsamı dışında **on üç adresli borç**
> doğurdu; bu bir başarısızlık değil, **görüş alanının genişlemesidir**.

### En ağır üçü — **canlı kusur**

| task | ne |
|---|---|
| `T-293` | LTA formu kaydediliyor, **spend motoru onu okumuyor** — iki uç yeşil, **bağ yok** |
| `T-295` | `ProtectedRoute` fail-open **∧** giriş ekranı **∧** evrensel fallback **∧** kapısız |
| `T-304` | kapsam borcu `38/38` — ve `Z25` kilidinin **sağlayıcısı** |

---

# 2 · KALAN `15`'İN SÖZLEŞMESİ

> **Her satır: ADRES · STATÜ · AÇILMA KOŞULU — *"kim, ne zaman, neyle açar"*.**

| n | rota(lar) | adres | statü | ⛔ AÇILMA KOŞULU |
|---|---|---|---|---|
| **6** | `plans/:id/{approve,reject,escalate-to-finance,review}` · `agreements/:id/{approve,reject}` | `K-2.5.12` · `T-276` ailesi | **KARAR BEKLER** | **Onay yeteneği kararı.** `Faz-2`'nin *"değiştir/onayla ekseni"* (`T-292`) ile **komşu** — ⇒ **`Faz-2` girdisiyle birlikte** açılır, tek başına değil |
| **4** | `lta-agreements` · `/:id` · `/:id/activate` · `/:id/terminate` | **`T-293`** (`Z39 §4` kayıtlı hayalet) | **BLOKLU** | `T-293`'ün **çift-model** teşhisi çözülmeden hücre adı bile yanlış. ⇒ **`T-293` kapanınca** |
| **3** | `finance-reporting/{budget-at-risk, cash-flow-projection, variance-analysis}` | **`T-304` DİLİM-1** | **`Z25` KİLİDİ** | `+CM` genişlemesi **kapsam-koşullu**: kapsam zorlaması inmeden `CM` **tenant-geneli görür**. ⇒ **`T-304 D1`** açar |
| **1** | `plans/pending-approvals` | `Z43 §3` | ✅ **KAYITLI, KOŞULSUZ** | **Açılmaz.** `−F` cümlesi ölçülerek kuruldu: *"`FINANCE` bu uçtan **iş göremez**"* — `findPendingApprovals` `PENDING_FINANCE_REVIEW` **döndürmez**; ihtiyacı `approval-queue` karşılıyor |
| **1** | `finance-reporting/budget-variance` | `Z42 ADIM 0` (SAPMA-3) | ✅ **KAYITLI, KOŞULSUZ** | **Açılmaz** *(bugünkü bilgiyle)*: frontend tüketicisi **SIFIR** (`EK_E` `🔒`). Bir tüketici doğarsa hücre sorusu **yeniden açılır** |

## ⛔ Sözleşmenin özeti — **iki sınıf**

```
KOŞULLU  13  →  6 (Faz-2 komşusu) + 4 (T-293) + 3 (T-304-D1)
KALICI    2  →  kayıtlı, gerekçeli, koşulsuz — BUNLAR ASLA SIFIRA İNMEZ
```

> ⛔ **Bu, `B4`'ün tasarım varsayımını ÇÜRÜTÜR** — bkz. `§3`.


---

# 3 · `B4` ÖN-KOŞUL SAYIMI

## ⛔ 3.1 — KRİTİK SORU, ve cevabı: **SORU YANLIŞ KURULMUŞTU**

> *"`default-deny` flip'i kalan 15'e ne yapar?"*

**Cevap tek değil — çünkü `B4` diye tek bir düğme YOK.** İki ayrı fail-open noktası
var ve **ZIT sonuç** veriyorlar (`ÖLÇÜLDÜ`, koddan):

```
roles.guard.ts:16-18        if (!requiredRoles) return true;    ← fail-open #1
capability.guard.ts:42-44   if (!required)      return true;    ← fail-open #2
APP_GUARD                   grep → 0 eşleşme    ⇒ GLOBAL KALDIRAÇ YOK
```

| düğme | ne yapılır | **kalan 15'e etkisi** |
|---|---|---|
| **A** | `CapabilityGuard` `return true` → `return false` | ⛔ **ERİŞİM KAPANIR** — 15'i de `403`, **`ADMIN` dahil** |
| **B** | `RolesGuard` zincirden çıkar, `@Roles` yerinde kalır | ⛔ **ERİŞİM AÇILIR** — 15'i de **her kimliği doğrulanmış kullanıcıya** |

> ⛔ **Aynı isimle anılan iki iş, tam zıt güvenlik sonucu üretiyor.** `B4`'ün hangisini
> kastettiği **bugün hiçbir belgede yazılı değil.** Bu, hükümden önce kapatılması
> gereken **bir tanım boşluğudur** — bir öncelik sorusu değil.

### ⛔ VE DÜĞME `A`'NIN GERÇEK KAPSAMI `15` DEĞİL, `22`

`CapabilityGuard` zincirde **ama** `@RequireCapability` **yok** olan rota:

```
22 = 15 ROLES  +  6 SELF (/users/me ailesi · notifications · my-requests)  +  1 settlement/close
```

**Doğrulandı (Team Lead, bağımsız):** `user.controller.ts:65` `@UseGuards(Jwt, Roles,
Capability)`, `/users/me` ailesi `@SelfScoped()` taşıyor — ve
**`capability.guard.ts` `SELF_SCOPED`'ı da `IS_PUBLIC_KEY`'i de HİÇ OKUMUYOR**
(74 satırda **0** eşleşme).

> ⇒ **Düğme `A` bugünkü hâliyle çevrilirse `/users/me` KIRILIR** — ve `/users/me`
> oturum yenilemenin yolu. Bu, `ADIM3_FAZB_PLAN.md`'nin **önceden yazdığı** vaka;
> çözümü (`@SelfScoped` tanıma) **henüz yazılmamış**.

### ⚠️ Bir güvenli yön — ölçüldü

`capability.guard.ts:51-57`: rota **hem** `@Roles` **hem** `@RequireCapability` taşırsa
→ **`return false`** (**fail-CLOSED**). Yani `(a)`'da bir rotaya sonradan yetenek
eklenirse rota **sessizce açılmaz, sert kapanır**.

## 3.2 — FLIP'İ KİM ADIYLA SÖYLER

| taraf | güç | kanıt |
|---|---|---|
| **STATİK** | ⛔ **15 / 15** | `route-scope.sh:210+` **"`@Roles` YAZILMIŞ AMA `RolesGuard` ZİNCİRDE DEĞİL — KURULUM HATASI"** bloğu: `exit 2`, her rotayı `dosya\|YÖNTEM\|yol` olarak **basar**. Ve `@Roles` da silinirse rotalar `FILTRESIZ` kovasına düşer → baseline'da **0 `F` satırı** ⇒ **ratchet kırmızı** |
| **DAVRANIŞSAL** | ⚠️ **2 / 15** | yalnız `plans/:id/approve` (`role-journey` N5/N11) ve `budget-variance` (`:105`) `403` ayrımı yapıyor |

⛔ **Sessiz kalanlar** — dört LTA yazma ucu · `plans/:id/{review,escalate-to-finance}`
(**hiçbir e2e'de geçmiyor**) · üç `finance-reporting` ucu · `agreements/:id/{approve,reject}`
(`403` servis katmanında, guard'da değil) · `pending-approvals`.

> Bu bir **`§2.7 #6`** vakası: testler var, **ayırt etme güçleri yok**.

📌 **Ama statik taraf kör değil** — her iki bozulma yolu da bir kapıya çarpıyor. Yani
risk *"sessiz felaket"* değil, *"kırmızıyı e2e değil guard verir"*.

## 3.3 — ÜÇ SAYAÇ: **ÜÇÜ DE SIFIR** *(ve bir belge bayat)*

`Z28`'in üç sayacı (`ADIM3_FAZB_PLAN.md:470`) — bugün yeniden ölçüldü:

| # | sayaç | bugün |
|---|---|---|
| 1 | `FILTRESIZ` | ✅ **0** |
| 2 | `@Roles` taşıyan `SELF` ucu | ✅ **0** (7 SELF rotanın 7'sinde) |
| 3 | guard `SELF` kovasını **tanıyor** | ✅ çıktıda kova başlığı basılıyor |
| — | ratchet sıfırı | ✅ |

⚠️ **`docs/decisions/TASARIM_KATMANI_VE_HATLAR.md:58` BAYAT:** *"`B4`'e üç sayaç +
ratchet sıfırı **kaldı**"* diyor; **üçü de inmiş**. — Bu, beşinci tarama satırının
**bu turdaki üçüncü yakalayışı**.

## 3.4 — `KİLİTLİ-TENANT PİNİ`: **YOK**, ve eksik olan iki şey FARKLI

| yarı | durum |
|---|---|
| *"`default-deny` altında"* | **ÖLÇÜLEMEZ** — default-deny henüz yok. **Tanımsal**, eksik değil |
| *"zincir"* | ⚠️ **kısmen var, ama brief'in istediği şekilde DEĞİL** |

```
✅ user-scope-creation.e2e-spec.ts:670   GERÇEK CANLI ZİNCİR, mock YOK
   admin POST /users (role+scope) → login → kapsam içi 201 → kapsam dışı 403
⚠️ "rol ata" AYRI bir HTTP çağrısı olarak zincirde DEĞİL (yaratma anında veriliyor)
⚠️ NEGATİF YARI (PLANNER → POST /users → 403) AYRI bir `it`'te
⛔ user-capability-boundary.e2e-spec.ts  ÜÇÜ DE AYRI `it` + NONEXISTENT UUID
                                        ⇒ GUARD'ı kanıtlar, ZİNCİRİ kanıtlamaz (§2.7 #6)
```

> **En ucuz yol:** `user-scope-creation.e2e-spec.ts:670`'in zincirini temel al,
> `PATCH /users/:id/scope`'u **zincire ekle**, negatif yarıyı **aynı `it`'e** koy.

## 3.5 — `Adım 2` kalemleri: **`B4`'ü BLOKLAYAN YOK**

| kalem | statü | bloklar mı |
|---|---|---|
| 1 RLS `N` `0/48` · 2 denetim envanteri · 4 `T-205` · 5 `K-2.6.9` | ✅ kapandı | hayır |
| **3 onay bekleme dağılımı** | ⛔ **eşik `2/20`** | **hayır** — şart *"veri biriktiğinde ölç"* diye **yeniden yazılmıştı** (`FAZ1_PLAN.md:145`); bir **erteleme**, kilit değil |
| **6 negatif kullanılabilirlik invariantı** | ⛔ **HÂLÂ AÇIK** — test **yok**, `budget_envelopes`'ta CHECK **yok** *(poz. kontrol: aynı sorgu 2 CHECK buldu)* | **hayır** — `B4`'e bağlanmamış bir **borç** |

**Kalem 3'ün verisi (`ÖLÇÜLDÜ`, şema-nitelendirilmiş):**
```
main.approval_requests  APPROVED/REJECTED = 2   (süreleri 113ms · 121ms ⇒ e2e ARTEFAKTI)
main.plans = 0 · main.plan_approval_history = 0 · main.tenants = 1 (dev)
POZ.KONTROL: main.admin_audit_logs = 39  ⇒ sıfırlar GERÇEK, bağlantı artefaktı değil
```
⇒ *"İlk müşteri tenant'ı"* **henüz yok**. Sayı üretmek `§ Karşılanamayan bir ÖLÇÜT`
ihlali olurdu.

## ⛔ 3.6 — KAYIP SAYAÇ: kalan `@Roles`'ı hiçbir kapı TUTMUYOR

```
grep -rn "roles-baseline\|ROLES_BASELINE" scripts/guards/*.sh   →  0 eşleşme
route-scope.sh                                     ROLES: 15  ← "(bilgi)" etiketiyle
```

⇒ ***"15 büyümesin"* şartını bugün HİÇBİR KAPI tutmuyor.** `(b)`'de önemsiz (hedef
sıfır); **`(a)`'da kritik** — çünkü `(a)` 15'i **kalıcı** kılıyor.

---

## ⛔ 3.7 — İKİ SEÇENEK, ÖLÇÜLMÜŞ MALİYETLERİYLE

| eksen | **(a) İSTİSNA-LİSTELİ FLIP** | **(b) FLIP BEKLER** |
|---|---|---|
| **ne demek** | `CapabilityGuard` default-deny **ve** `@Public`+`@SelfScoped`+`@Roles`'ı **tanır**; `RolesGuard` **4 controller**'da dar artık-guard olarak yaşar | 15 satır karara bağlanıp göçene kadar `B4` **açılmaz** |
| **kod maliyeti** | `capability.guard.ts` (74 satır) + **3 yeni metadata okuması**; 19 controller'dan `RolesGuard` çıkar, 4'ünde kalır | **0** bugün |
| **test borcu** | **22 rota** için *"default-deny altında hâlâ geçiyor"* pini; bugün **13'ünde `403` ayrımı yapan e2e yok** | ilgili karar dalgası kadar azalır |
| **fail-open riski** | ⚠️ var **ama KAPIYA BAĞLI**: bir rotadan `@Roles` kazayla silinirse `FILTRESIZ`'e düşer → **ratchet kırmızı** | bugünkü profil **değişmez** |
| **`single-mechanism`** | ✅ **İTİRAZ ETMEZ** — kural **rota başına**, sistem başına değil | değişmez |
| **`KİLİTLİ-TENANT` riski** | ✅ **düşük** — admin zincirinin üç ucu **`CAPABILITY` kovasında**, default-deny'dan etkilenmez | — |
| ⛔ **`İlke 4` / yazılı hüküm** | ⚠️ **ASIL İTİRAZ:** `capability.guard.ts:14-17` *"`RolesGuard`'ın kaldırılması … kalan-`@Roles` listesi **BOŞALMADAN yapılamaz** — bir karar değil, bir **ÖLÇÜM SONUCU**"*. `(a)` bu cümleyi **REVİZE EDER** ⇒ karar defterinde **kayıt ister** | mevcut yazılı hükümle **birebir uyumlu** |
| ⛔ **süre** | bugün açılabilir | **`§2`'ye göre SÜRESİZ**: 2 satır **KALICI** — sıfır bir tarih değil, bir **olay** |

### Kararı hangi olgu belirliyor

> **`§2`'nin sözleşmesi `(b)`'yi bir bekleme değil, bir BELİRSİZLİK yapıyor:**
> 13 satır koşullu (`Faz-2` · `T-293` · `T-304-D1`), **2 satır KALICI**.
> `(b)` seçilirse `B4` **hiçbir zaman** açılmaz — çünkü beklediği koşul
> **sağlanamaz bir koşuldur.**

⇒ Ürün sahibine giden soru **`(a)` mı `(b)` mi** değil; şudur:

```
1  B4 hangi DÜĞMEDİR — A mı B mi?          (bugün YAZILI DEĞİL, ve zıt sonuç veriyorlar)
2  capability.guard.ts:14-17'nin "boşalmadan yapılamaz" cümlesi
   §2'nin İKİ KALICI SATIRI karşısında revize edilecek mi?
3  (a) seçilirse: kalan-@Roles için bir RATCHET açılacak mı? (bugün YOK)
```

⚠️ **Üçünün de cevabı ürün sahibinindir.** Bu bölüm hüküm **içermez** — `(a)` ve `(b)`
yan yana, **ölçülmüş maliyetleriyle** duruyor.

---

# 4 · KAPI ENVANTERİ — **denetim altyapısının TAPUSU**

> `RLS` ve denetim adımları bu ağı **devralacak**. Her kapının **tek satır sözleşmesi**:
> *ne ölçer · evrenini nereden türetir · hangi mutasyonla kanıtlı*.

## 4.1 `route-cell-map.py` — mutabakat ağı (`npm run guards` yoluna bağlı, `T-288`)

| kapı | ne ölçer | evren-kaynağı | mutasyon kanıtı |
|---|---|---|---|
| `G1` | anahtar tekilliği · boş/geçersiz hücre | **türetilmiş** (rota satırları) | — |
| `G2` | `SUMMARY`/`APPROVE` kümelerinde ölü/çift üye | **yazılmış** (`Z31`/`Z32` kaydı) | — |
| **`G2b`** | **12 override tablosunda** ölü/çift üye | ⛔ **TÜRETİLMİŞ — `cell_for`'un KAYNAĞINDAN** | ✅ **iki eksen**: tip (`set`→`list`) · ad (`_ROUTES`→`_OVERRIDES`); ikisi de `exit 2`, tablo **yeni adıyla** yakalandı |
| `G3` | çözülemeyen `@Roles` | türetilmiş | — |
| `G4` | **çapraz araç** — `route-scope` ile toplam mutabakatı | türetilmiş (iki bağımsız araç) | — |
| `G5` | `Z35` bölünmesi ↔ `@Roles` | türetilmiş | *(evreni `W6`'da boşaldı — `G5b` doğdu)* |
| **`G5b`** | **25 hücrenin ROL KÜMESİ** ↔ dondurulmuş karar hükmü | ⛔ **DONDURULMUŞ KAYIT** *(kontrolün girdisi kontrol ettiğinden türemiyor)* | ✅ `READONLY += MODES_LEDGER_READ` → `exit 2`, hücreyi **adıyla** |
| **`G5c`** | **hükümsüz hücre** — göçmüş rota taşıyıp tabloda olmayan | ⛔ **TÜRETİLMİŞ** (göçmüş rotalardan) | ✅ tablodan bir hücre **düşürüldü** → `exit 2` |
| `G6` | göç **doğru hücreye** vardı mı (beyan ↔ türetim) | iki bağımsız yol | — |
| `G7` | **TSV sürüklenmesi** (commit'li ↔ taze üretim) | türetilmiş | ✅ dekoratör geri alındı → `DRIFT`, `exit 2` |
| `G8` | harita ↔ üretici **çift yönlü** (ölü ∧ hayalet hücre) | türetilmiş | ✅ sıfır-rota hücre eklendi → `exit 2` |
| `W1` | *(uyarı)* `ADMIN` taşımayan rota | türetilmiş | — |

## 4.2 Ratchet ailesi (`Z29`) + kardeşleri

| kapı | ne ölçer | not |
|---|---|---|
| `money-float` | Alan A'da kayan-nokta bulgusu **artmasın** | `--ratchet` · baseline **kendini yazmaz** |
| `lint-ratchet` | dosya başına lint borcu **artmasın** | ⚠️ `11 improved` birikmişti — `Z41` dersi |
| `scope-ratchet` | kapsam listesi (`A1`/`A2`/`B`/`C`) **büyümesin** | ⛔ **UYGULANDIĞINI ölçmez**, LİSTENİN BÜYÜMEDİĞİNİ ölçer |
| `route-scope` | `FILTRESIZ` kovası + `ROLES`/`CAP` sayımı | `G4`'ün çapraz aracı |
| `single-mechanism` | bir rota **iki mekanizma** birden taşımasın | `B4`'te kritik — bkz. `§3` |
| `app-runtime-grants` | çalışma-zamanı yetki self-test'i | ⚠️ **aralıklı** — `T-290` |

## 4.2b · `A′` DALGASININ DÖRT KAPISI (2026-08-27)

| kapı | ne ölçer | evren-kaynağı | mutasyon kanıtı |
|---|---|---|---|
| `roles-ratchet` | kalan `@Roles` **artmasın** (taban `15`, **dip `2`**) | **türetilmiş** (`route-scope --list-roles`) | ✅ baseline'dan anahtar silindi → `exit 1`, **adıyla** |
| `alan-guard-ratchet` | `ALAN_GUARD` kovası **büyümesin** (taban `2`) | **türetilmiş** (`--list-alan-guard`) | ✅ fixture'dan guard düşürüldü → `exit 1` |
| **`domain-guard-parity`** | ⛔ **ÇİFT-KAYIT**: muaf-guard kümesi **iki bağımsız kaynakta AYNI mı** | KAYNAK A `route-scope.sh` ↔ KAYNAK B `capability.guard.ts` | ✅ **iki yönde**: `KAYNAK-A-ONLY` · `KAYNAK-B-ONLY`, ikisi de **adıyla**. Ve **env set → `exit 2`** (*ölçemedim*) |
| `single-mechanism` **(genişletildi)** | **DÖRDÜNCÜ ÇİFT**: `@RequireCapability` + tanınan domain-guard | KAYNAK A'dan **geçirilir** (üçüncü kopya **yok**) | ✅ `SettlementGuard` sınıf seviyesine → `exit 3`, rotayı **ve çifti** adıyla |

> ⛔ **`ratchet` SAYIYI tutar · `parity` SINIFI tutar.** Yeni bir domain-guard
> **iki yere birden** yazılmadan geçemez, ve ikinci yazım bir **karar-kaydı** ister.

## 4.3 ⛔ AĞIN KENDİ SAĞLIĞI — bu arkın en değerli çıktısı

Üç kapı, **üç ayrı evren-kaynağı**, ve doğrusu **üçüncüde** bulundu:

```
YAZILMIŞ    donar     G5b (ilk) · G2b (ilk)      → yeni üye listeye girmez
TARANMIŞ    kaçar     G2b (globals)              → tip/ad ekseninden düşer, ÇALIŞMAYA DEVAM EDER
TÜRETİLMİŞ  ✅        G2b (cell_for) · G5c        → hüküm veren yer neresiyse evren orası
```

> **TEK YASA: HÜKÜM VEREN YER NERESİYSE, KAPININ EVRENİ ORASIDIR.**
> *(`DISIPLIN`: beklenti **dondurulur**, evren **türetilir**.)*

⚠️ **Ve taranmış olan en tehlikelisidir, çünkü OTOMATİK GÖRÜNÜR** — kimse kapsamını
sorgulamaz. Yazılmış bir liste **görünür biçimde** eksiktir; taranmış bir evren
*"kendiliğinden büyüyor"* sanılır.


---

# 5 · ⛔ BU BELGENİN KENDİ SINIRLARI

`DISIPLIN`: *"bir ÖLÇÜMÜN geçerliliği de koşullarına bağlıdır — koşulu ölçümle
birlikte yaz."*

| ölçülemeyen | neden |
|---|---|
| düğme `A`/`B`'nin **CANLI** davranışı | ölçüm turu **salt okunurdu**; `§3.1` **kod okumasından** türedi (`roles.guard.ts:16-18` · `capability.guard.ts:42-57`), **davranıştan değil**. ⛔ **Bir mutasyon + reprodüksiyon pini ile doğrulanmalı** — `T-289` dersi: *"dört durağan yüzey doğruydu, sonuç yanlıştı"* |
| *"`default-deny` altında admin zinciri"* | **default-deny yok** ⇒ ölçülecek durum mevcut değil. Tanımsal |
| onay bekleme **dağılımı** (medyan/p90) | örneklem **2**, ikisi de e2e artefaktı; `main.plans` **0 satır**. Sayı üretmek `§ Karşılanamayan bir ÖLÇÜT` ihlali olurdu |
| ekran pininin ikinci yarısı (`B3 §4`) | test sayfayı `vi.mock`'luyor ⇒ **kurulum ölçülecek koşulu yok ediyor** (`§2.7 #4`). Kutu **işaretlenmedi** |

## Bu turda düzeltilen BAYAT karar-girdisi yüzeyleri

Beşinci tarama satırı bu belgeyi kurarken **üçüncü kez** iş gördü:

```
Z42 ADIM 0    dört sapma (biri: İPTAL EDİLMİŞ bir kuralın bağlayıcı alıntısı)
Z43 §0        ölçüm-genellemesi ⇒ hüküm İKİ UÇTA geri çekildi
§3.3          TASARIM_KATMANI_VE_HATLAR.md:58 — "üç sayaç KALDI" · ÜÇÜ DE İNMİŞ
```

> **Üç turda üç bayat cümle, ve üçü de bir sonraki kararın GİRDİ yüzeyindeydi.**
