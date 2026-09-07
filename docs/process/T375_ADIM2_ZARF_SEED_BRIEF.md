# `T-375` ADIM 2 — ZARF SEED TASARIMI + ANLAŞMA KATEGORİSİ + CM-SCOPE

> Şerit: `data-engineer` · Repo: `collmind.backend` · Ürün-sahibi hükümleri 2026-09-07
> ⛔ Bu brief bir **kapının önceden bilinen sınırını** taşır (aşağıda `SINIR` bölümü).

## 0. Bağlam — neden bu tur var

`T-373` on-invoice yolunda kategori boyutunu zarf çözümlemesine bağladı. Ölçüm (canlı DB,
üretim yükleminin birebir kopyası):

```
kategorisiz (ESKİ davranış)   → 2 zarf bulunuyor
kategori GEÇİLİNCE            → 0 zarf
```

Yani düzeltme *"yanlış zarfa yazıyor"*u ***"hiçbir zarfa yazmıyor"***a çevirdi — çünkü
canlı dört zarfın **dördü de `category IS NULL`**. Bu tur o boşluğu kapatır.

## 1. ÖLÇÜLMÜŞ BAŞLANGIÇ DURUMU (Team Lead, 2026-09-07 — yeniden ölçülecek, körü körüne güvenilmeyecek)

```
main.budget_envelopes = 4, HEPSİ category NULL, HEPSİ channel KOLONU NULL
  (kanal yalnız metadata->>'channel'):
  ENV-2026-NKA-Q1   2026-01  500.000  meta NKA                 ledger 3 · budget_tx 4  BAĞLI
  ENV-2026-NKA-Q2   2026-02  600.000  meta NKA                 ledger 0 · budget_tx 3  BAĞLI
  ENV-2026-TRAD-Q1  2026-01  300.000  meta TRADITIONAL_TRADE   ledger 0 · budget_tx 0  bağsız
  ENV-2026-ECOM-Q1  2026-02  200.000  meta E_COMMERCE          ledger 0 · budget_tx 0  bağsız
main.categories = 8 (kodlar aşağıda)
main.agreements = 5, category_id 5/5 NULL
main.plans = 2, category_id 2/2 DOLU (kolon NOT NULL)
```

## 2. İŞ 1 — SEKİZ KATEGORİ ZARFI (ürün-sahibi imzalı tablo, ⛔ TUTAR/KATEGORİ İCAT YOK)

| kategori (görünen ad) | `category` kolonu (⛔ **KOD**) | tutar |
|---|---|---|
| Saç Boyası | `CAT-SAC-BOYASI` | 750.000 |
| Set Boya | `CAT-SET-BOYA` | 450.000 |
| Şekillendirici | `CAT-SEKILLENDIRICI` | 350.000 |
| Hair Care | `HAIR_CARE` | 300.000 |
| Köpük | `CAT-KOPUK` | 180.000 |
| Peroksit | `CAT-PEROKSIT` | 120.000 |
| Karma Koli | `CAT-KARMA-KOLI` | 90.000 |
| Diğer | `CAT-DIGER` | 60.000 |
| **Σ** | | **2.300.000** |

⚠️ **`HAIR_CARE`'in kod şekli diğer yediden FARKLI** — bu **ölçüldü** (`main.categories`),
düzeltilmedi ve uydurulmadı. Eğer bunu bir tutarsızlık sayıp değiştirmek istersen: **DUR**,
Team Lead'e bildir; kod değeri `plans`/`skus` tarafından da kullanılıyor olabilir — ÖLÇ.

⛔ **`category` kolonuna KOD yazılır, ad DEĞİL.** Gerekçe ölçüldü:
`on-invoice.service.ts:496` → `const category = skuCategory?.code || skuCategory?.name;`
ve `budget.repository.ts` → `envelope.category = :category`. Ada yazılırsa eşleşme **sessizce**
kaçar. ⛔ Ayrıca **`category_id` (uuid FK) kolonu da doldurulur** — iki temsil bir `F8` riskidir,
ama `category_id` bugün ZATEN var ve boş; hangisinin tek doğruluk kaynağı olacağı `ADIM 1`'in
kararı. Bu turda **ikisi de tutarlı** doldurulur ve tutarlılık bir kısıtla değil, **seed'in tek
noktasıyla** sağlanır (aynı satırdan türer).

**Diğer alanlar:**
- `channel` → **`NULL`** (tanımlı-wildcard = "tüm kanallar"). ⛔ `metadata->>'channel'` de **YAZILMAZ** —
  çözümleyici ikisine de bakıyor, metadata'ya yazmak wildcard'ı bozar.
- `period` → **`2026-04`**, `fiscal_year` → **`2026`**.
  ⛔ **Team Lead'in seçimi, gerekçesi ve SINIRI:** çözümleyici `period = :periodMonth OR period LIKE '2026%'`
  yapıyor ⇒ `2026`'nın **her ayı** bu zarfa düşer ⇒ kategori başına **tek** zarf, çakışmasız.
  `'2026-Q2'` yazmak exact-match dalını ve sıralama anahtarını **ölü** bırakırdı.
  ⚠️ Bu bir **Team Lead kararıdır**, ürün-sahibi imzası **çeyrek** dedi, **ay** demedi — kayda öyle geçer.
- `spend_type` → **`NULL`** (UNSPLIT), `status` → `ACTIVE`, `currency` → `TRY`
- `code` → mevcut konvansiyonu **ÖLÇ** (`ENV-2026-NKA-Q1` deseni) ve kategori-bazlıya uyarla; adı
  ürettikten sonra **UNIQUE(tenant_id, code)** kısıtına çarpmadığını doğrula.

## 3. İŞ 2 — ESKİ DÖRT ZARF (migration `1827000000000`)

```
BAĞLI (ENV-2026-NKA-Q1, ENV-2026-NKA-Q2)   → status = CLOSED    ⛔ SİLİNMEZ
bağsız (ENV-2026-TRAD-Q1, ENV-2026-ECOM-Q1) → seed yeniden kurulumu
```
⛔ **Bağı YENİDEN ÖLÇ** (`ledger_entries.budget_envelope_id`, `budget_transactions.envelope_id`)
— yukarıdaki sayılar 2026-09-07 ölçümüdür ve **bayatlayabilir**.
⛔ `Z100` migration şablonu bağlayıcı: üç-durum assert (`hepsi`/`hiçbiri`/`KISMİ ⇒ throw`) ·
şema-nitelendirme (`main`) · `run → revert → run` şema dökümü bayt-birebir ·
`down()`'ın ne yapamadığı **koda yazılır**.

## 4. İŞ 3 — ANLAŞMA KATEGORİSİ (migration `1828000000000` + seed)

Ürün-sahibi hükmü: **ANLAŞMA = TEK KATEGORİ.** Kategori **kapsamdaki FU'dan türetilir**.
Team Lead ölçtü — **5/5 türetilebiliyor**, ürün-sahibi ataması **gerekmedi**:

```
agreements.fu_id → forecasting_units.gu_id → generic_units.category_id → categories

STA-2026-0001 / STA-2026-0002 / LTA-2026-0001   FU-WELLA-HC-500ML → HAIR_CARE
STA-2026-003  / STA-2026-004                    FU-KARMA-KOLI     → CAT-KARMA-KOLI
```

⛔ Migration bu zinciri **kendisi çalıştırır** (elle yazılmış id listesi DEĞİL — `SAYI YAZMA,
LİSTE YAZ`'ın kardeşi: **türet, kopyalama**). Türetilemeyen bir satır kalırsa **DURUR** ve
hata fırlatır — sessiz atlama YOK (`§2.5`).

⛔ **`NOT NULL` BU TURDA YAZILMAZ** — ürün-sahibi hükmü: *"form zorunlu alan, seed atanır,
NOT NULL ayrı migration"*. Sıra `tanım → yazar → kısıt` (`Z98 §3`); yazar (form/DTO) `ADIM 1`'in
işi, kısıt migration `1830000000000` ile gelir. **Numara tahsis edildi, bu turda KULLANILMAZ.**

⚠️ **`STA-2026-003` / `STA-2026-004` adları `T-277 repro <epoch>`** — bunlar bir reprodüksiyon
turundan **artık** olabilir, seed verisi değil. **ÖLÇ:** `agreement.seed.ts` bunları üretiyor mu?
Üretmiyorsa bunlar **e2e/ad-hoc artığıdır** ve *"artığı BIRAKAN yolun teardown'u aynı turda"*
hükmü uygulanır. Üretiyorsa dokunma. ⛔ **Ne bulduğunu, ne sildiğini BASARAK raporla.**

## 5. İŞ 4 — CM-SCOPE (`user_scopes`, ürün-sahibi imzalı dağılım)

```
category.manager2@…   → Saç Boyası                                        (TEK)
category.manager@…    → Set Boya · Şekillendirici · Hair Care · Köpük
manager@…             → Peroksit · Karma Koli · Diğer
⛔ eski çift-atama KALKAR
```
- `user_scopes` şeması: `(tenant_id, user_id, cpl_id, category_id, is_active)` ·
  `UNIQUE(user_id, cpl_id, category_id) NULLS NOT DISTINCT`. Kategori-scope satırında
  `cpl_id` **NULL** olur (ölç: bugünkü satırlar hangi şekilde?).
- ⛔ **Tam e-posta adreslerini ÖLÇ** (`main.users`), yukarıdaki `…` kısaltmadır — tahmin etme.
- Üçlü dağılım **çakışmasız ve TAM**: sekiz kategorinin sekizi tek bir CM'e ait. Bunu bir
  sorguyla **kanıtla** (her kategori için tam 1 aktif scope satırı).

## 6. İŞ 5 — `T-047` TABANI

`budget_envelopes` 4 → 8, `user_scopes` yeni sayı, `agreements.category_id` 0 → 5 dolu.
⛔ **Sayıyı ÖLÇEREK yaz** — elle yazılmış üye-sayısı bu projede **onbir kez** yanlış çıktı.
`T-047` invaryantının okuduğu yeri bul (`test/global-*.js` / `e2e-preflight-*`) ve orada güncelle.

## 7. ⛔ SINIR — bu turun kapıları neyi GÖSTEREMEZ (önceden bilinen)

1. **`npm test` (birim) bu turu göremez** — zarf seçimi gerçek DB ister.
2. **e2e'ler kendi zarflarını kurar** (`T-273`'ün tersi: *"veri testte var, üretimde yok"*) ⇒
   e2e yeşili, **canlı seed'in doğru olduğunun kanıtı DEĞİLDİR.**
   ⇒ Bu yüzden **canlı DB'de doğrudan ölçüm ZORUNLU**: `npm run seed` sonrası
   `budget_envelopes` sekiz satırını **basarak** göster.
3. **Kapanış kanıtı `ADIM 1`'e aittir** (gerçek parti → doğru kategori-zarfı → `INV-R-001/002`).
   Bu turda o kanıt **üretilemez** ve *"ürettim"* denmez.

## 8. ⛔ DUR LİSTESİ

- `budget.repository.ts` / `budget.service.ts` / çözümleyici koduna **DOKUNMA** — `ADIM 1`'in işi.
- `budget_envelopes.category`'yi **`NOT NULL`** yapma — `1829000000000`, `ADIM 1`.
- `agreements.category_id`'yi **`NOT NULL`** yapma — `1830000000000`, sonraki tur.
- Tutar / kategori / e-posta **İCAT ETME**. Tablo ürün-sahibi imzalıdır; eksik bir şey varsa **DUR**.
- `tenants` tablosuna dokunma — `ADIM 3`'ün şeridi (migration `1826000000000`).
- `git commit` / `git push` **YAPMA**.
- Doğrulamanı **izole bir `git worktree`'de** yap; paylaşılan ağaçta `--fix` / mutasyon /
  `git checkout` **çalıştırma** (paralel şerit var).

## 9. DOĞRULAMA (borusuz: `cmd > log 2>&1; echo $?`)

- `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş** (hayalet kontrolü, İLK adım)
- `run → revert → run` her migration için, şema dökümü **bayt-birebir** (`shasum`)
- `npx tsc --noEmit` 0 · `npm test` 0 · `npm run test:e2e` 0 · `npm run guards` 0
- `npm run seed` sonrası canlı ölçüm: 8 zarf · 5 anlaşma kategorili · kategori-başına-1-CM
- ⛔ **Rapor: SAYI değil, satırın kendisi.** Ne sildin, ne ekledin — **basarak**.
