# `B3a` — rota → hücre eşlemesi · ÖLÇÜM RAPORU (2026-08-24)

> **Karar ürün sahibinin.** Bu belge ölçüm + öneridir. **Kod dokunuşu: SIFIR.**
>
> ✅ **KARAR VERİLDİ (2026-08-24): `Z30` — dokuz hüküm.** Aşağıdaki `DUR`'ların hepsi
> karara bağlandı; bu belge artık **ölçüm kaydı**, açık soru listesi değil.
> `B3b`'nin şekli `Z30`'un sonundadır.

## Kapsam ve nasıl sınırlandığı

```
rota evreni    33 controller dosyası · route-scope.awk (reponun KENDİ ayrıştırıcısı)  → 223
@Roles'lu      ayrıştırıcının 5. sütunu                                              → 211
rol kümeleri   @Roles metni + ...SPREAD sabitlerinin FIXPOINT çözümü — çözülemeyen 0
kapsam sütunu  scope-{a1,a2,b,c} join — 223/223 eşleşti, eşleşmeyen 0
```

**Yorum kirliliği — iki yönlü poz.kontrol:**

```
ham grep '@Roles('  (yorumlar DAHİL)   215
satır-başı yorum olanlar                 4   ← tenant×2 · settlement×1 · user×1
215 − 4 = 211                          ✅ ayrıştırıcıyla BİREBİR
```

Sayı **iki bağımsız yoldan** aynı çıktı.

## SONUÇ ÖZETİ

```
✅ BİREBİR           104   (%49)
⚠️ FARK               27   (26 UNION kaynaklı + 1 Z20 daraltması)
⛔ HÜCRE ATANMAMIŞ    80   (%38)
```

---

## ⛔ DUR-1 · `80` rota GÖÇEMEZ — eşiğin dört katı

```
MODES_READ      37      SHARED_READ  32      MODES_APPROVE  11
```

**`B3b` bugün başlatılsa `211`'in `104`'ünü göçürüp `107`'sini `@Roles`'ta bırakır** — ve
kalan-`@Roles` ratchet'i **`107`'de takılı** doğar.

### Ve bloke `80`'in `41`'i ZATEN kapsamsız

| hücre | `A1` | `A2` | `B` (kapsam VAR) | `C` |
|---|---|---|---|---|
| `MODES_READ` (37) | **22** | 0 | 10 | 5 |
| `SHARED_READ` (32) | **19** | 9 | 4 | 0 |
| `MODES_APPROVE` (11) | 0 | 0 | **11** | 0 |

📌 `MODES_APPROVE`'un `11/11`'i **kapsamlı** — onay yolunda kapsam katmanı **çalışıyor**.
İki `READ` hücresinin **`41`'i kapsamsız**: bir hücreye `5/5` rol yazmak, o `41` rotada
**herkes her şeyi görür** demek. `Z19`'un *"katman KISMİ"* hükmü **ölçülü**.

---

## ⛔ DUR-2 · `B1` şablonunun kapsamadığı DÖRT rota ailesi

### 2.1 · `Z18` `READ`'i ÜÇE ayırdı — hücre adları ÜRETİLMEDİ

```
Z18 §1        READ_OWN  ·  ÖZET  ·  modül-READ
CAPABILITIES  MODES_READ · SHARED_READ · (USER_READ)   ← yalnız modül-READ
```

`69` `READ` rotası bir ada eşlenemiyor — **çünkü ad yok**. `Z25`'in **kilit** tanımı: şart
yazılı, sağlayıcı yok.

**Ve ölçüm o üçe ayırmanın AMPİRİK girdisini veriyor:**

```
READ_OWN/ÖZET adayı (kapsam B)     14   plans · agreements · dashboard · settlements/summary
modül-READ adayı    (kapsam A1/A2) 50   ledger · agreement-transactions · finance-reporting
                                        · budget · spend-calculation · lta · approvals
kapsam ekseni YOK   (kapsam C)      5   template indirmeleri · tactics/available
```

### 2.2 · `MODES_APPROVE` TEK BİR SINIF DEĞİL

| aile | n | `@Roles` | ne |
|---|---|---|---|
| **gönderim/geri çekme** | 5 | **`AP` — beşi de AYNI** | plan/anlaşma **SAHİBİNİN** iş akışı |
| **onay kararı** | 6 | `ACF`·`ACF`·`ACF`·`AC`·`AC`·`AC` | onaycının kararı |

`capabilities.ts:134` *"onaylayabilir mi ↔ onay ekranını görebilir mi"* sınırını yazmış —
**ama üçüncü ayrım (gönderim) yazılmamış**.

### 2.3 · `POST /notifications/:id/read` — yüklem `SELF`, temsil `@Roles(5/5)`

```
GET  /notifications          @SelfScoped()     ← kardeş
GET  /notifications/unread   @SelfScoped()     ← kardeş
POST /notifications/:id/read @Roles(5/5)       ← ama yüklemi SELF
                             T-275: findById(tenantId, recipientId, id)
                                    recipientId ← @CurrentUser('id')
```

> ⛔ **`Z28`'in 2. sayacı (`@Roles` taşıyan `SELF` uçları = 0) bugün `0` okuyor — çünkü
> sayaç DEKORATÖRE bakıyor, YÜKLEME değil.**

📌 `v1` fixture'ının sessizliğiyle **aynı şekil, ters yön**: orada dekoratör vardı sayaç
görmüyordu; burada **yüklem var, dekoratör yok**.

### 2.4 · `kpis/grid[/:planId]` — modül ekseni yanlış sınıflandırıyor

`kpis/grid/:planId` kapsam kovası **`B`** (gerçek scope); `master-data`'nın diğer **26**
okuma rotası **`C`**. Ve `/kpis/grid` (planId'siz) **`C`** — yani **iki kardeş birbirinden
de ayrışıyor**. `T-273` uyarısı: ikisi tek hücreye konmadan önce `/kpis/grid`'in ne
döndürdüğü **ölçülmeli**.

---

## ⛔ DUR-3 · `Z18 §4` İHLALİ `ROLE_CAPABILITIES`'TE **ZATEN VAR**

`capabilities.ts:111` — `Faz A`'nın kendi ifadesi: *"Ürün sahibi kararı (2026-08-17):
**(a) UNION, ŞARTLI**."*

**Dört gün sonra `Z18 §4` (2026-08-21):** *"⛔ HİÇBİR hücre-rol çifti UNION gerekçesiyle
YAŞAYAMAZ."*

> **`Z18` yazılırken *"gelecekte olmasın"* denilen şey, `Faz A`'da ZATEN OLMUŞTU.**

**Team Lead bağımsız doğruladı:**

```
MODES_WRITE   = {ADMIN, PLANNER, FINANCE}                    = AFP
SHARED_WRITE  = {ADMIN, PLANNER, CATEGORY_MANAGER, FINANCE}  = ACFP
```

Ölçülmüş etki — **`26` rota, `@Roles` GENİŞLEYECEK**:

| hücre | mevcut | türeyen | n | genişleme |
|---|---|---|---|---|
| `MODES_WRITE` | `AP` | `AFP` | **12** | `FINANCE` → Plan CRUD (**`DELETE /plans/:id` dahil**) |
| `MODES_WRITE` | `AF` | `AFP` | **7** | `PLANNER` → upload·validate·process |
| `SHARED_WRITE` | `AP` | `ACFP` | **3** | `CM`+`FIN` → `budget/reserve`, `spend-calculation/distribute` |
| `SHARED_WRITE` | `AF` | `ACFP` | **2** | `CM`+`PLANNER` → `budget/envelopes` **oluşturma**, **`split`** |
| `SHARED_WRITE` | `A` | `ACFP` | **2** | `C`+`F`+`P` → `POST/PATCH /lta-agreements` |

⛔ **Son satır doğrulandı:** `lta-agreement.controller.ts:44-45` `@Post()` +
`@Roles(UserRole.ADMIN)` — bugün **yalnız ADMIN**, union sonrası **dört rol**.

---

## ⚠️ DUR-4 ve diğer FARK satırları

### `GET /users` — `Z20` bir DARALTMA getiriyor

```
bugünkü kod   @Roles(ADMIN, FINANCE)      user.controller.ts:73
Z20           USER_MANAGE → @Roles(ADMIN)
```

⚠️ Bu göç **`FINANCE`'ın tenant kullanıcı listesi erişimini KALDIRIR** — *"göç davranış
değiştirmez"* kuralının **bilinçli istisnası**, ve `DUR`'dan gelmiş olarak **yazılmalı**.

### `capabilities.ts` `Z20`'ye göre BAYAT

`:154` hâlâ *"DUR (5) — … `USER_READ`"* diyor, `CAPABILITIES`'te `USER_READ` duruyor.
`Z20` o hücreyi **ikiye ayırdı ve kapattı**. Dosya **kendi kendisiyle çelişiyor**.

---

## `5` HÜCRE BUGÜN BOŞ — `capabilities.ts`'in *"DUR (5)"*'inden FARKLI bir beşli

| hücre | rota | haritada | ne oldu |
|---|---|---|---|
| `SHARED_APPROVE` | **0** | (bloke) | jenerik onay uçları silindi; `budget-allocation` `Z24` ile **öldü** |
| `NOTIFICATION_READ` | **0** | 5/5 | iki `GET` **`@SelfScoped()`'a geçti** |
| `MODES_MANAGE` | **0** | `A`,`F` | **hiçbir rotaya eşlenmiyor** |
| `USER_READ` | **0** | (bloke) | `Z20` ile ikiye ayrıldı, **kalıntı** |
| `HEALTH_READ` | **0** | 5/5 | rota `@Public()` |

⛔ **`MODES_MANAGE` bir *"yol olmadan verilmiş yetki"*** — `ADMIN`/`FINANCE`'ta duruyor,
arkasında **hiçbir rota yok**.

---

## `APPROVE` HİPOTEZİNİN TESTİ

| hücre | sonuç |
|---|---|
| `SHARED_APPROVE` | ✅ **TUTTU — ama sebebi farklı.** Hücrede `0` rota; dağıtılacak şey yok. **Gerekçesiz kaldığı için** düşer |
| `MODES_APPROVE` | ⚠️ **YARI TUTTU.** `6` gerçekten onay kararı → `K-2.5.12`. **Ama `5` rota onay kararı DEĞİL** (gönderim/iptal/taslak), ve **bir eve ihtiyaçları var** |

**`5`'in gideceği yer — iki şık, ikisi de KARAR:**

```
(i)  MODES_WRITE'a düşsün    →  AP → AFP (union). FINANCE plan GÖNDERİR.
                                ⛔ ve zaten DUR-3'ün kovası
(ii) YENİ hücre MODES_SUBMIT →  {ADMIN, PLANNER}, dal 1 (tek küme, MEKANİK)
                                ✅ K-2.6.4: "PLANLAMACI … GÖNDERİM — GÜNLÜK KULLANICI"
                                ⚠️ 24 → 25 hücre = eksen değişikliği
```

📌 **`(ii)` bir union'dan değil, ROL TANIMINDAN doğar** — *"gönderim"* kelimesi
`K-2.6.4`'te **açıkça yazılı**. `Z18 §4`'ün istediği tam olarak budur.

---

## ÖLÇÜM A · TEL PROTOKOLÜ — **kırılma YOK**, ama iki kopya var

```
capability dizeleri  yanıt DTO'larında 0 · frontend'de 0   (poz.kontrollü)
JWT                  { sub, role, tenantId } — role TEL DEĞERİ, göç ona DOKUNMUYOR
```

⇒ Göç **backend-içi** kalır. `B` dalgasının rol-enum vakası **tekrarlanmaz**.

### ⚠️ Ama frontend'de rol-adı-bağlı ÜÇ kapı katmanı var

| katman | ölçü |
|---|---|
| UI rota kapısı (`routes/index.tsx`) | **38** kapı |
| `RoleGuard.tsx` | tanımlı, **kullanımı 0** → ölü |
| **eylem kapısı** (`useAgreementPermissions`) | `canEdit·canSubmit·canApprove·…` — **backend ile BİREBİR uyumlu** |

⛔ **Ve tam bu yüzden `DUR-3` bir ÇAPRAZ-REPO satırıdır:** union `PATCH`/`DELETE
/agreements/:id`'yi `FINANCE`'a açıyor; `canEdit` **açmıyor**. Sonuç bir `500` değil —
**`FINANCE` API'de yazabilir, ekranda düğmeyi göremez.** İki kopyanın **ilk somut bedeli**.

### ⚠️ Yan bulgu — bugün CANLI çapraz-repo bayatlığı

```
backend   migration 1806  →  users.permissions KOLONU DÜŞTÜ
frontend  UserForm.tsx:118  permissions: createData.permissions   ← HÂLÂ GÖNDERİYOR
```

`Z26`'nın *"`permissions` → sessiz no-op"* kaydının **gönderen tarafı**.

---

## ÖLÇÜM B · `UNRESTRICTED_ROLES` TERFİSİ

```
tanım    access-scope.service.ts:121   new Set([ADMIN, FINANCE])
okuyan   access-scope.service.ts:169   TEK çağrı yüzeyi, aynı dosya
```

### ⛔ `Z18 §3`'ün kümesi BAYAT

```
Z18 §3 (2026-08-21)   "küme AYNI kalır  {ADMIN, FINANCE, READONLY}"
kod bugün             {ADMIN, FINANCE}
kodun yorumu          "T-235 ADIM 2: READONLY bu sabitten ÇIKARILDI (K-2.6.4c)"
```

`READONLY` `Z18`'den **önce** çıkarılmıştı → **`Z18` yazıldığı gün de yanlıştı**.
`F12`/`0006-R` deseniyle düzeltilmeli.

### Üç şık — ölçülmüş sonuçlarıyla

| şık | değerlendirme |
|---|---|
| **(a)** `roles` tablosuna kolon | ⛔ **ÖLÜ TABLOYU DİRİLTİR** — `Role` entity'sinin tüketicisi **beş yüzeyde de `0`**. `capabilities`/`role_capabilities` tam böyleydi ve `T-233` onları **düşürdü** |
| **(b)** ikinci kod haritası | ⚠️ *"koşulsuz → **kayıtlı**"* terfisini **vermez** — kod sabitinden kod sabitine taşımak **statüyü değiştirmez** |
| **(c)** `user_scopes` JOKER SATIRI | ✅ **ÖNERİLEN** — mekanizma **zaten var**, `READONLY` için **fiilen uygulandı**. `K-2.6.8a`: *"kod dalı değil, SATIR kanonik"* |

**Sıra ve ayrılabilirlik:**

```
1  ADMIN + FINANCE'a joker user_scopes satırı      (seed + migration)
2  UNRESTRICTED_ROLES kod dalı KALDIRILIR           ← 1'den SONRA
3  FINANCE'ın K-2.6.4 gerekçesi YAZILIR             ← 1'in ÖN KOŞULU
```

⛔ **`SIRA` yetmez:** `1` inmeden `2` inerse `ADMIN`/`FINANCE` **fail-closed** düşer
(`rows.length === 0` → *"hiçbir şey"*). Ara durum **deploy edilebilir değil**, ve bu
**yazılmalı**.

⚠️ **Ve pencere şerhi:** ölçüm *"capability çözümlemesiyle aynı tur"* bağını **bulamadı** —
`UNRESTRICTED_ROLES`'un tek okuyucusu `AccessScopeService`, `@RequireCapability` ise
`RolesGuard` hattında. **İki ayrı katman, sıfır çağrı bağı.** Pencere *"aynı turda"* değil,
*"aynı konu açıkken"* — **paralel yürüyebilir**.

---

## `B3b` İÇİN ÖN NOTLAR

```
rota-başına TEK MEKANİZMA   bugün ihlal YOK: @Roles+@SelfScoped 0 · @Roles+@Public 0
                            (223 rotanın tamamı tarandı) → guard SIFIRDA doğar ✅
kalan-@Roles ratchet tabanı  211 OLAMAZ — gerçekçi: 107  (80 kilit · 26 karar · 1 Z20)
                            Z29 sayesinde SIFIR-GÜVENLİ ✅
pin çifti önerisi            GET /master-data/brands (ACFPR) ∧ DELETE /users/:id (A)
B2'nin KAPSAM sütunu         DOKUNULMADI — ayrı sütun, @Roles ile KARIŞTIRILMADI
ratchet kör noktası          bloke 80'in 41'i kapsam A1/A2'de; iki listenin anahtarı
                            AYNI (<dosya>|<YÖNTEM>|<yol>) — 223/223 eşleşti
```

---

## ÖLÇÜMÜN SINIRLARI

1. **Hücre atamaları ADAYDIR.** `Z18 §4`'ün *"her hücre-rol çifti için ayrı cümle"* şartı
   **yalnız `T1`/`T2`/`T4`/`T9`'da karşılanmış**.
2. **`WRITE` ↔ `MANAGE` ayrımı bazı ailelerde sonucu DEĞİŞTİRMİYOR** (`customer`,
   `tenant`, `user`) — o satırlardaki `✅` **sınıf ayrımına dayanmıyor**.
3. **Yalnız `@Roles` sütunu ölçüldü.** `12` `@Roles`'suz rota kapsam dışı.
4. **Davranış ölçülmedi.** Kapsam sütunu `Z19b`'nin **kayıtlı** sınıflandırmasından;
   `§2.4`'ün `/kpis/grid` ikizi tam bu sınırın içinde.

> **Tam `211` satırlık tablo ajanın raporundadır** (rota · hücre · `@Roles` · türeyen ·
> sonuç · rol-çıkarma testi · kapsam kovası).

---

# EK · `H4` DAĞILIMI ve `H6` ÖLÇÜMÜ (2026-08-24)

> `Z30 H4`/`H6`'nın istediği ölçümler. **Karar ürün sahibinin.**

## `H4` — `14` adayın dağılımı

**Kümenin sınırı:** `scope-b.txt` `45` satır · `15`'i `GET`; `14` = bunların
`kpis/grid/:planId` **hariç** olanı (o `master-data` hücresinde → `H6`'nın konusu).
`B3a` tablosuyla birebir: `MODES_READ` B=`10` + `SHARED_READ` B=`4`.

```
(b) SUMMARY_READ    4     (3 kesin + 1 sınırda)
(c) READ_OWN        0     ← HİÇBİRİ own-yüklemi taşımıyor
modül-READ         10     (8 kesin + 2 sınırda)
```

### `(b) SUMMARY_READ` — çapraz-modül agregasyon

| rota | okuduğu | modül |
|---|---|---|
| `GET /actuals-first/settlements/summary` | `agreements` + `ledger_entries` (DEBIT−CREDIT) | **2** |
| `GET /dashboard/summary` | `agreements` + `approval_requests` + `budget_envelopes`/`v_budget_summary` | **3** |
| `GET /finance-reporting/budget-variance` | `budget_envelopes` + `v_budget_summary` (→ `budget_transactions`+`ledger_entries`) | **2-3** |
| `GET /dashboard/cpl-status` ⚠️ | `cpls` + `agreements` | **2** — ama agregasyonun kaynağı **tek modül** |

### `(c) READ_OWN = 0` — POZİTİF KONTROLLÜ

`14`'ün **hiçbirinde** sahiplik yüklemi yok. Desen çalışıyor: aynı tarama
`approval.repository.ts:129` `requestedById = :requestedById` (**gerçek own-yüklemi**) ve
plan/agreement **yazma** yollarında `12` eşleşme veriyor. **Okuma metotlarında sıfır.**

📌 **`yüklem ≠ kapsam` ayrımı ölçümle doğrulandı:** `resolveScopedCplIds` bir **kapsam
filtresi**; `14`'ün tamamı onunla daralıyor, **hiçbiri** `req.user`'a bağlı bir sahiplik
yüklemi taşımıyor.

### ⚠️ ÜRÜN SAHİBİNE GİDEN DÖRT SINIRDA VAKA

| rota | soru |
|---|---|
| `plans/:id/budget-check` | Çapraz-modül (plan+bütçe) **ama tek plan için KAPI CEVABI**. `SUMMARY_READ` *"çapraz-modül"* mü, *"portföy özeti"* mi? |
| `dashboard/pending-tasks` | ⛔ **`Z30 H4`'ün *"dashboard sınıfı"* ifadesi bu rotada ÖLÇÜMLE TUTMUYOR** — **tek modül** okuyor (Team Lead doğruladı: `getPendingTasks` gövdesinde yalnız `this.agreementRepo`). Hücreye **modül sayısıyla** mı, **yaşadığı yüzeyle** mi girecek? |
| `dashboard/cpl-status` | İki modül, ama agregasyonun **kaynağı tek**; `cpls` **gruplama boyutu**. Yanıt **hiçbir satırda durmayan** türetilmiş sayaçlar |
| `plans/approval-queue` | Adı *"for current user"*, yüklemi **KAPSAM**. Kayda ***"ad `OWN` diyor, yüklem `SCOPE`"*** diye geçmeli |

📌 **`dashboard`'un üç rotası ÜÇ AYRI davranıyor** (3 modül · 1 modül · 2 modül). Modül
yüzeyine bakarak toptan `SUMMARY_READ` verilseydi, `pending-tasks` **ölçümsüz atanmış**
olurdu — `Z30 H4`'ün *"tek tek, toptan atama yok"* şartının ödediği yer.

---

## `H6` — `GET /master-data/kpis/grid` veri sınıfı

```
okuduğu tablo     main.kpis  —  TEK tablo, başka hiçbir tablo yok
plan-bağlı satır  YOK
şekil             Kpi[]  —  KPI TANIMLARI (formula_text · rag_* · column_order
                            · show_in_grid). HESAPLANMIŞ DEĞER TAŞIMIYOR
```

Poz.kontrol: `kpi.service.ts`'te `InjectRepository(Plan…)` → **0**; `this.kpiRepository.`
→ **16**. `main.kpis` şemasında plan referansı olan **tek kolon yok**.

### ⛔ İKİ KARDEŞ AYNI VERİYİ DÖNDÜRÜYOR — fark KAPININ varlığı

```
findGridKpis(tenantId)        find({ where:{tenantId,isActive,showInGrid}, order:{…} })
getGridKpisForPlan(planId,…)  await planService.findById(planId, tenantId, actor)   ← KAPI
                              find({ AYNI where, AYNI order })
```

> **`planId` bir FİLTRE değil, bir KAPSAM KAPISIDIR.** Yanıt gövdesi ikisinde de
> **bit-bit aynı** `Kpi[]`.

📌 `B` ↔ `C` kova ayrımı **veri sınıfından değil, KAPININ varlığından** doğuyor —
`T-273`'ün *"aynı dekoratör, farklı davranış"* vakasının **tersi**: **farklı kova, aynı
veri**.

### ⛔ VE KOD KENDİ KENDİSİYLE ÇELİŞİYOR — Team Lead doğruladı

```
kpi.controller.ts:70    "bu uç master-data DEĞİL, PLAN verisi döndürüyor"
kpi.service.ts:94-95    "it never returns plan content (grid KPI defs only)"
```

**Aynı repo, aynı rota, iki zıt cümle** — ve **ölçüm servisinkini destekliyor**.

⚠️ Controller'ın cümlesi (`T-267`/`B1 §2d`) **iki rotanın `5`-rollü `@Roles`'unun YAZILI
GEREKÇESİ**, ve `:97-98` onu `planId`'siz kardeşe de genişletiyor — **oysa o kardeşte kapı
bile yok**.

📌 `§`'nin *"kod yorumunda bir iddia varsa ÖLÇÜLMELİ"* sınıfı: bir **kapsam gerekçesi**
ölçülmemiş bir iddiaya dayanıyor, ve **bedeli yapılmayan işte değil, YANLIŞ SINIFLAMADA**.

⛔ **Bu bir kusur iddiası DEĞİL** — davranış ölçülmedi, yalnız **veri sınıfı**. Ama `H6`
*"ölçümsüz hücre atanmaz"* diyor, ve **hücre ataması bu gerekçe cümlesine yaslanamaz.**
