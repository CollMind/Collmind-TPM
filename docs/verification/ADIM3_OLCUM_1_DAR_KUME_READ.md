# `ADIM 3` ölçüm 1 — dar-kümeli `READ` route'ları: iş kuralı mı, tesadüf mü?

> **Ölçen:** Team Lead · **Tarih:** 2026-08-17 · **İsteme listesi:** `0073 §5/1`
> **Soru:** üç `READ` hücresindeki dar `@Roles` kümeleri **neyi kodluyor** —
> bir iş kuralını mı, tarihsel bir tesadüfü mü?

---

## 0 · Ön beklenti tablosu (`0073`'ten, ölçümden ÖNCE yazılı)

| şık | union kararı |
|---|---|
| kısıt bir **iş kuralı** | union **RED** — daraltma korunur |
| kısıt bir **tesadüf** | union **KABUL** |
| **karışık** | route bazında |

---

## ⚠️ 1 · Bu ölçümün SINIRI — önce okunur

**`39` dar-kümeli `GET` route'u var** (parser: `237/160/77` tabanını üreten aynı
fixpoint parser'ı, `5/5` ve filtresiz olanlar dışlanarak). Bu belge **hepsini
sınıflandırmıyor** — **üç kümeyi** ölçtü ve sonuç **karışık** çıktı.

```
ÖLÇÜLDÜ    şablon indirmeleri (4)  ·  zarf defteri (2)  ·  GET /users (1)
ÖLÇÜLMEDİ  agreement-transaction / on-invoice / ledger ana okumaları (~24) ·
           finance-reporting'in 8 ucu (iki farklı küme taşıyor) · plan kuyrukları
```

> `CLAUDE.md`: *"bir küme hakkında sonuç yazılıyorsa, kümenin NASIL SINIRLANDIĞI
> aynı cümlede yazılır."* Bu ölçüm bir **örneklemdir**; genel sonuç yalnız
> ölçülen üç küme için geçerlidir.

---

## 2 · Sonuç: **karışık** — ve ölçülen üçünde de kısıt bir iş kuralı DEĞİL

### 2.1 · Şablon indirmeleri — kısıt **yazma yoluna bağlanmış**, veriye değil

```
GET /agreement-transactions/template/csv     {ADMIN, FINANCE}
GET /agreement-transactions/template/excel   {ADMIN, FINANCE}
GET /on-invoice/template/csv                 {ADMIN, FINANCE}
GET /on-invoice/template/excel               {ADMIN, FINANCE}
```

Ölçüm — gövde **hiç tenant verisi taşımıyor**:

```ts
async downloadCSVTemplate(@Res() res: Response) {         // tenantId YOK, actor YOK
  const csv = this.fileParserService.generateCSVTemplate();
  ...
}
```

Ve **anlattığı veri daha AÇIK**: `GET /on-invoice/entries` = `{ADMIN, FINANCE,
PLANNER, READONLY}`.

> **Sıfır tenant verisi taşıyan bir uç, anlattığı veriden DAHA KISITLI.**

📌 Teşhis: kısıt **yükleme** rotasının rol kümesinden (`WRITE_ROLES = {ADMIN,
FINANCE}`) miras alınmış. `K-2.6.4` `FİNANS`'a *"içe aktarma"* sorumluluğu veriyor —
yani **yükleme** kısıtı gerekçeli. Ama **şablonu indirmek** bir içe aktarma değil,
ona hazırlıktır. **Tesadüf (yazma yoluna eşlenme), iş kuralı değil.**

### 2.2 · Zarf defteri — kardeş bir uç kısıtı ANLAMSIZ kılıyor

```
GET /ledger/envelope/:envelopeId              {ADMIN, FINANCE}     ← CM ve PLANNER DIŞARIDA
GET /ledger/envelope/:envelopeId/consumed     {ADMIN, FINANCE}
GET /budget/envelopes/:id/transactions        ⛔ FİLTRESİZ          ← HERKES
```

⚠️ **Ve bunlar AYNI TABLO DEĞİL** — ölçüldü, varsayılmadı:

```
LedgerEntry        @Entity('ledger_entries',      schema 'main')
BudgetTransaction  @Entity('budget_transactions', schema 'main')
```

Yani iddia *"aynı veri iki kapıdan"* **değil**. Doğru iddia daha dar ve yine
keskin: **aynı zarfın para hareketi kaydı iki ayrı defterde tutuluyor, ve
ikisinin koruması zıt** — biri iki role kapalı, öbürü herkese açık.

📌 Ve `K-2.6.4` ile çelişiyor: `KATEGORİ MÜDÜRÜ` = *"Kategori bütçe sahibi: onay +
**zarf yönetimi**"*. Zarfın sahibi sayılan rol, o zarfın defter kaydını
`ledger/envelope` üzerinden **göremiyor**, ama `budget/envelopes/:id/transactions`
üzerinden **filtresiz** görüyor.

> Bir kısıt, kardeşi filtresizken bir **iş kuralı** olamaz — koruduğu şeyi
> korumuyor. **Tesadüf.**

### 2.3 · `GET /users` — `{ADMIN, FINANCE}`, ve `FINANCE`'ın gerekçesi yok

`K-2.6.4`'te `FİNANS`'ın sorumluluğu: *"Eşik üstü onay/bildirim, transfer,
mutabakat, içe aktarma."* **Kullanıcı yönetimi yok** — o `YÖNETİCİ`'de
(*"Tanımlar, kural yönetimi"*).

`findAll` tenant'ın **tüm kullanıcı kaydını** döndürüyor (`user.service.ts:114`,
alan seçimi yok — `User[]`).

> `FINANCE`'ın burada olmasının `L2`'de bir dayanağı **bulunamadı**. ⚠️ Ve bu bir
> *"yok"* iddiası değil, bir *"aranan yerde bulunamadı"* iddiası: `K-2.6.4` rol
> kataloğu ve `L2_03 §2.6.2` yetenek katmanı tarandı. Başka bir yerde olabilir —
> **kapsam budur.**

---

## 3 · Union kararına etkisi

Ön beklenti tablosunun **üçüncü şıkkı** çıktı: **karışık → route bazında.**

Ama ölçülen üç kümede sonuç aynı yöne bakıyor: **kısıt bir iş kuralı değil.** Bu,
union'ı otomatik olarak meşrulaştırmıyor — çünkü:

⚠️ **Ölçüm 2'nin bulgusu burayı da vuruyor.** Kapsam filtresi bugün `5` rolün
`1`'inde aktif (`T-235`). Yani bir okuma ucunu union ile genişletmek, **hiçbir
satır-seviyesi daraltmanın devralmayacağı** bir genişlemedir. `@Roles` bugün
gerçekten **tek** kapı.

> **`A` sınıfının *"gerçek daraltma serviste"* gerekçesi, union kararının ön
> koşuluydu — ve o gerekçe `T-235` kapanana kadar `4/5` rol için geçersiz.**

📌 Bu yüzden öneri: **union bu üç `READ` hücresinde `T-235`'ten SONRA
değerlendirilir.** Sıra tersine çevrilirse, kapsam katmanı kapalıyken rol katmanı
gevşetilmiş olur — iki kapı da aynı anda açık.

---

## 4 · Kalan iş

| # | küme | neden ölçülmedi |
|---|---|---|
| 1 | `agreement-transaction` · `on-invoice` · `ledger` ana okumaları (~24) | tek tek veri sınıfı incelemesi gerekiyor — bu turun kapsamı dışı |
| 2 | `finance-reporting`'in `8` ucu | **iki farklı küme** taşıyor (`{ADMI,FINA,READ}` ↔ `{ADMI,CATE,FINA,READ}`) — ayrımın `CM`'yi neye göre dışladığı ayrı bir soru |
| 3 | `plans/approval-queue` · `pending-approvals` | `0073 §5/3` (onay **görme** tarafı) ile aynı soruyu paylaşıyor — birlikte ölçülmeli |
