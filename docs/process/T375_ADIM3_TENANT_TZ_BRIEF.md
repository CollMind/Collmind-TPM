# `T-375` ADIM 3 — `"BUGÜN"` = TENANT SAAT DİLİMİ (hüküm 11)

> Şerit: `data-engineer` · Repo: `collmind.backend` · Migration numarası **`1826000000000`** (tahsis edildi)
> ⛔ Ajan kendi migration numarasını seçmez.

## 0. Hüküm

Finansal yollarda `"bugün"` **sunucu-yereli değil, TENANT'ın saat dilimidir.** Bugün üç ayrı
taban karışık kullanılıyor ve bu, İstanbul'da `00:00–03:00` penceresinde **geçerli bir tarihi
reddedebilir**.

## 1. ⛔ ÖNCE OKU: BU ALAN ZATEN VAR (Team Lead `§7` ölçümü, 2026-09-07)

```
tanım   tenant.entity.ts:93     settings.timezone?: string     (jsonb `settings` içinde)
yazar   tenant.seed.ts:23       'Europe/Istanbul'
DTO     create-tenant.dto.ts:96 timezone?: string
canlı   Wella Turkey            settings->>'timezone' = 'Europe/Istanbul'    DOLU
eksik   KISIT (nullable jsonb, CHECK yok)   ·   TÜKETİCİ (local-today.ts okumuyor)
```

⇒ **YENİ ALAN AÇMA.** `tanım → yazar` zaten var; bu tur **kısıt** ve **tüketici** getirir.

## 2. İŞ 1 — TERFİ (migration `1826000000000`)

`settings.timezone` (jsonb) → **`tenants.timezone varchar(64) NOT NULL DEFAULT 'Europe/Istanbul'`**

- `settings->>'timezone'`'dan **backfill** (dolu olanlar taşınır; boş olanlar DEFAULT alır).
- ⛔ **`settings.timezone` entity tipinden DÜŞER** ve migration `settings`'ten anahtarı **siler**.
  Gerekçe: aynı kavramın iki temsili **`F8`**'dir ve bu projede dört yerde dört farklı değer üretti.
  ⛔ `settings.timezone` yazan/okuyan **HER yeri ÖLÇ ve taşı** — `create-tenant.dto.ts:96`,
  `tenant-response.dto.ts`, `tenant.seed.ts`, servis katmanı. *"Kardeş yol etkilenmiyor" iddiası
  ölçülmeden yazılamaz* (`§7.1`).
- `down()`: değeri `settings`'e **geri yazar**, sonra kolonu düşürür. ⛔ `Z100` şablonu bağlayıcı:
  üç-durum assert · şema-nitelendirme (`main`) · `run→revert→run` bayt-birebir ·
  `down()`'ın ne yapamadığı koda yazılı.
- ⛔ **ŞEMA ↔ ENTITY METADATA aynı turda hizalanır** (`Z100` md.6): iki paralel şerit birinde
  şemayı birinde entity'yi tuttu, ikisi de ayrı ayrı yeşildi, çelişki **yalnız birleşmede** göründü.
- **Değer geçerliliği:** `CHECK` ile IANA adı doğrulanamaz. Kabul edilen çözüm: uygulama
  katmanında `Intl.DateTimeFormat` ile **doğrula ve REDDET** (`§2.5` — sessiz düzeltme YOK).
  Bir `CHECK` yazacaksan yalnız *"boş string değil"* düzeyinde yaz ve **sınırını koda yaz**.

## 3. İŞ 2 — TÜKETİCİ: `local-today.ts`

Bugünkü hâl:
```ts
export function localTodayIsoDate(now: Date = new Date()): string { … getFullYear/getMonth/getDate … }
```
⇒ **SUNUCU** saat dilimi. Yeni hâl: kaynağı **tenant'ın `timezone`'u** olan bir gün hesabı
(`Intl.DateTimeFormat(tz, {timeZone})` ile — `Date` aritmetiğiyle değil).

⛔ **ÜÇ TÜKETİCİSİ VAR** (ölçüldü — dosyanın kendi yorumu "tek tüketicisi" diyordu, YANLIŞTI ve
`F12` ile düzeltildi):
```
agreement-transaction.controller.ts:38
ledger.service.ts:5              ⛔ FİNANSAL TERS KAYIT YOLU
lta-agreement.service.ts:24
```
Her üçünün `tenantId`'ye erişimi olduğunu **ölç**; olmayan varsa **DUR** ve bildir — imzayı
zorlamak için `tenantId`'yi uydurma.

## 4. İŞ 3 — `S1` KAPANIŞI: KARIŞIK TABAN

Review bulgusu (doğrulandı):
```
lta-agreement.service.ts:127   UTC tabanlı
lta-agreement.service.ts:139   localTodayIsoDate()  (yerel)     ⛔ AYNI if BLOĞUNDA
agreement-transaction.controller.ts:288  ·  ledger.service.ts:55 vs :152   aynı asimetri
```
Hepsi **tek tabana** (tenant-TZ) çekilir. ⛔ Her birinin **ÖNCE/SONRA** davranışını yaz —
bir düzeltme de bir iddiadır.

## 5. PİN — `T-333` HARNESS'İ (zorunlu)

`T-333` deseni: **child-process**, `TZ` ortam değişkeni **üç farklı değerle**
(`UTC`, `Europe/Istanbul`, `America/New_York`) — üçünde de **aynı tenant-günü** çıkmalı.
⛔ Emsal harness'i **bul ve yeniden kullan** (`excel-serial-date.spec.ts` / `T-333` izleri);
ikinci bir kopya yazmak `§2.7 #8`'dir.

⛔ **REPRODÜKSİYON-ÖNCE:** düzeltmeden ÖNCE, `TZ=America/New_York` altında bugünkü kodun
**farklı bir gün** ürettiğini **GÖR** ve raporla. Görülemezse **DUR** — *"kusur var"* demek,
*"kusur yok"* demek kadar bir iddiadır (`T-273` dersi).

## 6. ⛔ DUR LİSTESİ

- `budget_envelopes` / `budget.repository.ts` / zarf çözümlemesine **DOKUNMA** (`ADIM 1`/`ADIM 2`).
- `agreements.category_id`'ye dokunma (`ADIM 2`).
- `agreement-transaction.controller.ts:191` (zarf çözümlemesi) satırına **dokunma** — aynı dosyada
  ama **başka şeridin** kalemi. Yalnız tarih tabanıyla ilgili satırlar senin.
- Yeni bir `now()`/`Date` yardımcı dosyası açma; **`common/date/` altındakileri ÖLÇ ve kullan**
  (`add-months.ts`, `period-month.ts`, `date-text.ts`, `excel-serial-date.ts` zaten var).
- `git commit` / `git push` **YAPMA**.
- Doğrulamanı **izole `git worktree`'de** yap; paylaşılan ağaçta `--fix`/mutasyon/`git checkout` yok.

## 7. DOĞRULAMA (borusuz)

- `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş** (İLK adım)
- `run → revert → run` şema dökümü **bayt-birebir**
- `npx tsc --noEmit` 0 · `npm test` 0 · `npm run test:e2e` 0 · `npm run guards` 0
- Üç `TZ` altında pin yeşil · reprodüksiyon kanıtı (kırmızı → yeşil) raporda
- ⛔ Rapor: **SAYI değil, satırın kendisi.**
