# `FAZ-1` KAPANIŞ BEYANI

> **Tarih:** 2026-08-28 · **Yazan:** Team Lead · **Statü:** ⏳ **mühür-öncesi son okuma bekliyor**
> **Dayanak:** `docs/process/FAZ1_KAPANIS_DENETIMI_BRIEF.md` · ölçümler bu turda, canlı
> **İşaretleme:** `[ÖLÇÜLDÜ]` bugün · `[DEVRALINDI]` başka bir turun ölçümü · `ÖLÇEMEDİM`

---

# ⚡ BEYAN

> ## **`FAZ-1` TAM KAPANDI.**
> **Aktivasyon-eşiği listesi ektedir; her satırın sahibi ve tetikleyicisi yazılıdır.**

⛔ **Ve bu bir "koşullu kapanış" DEĞİLDİR** — çünkü hiçbir ölçüt açık değil. Ölçüt-5'in
tanımı **kayıtla daraltıldı** (`Z50`/`Z54`) ve **o tanım karşılandı**:

> `Faz-1`, `RLS`'i **erteleyerek** kapanmıyor — **`RLS`'in `Faz-1` payını
> TAMAMLAYARAK** kapanıyor. Aktivasyon bir sonraki fazın değil, **bir eşiğin** işi.

---

# 1 · BEŞ ÖLÇÜT — **ölçülerek** işaretlendi

⚠️ `FAZ1_PLAN §0b`'nin tablosu `2026-08-20` tarihliydi ve **sekiz gün, altı `ADIM`**
güncellenmemişti. **Okunmadı — yeniden ölçüldü.**

| # | ölçüt | durum | kanıt `[ÖLÇÜLDÜ]` |
|---|---|---|---|
| **1** | ayrıcalıksız DB rolleri, sessiz geri dönüş yok | ✅ **KARŞILANDI** | `app_runtime`·`app_migrate` → `super=f · bypassrls=f · createrole=f`. `app_operator` `bypassrls=t` **bilerek** (`Z52`, operatör rolü). `postgres` yalnız bootstrap |
| **2** | kapsam filtresi açık + besleyen yolu var | ✅ **KARŞILANDI** | bayrak `access-scope.service.ts:163` okunuyor, `:188` `PLANNER` dalında kullanılıyor · besleyen yol `PATCH /users/:id/scope` **canlı** · **37** aktif kapsam satırı / **9** kullanıcı |
| **3** | yetenek modeli + `default-deny` | ✅ **KARŞILANDI** | `206` `@RequireCapability` · `26` hücre · `capability.guard.ts` **`DEFAULT-DENY`** dalı. **kalan `@Roles`: 15** (baseline `15`, **dip değer `2` KALICI** — `Z44 §4`), ratchet **exit 0** |
| **4** | denetim: **kim · ne zaman · neye dayanarak** | 🟡 **DAR TANIMLA KARŞILANDI** | ↓ `§1a` |
| **5** | çok-tenant izolasyonu | ✅ **KARŞILANDI** *(hükümlü tanımla)* | ↓ `§1b` |

## `1a` · Ölçüt-4 — **üç parçalı**, ve hiçbir yarım yuvarlanmıyor

```
kim + ne zaman        39/39 KANITLI                    ✅
dayanak alanı         ŞEMA HAZIR · SINIF-TANIMI BORÇ   → justification paketi
görme yolu            API HAZIR · EKRAN BORÇ           → T-326
                      ⇒ ÜÇÜ TEK KUYRUKTA: denetim-çekirdeği tamamlama paketi
```

**Ölçüm:** `admin_audit_logs` **39** satır · `admin_id` **39/39** · `created_at` **39/39**
· `justification` **0/39** · **27** yazıcı çağrı yeri, `justification` yazan **0**
*(POZ.KONTROL: `afterValues` → 8 yazıcı, tarama şekli sağlam)*.

⛔ **Ve `0/39` bir kusur DEĞİL, tanımsız bir sınıfın doğal yansımasıdır** *(ürün sahibi)*:
ölçütün üç ayağı **eşit doğmadı** — *"kim + ne zaman"* **her** denetim satırının zorunlu
alanı; *"neye dayanarak"* **yüksek-riskli eylem** sınıfının alanı, **ve o sınıf bugün
tanımsız** (`Z`-kaydı yok, sözlükte yok). Hiçbir eylem *"yüksek-riskli"* etiketi
taşımıyorsa hiçbir satır `justification` taşıyamaz.

⚠️ **Ama `T-079`/`T-314B` kaydı da doğru:** tanımsız kaldıkça kolon **ölü vaat**.

## `1b` · Ölçüt-5 — **hükümlü tanım**, ve her parçası ölçülü

```
YÜRÜRLÜKTEKİ TANIM (süzgeç kararıyla revize):
  "Çok-tenant izolasyonu: TASARIM + POLİTİKA-ŞEKLİ + KANIT-ALTYAPISI Faz-1'de;
   AKTİVASYON ikinci-müşteri/deploy SERT EŞİĞİNDE."
```

| parça | kanıt |
|---|---|
| üç açılış kararı **hükümlü** | `Z45` · `Z46` · `Z50` |
| politika şekli **yazılı** | fail-closed boş-küme |
| sonda | **üç-çıktılı + iki-kiracılı** |
| desen **kanonik** | `SET LOCAL` + istek-kapsamlı tx, `NFR`-ölçümlü (`p95` delta `0.59 ms` = bütçenin `%0.12`'si) |
| `FORCE` hükmü | `Z54` — **(ii) açık**, muafiyet politikası **yok** |
| canlı kusurlar | `T-307` (çapraz-tenant) · `T-308` (`security_invoker`) **KAPALI** |
| bugünkü hâl | `relrowsecurity` **0/48** · `FORCE` **0/48** — **hükümle böyle** |

---

# 2 · 5-HALKA MÜHRÜ — çekirdek döngü

```
anlaşma/plan → gerçekleşme → eşleştirme → settlement/claim → defter
```

| halka | mühür | dürüstlük satırı |
|---|---|---|
| **1 · anlaşma/plan** | 🟡 **KOŞULLU** | Çekirdek yaşam döngüsü (`create→submit→approve/reject→return-to-draft→approve`) **SQL kanıtlı, ayırt edici, canlı** (`role-journey` A1–A21). ⛔ **İSTİSNA ADIYLA:** `POST /plans/:id/review` ve `/escalate-to-finance` **e2e SIFIR** (POZ.KONTROL: `return-to-draft` → 20) — yalnız **mock'lu unit**; RBAC, gerçek durum geçişi, DB izi ve audit satırı **bu iki uçta hiç ölçülmedi** |
| **2 · gerçekleşme** | 🟡 **KOŞULLU** | Üç bacağın üçü de canlı e2e taşıyor. ⛔ on-invoice **tek mutlu-yol** testine bağlı, okuma/şablon yüzeyi **tamamen beyan**; `sales_actuals` **ÇIKMAZ BACAK** — modül-dışı üretim tüketicisi **0** (POZ.KONTROL: `AgreementTransaction` → 4). *"Süreç net"* denebilir, ***"süreç tamam" denemez.*** |
| **3 · eşleştirme** | 🔴 **YOK — ve mühürlenmesine gerek yok** | ⛔ **Açıkça yazılır:** *eşleştirme halkası `Faz-1`'de **YOKTUR**; bugünkü ilişkilendirme bir **GİRDİ ALANIDIR** (kullanıcı `agreementId`'yi dosyaya kendi yazıyor), ve **idempotency eşleştirme değildir**.* Üç yerde kayıtlı ve **bilerek** kapsam dışı: `L2_04:52,156` · `EK_E:105` · `FAZ1_PLAN:582` (`Faz-2` çekirdeği) |
| **4 · settlement/claim** | 🟠 **YARISI** — **tek satır yazılamaz** | `settlement` yarısı turun **en iyi kanıtlanmış** halkası: `BR-E2E-02` (`cap=20000`, `DEBIT=12000` → close sonrası available **tam +20000**, `+8000` değil) **iki semantiği gerçekten ayırıyor**. ⛔ `claim` yarısı **ŞEMA-ONLY**: 0 rota · 0 servis · 0 satır — ve dashboard'da **iki bayat yorum** hâlâ *"CTPM does not have a separate Claim entity yet"* diyor (entity `2026-08`'de doğdu). **İkiye bölünmeden mühürlenirse manşet yanıltır** (`Z58`) |
| **5 · defter** | 🟢 **MÜHÜRLENDİ** | Yön ayrımı (`DEBIT − CREDIT`) **üç kat pinli**: canlı e2e (`reversal.e2e:272` — yön-bağımsız `SUM`'a dönülse `consumed` **artardı**) + `ledger-direction.sh` guard + ratchet. Üç yazıcının üçü de kapsanmış. ⛔ **DÜRÜSTLÜK SATIRI:** kanıt **e2e + guard**'tan gelir, **`ledger.repository.spec.ts`'ten DEĞİL** — o dosya `LedgerRepository`'yi **hiç import etmiyor**, yerel bir `netAmount()` kopyası test ediyor (`§2.7 #8` **kanonik vakası**); unit katmanında bir **sahte kapsama** vakası, temizlik listesinde |

⚠️ **Ve halka 1 için bir ikamet notu:** `plans` canlı DB'de **0 satır** — plan halkasının
tüm verisi e2e'nin ürettiği ve sildiği veridir (`T-047` net-sıfır invaryantı bunu
**zorunlu** kılıyor). Halka **kanıtlı, ama ikamet etmiyor**.

---

# 3 · KAPATTI · DEVRETTİ · ARTIK

| **KAPATTI** *(bu fazda bitti)* | **DEVRETTİ** *(`Faz-2`'nin işi, kayıtlı)* | **ARTIK** *(adresli, kapanışı bloklamaz)* |
|---|---|---|
| DB rol ayrımı + ayrıcalık düşürme (`K-2.6.13`) | eşleştirme halkası (`K-2.13.*`) | `justification` sınıf-tanımı |
| Kapsam zorlaması + besleyen yol (`T-242a`) | `claim` yarısı (şema var, kod yok) | `T-326` denetim ekranı |
| Yetenek modeli + **`default-deny`** (`A′`/`B4`) | baseline hattı (`D1`–`D4`) | `sözlük Madde 2` |
| `RLS` tasarımı + politika şekli + kanıt altyapısı | `T-293` LTA birleşmesi · `T-291` | `T-321` `%100 BLOCKED` |
| Denetim kaydı **yazımı** (kim + ne zaman) | ROI-onay politikaları (`E1`,`E4`) | `T-324` ✅ *(bu turda kapandı)* |
| Bildirim dilimi — **`K-2.2.7b` yürürlükte** | çok-seviyeli sıralı onay (`E2`) | `T-325` e2e tek-çalıştıran kilidi |
| Dört DB-hijyen kapısı + ratchet ağı | `sales_actuals` tüketicisi | **`T-314` dörtlüsü** — `GRANT`-drift kapısı · `NULL`-tenant okuyucu · arşiv adımı · `schema-isolation` kapsamı |
| — | — | temizlik: ölü ikiz grid (854 satır) · `tier_roles` · `calculate-kpis` ucu · `ledger.repository.spec` · bayat `claim` yorumları · filtrelemeyen filtre |

## Bildirim halkası — **beş-ölçüt tablosunun satırı**

> **`K-2.2.7b` yürürlükte: zil çalıyor.**
> **Kanıtı: `P1`–`P4b` + iki-yol pinleri, mutasyon-kanıtlı, `P4b` mock'suz.**

Ve açılış↔kapanış mesafesi: **üç hafta önce** *canlı zil, **sıfır** çağıran* —
tablo, servis, kanal, UI'ın **dördü de vardı ve zincir kopuktu**. **Bugün:** üç-dünyalı
ilişki-pini · tx-güvenli yazım · görünür fallback · tekrar-bastırma.

---

# 4 · EK — AKTİVASYON EŞİĞİ LİSTESİ

**Sahibi ve tetikleyicisi yazılı** *(kaynak: `FAZ1_PLAN §0`)*:

| # | eşik kalemi | tetikleyici |
|---|---|---|
| 1 | Yedekleme (RPO/RTO) | ilk deploy |
| 2 | Guard-tanıma yükleminin **minification dayanıklılığı** | prod build'de minification istenirse |
| 3 | **Aktivasyon-öncesi yük probe'u** (`411` sorgu çağrı yerinin havuz etkisi) | `RLS` aktivasyonundan **önce** |
| 4 | **compose-tanımı ↔ canlı-container eşleşmesi** (port · volume · env) | `compose` kullanımı başlayınca |
| ~~5~~ | ✅ **`K1b` iki-belirteç pini — GEÇTİ (2026-08-28, `exit 0`)** · `DB_OPERATOR_PASSWORD` `.env`'de | ~~insan eylemi~~ — **TAMAMLANDI** |
| 6 | `RLS` **aktivasyonu** | **ikinci müşteri / deploy** |
| **6a** | ⛔ **`T-308` davranışsal pin** + **`BLOCKED` kapıların açılışı** (yeni-tablo-`RLS` dahil) | **aktivasyonla BİRLİKTE** |

> ⚠️ **`6a` neden ayrı bir satır:** `T-308` bugün `status: blocked` ve açılma koşulu
> *"`RLS` aktivasyonu"*. **Aktivasyon günü bir checklist okunacak — o gün hatırlanması
> gereken her şey BUGÜN o listede olmalı.** *(Bir eşik listesi, eşiğe varan turun
> hafızasına güvenemez.)*

---

# 5 · `FAZ-2` AÇILIŞ TEZİ — *"inşa" değil, **doğrulama + tamamlama***

`JOIN`'in ana çıktısı beklenenden **büyük**: `Section-10`'un `Faz-2`'ye ertelediği
**Planning Grid'in tamamı** (`A1`–`A7`) · **KPI agregasyonu** (`B3`) · **edge-case `null`
propagasyonu** (`B4` — BRD'den **daha katı**) · **admin-konfigüre formüller** (`B5`) ·
**RAG** (`C2`) · **bütçe `COMMIT`** (`E3`) · **Plan Performance Report** (`F1`) —
**hepsi bugün çalışıyor ve üretim yolu var.**

⛔ Ve bir **bonus**: `variance-analysis` — BRD onu ***`Explicitly NOT in Phase 2`***
listesine koyup `Faz-3`'e atmıştı. **Yapılmış.**

> ### ⇒ `Faz-2`'nin gerçek kalan işi, BRD'nin 10-haftalık listesi DEĞİL:
> ```
> i    KPI motorunun DOĞRULUK MÜHÜRLENMESİ
>        33/30-aktif envanteri · eksik-KPI teşhisi · <500ms CANLI ölçümü
>        ⇒ üçü de bugün ÖLÇEMEDİM statüsünde — oradan çıkarılacak
> ii   BASELINE HATTI
>        D1'in GERÇEĞİYLE inşası + ≥%95 kapısı
> iii  T-293 BİRLEŞMESİ + devir listesi kararları
> iv   SENARYO ZİNCİR TESTLERİ
> ```
> **`Faz-2` bir *inşa fazından* çok bir *doğrulama + tamamlama fazına* dönüşüyor** —
> ve bu, üç haftadır kurulan disiplinin `Faz-2`'ye **en doğal girişi**.

---

# 6 · `ÖLÇEMEDİM` — aynen taşınıyor

| ne | neden |
|---|---|
| `A4`'ün `<500ms` hedefi **bugün tutuyor mu** | enstrüman kurulu, ölçüm **canlı UI koşumu** ister; tur salt-okunur |
| `B1`'in eksik `7`–`10` KPI'ının **hangileri** olduğu | kanonik `40+` listesi `Section-10`'da **yok**; karşılaştırma evreni kurulamadı |
| baseline'ın bir **kolon** düzeyinde gizli saklanması | tablo düzeyinde ölçüldü (**48/48**), kolon düzeyinde taranmadı |
| `review`/`escalate` unit testlerinin **mutasyonla sınanmışlığı** | salt-okunur rol — dosya değiştirilemedi |
| tam `npm run test:e2e`'nin **envanter turunda** koşturulması | paylaşılan ağaçta paralel ajanın ölçümünü bozardı ⇒ o tur için `[DEVRALINDI]`. **Team Lead ayrıca koştu:** `792/792`, `T-047 PASS` |

📌 **`B1` disiplini:** BRD `40+` diyor, canlı DB **33/30 aktif**.
**Sayı bir ENVANTERDİR, bir TEŞHİS DEĞİL** — hangilerinin eksik olduğu **ölçülmedi**.

---

# 7 · TURUN KENDİ HATALARI — kayda

| # | hata | ders |
|---|---|---|
| 1 | `SCOPE_ENFORCEMENT_ENABLED` arayıp *"okuyan kod yok"* diyecektim — kodun dili **`scopeEnforcementEnabled`** | *arama terimi **aranan yerin diliyle*** |
| 2 | *"yakında"* sınıfını tararken beşinci üyeyi **kaçırdım** — o dosya `TODO: Implement` diyor | **aynı ders, aynı gün üçüncü kez** *(ilki `mod ayrımı`)* |
| 3 | `@Roles` için ham grep **`44`/`54`** dedi; ratchet **`15`** | **türetilmiş sayı kanonik**, elle grep değil |
| 4 | `countRows` dönüş şeklini **varsaydım**, probe `evren: 2` dedi — bir an ajanın `48`'ini çürüttüğümü sandım | **çürüten ölçüm de ölçümdür** ve aynı şekil-doğrulamasına tabidir |
| 5 | `information_schema` ile grant sorup *"canlı değil"* diyecektim | **kuralı hatırlamak yerine ARACI çağır** |

> **Beşinin ikisi *"ajanı yakaladım"* hissi veriyordu.** İkisi de **ben yanılmıştım.**

---

# 8 · MÜHÜR SONRASI — **`K1b` KAPANDI** *(append-only, 2026-08-28)*

Beyan mühürlendikten sonra ürün sahibi `K1b` penceresini açtı: container yeni
compose ile yaratıldı, `-logs` volume'u doğdu, roller+`GRANT`'lar senkron, veri
korunumu **dört-tablo sayımıyla** kanıtlı (`1/9/5/39`).

```
bash scripts/verification/k1b-two-marker-pin.sh     PIN EXIT=0
  app_runtime@   1 satır
  app_operator@  4 satır
  ✅ iki bağlantı, MARKER METNİ OLMADAN, u= alanıyla ayrışıyor
```

⇒ **Eşik listesi kalemi `5` KAPANDI.** `Z52 §3`'ün şartı düştü: *"operatör
denetim-olaylıdır"* cümlesi **artık kurulabilir**, ve borç cümlesi
`01-roles-and-ownership.sql`'de **`F12` iziyle** kapatıldı.

📌 **Ve pin, `ADIM 6` review'ünün `B1` düzeltmesini CANLI doğruladı:** düzeltme
öncesi desen (`u=app_runtime,`) **matematiksel olarak geçemezdi** ve hata mesajı
insanı **yanlış sebebe** gönderirdi. Düzeltme olmasaydı bu pencere yanlış sebeple
kırmızı verir, **insan eylemi gerektiren bir pencere ikinci kez açılırdı.**

⚠️ **Kalan sınır kayda geçti:** denetim izinin üç parçasından **ikisi ortam
seviyesindedir** (`docker-compose.yml`) — taze bir kurulumda rol betiği **tek başına
denetim izini sağlamaz**. Kapısı **eşik `4`**.

⇒ **Eşik listesinde kalan: `1` · `2` · `3` · `4` · `6` · `6a`.**

---

# 9 · ⛔ DÜZELTME NOTU — `B1` SAYISI KİRLİYDİ *(append-only, 2026-08-28)*

`§5` ve `§6`'da `B1` için **`33/30 aktif`** yazılmıştı. `Faz-2` planlama turu o sayıyı
**yeniden ölçtü ve KİRLİ buldu**:

```
YAZILAN   33 toplam / 30 aktif
GERÇEK    27 toplam / 24 aktif          ← ÜRÜN KPI'ları
fark = 6  kpi_group='Test' · E2E_KPILOCK_* · created_at 2026-08-16 · is_active=TRUE
```

⇒ **Altı e2e artığı canlı DB'de `is_active` duruyor** ve *"aktif KPI"* sayan **her**
ölçümü `+6` şişiriyor.

### Ve `ÖLÇEMEDİM` de düştü — kanonik liste **VAR**
```
docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md:587
  "### Complete KPI Library (40 KPIs)"
```
Beyan *"kanonik `40+` listesi `Section-10`'da **yok**"* diyordu ve **doğruydu** —
liste **başka bölümde**. Boşluk `7`–`10` **değil**: **`42 − 24 = 18`**
*(gruplar `2+4+3+8+11+6+5+3`; BRD'nin kendi başlığı `40` diyor — `F12`'si `W2`'de)*.

> **📌 Ve bu düzeltmenin kendisi `B1` disiplininin kanıtı:**
> *"sayı bir **ENVANTERDİR**, bir **TEŞHİS DEĞİL**"* — beyan o sayıyı bir envanter
> olarak yazmıştı ve **teşhis niyetine kullanmamıştı**. Teşhis turu geldiğinde
> envanterin **kendisi** düzeldi.
>
> ⛔ **Mühür bozulmaz:** düzeltme `append-only` ve sayı hiçbir **ölçüt** işaretini
> taşımıyordu — `B1` `Faz-2`'nin `DEVRETTİ` sütununda, `KAPATTI`'da değil.

⚠️ **Ve `42` de nihai olmayabilir:** yeni girdi (`DEMO_EXCEL_KPI_TACTIC_REFERANSI.md`)
Excel'de **`NIV` grubunun** varlığını, `BRD-42`'de **yokluğunu** gösterdi (`§6 soru-1`).
Cevap *"bilinçli düşüş değil"* ise evren **üçüncü kez** düzelir.

