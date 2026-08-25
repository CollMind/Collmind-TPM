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

## 4 · ⛔ DUR — bu pakette OLMAYANLAR

- **Hüküm yok.** Cümle adayları **öneri**; hiçbiri karara bağlanmadı.
- **Kapsam kararı yok.** `47` kapsamsız rotanın önceliklendirmesi **kapsam
  hattının**, `B3`'ün değil (`Z19b` iki-hat ayrımı).
- **`MODES_READ` bölünmesi bir HİPOTEZ** — `{A,F}` grubunun defter-okuması olduğu
  **ölçülmedi**. Karar öncesi ön koşul.
- Numara/hücre tahsisi yapılmadı.
