# `B3` İSTİSNA DALGASI — BRIEF (onay bekler)

**Tarih:** 2026-08-26 · **Hazırlayan:** Team Lead · **Karar:** ürün sahibi
**Dayanak:** `docs/brd-v2/04_KARAR_KAYDI.md` `Z42` — `§2` çerçeve hükmü, `§3`–`§5`
**Statü:** ✅ **ONAYLANDI** (ürün sahibi, 2026-08-27) — ⛔ **İKİ-FAZLI SÖZLEŞMEYLE**

> ## ⛔ SÖZLEŞME — önce TÜM ölçümler, sonra TEK uygulama
>
> ```
> FAZ-A   dört ölçüm BİRDEN → tabloya işlenir → DUR çıkan satır DÜŞER
> FAZ-B   kalan satırlar TEK commit-dizisi · satır-başına YÖN-ETİKETLİ davranış pini
> ```
>
> **Ürün sahibinin gerekçesi — iki riskin arasından geçiyor:**
>
> | reddedilen yol | neden |
> |---|---|
> | ayrı bir ölçüm turu açmak | *"iki küçük çağrı-ölçümü için **tur-yükü** taşımak"* — `İlke 1`'in **süreç hâli** |
> | ölçüm ile uygulamayı iç içe geçirmek | `T-294→296` zincirindeki **kapsam-kayması** riski |
>
> 📌 İki-fazlı sözleşme bu ikisinin **ortasıdır**: tek tur, ama **içinde bir bariyer**.
> Ve bariyer `DISIPLIN`'in *"yazma ile commit arasına bir DOĞRULAMA koy"* kuralının
> **dalga ölçeğindeki** hâli.
>
> ### Faz-A'nın dört ölçümü
> ```
> §1  tüketici sayımı (ekran-kapısı zinciriyle)
> §5  boş-küme ÇAĞRISI    [fixture şartı: PENDING_FINANCE_REVIEW ≥ 1, yoksa T-273]
> §6  türetilebilirlik
> §3  karma satırın −P tüketici payı
> ```
>
> ⛔ **`§5` ve `§6` ölçüm sonucuna göre ya `Faz-B`'ye biner ya KAYITLA tek-vaka kalır —
> ikisi de bu dalganın raporunda kapanır, SARKAN KALMAZ.**

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

## 1 · DARALTMALAR — ~~`−PLANNER` ×4~~ → **×3** (`Z43 §0` ile GERİ ÇEKİLDİ)

> ⛔ **`Z43 §0` (2026-08-27): bu bölümün hükmü İKİ UÇTA GERİ ÇEKİLDİ.**
> `Faz-A` ölçümü, aşağıdaki *"dayanak 2"*yi çürüttü: *"tek tüketici `/finance`
> ekranı"* cümlesi **`plan-performance` için ölçülmüş**, `dashboard/summary`'ye
> **GENELLENMİŞTİ** — ikincisinin tüketicisi `DashboardPage`.
> **Ürün sahibi: *"GENELLEME, ÖLÇÜM DEĞİLDİR."***
>
> | uç | hüküm |
> |---|---|
> | `sales-actuals/summary` · `settlements/summary` · `plan-performance` | ✅ **AYAKTA** — ölçüm doğruladı |
> | `dashboard/summary` | ⛔ **GERİ ÇEKİLDİ** — `PLANNER` **KALIR**, `MODES_READ` tabanına **birebir** transfer (`Z43 §1`) |
>
> *(`F12`: aşağıdaki metin **silinmedi**; geri çekilme **ölçümün çürüttüğü KADARDIR**.)*

| rota | bugün | sonra |
|---|---|---|
| `actuals-first/sales-actuals/summary` | `{A,CM,F,P,RO}` | `{A,CM,F,RO}` |
| `actuals-first/settlements/summary` | `{A,CM,F,P,RO}` | `{A,CM,F,RO}` |
| ~~`dashboard/summary`~~ ⛔ **GERİ ÇEKİLDİ** (`Z43 §1`) | `{A,CM,F,P,RO}` | **DEĞİŞMEZ** — `MODES_READ` (5/5) transferi |
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

### ⛔ ARAMA YÜZEYİ — uç çağrısı YETMEZ (ürün sahibi, `K3`/`B1` dersi)

> *"Arama yüzeyi yalnız `fetch`/endpoint çağrıları değil, **EKRAN-KAPISI ZİNCİRİ**:
> hangi sayfalar bu uçları çağırıyor **∧** o sayfalara `P` girebiliyor mu."*

| durum | sonuç |
|---|---|
| uç çağrılıyor **ama** ekran `P`'ye **kapalı** | daraltma **GÜVENLİ** |
| uç çağrılıyor **ve** ekran `P`'ye **AÇIK** | ⛔ **DUR** |

⚠️ **En riskli adaylar GENEL yüzeylerdir** — `dashboard/summary` gibi. Bir dashboard
her role açık olabilir.

- [ ] Zincir sonuna kadar izlenir: `uç → sarmalayıcı → hook → bileşen → SAYFA → kapı`
- [ ] Davranış pini: `PLANNER` ile çağrı → **`403`**; `FINANCE` ile → **`200`**

### ⛔ VE `DUR` SATIRI DÜŞÜRÜR, KARARI DÜŞÜRMEZ

> **Ürün sahibi:** *"O durumda bana dönen şey **'`P`'nin o ekrandaki ihtiyacı ne'**
> sorusudur — `#9`'un çift-olumsuzu **ekran-gerçeğiyle çelişirse**, provenance-kuralı
> gereği **yeniden bakarız**."*

📌 Yani `Z42 §1`'in emsali burada **kendi girdisini de denetliyor**: `#9`'un *"davranışsal
ulaşılamazlık"* yarısı bir **ölçümdü** — ve ölçüm çürürse **hüküm yeniden açılır**.
*(Bir hükmün dayanağı ölçümse, ölçümün çürümesi hükmü de çürütür.)*

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
- [ ] Davranış pini **(backend)**: `READONLY` ile `GET` → `200`, `POST`/`PATCH` → **`403`**
      *(izleme genişliyor, yazma genişlemiyor)*
- [x] Davranış pini **(ekran)**, BİRİNCİ YARI: üç kapıya `READONLY` eklendi ve pin
      **ayırt edici** — kapılar eski hâline döndürüldüğünde tam **üç yeni pin** kırıldı
- [ ] ⛔ **İKİNCİ YARI ÖLÇÜLMEDİ** — *"`Promise.all`-sınıfı toplu düşüş yaşamıyor"*.
      Mevcut test sayfayı `vi.mock` ile **stub**'lıyor ⇒ hiçbir veri çekilmiyor;
      **kurulum, ölçülmek istenen koşulu ORTADAN KALDIRIYOR** (`§2.7 #4`).
      *Bu kutu işaretlenmiyor — ölçülmedi diye yazılıyor.*

> ⚠️ **Ölçülen hafifletici (`Faz-B` review `S6`):** sayfanın çağırdığı **beş ucun
> beşi de** artık `READONLY`'ye açık (`MODES_LEDGER_READ` ×3 · `MODES_ONINVOICE_READ`
> ×2) ve demetler **zaten `allSettled`**. ⇒ Bulgu *"ekran kırık"* **değil**,
> *"kutu işaretlenemez"*. Gerçek risk düşük, **ama ölçüm ölçümdür.**

> **Ürün sahibi:** *"`T-287`'nin öğrettiği: **API `200` olsa da ekran zinciri ayrı
> kırılabilir**. İki-repo-tek-kapanışın kanıtı **iki repodan da** gelir."*

📌 Bir `403` bir demeti öldürebiliyorsa, bir `200` de tek başına *"ekran çalışıyor"*
demez. `#7`/`#8` **iki repoda birden** açılan bir yetki olduğundan, kapanışın kanıtı
da **iki repodan** gelmelidir — yoksa `§2.7`'nin *"kapsam doğru, ayırt etme gücü yok"*
sınıfına düşer.

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

### ⛔ ÖLÇÜM SONRASI İKİ YOL — ikisi de YAZILI (ürün sahibi şartı)

| ölçüm | sonuç | ne kaydedilir |
|---|---|---|
| boş-küme **DOĞRULANDI** | rota **TEK-VAKA** kalır | `−F` cümlesi kayda geçer: *"`FINANCE` bu uçtan **iş göremez** — `findPendingApprovals` `PENDING_FINANCE_REVIEW` **döndürmez**"* |
| boş-küme **ÇÜRÜDÜ** (`F`'nin görebileceği kayıt dönüyor) | `+F` **`Faz-B`'ye biner** | `APPROVAL_QUEUE_READ`'e göç **tamamlanır** |

> **Ürün sahibi:** *"İki yol da tek-vaka-listesini ya da hücreyi **temiz bırakıyor** —
> **üçüncü durum (belirsiz) YOK**, çünkü fixture şartın onu **imkânsız** kılıyor."*

📌 Bu, `DISIPLIN`'in **İMKÂNSIZLIK KONTROLÜ** deseninin uygulanışı: bir ölçüm
tasarlanırken *"belirsiz çıkarsa ne yaparım?"* sorusu **cevaplanmaz, ORTADAN
KALDIRILIR**. Belirsiz çıkarsa **fixture eksiktir**, ölçüm değil.

---

## 6 · CÜMLE-TESTİNE GİDEN — `on-invoice` ↔ `agreement-batch` asimetrisi

```
GET on-invoice/batch/:batchId              {A,F,P,RO}
GET agreement-transactions/batch/:batchId  {A,F}
    yapısal olarak ÖZDEŞ · aynı boru hattı · İKİSİNDE DE KAYIT YOK
```

**`Z42 §4` hükmü:** yön **cümle-testiyle** belirlenir — `P`/`RO`'nun satırları
**`ledger`'dan türetebildiği** ölçülürse hizalama **açılımsızdır**.

- [x] Ölçüm **YAPILDI** (`Faz-A`, `Z43 §3`): `batch`'te olup `findAll`'da olmayan
      alan **`[]`**; `findAll` **daha zengin** (`agreement`,`customer` join'li);
      `PLANNER` `?batchId=` ile **birebir aynı** satırları alıyor ⇒ **AÇILIM YOK**

> ### ⛔ ÖLÇÜMÜN SINIRI — `Z43 §5` şart-2, aynen taşınıyor
>
> **`on-invoice/batch/:batchId`'nin KENDİ alan kümesi ÖLÇÜLMEDİ.**
>
> ⇒ Dolayısıyla *"kardeşi zaten `{A,F,P,RO}`"* bir **BİÇİMSEL TUTARLILIK**
> argümanıdır. Hizalamayı meşrulaştıran şey **o değil**, ölçülen
> **türetilebilirliktir**. İkisi karıştırılmamalı: biri ölçüldü, diğeri **emsal**.

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
| 1 | ~~`−P` ×4~~ → **×3** | daraltma | ✅ **İNDİ** — `dashboard/summary` `Z43 §1`'de geri çekildi, `MODES_READ`'e transfer |
| 2 | `+CM` ×3 **+ `stats/+CM`** | genişleme | ⛔ **BEKLİYOR** — `Z25` kilidi · sağlayıcı `T-304` **DİLİM-1** |
| 3 | `stats/summary` karma | üç yön | ✅ **ÇÖZÜLDÜ** (`Z43 §2`): `−P` **ÖLDÜ** (P yeni evinin üyesi) · `+RO` **§4'e katıldı** · `+CM` `Z25`'te |
| 4 | `+RO` (`#7` · `#8` · `stats/summary`) | genişleme | ✅ **İNDİ** — hücre `+RO` + üç ekran kapısı, iki-repo-tek-kapanış |
| 5 | `pending-approvals` `+F` | genişleme | ⛔ **TEK-VAKA** — boş-küme **ÇAĞRILARAK DOĞRULANDI** (`Z43 §3`); `−F` cümlesi kayıtlı |
| 6 | batch asimetrisi | hizalama | ✅ **İNDİ** — türetilebilirlik **ölçüldü**, açılım yok (`Z43 §3`) ⚠️ sınırı: `§6` |

> **Sorulan:** `1` · `3`'ün iki yarısı · `4` bu dalgaya binsin mi; `5` ve `6`'nın
> ölçümleri bu dalgada mı yapılsın, yoksa ayrı bir ölçüm turuna mı bırakılsın?
