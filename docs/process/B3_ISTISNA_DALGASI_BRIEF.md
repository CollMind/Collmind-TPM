# `B3` İSTİSNA DALGASI — BRIEF (onay bekler)

**Tarih:** 2026-08-26 · **Hazırlayan:** Team Lead · **Karar:** ürün sahibi
**Dayanak:** `docs/brd-v2/04_KARAR_KAYDI.md` `Z42` — `§2` çerçeve hükmü, `§3`–`§5`
**Statü:** ⏳ **ONAY BEKLER** *(birebir dalga `W9` onaysız indi; bu dalga onaya gelir)*

> **`Z42 §2`:** *"Küme-evrimi **hücrenin üstünde**, **kayıtla**, bir **istisna-dalgası
> satırı** olarak iner."* Bu belge o satırların **listesidir** — ve her satır bir
> **yön** (daraltma / genişleme) ve bir **şart** taşır.

---

## 0 · Bu dalganın BİREBİR dalgadan farkı — tek cümle

```
W9 (birebir)     rol kümesi DEĞİŞMEDİ   →  davranış değişmedi  →  pin STATİK KAPI
istisna dalgası  rol kümesi DEĞİŞİYOR   →  davranış DEĞİŞİYOR  →  pin DAVRANIŞ PİNİ
```

📌 `DISIPLIN`'in **TAM-GERİ-ALMA MUTASYONU beklenti tablosu** bu ayrımı zorunlu kılar:
davranış-**değiştiren** her satır bir **davranış pini** ister; statik kapı yetmez.

---

## 1 · DARALTMALAR — `−PLANNER` ×4 (`Z42 §3`)

| rota | bugün | sonra |
|---|---|---|
| `actuals-first/sales-actuals/summary` | `{A,CM,F,P,RO}` | `{A,CM,F,RO}` |
| `actuals-first/settlements/summary` | `{A,CM,F,P,RO}` | `{A,CM,F,RO}` |
| `dashboard/summary` | `{A,CM,F,P,RO}` | `{A,CM,F,RO}` |
| `finance-reporting/plan-performance` | `{A,CM,F,P,RO}` | `{A,CM,F,RO}` |

**Dayanak (`Z42 §3`), iki bağımsız yarı:**
1. `#9` **çift-olumsuz** — kayıt yok (`d40ca16`: *"Add Dockerfile and pipeline config"*)
   **∧** davranışsal ulaşılamaz (`/finance` kapısında `PLANNER` yok, tek tüketici o ekran)
2. `K-2.6.4`'ün planner cümlesi **özet içermiyor**

> ⚠️ **`§1` emsalinin (`PROVENANCE KAZANIR`) uygulanışı:** burada **iki sinyal de kaza
> yönünde** ⇒ üyelik **düşer**. `#5`'te sinyaller zıttı ve **kasıt kazanmıştı**. Aynı
> kural, iki yönde.

### ⛔ ŞART — daraltma da bir davranış değişikliğidir

Daraltma *"güvenli yön"* diye **pinsiz** geçilemez: bir `PLANNER` ekranı bugün bu uçlardan
birini çağırıyorsa dalga **canlı bir sayfayı `403`'e düşürür**. `T-287`'nin
`Promise.all → allSettled` bulgusu tam bu sınıftı: **tek bir `403` sayfanın tamamını
öldürüyordu.**

- [ ] Dört ucun **frontend tüketicileri** sayılır; `PLANNER`'ın ulaşabildiği bir çağrı
      varsa o satır **DUR**'a düşer *(poz. kontrol zorunlu)*
- [ ] Davranış pini: `PLANNER` ile çağrı → **`403`**; `FINANCE` ile → **`200`**

---

## 2 · GENİŞLEMELER — `+CATEGORY_MANAGER` ×3 (`Z42 §3`) ⚠️ **KAPSAM-KOŞULLU**

| rota | bugün | sonra |
|---|---|---|
| `finance-reporting/budget-at-risk` | `{A,F,RO}` | `{A,CM,F,RO}` |
| `finance-reporting/cash-flow-projection` | `{A,F,RO}` | `{A,CM,F,RO}` |
| `finance-reporting/variance-analysis` | `{A,F,RO}` | `{A,CM,F,RO}` |

Bu, `T-287 K3`'ün açık bıraktığı **üç widget sorusunun** cevabıdır: **evet, ama kapsamla.**

### ⛔ VE BU SATIRLAR BU DALGAYA BİNMEZ — `Z25`'te BEKLER

> **`Z42 §2`:** *"`CM`-genişlemeleri **kapsam-koşulludur** — kapsam zorlaması o rotalara
> inmeden `CM` **tenant-geneli görür** = açılım."*

```
sağlayıcı        T-304 (kapsam borcu programı) · bu üç rota A1'de
şart             kapsam zorlaması İNMEDEN genişleme YAPILMAZ
statü            Z25 KOŞUL SATIRI — bir erteleme değil, bir KİLİT
```

⚠️ **Ve `SUMMARY ∧ A1` üçünü de içeriyor** — yani genişleme, `T-304`'ün **ilk diliminin**
kapanışına bağlı. Bu bir tesadüf değil: hücrenin kapsam borcu ile genişleme şartı
**aynı rotalarda** buluşuyor.

---

## 3 · KARMA — `agreement-transactions/stats/summary` (`+CM +RO −P`)

```
bugün  {A,F,P}          sonra  {A,CM,F,RO}
```

⛔ **Üç yön tek satırda.** `−P` `§1`'in gerekçesini paylaşır; `+RO` `§4`'ün tanımsal
listesine girer; `+CM` `§2`'nin **kapsam-koşuluna** tabidir.

> **Şart:** üç yön **ayrı ayrı** pinlenir. Tek bir *"küme değişti"* pini bu satırı
> ölçmez — `DISIPLIN`: *"bir testin şekli iki alternatifi ayırt edebiliyor mu?"*

---

## 4 · `+READONLY` TANIMSAL LİSTESİ — ve **iki-repo-tek-kapanış** (`Z42 §5`)

| rota / yüzey | bugün |
|---|---|
| `agreement-transactions` ailesi (`#7`) | `RO` **yok** |
| `ledger` ailesi (`#8`) | `RO` **yok** |
| *(ekran kapıları)* `/off-invoice/transactions` · `/budget/ledger` | `{A,F,P}` |

**Dayanak:** `K-2.6.4c` — *"İZLEYİCİ bir İZLEME YETENEKLERİ SETİDİR"* (`Z18`).

### ⛔ Yokluğun kaynağı bir CÜMLE değil, bir COMMIT'in DOSYA KAPSAMI

```
f3b9f82  "add READONLY role (TPM-142)"  →  dokunmadığı TAM OLARAK İKİ dosya:
         ledger.controller.ts  ·  agreement-transaction.controller.ts
```

⇒ `#7` ve `#8` **aynı commit'in aynı boşluğu**. Ve kardeşleri zıt karar taşıyor:
`on-invoice/count`·`/entries` **`{A,F,P,RO}`** — aynı sayfa, aynı `Promise` demeti.

- [ ] Backend + **ekran kapıları aynı satırda** güncellenir *(iki repo, tek kapanış)*
- [ ] Davranış pini: `READONLY` ile `GET` → `200`, `POST`/`PATCH` → **`403`**
      *(izleme genişliyor, yazma genişlemiyor)*

---

## 5 · ÖLÇÜM ŞARTLI — `plans/pending-approvals` `+FINANCE` (`Z42 §4`)

```
APPROVAL_QUEUE_READ           {A,CM,F,RO}
plans/pending-approvals       {A,CM,RO}      ⇒ göç = +FINANCE GENİŞLEME
```

**`−FINANCE`'ın cümlesi VAR ve `ADR 0002` dayanaklı:**
```
plan.service.ts:395-405        findPendingApprovals → [PENDING_APPROVAL]
approval-workflow.service:859  getApprovalQueue     → [PENDING_APPROVAL,
                                                       PENDING_FINANCE_REVIEW]
```
⇒ `FINANCE` o uçtan **onaylayabileceği hiçbir kaydı görmüyor**.

### ⛔ ŞART (ürün sahibi hükmü, `Z42 §4`)

> **`FINANCE`'ın o uçtaki görünümünün BOŞ KÜME olduğu ÇAĞRILARAK ölçülür.**
> `ADR 0002` okuması bir **DURAĞAN YÜZEYdir** (`T-289` dersi).
> **Ölçüm tutmazsa rota TEK-VAKA kalır.**

⚠️ Ve `DISIPLIN`: **boş sonuç FARK DEĞİLDİR** — fixture `PENDING_FINANCE_REVIEW`
statüsünde **en az bir** kayıt taşımalı, yoksa ölçüm `T-273` sınıfına düşer
(*"yol bugün koşuyor mu?"*).

---

## 6 · CÜMLE-TESTİNE GİDEN — `on-invoice` ↔ `agreement-batch` asimetrisi

```
GET on-invoice/batch/:batchId              {A,F,P,RO}
GET agreement-transactions/batch/:batchId  {A,F}
    yapısal olarak ÖZDEŞ · aynı boru hattı · İKİSİNDE DE KAYIT YOK
```

**`Z42 §4` hükmü:** yön **cümle-testiyle** belirlenir — `P`/`RO`'nun satırları
**`ledger`'dan türetebildiği** ölçülürse hizalama **açılımsızdır**.

- [ ] Ölçüm: `agreement-transactions/batch/:batchId`'nin döndürdüğü alanlar,
      `MODES_LEDGER_READ` uçlarından **türetilebiliyor mu?** *(çift bilgi-açılım
      testinin ikinci yarısı: "türetilmiş çıktılar")*

---

## 7 · DALGA DIŞI — dokunulmaz

| kalem | neden |
|---|---|
| `MODES_APPROVE` (6) | ONAY yeteneği — `K-2.5.12`, ayrı karar |
| `SHARED_WRITE` / LTA (4) | `T-293` · `Z39 §4` kayıtlı hayalet |
| `finance-reporting/budget-variance` (1) | hücresi `Z42 ADIM 0`'da açıldı; **çağıranı sıfır** (`EK_E` `🔒`) |

---

## 8 · ⛔ ÖZET — ürün sahibinin onayına giden ŞEY

| # | satır | yön | bu dalgada iner mi? |
|---|---|---|---|
| 1 | `−P` ×4 | daraltma | ✅ **evet**, tüketici sayımı + davranış pini şartıyla |
| 2 | `+CM` ×3 | genişleme | ⛔ **hayır** — `Z25` kilidi, sağlayıcı `T-304` |
| 3 | `stats/summary` karma | üç yön | kısmen: `−P` ✅ · `+RO` ✅ · `+CM` ⛔ |
| 4 | `+RO` (`#7`/`#8`) | genişleme | ✅ **evet**, tanımsal (`K-2.6.4c`) + iki-repo-tek-kapanış |
| 5 | `pending-approvals` `+F` | genişleme | ❓ **ölçüme bağlı** — boş-küme ÇAĞRILARAK kanıtlanırsa |
| 6 | batch asimetrisi | ? | ❓ **cümle-testine bağlı** |

> **Sorulan:** `1` · `3`'ün iki yarısı · `4` bu dalgaya binsin mi; `5` ve `6`'nın
> ölçümleri bu dalgada mı yapılsın, yoksa ayrı bir ölçüm turuna mı bırakılsın?
