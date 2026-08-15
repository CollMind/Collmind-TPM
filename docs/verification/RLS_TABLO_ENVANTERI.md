# `ADIM 2` · Ölçüm 1 — RLS tablo envanteri (`N`)

> **Ölçüldü:** 2026-08-15 · **Ölçen:** Team Lead · **Kaynak:** canlı DB, `collmind_tpm`, şema `main`
> **Plan kalemi:** `docs/process/FAZ1_PLAN.md §4.1`
> **Tüketici:** `ADIM 5` (`K-2.6.12`, RLS politikaları) — bu envanter onun **paydası**

## Neden bu ölçüm var

`0071 §5` şunu kaydetti: ***`RLS 0/43` rakamı KAYITTA YOK.*** O sayı bir oturumda
**uydurulmuştu** ve kaydedilen tek gerçek `0056`'nın *"`tenant_id` taşımayan 4 tablo"*
notuydu — payda hiç ölçülmemişti.

> **Bir oran, paydası ölçülmeden yazılamaz.** `0/N` ifadesi ancak bu ölçümden sonra
> yazılabilir (plan `§4.1`'in kendi şartı).

## Sonuç

```
main şemasındaki BASE TABLE          52
  tenant_id TAŞIYAN                  48     ← RLS'in PAYDASI
  tenant_id taşımayan                 4
```

⚠️ **Yani yazılabilir ifade: `0/48`** — bugün hiçbir tabloda politika yok
(`L2_03 K-2.6.12`: *"Veritabanı seviyesinde hiçbir politika tanımlı değil"*).

## `tenant_id` taşımayan dört tablo — ve üçü SİSTEM

| tablo | sınıf | RLS gerekir mi |
|---|---|---|
| `migrations` | TypeORM defteri | ❌ sistem |
| `typeorm_metadata` | TypeORM defteri | ❌ sistem |
| `_t019_backfilled_tx` | **göç defteri** — `1795`'in `down()`'u *"kendi yazdığından fazlasını silme"* (`T-030`) için kullanıyor; `down()`'da `DROP` ediliyor | ❌ sistem |
| `tenants` | **kiracının kendisi** | ⚠️ **ayrı soru** — bir kiracı diğerinin satırını görmeli mi; `ADIM 5`'in kararı |

📌 **`_t019_backfilled_tx` ölü iskele DEĞİL** — ilk bakışta `BudgetReservation` sınıfına
benziyor (`1` satır, ad başında `_`), ama ölçüldü: `1795000000000-AddSpendTypeToBudget
Dimensions.ts` onu `up()`'ta yaratıp `down()`'ta düşürüyor ve **`down()`'un doğruluğu ona
bağlı**. Silinmesi `1795`'in geri alınmasını bozar.

> Bu ayrım, `T-225`'in tersinden bir vakası: orada *"ölü mü, port edilmemiş mi"* soruldu ve
> **ölü** çıktı; burada *"ölü mü"* soruldu ve **canlı bir mekanizmanın parçası** çıktı.
> İkisinde de cevabı veren şey adı değil, **onu yazan/okuyan yolun ölçülmesi** oldu.

## Ölçümün sınırı

- **Tek veritabanı** (`collmind_tpm`, dev). Başka bir ortamda tablo kümesi farklı olabilir.
- **`BASE TABLE` ile sınırlı** — görünümler (`v_budget_summary` gibi) sayılmadı; RLS
  görünümlere doğrudan uygulanmaz, ama **alttaki tabloların politikası görünüme yansır**
  ve bu `ADIM 5`'in ayrı bir sorusudur.
- Bu envanter **hangi politikanın yazılacağını** söylemez, yalnız **kaç tabloya**
  yazılacağını.

## Komut (yeniden üretilebilir)

```sql
select count(*) filter (where has_tenant) as tenant_id_var,
       count(*) filter (where not has_tenant) as tenant_id_yok
from (select t.table_name,
             exists(select 1 from information_schema.columns c
                    where c.table_schema='main' and c.table_name=t.table_name
                      and c.column_name='tenant_id') as has_tenant
      from information_schema.tables t
      where t.table_schema='main' and t.table_type='BASE TABLE') x;
```
