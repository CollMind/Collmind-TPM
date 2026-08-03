# Guard Baseline — Faz 1

| | |
|---|---|
| Tarih | 2026-08-03 |
| Repo | `collmind.backend` (submodule) |
| Branch | `staging` (⚠️ `feat/financial-guards` açılmadı — bkz. "Açık noktalar") |
| Commit SHA | `b122a6e` |
| Mod | `GUARD_MODE=report` — hiçbir guard build/test/commit kırmaz |
| Kaynak | `docs/contracts/SYSTEM_INVARIANTS.md` §10 (guard backlog 2–5) |

Bu faz kod davranışını değiştirmedi. Yalnızca kontrol script'leri eklendi.

---

## Özet

| Guard | Bulgu | Muhtemel gerçek | Muhtemel yanlış pozitif |
|---|---|---|---|
| migration-schema (INV-M-002) | 6 | 5 | 1 |
| ledger-direction (INV-L-007) | 0 | 0 | 0 |
| financial-ordering (INV-N-001) | 0 | 0 | 0 |
| schema-isolation (INV-M-003) | 1 | 1 | 0 |
| **TOPLAM** | **7** | **6** | **1** |

Değerlendirme dağılımı: **GERÇEK 6 · YANLIŞ_POZİTİF 1 · EMİN_DEĞİLİM 0**

Bilinen doğru pozitif kontrolü: **guard 1, `1777000000000-LedgerReversalSupport.ts` bulgusunu
buldu (satır 28 ve 45) — EVET.**

`ledger-direction` ve `financial-ordering` sıfır bulgu verdi. Bu sonuç guard'ların çalışmadığı
anlamına gelmiyor: her ikisi de scratchpad'de kurulmuş sentetik fixture üzerinde beklenen
pozitifleri yakaladı ve beklenen negatifleri (tie-breaker `id`, iş anahtarı, `budget_transactions`)
geçirdi. Kaynak dosyalara dokunulmadı; fixture repo dışındadır. Ayrıntı: "Guard kalitesi".

---

## Guard 1 — migration-schema (INV-M-002)

### 1. `src/database/migrations/1777000000000-LedgerReversalSupport.ts:28` — **GERÇEK**

```ts
SELECT conname FROM pg_constraint
WHERE conname = 'FK_ledger_entries_reverses_entry'
```

Gerekçe: DB ölçümüyle kanıtlı — migration `main.migrations`'ta kayıtlı, ama FK yalnızca
`public` şemasında var:

```
 nspname |             conname
---------+----------------------------------
 public  | FK_ledger_entries_reverses_entry
```

### 2. `src/database/migrations/1777000000000-LedgerReversalSupport.ts:45` — **GERÇEK**

```ts
SELECT indexname FROM pg_indexes
WHERE indexname = 'UQ_ledger_entries_reversal_per_tenant'
```

Gerekçe: aynı kanıt — index yalnızca `public.ledger_entries` üzerinde:

```
 schemaname |               indexname
------------+---------------------------------------
 public     | UQ_ledger_entries_reversal_per_tenant
```

`main.migrations` içinde `LedgerReversalSupport1777000000000` kayıtlı olmasına rağmen CTPM
şemasında ne FK ne de UQ index var — migration sessizce no-op oldu.

### 3–5. `src/database/migrations/1779000000000-CreateUserScopes.ts:102, :119, :136` — **GERÇEK**

```ts
SELECT conname FROM pg_constraint
WHERE conname = 'FK_user_scopes_tenant'   // ve _user, _cpl
```

Gerekçe: 1777 ile birebir aynı desen — constraint adı şema filtresi olmadan aranıyor.
**Not:** bugün henüz sapma üretmemiş; DB'de bu üç constraint yalnızca `main`'de var, `public`'te
karşılığı yok. Yani ihlal gerçek, hasar henüz oluşmamış. Bunları "gerçek" saymamın sebebi
invariant'ın sorgunun kendisi hakkında olması, oluşmuş hasar hakkında değil.

### 6. `src/database/migrations/1770580780000-MakeFuIdNullableInAgreements.ts:33` — **YANLIŞ_POZİTİF**

```ts
SELECT 1 FROM pg_constraint
WHERE conname = 'FK_agreements_fu_id'
AND conrelid = 'main.agreements'::regclass;
```

Gerekçe: sorgu şema-güvenli, ama guard'ın tanımadığı bir mekanizmayla —
`'main.agreements'::regclass` tek bir tabloyu çözer, dolayısıyla `public`'e sızamaz. Guard
yalnızca `nspname`/`schemaname`/`table_schema` predicate'lerini tanıyor.

---

## Guard 2 — ledger-direction (INV-L-007)

Bulgu yok.

Repoda ledger üzerinde `amount` toplayan tüm yerler yön-farkındalıklı:

- `src/modules/modes/actuals-first/ledger/ledger.repository.ts:115,116,139,140` —
  `SUM(CASE WHEN ledger.entryDirection = DEBIT ...) - SUM(CASE WHEN ... CREDIT ...)`
- `src/database/migrations/1789000000000-FixBudgetSummaryCommitDoubleCounting.ts:62,86,113,160` —
  `SUM(CASE WHEN le.entry_direction = 'DEBIT' THEN le.amount ELSE -le.amount END)`
- `src/database/migrations/1704067740000-CreateBudgetSummaryView.ts` — aynı desen

Bu sıfır, elle doğrulanmış bir sıfırdır (yukarıdaki satırlar tek tek okundu), guard'ın kör
noktası değil.

---

## Guard 3 — financial-ordering (INV-N-001)

Bulgu yok. Finansal modüllerdeki 26 sıralama ifadesinin birincil anahtarları iş anahtarı veya
zaman damgası:

`plan.createdAt` · `plan.planCode` · `tx.invoiceDate` · `ledger.createdAt` ·
`agreement.agreementCode` · `batch.createdAt` · `entry.invoiceDate` · `ag.periodMonth` ·
`ag.updatedAt` · `lta.effectiveDate` · `ar.createdAt` · `envelope.createdAt` ·
`ba.periodStart` · `fu.name` · `sku.name`

⚠️ Bir yer statik olarak değerlendirilemedi — aşağıdaki "yanlış negatif" bölümüne bakın.

---

## Guard 4 — schema-isolation (INV-M-003)

### `db:collmind_tpm` — **GERÇEK**

```
 schema | count
--------+-------
 main   |    54
 public |    44
```

Aynı veritabanında iki ürün şeması var ve ikisinde de `migrations` tablosu bulunuyor. Bu,
guard 1'deki bulguları teorik olmaktan çıkarıp gerçek hâle getiren yapısal koşuldur:
şema-nitelendirilmemiş her catalogue sorgusu şema sınırını aşabilir.

`scripts/db-query.sh` sarmalayıcısı backend'den `$ROOT/../scripts/db-query.sh` olarak
çözüldü ve çalıştı — guard içine doğrudan `docker exec` yazmaya gerek kalmadı (fallback yine de
script'te duruyor).

---

## Faz 2 için allowlist adayları

```
migration-schema|src/database/migrations/1770580780000-MakeFuIdNullableInAgreements.ts:33|conrelid = 'main.agreements'::regclass ile şema-güvenli; guard ::regclass desenini tanımıyor
```

Yalnızca bu bir satır. Diğer altı bulgu susturulmamalı — beşi düzeltilmeli, biri
(schema-isolation) yapısal koşulun kendisidir ve düzeltilene kadar açık kalmalı.

---

## Guard kalitesi öz-değerlendirmesi

### Hangi guard çok gürültülü?

Bugünkü ölçümde hiçbiri. 7 bulguda 1 yanlış pozitif (%14). Ancak bu, kod tabanının bu üç
desende zaten temiz olmasından kaynaklanıyor — guard'ların seçiciliğinden değil.
`financial-ordering`'in gürültülü olacağı öngörülmüştü; bugün sıfır verdi çünkü repoda
gerçekten id-birincil sıralama yok.

### Yanlış negatif riski nerede? (en önemli bölüm)

**1. Guard 1 — ±10 pencere maskeleme. Kanıtlanmış.**
Fixture testinde şunu gördüm: şema-nitelendirilmiş bir sorgu, nitelendirilmemiş bir sorgunun
±10 satır penceresine düşerse, guard ikincisini **kaçırır**. Fixture'daki
`pg_indexes WHERE indexname = 'Y'` bulgusu tam bu yüzden basılmadı.

Bu, görev tanımındaki "pencere yaklaşımı yanlış negatif üretmez" varsayımıyla çelişiyor.
Yaklaşımı kendi başıma değiştirmedim (talimat gereği) — ama Faz 2'de pencerenin sorgu
sınırına (backtick template literal bloğu) daraltılması gerekiyor. Bugün 54 migration'ın
9'u catalogue sorgusu içeriyor; bunların içinde maskeleme olup olmadığı **ölçülmedi**.

**2. Guard 1 — `::regclass` tanınmıyor.** Yukarıdaki yanlış pozitifin sebebi. Faz 2'de
predicate listesine `::regclass` eklenmeli; aksi hâlde doğru yazılmış kod allowlist'e
birikir ve allowlist gerçek bulguları gizlemeye başlar.

**3. Guard 3 — dinamik sıralama alanı görünmez.**
`src/modules/shared/finance-reporting/finance-reporting.service.ts:492`:

```ts
query.orderBy(sortField, pagination.sortOrder || 'DESC');
```

`sortField` çalışma zamanında belirleniyor. Statik guard bunu değerlendiremez; guard bu satırda
`'DESC'` dizgisini okuyup geçiyor. `sortField` bir id alanına çözülebiliyorsa INV-N-001 burada
ihlal edilir ve **hiçbir guard bunu yakalamaz**. Bu bir triyaj konusu değil, insan incelemesi
konusu — Faz 2 kapsamına alınmalı.

**4. Guard 2 — yön anahtarı penceresi fazla cömert.** ±10 satır içinde herhangi bir yerde
`DEBIT` geçen bir **yorum satırı** bile bulguyu bastırır. Bugünkü sıfır bulgunun elle
doğrulanmasının sebebi bu.

**5. Guard 2 — pencere yanlış pozitif de üretebilir.** Fixture'da `budget_transactions`
üzerindeki meşru bir `SUM(amount)`, 10 satır ötedeki ledger bağlamı yüzünden bulgu olarak
basıldı. Gerçek repoda tetiklenmedi, ama ledger ve budget toplamları aynı metoda yaklaşırsa
tetiklenecek.

**6. Guard 4 — tek koşul kontrol ediyor.** Yalnızca "iki şemada da `migrations` var mı" diye
bakıyor. TTM şeması `migrations` tablosu olmadan da ad çakışması üretebilir; bu durumda guard
sessiz kalır.

### Yapısal notlar

- **`filter_allowlist` fonksiyonu dört script'te birebir tekrarlanıyor.** Bilinçli: teslimat
  listesi tam olarak 6 dosya sayıyordu ve guard'ların tek başına çalıştırılabilir olması
  gerekiyordu. Faz 2'de `_lib.sh`'a çıkarılmalı (CLAUDE.md §7).
- Allowlist'in gerekçe zorunluluğu test edildi: gerekçesiz satır susturma yapmıyor
  (2 satır eklendi, yalnızca gerekçeli olan uygulandı → 6 bulgu 5'e düştü).
- Guard'lar salt-yorum satırlarını atlıyor. Aksi hâlde `1777`'deki
  `// 3) Self-FK — idempotent via pg_constraint check` yorumu ayrı bir bulgu üretirdi.
