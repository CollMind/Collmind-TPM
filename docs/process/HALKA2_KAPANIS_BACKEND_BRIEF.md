# Halka-2 · **KAPANIŞ ŞERİDİ** — seed sözleşmeye uyar · `T-064` · doğrulama fixture temizliği

> **HEAD:** meta `93fc355` · be `6aada26` (+ **commit'siz** halka-2 yolu ağaçta)
> **Hüküm:** ürün sahibi, 2026-09-06 — kapanış paketi
> ⛔ Ağaçta **başkasının commit edilmemiş işi var** (halka-2 backend yolu). `git checkout`/
> `git stash`/`git reset` **YASAK**. Yalnız kendi dosyalarına dokun.

## `İŞ 1` · SEED FIXTURE'LARI SÖZLEŞMEYE UYAR `[ürün sahibi]`

**Hüküm:** `actuals_2026-01/02.csv` **SEED KURGUSUDUR** (gerçek veriden türetilmiş,
pilot-export **DEĞİL**) ⇒ FU kodu eklemek **seed tasarımıdır, uydurma değil**.

```
iki CSV → FU-kodlu formata (fu_code kolonu)
FU'lar    mevcut 12 forecasting_units'tan, satırın KATEGORİSİYLE HİYERARŞİDEN tutarlı
          (FU → GU → category zinciri; rastgele YASAK)
korunur   satır sayısı + tutarlar (T-047 tabanı değişmesin; değişirse yeni taban
          ÖLÇÜLEREK yazılır, tahmin edilmez)
YASAK     cpl_code'dan FU türetme · sözleşmeyi gevşetme
```

**FU ↔ kategori haritası `[TL ölçtü, canlı DB]`:**
```
Şekillendirici  → FU-NEW-WAVE                                    (TEK aday)
Saç Boyası      → FU-KOLESTON · FU-NATURALS · FU-TUP-BOYA        (ÜÇ aday)
Set Boya        → FU-INTENSE · FU-KOLESTON-KIT                   (İKİ aday)
```
⛔ **Birden çok adayda seçim RASTGELE olamaz.** Deterministik bir kural yaz (ör. `cpl_code`'un
son parçasıyla eşleyen bir seed-tablosu, ya da kategori-ilk-FU alfabetik) ve **kuralı
seed dosyasının başlığına yaz** — bir sonraki okuyucu *"neden bu FU?"* sorusunu **oradan**
cevaplayabilmeli. Kural bulamıyorsan **DUR ve raporla**.

⚠️ `FU-E2E-GRID-SINGLE-SKU` canlı tabloda duran bir **e2e fixture FU'su** — seed **onu
kullanmaz**.

**Seed'in kendi pini kalır:** `NO_VALID_ROWS` (FU'suz satır ⇒ red). Yani seed **kendi
sözleşmesini** koşuyor.

⛔ **ÖNCE ÖLÇ:** `npm run seed` aynı `fileName` ile **REPLACED** üretiyor mu, yoksa yeni
batch mi ekliyor? (`INV-R-003/004`: `sales_actual_batches` `ACTIVE`/`REPLACED`.) Cevap
`T-047` tabanını belirler. `npm run seed`'i **koşmadan önce** `sales_actuals`/`batches`
sayısını bas; **sonra** bas; fark **açıklanmış** olmalı.

## `İŞ 2` · `T-064` — BU DALGA KAPATIR `[ürün sahibi]`

```
on-invoice.service.ts:218, :239   e.invoiceDate.toISOString().split('T')[0]
entity                            invoiceDate!: Date
gerçek                            TypeORM `type: 'date'` kolonu STRING hydrate eder
canlı                             TypeError: e.invoiceDate.toISOString is not a function
```
> ### **KOLONUN TİPİ `Date` DEĞİLDİR** — `T-333`/`Z81` ailesi (`new Date(…)` beş sessiz hata).

**Düzeltme:** `.toISOString()` **KALDIRILIR**, string **doğrudan** taşınır.
⛔ **`Date`'e çevirip geri çevirme YASAK** — TZ kayması üretir (`T-333` dersi: `pg` sürücüsü
`date`'i yerel gece yarısı olarak parse eder; UTC'ye çevrilince gün kayabilir).

**Pinler:** gerçek parti → `POSTED` (`FAILED` değil) · **date-string üç TZ'de aynı**
(`T-333` harness deseni — `TZ=UTC` / `TZ=Europe/Istanbul` / `TZ=America/Los_Angeles`
ayrı süreçlerde; **`process.env.TZ` Jest içinde ATIL**, `Z81`'de ölçüldü).
⚠️ Entity'deki `invoiceDate!: Date` tipi de **yalan söylüyor** — düzelt (`string`), ve
başka `.toISOString()`/`getTime()` tüketicisi var mı **grep ile say**, pozitif kontrollü.

## `İŞ 3` · DOĞRULAMA FIXTURE TEMİZLİĞİ — **NE SİLDİĞİNİ BASARAK** (`T-325`)

Önceki şerit canlı DB'de doğrulama satırları bıraktı. Hedef:
```
sales_actuals 5→3 · sales_actual_batches 4→3 · on_invoice_entries 1→0 ·
ledger_entries 4→3 · budget_envelopes 5→4   (zarf sayısı BÜTÇE PANELİNİ etkiler — özellikle)
```
⛔ **Her `DELETE` ÖNCE `SELECT` ile ne sileceğini basar**, sonra siler, sonra **sayımı
yeniden okur** (`DELETE`'in dönüş değeri kanıt değildir). İzole dönemler `2027-01`/`2027-02`
ve `E2E-HALKA2-VERIFY-*` öneki — **kapsamı bununla daralt**, tablo-geneli `DELETE` **YASAK**.
⚠️ `ledger_entries` **audit-immutable** olabilir — silinemiyorsa **ölç, raporla, DUR**;
sahte "temizlendi" yazma. `on_invoice_batches` da varsa sayıya kat.

⚠️ **`İŞ 1`'in seed koşumu bu sayıları DEĞİŞTİREBİLİR** — temizlik ile seed'in sırasını
**sen belirle ve gerekçesini yaz** (T-047 tabanı tek bir **son** durum olmalı).

## `§X` · YAPILMAZ
```
PİN-5/6'nın e2e'ye taşınması        → qa-engineer (sonraki şerit)
getSummaryByFu rotası               → halka-3 brief'i (kova + hücre kararı)
M2 (fu_id NOT NULL, üç satır)       → data-engineer, bu şeritten SONRA
NotMatched reason üyeleri           → halka-3
```

## PİNLER
```
PİN 1  npm run seed exit 0 · her iki CSV'de red 0 · FU'suz bir test satırı ⇒ NO_VALID_ROWS/red
PİN 2  seed sonrası sales_actuals'ta fu_id DOLU (3/3 ya da ölçülen sayı) · tutar toplamları ÖNCE==SONRA
PİN 3  T-064: gerçek parti POSTED · date-string üç TZ'de birebir · entity tipi string
PİN 4  temizlik: her tablo için ÖNCE / SİLİNEN (id'leriyle) / SONRA
PİN 5  npm run guards exit 0 · tsc 0
```

## ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → boş
- Container'a **dokunma** · DDL **yazma** · `.env` **okuma** · **commit/push YAPMA**
- `git stash`/`git checkout`/`git reset` YASAK · `git add -A` YASAK · geri alma
  kopyala→uygula→kopyadan geri yükle→`shasum -a 256 -c`
- İzole `git worktree`'de doğrula; ama **DB tek** — oraya yazdığın her şeyi **bas**
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **dokunma**
- Exit kodunu boruya sokma · `grep -c` sıfırda exit 1 verir (`|| echo 0` YASAK)
- Tam e2e'yi **KOŞMA** · **`ölçemedim` meşru, `flaky` DEĞİL**
