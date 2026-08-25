# `B3` KARAR-BEKLER PAKETİ — dört hücre, `72` rota

**Tarih:** 2026-08-25 · **Hazırlayan:** Team Lead · **Karar:** ürün sahibi
**Statü:** ⏳ **cümle adayları ÖNERİ — hüküm ürün sahibinde**

> **Sözleşme:** cümle adaylarını Team Lead **türetir**, hükmü **ürün sahibi verir**.
> Bu belge bir **ölçüm + öneri** paketidir; hiçbir hücre burada çözülmez.

---

## 0 · ⛔ KİLİDİN GERÇEK İÇERİĞİ — ölçüldü, ve tek cümleyle şu

**Bu dört hücrenin her biri BİRDEN ÇOK farklı `@Roles` kümesi taşıyor.**

```
MODES_APPROVE    2 farklı küme        SUMMARY_READ     4 farklı küme
SHARED_READ      3 farklı küme        MODES_READ       7 farklı küme
```

⇒ Tek bir yetenek hücresi, bu kümelerin **hepsini birden** koruyamaz. İki yol var
ve **biri yasak**:

| yol | sonuç |
|---|---|
| **`union`** | küme `5/5`'e çöker — `Z18`: *"`union` asla bir gerekçe değildir"* |
| **cümle** | `K-2.6.4`'te **yazılabilir** bir sorumluluk cümlesi → küme ondan türer |

📌 **`Z18`'in reddi bir titizlik değil, bir EMSAL koruması:** *"union'la `5/5` olsun,
okuma zaten zararsız"* kabul edilirse **aynı tembellik `WRITE`/`MANAGE` hücrelerinde
tekrarlar.**

## 1 · ⛔ VE İKİNCİ BİR ADRES VAR — karıştırılmamalı

```
72'yi açan şey        ROL KÜMELERİ              → ürün sahibi (bu paket)
47'yi açan şey        KAPSAM BORCU              → KAPSAM HATTI (B3'ün DEĞİL)
```

| hücre | `A1` | `A2` | `B` | `C` | TOP | **KAPSAMSIZ** |
|---|---|---|---|---|---|---|
| `MODES_READ` | **20** | 0 | 9 | 5 | 34 | **20** |
| `SHARED_READ` | **11** | 6 | 3 | 0 | 20 | **17** |
| `SUMMARY_READ` | **10** | 0 | 2 | 0 | 12 | **10** |
| `MODES_APPROVE` | 0 | 0 | **6** | 0 | 6 | **0** |
| | | | | | **72** | **47** |

> **`MODES_APPROVE`'un tamamı kapsamlı** — onay yolunda kapsam katmanı çalışıyor.
> Üç `READ` hücresinin **`47`'si kapsamsız**: o hücrelere `5/5` rol yazmak,
> `47` rotada *"herkes her şeyi görür"* demektir. `Z19`'un *"katman KISMİ"* hükmü
> **ölçülü**.

⚠️ **Sıra önerisi:** `MODES_APPROVE` **önce** çözülebilir (kapsam borcu **yok**,
`6` rota, ve `W3`'ün `Z20` bölgesine girmeden `APPROVE` tarafının kararlı olması
sırayı rahatlatır). Üç `READ` hücresi kapsam borcuyla **bağlı**.

---

## 2 · CÜMLE ADAYLARI — öneri, hüküm değil

### `MODES_APPROVE` (6) — **en hazır olan**

Ölçülen iki küme: `{A,CM,FINANCE}` **3 rota** · `{A,CM}` **3 rota**.
Fark tam olarak **`FINANCE`**, ve ayrım anlamlı: `FINANCE` taşıyanlar
**eşik-üstü/finans kademesi**, taşımayanlar **kategori kademesi**.

> **Cümle adayı — `K-2.6.4` sorumluluk tablosundan TÜRETİLEBİLİR:**
> *"`KATEGORİ MÜDÜRÜ` kategori bütçesinin sahibidir ve onun onay kademesini
> yürütür; `FİNANS` **eşik üstü** kademeyi yürütür."*
> ⇒ `MODES_APPROVE` = `{YÖNETİCİ, KATEGORİ MÜDÜRÜ, FİNANS}` — **union DEĞİL**,
> çünkü her üyenin **ayrı bir cümlesi var** (`K-2.6.4`: *"KATEGORİ MÜDÜRÜ —
> kategori bütçe sahibi: onay + zarf yönetimi"* · *"FİNANS — eşik üstü
> onay/bildirim"*).

📌 **`Z18` şartı sağlanıyor:** her eleman için **ayrı bir cümle yazılabiliyor**.

#### ⛔ VE `T-276`'NIN `(a)`-YÜKLEMİ BURAYA İLİŞTİRİLİR

`T-276`'nın `(a)`-yüklemi (*"onay kademesinde ben varım"*) indiğinde:
- `plans/approval-queue`'nun **adı doğru, yüklemi eksik** çıkabilir — `Z30 H4-4`:
  *"ad bayat değil, YÜKLEMİNİ BEKLEYEN bir rota"*
- `FAZ2` `ÜÇ ZİNCİRLEME KALEM`'in **2. kalemi** (*eşik-üstü `FINANCE` kademesi ve
  `%90` bildirimi → **kapsamı KESİŞEN** `FINANCE` kullanıcılarına*) **aynı yüklemi**
  alır

⇒ **`MODES_APPROVE`'un rol kümesi ile `T-276` yüklemi BİRLİKTE çözülür.** Ayrı
çözülürse rol kümesi *"kim onaylayabilir"*i, yüklem *"hangi onayı"*yı söyler ve
ikisi **ayrışabilir**.

### `SUMMARY_READ` (12) — `Z31/Z32` tanımı hazır, küme değil

Dört küme: `{A,CM,F,RO}` 4 · `{A,CM,F,P,RO}` 4 · `{A,F,RO}` 3 · `{A,F,P}` 1.

> **Cümle adayı:** *"Portföy özeti, nesne-bağsız ve çok-işlem-modüllüdür; onu
> **karar için** okuyan her rol görür."* ⇒ ayrım `PLANNER`'ın portföy-seviyesi
> karar verip vermediğine iner — ve o **yazılabilir bir cümle değil** bugün.
>
> ⚠️ **Bu yüzden `SUMMARY_READ` `MODES_APPROVE`'dan DAHA ZOR**, tanımı hazır olsa
> bile: `Z31` *"hangi rotalar"*ı çözdü, *"hangi roller"*i değil.

**`Z32` bağı:** `SUMMARY_READ ∧ A1 = 10` bugün — çıkış ölçütü sıfırlandığında kural
**kapıya terfi eder** (*"yeni bir `SUMMARY_READ` rotası kapsamsız DOĞAMAZ"*). O
ölçüt **kapsam hattının**; rol kümesi bu paketin.

### `SHARED_READ` (20) — `16` rota TEK kümede

`{A,CM,F,P,RO}` **16 rota** (`5/5`) · `{A,CM,F,RO}` 3 · `{A,CM,P,RO}` 1.

> **Cümle adayı:** *"Paylaşılan okuma tabanı — bütçe/anlaşma/onay görünürlüğü her
> rolün işini yapabilmesi için gereklidir."* ⇒ `5/5` burada **union değil, TABAN**:
> `K-2.6.5b`'nin *"her rolün okuma tabanı zaten var"* maddesi bunu **zaten**
> söylüyor.
>
> ⚠️ **AMA `17/20`'si KAPSAMSIZ.** Cümle `5/5`'i haklı çıkarsa bile, kapsamsız
> `17` rotada *"herkes her şeyi görür"* demektir — **cümle rol katmanını çözer,
> kapsam katmanını çözmez.** Üç istisna (`{A,CM,F,RO}` ve `{A,CM,P,RO}`) ayrıca
> gerekçelenmeli: neden `PLANNER`/`FINANCE` dışarıda?

### `MODES_READ` (34) — **EN ZOR**, yedi küme

`{A,F,P}` 10 · `{A,CM,F,P,RO}` 10 · `{A,F}` **7** · `{A,F,P,RO}` 3 ·
`{A,CM,F,RO}` 2 · `{A,CM,RO}` 1 · `{A,CM,P,RO}` 1.

> ⛔ **Tek bir cümle bu yediyi kapsayamaz.** `{A,F}` (7 rota) ile `{A,CM,F,P,RO}`
> (10 rota) arasındaki fark **bir sorumluluk farkı**, bir yazım kazası değil —
> `{A,F}` grubu **gerçekleşme/defter okuması**, geniş grup **plan/katalog okuması**.
>
> **Cümle adayı — HÜCRE BÖLÜNMESİ:**
> *"`MODES_READ` ikiye ayrılır: **gerçekleşme okuması** (`{A,F}` — defter, mutabakat,
> uzlaşma) ve **plan okuması** (geniş taban)."*
> ⇒ `Z35`'in `MODES_WRITE`'a yaptığının **okuma tarafındaki karşılığı**, ve aynı
> ayırt ediciyi kullanır: **defter etkisi**.

📌 **Bu bir hüküm değil, bir HİPOTEZ** — ve `Z35`'in emsali gereği **ölçülmeden**
karara bağlanmaz: `{A,F}` grubunun **hepsi** gerçekten defter/mutabakat okuyor mu?
Ölçüm bu paketin **dışında**, kararın **ön koşulu**.

---

## 3 · ROTA LİSTELERİ (tam, `A1` **kalın**)

### `MODES_APPROVE` — 6 rota

| yöntem | yol | mevcut `@Roles` | kapsam |
|---|---|---|---|
| `POST` | `plans/:id/approve` | `ADMIN,CATEGORY_MANAGER` | B |
| `POST` | `plans/:id/escalate-to-finance` | `ADMIN,CATEGORY_MANAGER` | B |
| `POST` | `plans/:id/reject` | `ADMIN,CATEGORY_MANAGER` | B |
| `POST` | `agreements/:id/approve` | `ADMIN,CATEGORY_MANAGER,FINANCE` | B |
| `POST` | `agreements/:id/reject` | `ADMIN,CATEGORY_MANAGER,FINANCE` | B |
| `POST` | `plans/:id/review` | `ADMIN,CATEGORY_MANAGER,FINANCE` | B |

### `SUMMARY_READ` — 12 rota

| yöntem | yol | mevcut `@Roles` | kapsam |
|---|---|---|---|
| `GET` | `actuals-first/sales-actuals/summary` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `finance-reporting/plan-performance` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `finance-reporting/budget-utilization` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | **A1** |
| `GET` | `finance-reporting/mechanic-effectiveness` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | **A1** |
| `GET` | `finance-reporting/spend-composition` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | **A1** |
| `GET` | `finance-reporting/spend-trend` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | **A1** |
| `GET` | `agreement-transactions/stats/summary` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `finance-reporting/budget-at-risk` | `ADMIN,FINANCE,READONLY` | **A1** |
| `GET` | `finance-reporting/cash-flow-projection` | `ADMIN,FINANCE,READONLY` | **A1** |
| `GET` | `finance-reporting/variance-analysis` | `ADMIN,FINANCE,READONLY` | **A1** |
| `GET` | `actuals-first/settlements/summary` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `dashboard/summary` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |

### `SHARED_READ` — 20 rota

| yöntem | yol | mevcut `@Roles` | kapsam |
|---|---|---|---|
| `GET` | `budget/envelopes` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `budget/envelopes/:id` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `budget/envelopes/:id/reserved` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `budget/envelopes/:id/transactions` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `budget/status` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `spend-calculation/breakdown/:planFuId` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `spend-calculation/validate-before-submission/:planId` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `spend-calculation/validate-combinations/:planFuId` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `spend-calculation/validate-distribution/:planFuId` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `spend-calculation/validate-inputs/:planFuId` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `spend-calculation/validate-budget/:planId` | `ADMIN,CATEGORY_MANAGER,PLANNER,READONLY` | **A1** |
| `GET` | `approvals/:id` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | A2 |
| `GET` | `lta-agreements` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | A2 |
| `GET` | `lta-agreements/:id` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | A2 |
| `GET` | `lta-agreements/cpl/:cplId/active` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | A2 |
| `GET` | `approvals` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | A2 |
| `GET` | `approvals/pending` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | A2 |
| `GET` | `dashboard/cpl-status` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `dashboard/pending-tasks` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `finance-reporting/budget-variance` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | B |

### `MODES_READ` — 34 rota

| yöntem | yol | mevcut `@Roles` | kapsam |
|---|---|---|---|
| `GET` | `actuals-first/sales-actuals/batches` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `actuals-first/sales-actuals/batches/:batchId` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `actuals-first/sales-actuals/batches/:batchId/rows` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `agreements/pending-approvals` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | **A1** |
| `GET` | `agreement-transactions/batch/:batchId` | `ADMIN,FINANCE` | **A1** |
| `GET` | `ledger/envelope/:envelopeId` | `ADMIN,FINANCE` | **A1** |
| `GET` | `ledger/envelope/:envelopeId/consumed` | `ADMIN,FINANCE` | **A1** |
| `GET` | `agreement-transactions` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `agreement-transactions/:id` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `agreement-transactions/agreement/:agreementId` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `agreement-transactions/agreement/:agreementId/total` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `agreement-transactions/budget-impact/:agreementId` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `agreement-transactions/count` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `ledger` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `ledger/:id` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `ledger/agreement/:agreementId` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `ledger/agreement/:agreementId/consumed` | `ADMIN,FINANCE,PLANNER` | **A1** |
| `GET` | `on-invoice/batch/:batchId` | `ADMIN,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `on-invoice/count` | `ADMIN,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `on-invoice/entries` | `ADMIN,FINANCE,PLANNER,READONLY` | **A1** |
| `GET` | `agreements` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `agreements/:id` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `plans` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `plans/:id` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `plans/:id/analysis` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `plans/:id/approval-history` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | B |
| `GET` | `plans/approval-queue` | `ADMIN,CATEGORY_MANAGER,FINANCE,READONLY` | B |
| `GET` | `plans/:id/budget-check` | `ADMIN,CATEGORY_MANAGER,PLANNER,READONLY` | B |
| `GET` | `plans/pending-approvals` | `ADMIN,CATEGORY_MANAGER,READONLY` | B |
| `GET` | `agreements/tactics/available` | `ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER,READONLY` | C |
| `GET` | `agreement-transactions/template/csv` | `ADMIN,FINANCE` | C |
| `GET` | `agreement-transactions/template/excel` | `ADMIN,FINANCE` | C |
| `GET` | `on-invoice/template/csv` | `ADMIN,FINANCE` | C |
| `GET` | `on-invoice/template/excel` | `ADMIN,FINANCE` | C |

---

---

# ✅ KARARLAR (ürün sahibi, 2026-08-25)

## `MODES_APPROVE` — **HÜCRE İKİYE AYRILIR**, tek-hücre `{A,CM,F}` REDDEDİLDİ

**Gerekçe paketin kendi tablosundaydı:** `plans/approve·reject·escalate` bugün
`{A,CM}`. Tek hücre `{A,CM,F}` yazılsaydı **`FINANCE` üç plan-onay rotasına
GENİŞLERDİ** — `H1`'in `DUR-3`'te söktüğü şekil.

```
{A,CM}      plans/:id/approve · plans/:id/reject · plans/:id/escalate-to-finance
{A,CM,F}    agreements/:id/approve · agreements/:id/reject · plans/:id/review
```

📌 **Ayrım plan/anlaşma DEĞİL** (ölçüldü): `plans/:id/review` `{A,CM,F}`'de.
Anlamlı — eskalasyon **sonrası** incelemeyi finans da yapabiliyor; `escalate` ise
`{A,CM}`, çünkü eskale **eden** taraf `CM`.

> **İki küme iki AYRI CÜMLEYE oturuyor** — `Z18` şartı sağlanıyor:
> *kategori-kademe onayı* · *finans-dahil onay*.
> `Z35`/`MODES_READ`-hipoteziyle **aynı desen**: tek işlem-türü, iki sorumluluk
> sınıfı.

### Ad tahsisi (Team Lead) — **sınıf adı, küme adı DEĞİL**

| hücre | sınıf |
|---|---|
| `MODES_APPROVE_CATEGORY` | onay kararı **kategori kademesinde kalır** |
| `MODES_APPROVE_JOINT` | onay yüzeyine **finans da TARAFTIR** |

⚠️ Adlar **kümeyi** anlatmıyor (`_CM`, `_ACMF` gibi) — çünkü küme değişebilir,
sınıf değişmez. Üyelik testi ölçülebilir: *"bu onay eylemini finans da
yapabilir mi?"*

⇒ **6 rota göçebilir, davranış birebir.**

### ⛔ `T-276` — DÜZELTME: *"birlikte çözülür"* ≠ aynı dalgada

**Katman ayrımı kayda geçer:**

```
HÜCRE    "onay YÜZEYİNE kim dokunur"    → TÜR       (bu karar)
YÜKLEM   "bu ONAYI kim verir"           → KADEME    (K-2.5.12-R, T-276)
```

> **Ayrışmaları TASARIMDIR, kusur değil.**

**`T-276`'nın kabul pinine:** hücre-kapısı **+** yüklem **birlikte** test edilir.

## `SHARED_READ` — **KISMİ KARAR: 16 rota bugün açılır**

`{A,CM,F,P,RO}` = `5/5` **union DEĞİL, TABAN** — `K-2.6.5b` cümleyi **kümeden
önce** yazmış (*"her rolün okuma tabanı zaten var"*).

### ⛔ DÖRT İSTİSNA ROTA GÖÇ-DIŞI — her biri için TEK SORU

> **Eksik rolün YOKLUĞU cümlelenebiliyor mu?**

| rota | mevcut küme | eksik | ürün sahibi sezgisi |
|---|---|---|---|
| `GET approvals` | `{A,CM,F,RO}` | **`PLANNER`** | *"muhtemelen cümlelenir"* |
| `GET approvals/pending` | `{A,CM,F,RO}` | **`PLANNER`** | *"muhtemelen cümlelenir"* |
| `GET finance-reporting/budget-variance` | `{A,CM,F,RO}` | **`PLANNER`** | ⚠️ **sezgide anılmadı** — ayrıca sorulmalı |
| `GET spend-calculation/validate-budget/:planId` | `{A,CM,P,RO}` | **`FINANCE`** | *"kaza kokuyor"* |

```
cümlelenen      → kayıtlı ALT-İSTİSNA
cümlelenemeyen  → tabana hizalama = kayıtlı DAVRANIŞ-İSTİSNASI dalgası
```

📌 **Üçü `PLANNER`, biri `FINANCE` eksik** — yani soru tek tip değil: `PLANNER`
grubu bir **görünürlük** sorusu, `FINANCE` grubu bir **kaza adayı**.

## `SUMMARY_READ` + `MODES_READ` — ÖLÇÜM TURU KOŞTU (2026-08-25)

### ⛔ HİPOTEZ (a) ÇÜRÜDÜ — üç bağımsız yüzeyde

Team Lead'in hipotezi (*"`{A,F}` yedilisi = defter okuması, `Z35`'in okuma
tarafı"*) **çürüdü**:

| # | çürütme | ölçüm |
|---|---|---|
| 1 | yedinin **dördü hiçbir tabloya dokunmuyor** | `template/csv\|excel` ×4 → statik üreteç; `Repository\|dataSource\|getRepository` = **0**. POZ.KONTROL `ledger.service.ts` = **2** |
| 2 | veri okuyan üçünün **aynı tabloyu aynı yüklemle okuyan `{A,F,P}` kardeşi var** | `ledger.repository.ts:49` ↔ `:76` aynı yüklem · `agreement-transaction.repository.ts:56` ↔ `:88` (**geniş rota DAHA ÇOK veri**) |
| 3 | defter okuyan rotalar **`5/5`'te, ve KAYITLI kararla** | `settlements/summary` (`T-267 B1 §1f`) · `budget/envelopes*` → `budget-summary.view-entity` `FROM main.ledger_entries` (**4. yüzey: VIEW**) |

⇒ **`{A,F}` kısıtı bugün HİÇBİR ŞEY UYGULAMIYOR** — `PLANNER` aynı veriyi
(birinde **fazlasını**) `{A,F,P}` rotasından alıyor.

📌 **Ve hipotez, KENDİ YAZDIĞIM bir notla çelişiyordu:** `capabilities.ts:562-567`
*"`Z35`'in ayırt edicisi bir DİSJONKSİYON, tek grep'lik bir test DEĞİL"* —
`Z35` bir **alt-modül** ayrımıdır, okumaya uygulandığında `{A,F}` üretmiyor
(gerçekleşme alt-modülleri bugün **dört farklı küme** taşıyor).

**`{A,F}` yedilisi GERÇEKTE ne:** `K-2.6.14`'ün *"Bugün: yalnız finans +
yönetici"* satırının, içe-aktarma boru hattının **okuma-şekilli** üyelerine
**taşması** — ve taşma **tutarsız**:
```
GET on-invoice/batch/:batchId              {A,F,P,RO}
GET agreement-transactions/batch/:batchId  {A,F}
    yapısal olarak ÖZDEŞ rota · aynı boru hattı · İKİ FARKLI KÜME
```

### (b) İKİ SINIF YETMİYOR — ölçülen **DÖRT**

```
1  plan/anlaşma TANIMI okuması      5/5 taban
2  gerçekleşme VERİSİ okuması       5/5 taban
3  ONAY KUYRUĞU okuması             APPROVE aynası     ← YENİ SINIF
4  İÇE AKTARMA boru hattı           {A,F} K-2.6.14
```

**Sınıf 3 zaten KARARLI ve iki repoda birden doğrulandı:**

| rota | backend | frontend ekran kapısı | eşleşme |
|---|---|---|---|
| `GET plans/pending-approvals` | `{A,CM,RO}` | `['ADMIN','CATEGORY_MANAGER','READONLY']` | ✅ **BİREBİR** |
| `GET agreements/pending-approvals` | `{A,CM,F,RO}` | `['ADMIN','CATEGORY_MANAGER','FINANCE','READONLY']` | ✅ **BİREBİR** |

⇒ `MODES_APPROVE_CATEGORY`/`_JOINT`'in **okuma aynası**. Cümle zaten yazılı.

**Eşlenemeyen tek kalan:** `GET plans/:id/budget-check` `{A,CM,P,RO}`.

### (c) DÖRT KÜME DÖRT KARAR DEĞİL — mekanizma bir COMMIT

`f3b9f82` (2026-03-05, *"add READONLY role"*) `READONLY`'yi **ayrım yapmadan**
beş controller'a ekledi, ikisine **hiç dokunmadı**. ⇒ Bugünkü `READONLY`
dağılımı büyük ölçüde **o commit'in kapsamının fonksiyonu**.

⛔ **VE İKİ CANLI KUSUR ÇIKTI** → **[[T-287]]** (Team Lead bağımsız doğruladı):
`/finance`'te `CATEGORY_MANAGER` üç widget'ta `403` · `/off-invoice/transactions`'ta
`READONLY` için `Promise.all` yüzünden **sayfanın tamamı** düşüyor.

### ⛔ ÜRÜN SAHİBİNE — hüküm gereken ÜÇ nokta
1. **`{A,F}` yedilisi bölünmeye gerekçe OLAMAZ.** İki seçenek: (i) şablonlar +
   `agreement-transactions/batch/:batchId` **içe-aktarma hücresine** · (ii)
   `ledger/envelope/*` `{A,F,P}`'ye **hizalansın** (zaten bypass ediliyor).
2. **Üçüncü sınıf (`onay kuyruğu okuması`) tanınsın mı?**
3. **Kaza satırları** — tek dalga mı, ayrı ayrı kayıtlı istisna mı?
   ⚠️ `K2`/`K3` bir taksonomi tartışması değil, **çalışan kusur**.

---

---

# ⛔ YENİ DUR — `W4` BRİEFTEKİ HÂLİYLE KOŞAMAZ (ölçüldü 2026-08-25)

## DUR-1 · `SHARED_READ` haritada **BLOKE** — kısmi karar KODA İNMEDİ

```
ürün sahibi kararı   "16 rota bugün açılır"  (5/5 union DEĞİL TABAN, K-2.6.5b)
ROLE_CAPABILITIES    SHARED_READ → HİÇBİR ROLDE     ← ölçüldü
```

⇒ `W4`'ün bir **`ADIM 0`**'ı var (`Z35`'in `MODES_WRITE` bölünmesiyle **aynı
şekil**): karar önce **haritaya** yazılır, sonra rota göçer. Aksi hâlde 16 rota
`SHARED_READ`'e göçer ve **hiçbir rol** onu almaz ⇒ **`403`, tam kilitlenme**.

## DUR-2 · ⛔ `SHARED_WRITE` göçü **ON ÜÇ ROTANIN ON ÜÇÜNDE** davranış değiştirir

| mevcut `@Roles` | ×N | hücre verir | değişim |
|---|---|---|---|
| `{ADMIN}` | 5 | `{A,P,CM,F}` | **+PLANNER +CM +FINANCE** — genişleme |
| `{A,CM,F,P,RO}` | 3 | `{A,P,CM,F}` | **−READONLY** — **daraltma** |
| `{A,FINANCE}` | 2 | `{A,P,CM,F}` | **+PLANNER +CM** — genişleme |
| `{A,PLANNER}` | 3 | `{A,P,CM,F}` | **+CM +FINANCE** — genişleme |

⇒ *"Göç davranış değiştirmez"* kuralı **hiçbir grupta** sağlanmıyor.

### Ve hücrenin KAYDI da bayat — iki ayrı sebeple

```
KAYIT (Faz A)   union 9 rotadan hesaplandı: {A,CM} 1 · {A,F} 5 · {A,P} 1 · {A} 2
BUGÜN            13 rota: {A} 5 · {A,CM,F,P,RO} 3 · {A,F} 2 · {A,P} 3
```

1. **`budget-allocations` rotaları SİLİNDİ** (`Z24`) — kaydın `{A,F} n=5` grubu
   `2`'ye indi.
2. **Kaydın *"union'a GİRMEDİ"* dediği üç rota bugün hücrede:**
   `lta-agreements/context/rates` · `calculate/base-spend` · `calculate/planned-spend`
   — kayıt onları *"filtresiz `4`, `K-2.6.6` kapsamı"* diye **dışarıda
   bırakmıştı**, mekanik eşleme onları **içeri aldı**. Ve bu üçü **`5/5`**, yani
   göç onlardan **`READONLY`'yi ALIR**.

📌 **Sınıf:** `MODES_WRITE`'ın `H1`/`Z35` öncesi hâliyle **birebir aynı** — bir
`union` kararı, göç anında **erişim genişletmesine** dönüşüyor. `Z35` orada
bölünmeyle çözdü; burada da bir **cümle ya da bölünme** gerekiyor.

⚠️ **Fark ve daha ağırı:** `MODES_WRITE`'ta yalnız **genişleme** vardı; burada
**daraltma da var** (`−READONLY`, 3 rota), ve daraltma `Z20`'nin sınıfından —
**istisna dalgasının işi**, mekanik dalganın değil.

## ⇒ `W4` ÖNERİSİ (ürün sahibi kararı bekliyor)

```
W4a   SHARED_READ 16      ADIM 0 (haritaya 5/5 yaz) + göç     ← karar VAR, kod yok
W4b   SHARED_WRITE 13     ⛔ DUR — yeni karar gerekiyor
      SUMMARY_READ 9      karar-bekler (bu paket)
      4 istisna           karar-bekler (cümle testi)
```

Sabitlik `W4a` sonrası: **`176 + 35 = 211`**.

---

---

# `W4b` ÖLÇÜM TURU SONUÇLARI (2026-08-25)

## (1) ÜÇ ROTA — hüküm **DOĞRULANDI**, ve sınıf **hipotezden GENİŞ**

Yazma yüzeyi **dört yüzey + cascade**, tam çağrı grafiği izlenerek: **`0`**.
Cascade *"yapısal olarak imkânsız"* — `.save()` grafikte **hiç yok**.

⛔ **Ama sınıf `3` rota değil, `7` — ve İKİ hücrede:**

| rota | mevcut hücre | yazma |
|---|---|---|
| `POST lta-agreements/context/rates` · `calculate/base-spend` · `calculate/planned-spend` | `SHARED_WRITE` | **0** |
| `POST master-data/mechanics/applicable` · `check-combination` · `validate-formula` | `MASTER_DATA_WRITE` | **0** |
| `POST master-data/kpis/validate-formula` | `MASTER_DATA_WRITE` | **0** (`async` bile değil) |

⚠️ **Ve `5/5` proxy'si SON İKİSİNİ KAÇIRIRDI** — `validate-formula` uçları
`ADMIN`-only. ⇒ Ayırt edici **rol kümesi değil, YAZMA YÜZEYİ**.
📌 **Ad da ayırt edici değil:** `plans/:id/recalculate` · `on-invoice/:batchId/validate` ·
`agreement-transactions/validate-and-import` aynı ad-şeklini taşıyor ve
**gerçekten yazıyorlar**.

**Önerilen ev `SHARED_READ` DEĞİL:** oraya koymak `MASTER_DATA_WRITE`'taki dört
kardeşi **yerinde bırakır** ⇒ aynı sınıf iki farklı muamele (`İlke 4`).
Üreticide `SUMMARY`/`APPROVE` ile **aynı şekilde** açık bir hesap-okuma istisna
kümesi — üyelik **yazma-yüzeyi ölçümüyle**, `fam` ile birleşince her rota kendi
ailesinin okuma tarafına düşer.

📌 **`K-2.6.6` etiketi bu çıkarmayı gerekçelendiremez** — ölçüldü: `K-2.6.6`
*"kural yoksa reddet"* diyor, bir **fail-closed ilkesi**, bir **veri sınıfı**
kuralı değil. Ürün sahibinin *"etiketle değil ölçümle"* şartı **yerinde çıktı**.

## (2) ON ROTA — hipotezin `2/3`'ü doğrulandı, `1/3`'ü ÇÜRÜDÜ

⛔ **`Z35`'in *defter etkisi* ayırt edicisi bu bölünmeyi ÜRETMİYOR** — defter
etkisi grupların **içinden** geçiyor: `split`(`{A,F}`) ve `reserve`(`{A,P}`)
defter yazıyor; `createEnvelope`(`{A,F}`) ve iki `spend-calc`(`{A,P}`) yazmıyor.
**Bölünmeyi üreten eksen: yazılan nesnenin SAHİPLİĞİ.**

| sınıf | n | rota | cümle |
|---|---|---|---|
| **A** yönetişim/kural yazımı | 1 | `PATCH approval-policies/:id` `{A}` | ✅ `K-2.6.4` *tanımlar, kural yönetimi* + `K-2.6.4a/b`: **şablonun ÖZNESİ olan rol, şablonu DÜZENLEYEMEZ — görev ayrılığı** |
| **B** zarf yapısı / bütçe sahipliği | 2 | `POST budget/envelopes` · `/:id/split` `{A,F}` | ✅ `K-2.2.9c` *"finans zarfı büyütür … kararı PARANIN SAHİBİNE taşır"* ⚠️ **ÇATIŞMA, aşağı** |
| **C** plan tüketimi / ızgara yazımı | 2 | `spend-calculation/distribute` · `recalculate-on-volume-change` `{A,P}` | ✅ `K-2.6.4` *plan, taktik, hacim girişi* + emsal `T-249` · **canlı frontend tüketici var** |

### ⚠️ SINIF B'de bir ÇATIŞMA — ve bir SAĞLAYICIYA bağlı

`K-2.6.4` rol kataloğu (`L2_03:401`) **yazılı olarak** diyor ki:
> `KATEGORİ MÜDÜRÜ` | Kategori bütçe sahibi: onay + **ZARF YÖNETİMİ**

Aynı cümle yazma tarafına uygulanırsa `CM` bu iki rotaya **girer**.
⛔ **Ama girerse FAIL-OPEN:** `BudgetService`'te `AccessScope` atfı **`0`**
(poz.kontrol: **7** servis kullanıyor). `CM` **kategori-kapsamlı** bir roldür;
kapsam katmanı olmadan eklenirse *"kendi kategorisinin zarfı"* değil **tenant'ın
HER zarfı** yazılabilir olur.
⇒ `§ ŞARTIN SAĞLAYICISI` vakası — sağlayıcı **`T-266`**.
**Küme AÇIK: `{A,F}` mı, `{A,CM,F}` (kapsam indikten sonra) mı — ürün sahibi.**

## (3) EŞLENEMEYEN — `5` rota, iki ayrı sebep

### (3a) LTA sözleşme yaşam döngüsü — `4` rota, `{ADMIN}` bir KARAR DEĞİL

```
POST lta-agreements · PATCH :id · POST :id/activate · POST :id/terminate
```

| ölçüm | bulgu |
|---|---|
| `L2`'de sahiplik kuralı | **YOK** — `LTA` `L2`'de **tek** yerde (`K-2.1.15`) ve orada *"`STA`/`LTA` etiketi davranış kaynağı DEĞİLDİR"* |
| kardeş emsal | `agreement.controller.ts` `POST`/`PATCH`/`submit`/`DELETE` = **`{ADMIN, PLANNER}`** — aynı domain fiili, **iki farklı küme** |
| `{ADMIN}`'in kaynağı | `git log -S`: **tek commit** `d40ca16` *"Add Dockerfile and pipeline config"* — **toplu ilk commit**, dört dekoratörün hiçbirinde **gerekçe yorumu yok** |

⇒ `K-2.6.4`'ün *"tanımlar, kural yönetimi"* cümlesi bu dördü için **YAZILAMAZ**:
bir LTA anlaşması müşteriyle yapılan **ticari sözleşmedir**, bir sistem tanımı değil.

⛔ **Hüküm verilmeden `SHARED_WRITE`'a ALINMAMALI** — hücreye girerse
`{ADMIN}`-only'den **dört role genişler**, yani *"`H1`'in söktüğü şeklin en ağır
hâli"*.

### (3b) `POST budget/reserve` → **[[T-289]]**, ve bir rol sorusundan BÜYÜK

Ayrıntı task'ta. Özet: `/budget` ekranı **rol kapısız** · `agreementId` **serbest
metin** · servis **doğrulamıyor** · `txStatus: POSTED` · `AccessScope` **0**.
⇒ Bir `PLANNER`, **var olmayan bir anlaşma kimliğiyle herhangi bir zarfa
kesinleşmiş defter satırı** üretebilir. **Team Lead dört yüzeyde doğruladı.**

⚠️ Ve `K-2.2.4` gerilimi: kural *"bir anlaşma ONAYLANDIĞINDA"* diyor; bu uç
tetikleyiciyi **atlayan ikinci bir yol**.

---

## 4 · ⛔ DUR — bu pakette OLMAYANLAR

- **Hüküm yok.** Cümle adayları **öneri**; hiçbiri karara bağlanmadı.
- **Kapsam kararı yok.** `47` kapsamsız rotanın önceliklendirmesi **kapsam
  hattının**, `B3`'ün değil (`Z19b` iki-hat ayrımı).
- **`MODES_READ` bölünmesi bir HİPOTEZ** — `{A,F}` grubunun defter-okuması olduğu
  **ölçülmedi**. Karar öncesi ön koşul.
- Numara/hücre tahsisi yapılmadı.


---

## ⚠️ `W4a` yan bulgusu — `lta` üçlüsünün hücresi MEKANİK türedi (code-reviewer E)

`W4a` `SHARED_READ`'in 16 rotasını göçürdü. Aynı controller'ın **üç `POST`'u**
(`context/rates` · `calculate/*`) aynı `5/5` kümeyi taşıyor ama **göçmedi** —
çünkü `SHARED_WRITE` hücresinde, ve o hücre karar-bekler.

**Bu turda dokunmamak doğru.** Ama tutarsızlık ölçüldü ve **kayda geçmeli**:

```
TSV        hucre=SHARED_WRITE  kaynak=MEKANIK      ← hücre HTTP METODUNDAN türedi
dosyanın   lta-agreement.controller.ts:195-198, 220-223
kendi      "T-267 Ölçüm 1: YAZMA:0 · Ölçüm 3: 0 tüketici
yorumu      — hesaplama, yazma DEĞİL"
```

`DISIPLIN` — *"mekanik olarak türetilmiş bir değer GEREKÇE değildir."* `POST` olmak
bir yazma **kanıtı** değil, bir **yöntem adı**.

⛔ **Yazılmasaydı riski somuttu:** bir sonraki dalga `SHARED_WRITE`'ı toplu
göçürürken bu üçünü *"yazma"* sanarak taşırdı — ve `W4b` ölçümü bunların
`calculate` sınıfının üyesi olduğunu **zaten bulmuştu** (yazma yüzeyi `0`,
cascade yapısal olarak imkânsız).

⇒ **Karar anında bu üç rota `SHARED_WRITE`'ın değil, `calculate` sınıfının
üyesi olarak değerlendirilir.**
