# `T-375` ADIM 1 — ZARF **KASKADI** + 13 KATEGORİ-KÖR ÇAĞRI YERİ

> Şerit: `backend-engineer` · Repo: `collmind.backend` · Migration **`1829000000000`** (tahsis edildi)
> ⛔ **ÖN ŞART: `ADIM 2` (seed) İNMİŞ OLMALI.** Sekiz kategori zarfı ve `agreements.category_id`
> backfill'i olmadan bu turun reprodüksiyonu kurulamaz.

## 0. KAYNAK — ve o kaynak BUGÜN YAZILDI

⛔ **Önce oku:** `docs/brd-v2/03_IS_KURALLARI/L2_01_veri_butce_defter_hesaplama.md`
→ **`K-2.2.1`** (revize, `F12`) · **`K-2.2.3`** · **`K-2.2.3a`** (kaskad) · **`K-2.2.3b`** (anlaşma=tek kategori)
ve karar kaydı **`Z102`** (`docs/brd-v2/04_KARAR_KAYDI.md`).

Bu tur o kuralların **uygulanmasıdır**. Kuralla kod çelişirse **kural kazanır**; kuralın
kendisi yanlış görünüyorsa **DUR** ve Team Lead'e bildir — `§2.1.2`: *"bağlayıcı kaynak bir
GİRDİ'dir, kanıt değil"* — ama sapma **sessizce** yapılmaz.

## 1. İŞ 1 — TEK KASKAD (`budget.repository.ts`)

`K-2.2.3a`:
```
1  kategori + dönem      HER ZAMAN, atlanamaz
2  kanal-ÖZEL zarf       varsa KAZANIR
3  kanal-GENEL zarf      (channel NULL) yalnız kanal-özel YOKSA
⛔ tie YOK · gizli tie-break YOK · hiçbiri yoksa → K-2.2.14
```

⛔ **İKİ metot var ve İKİSİ DE aynı kaskaddan geçer:**
`findEnvelopeByDimensions` **ve** `findEnvelopeByDimensionsStrict`. İkisine ayrı kaskad
yazmak **`K-2.2.3` ihlalidir** — kaskad **tek bir fonksiyonda** yaşar, ikisi onu çağırır.
(Emsal: `apply_primitive_filter` deseni, `§2.7 #8`'in düzeltme şekli.)

⛔ **`spendType` split-guard'ına DOKUNMA.** O mekanizma (`isSplitDimensionGuardError`,
`candidates`'ten türetilen split tespiti, *"tek türetim noktası"*) **çalışıyor** ve bu turun
kapsamı dışında. Sen **boyut yüklemlerini** ve **sıralamayı** değiştiriyorsun; split
türetimi aynı sonuç kümesinden türemeye **devam etmeli**.

⚠️ Bugünkü kanal yüklemi: `envelope.channel = :channel OR metadata->>'channel' = :channel`.
Yeni kanal-GENEL kademesi `envelope.channel IS NULL` **ve** `metadata->>'channel' IS NULL`
ister — ⛔ **metadata'da kanal taşıyan bir zarf GENEL DEĞİLDİR.** Bunu ölç ve koda yaz.

## 2. İŞ 2 — ÇAĞRI YERLERİ: **SAYI DEĞİL, LİSTE** (`§7.1`)

Team Lead'in ölçtüğü ham liste (üretim, yorum satırları hariç). ⛔ **YENİDEN ÖLÇ** — bu liste
2026-09-07'de alındı ve `ADIM 2` sonrası kaymış olabilir; ve Team Lead'in **önceki sayısı
("11") YANLIŞ ÇIKTI** (on birinci elle-sayı vakası).

```
plan.service.ts:1415                       kategori YOK
plan.service.ts:1502  / :1509              kategori undefined (ON/OFF tipli)
plan.service.ts:1701                       kategori YOK
plan.service.ts:1730  / :1737              kategori undefined (ON/OFF tipli)
agreement-transaction.controller.ts:191    kategori YOK      ⛔ FİNANSAL
agreement-transaction.service.ts:190       kategori YOK      ⛔ FİNANSAL
agreement-transaction.service.ts:212       kategori undefined ⛔ FİNANSAL
on-invoice.service.ts:532 / :544           kategori ✓ (T-373'te bağlandı)
on-invoice-validation.service.ts:608       ölç
budget.service.ts:467 / :474 (Strict)      ölç
budget.service.ts:495 / :601 / :865        ölç
budget.service.ts:1298                     cephe metodu (delegasyon)
budget.service.ts:1394 / :1401 / :1664     ölç
```

**Her satır için ÜÇ durumdan birine sınıfla ve GEREKÇESİNİ yaz:**
```
(a) kategori GEÇİYOR                       → dokunulmaz
(b) kategori VAR ama geçirilmiyor          → KUSUR, düzeltilir
(c) kategori MEŞRU BİÇİMDE yok             → gerekçesi KODA yazılır (yoruma), ve NEDEN
                                             meşru olduğu ölçümle desteklenir
```

⛔ **Kategori kaynakları ölçüldü — mevcut, uydurulmayacak:**
```
plan.categoryId          NOT NULL (kolon) · canlı 2/2 dolu
agreement.categoryId     ADIM 2 backfill'i sonrası 5/5 dolu
sku → genericUnit → category   on-invoice'un zaten kullandığı zincir
```

⛔ **`agreement-transaction` üç çağrı yeri FİNANSAL YAZMA YOLUDUR** ve bu turun **asıl
kalemidir** — `Z102 §3`: bu yol kategori-zorunlu grain altında `ADIM 2` olmadan **kapanırdı**.

## 3. İŞ 3 — YAZAR: ANLAŞMA KATEGORİSİ FORMDA ZORUNLU (`K-2.2.3b`)

`tanım → yazar → kısıt` (`Z98 §3`). `ADIM 2` **tanım+backfill**'i getirdi; sen **yazarı**
getiriyorsun: anlaşma oluşturma/güncelleme DTO'sunda `categoryId` **zorunlu alan**.
⛔ **`NOT NULL` migration'ı SEN YAZMAZSIN** — `1830000000000`, **sonraki tur**, yazar indikten
sonra. Numara tahsis edildi, **kullanma**.

**Çapraz doğrulama (`K-2.2.3b`):** işlem satırının FU'su anlaşmanın kategorisiyle uyuşmalı;
uyuşmazlık **açık red**. ⛔ **Emsali BUL VE KULLAN, ikinci kopya yazma:**
`sales-actuals-validation.service.ts`'in `FU_CATEGORY_MISMATCH` kodu ve şekli.

## 4. İŞ 4 — MIGRATION `1829000000000`

`budget_envelopes.category` → **`NOT NULL`**. ⛔ Yalnız `ADIM 2` sekiz zarfı ürettikten ve
eski dördü süperseded olduktan **sonra**; öncesinde migration **DURUR** (üç-durum assert).
`Z100` şablonunun altı maddesi bağlayıcı.

⚠️ **`category_id` (uuid FK) kolonu da var ve `ADIM 2` onu doldurdu.** İki temsil bir `F8`
riskidir. **Bu turda karar ver ve yaz:** hangisi tek doğruluk kaynağı? Çözümleyici bugün
`category` (varchar) okuyor. `category_id`'ye geçmek **her çağıranın id taşımasını** ister —
ölç, taşımıyorlarsa **bugün geçme** (`İlke 1`) ama **ayrımı koda yaz** ve bir task aç.

## 5. ⛔ PİNLER — REPRODÜKSİYON-ÖNCE, HER BİRİ AYIRT EDİCİ

```
P1  kategori-özel + kanal-geneli iki zarf   ⇒ kanal-ÖZEL kazanır
P2  yalnız kanal-geneli zarf                ⇒ O seçilir
P3  kategori eşleşmeyen                     ⇒ 0 zarf + AÇIK HATA (K-2.2.14)
P4  eski "yanlış zarf" davranışı            ⇒ MUTASYONLA KIRMIZI olmalı
P5  FU ↔ anlaşma kategorisi uyuşmazlığı     ⇒ açık red (K-2.2.3b)
```

⛔ **Her pin için:** düzeltmeden ÖNCE kusuru **GÖR**, sonra düzelt. `P4` için mutasyon:
dosyayı **kopyala** → mutasyonu uygula → **değiştirilen satırı `sed -n '<n>p'` ile BAS** →
ölç → kopyadan geri yükle → `shasum -a 256 -c` ile **doğrula**.
⛔ `git checkout` ile geri alma **YASAK** (`CLAUDE.md §3`).
⛔ Mutasyon kırmızısının **bir assertion** olduğunu doğrula — derleme hatası **başarısız bir
deneydir**, kanıt değil.

⛔ **`mode-split`:** `src/modules/modes/` altına **YENİ DOSYA** eklenemez. Yeni spec'ler
**mevcut kardeş dosyalara** yazılır. Ve `test/` altına konan yeni bir dosya `modes/`'a import
ederse **YENİ REFERANS** ihlali doğar (`Z102 §7` — ampirik olarak ölçüldü). Bu iki sınırı
**başlamadan önce oku**: `scripts/guards/mode-split.sh`.

## 6. ⛔ DUR LİSTESİ

- Migration `1826`/`1827`/`1828` **başka şeritlerin** — dokunma. `1830` **sonraki turun**.
- `docs/brd-v2/**` **YAZMA** — `L2`'yi yalnız Team Lead yazar (`CLAUDE.md §3`, tek yazar **ve**
  tek kanal). Kuralda eksik görürsen **bildir**, düzeltme.
- Seed dosyalarına dokunma (`ADIM 2`).
- `tenants` / tarih yardımcılarına dokunma (`ADIM 3`).
- Split-guard mekanizmasını **yeniden yazma**.
- `git commit` / `git push` **YAPMA**.
- Belirsizlikte **DUR** — bu projede *"en makul olanı seçtim"* defalarca pahalıya mal oldu.

## 7. DOĞRULAMA (borusuz: `cmd > log 2>&1; echo $?`)

- `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş** (İLK adım)
- `npx tsc --noEmit` 0 · `npm test` 0 · `npm run test:e2e` 0 · `npm run guards` 0
- `run → revert → run` bayt-birebir · üç-durum assert kanıtı
- ⛔ **Rapor: SAYI değil, LİSTE.** Her çağrı yeri, sınıfı ve gerekçesi. Mutasyon kanıtı
  (basılmış satır + assertion mesajı + geri yükleme shasum'ı).

---

# ⛔ EK — `ADIM 2` İNDİ (2026-09-07), VE ORTAM DEĞİŞTİ. BUNU OKUMADAN BAŞLAMA.

## E.1 · Canlı durum (Team Lead bağımsız doğruladı)

```
budget_envelopes  10 satır:  8 kategori zarfı ACTIVE (channel NULL · period 2026-04 · Σ 2.300.000)
                             ENV-2026-NKA-Q1 / Q2  CLOSED  (bağlıydı, SİLİNMEDİ)
                             ENV-2026-TRAD-Q1 / ECOM-Q1  silindi (bağsızdı, ölçüldü 0/0)
agreements.category_id  5/5 DOLU, FU zincirinden TÜRETİLDİ
user_scopes  8/8 kategori tam-1-CM
```

## E.2 · ⛔ e2e ŞU AN KIRMIZI — VE BU SENİN İŞİNİN TANIMI

`ADIM 2` sonrası `npm run test:e2e` **exit 1** (12/64 suite). Üç kök neden ölçüldü:

**`R1` — ANA KÜTLE, VE TAM OLARAK SENİN KALEMİN.** `budget.service.ts:495` · `:601` · `:865`
zarfı **kanal + dönem** ile arıyor, kategoriyi hiç geçirmiyor. `NKA` zarfları `CLOSED`
olunca üçü de fırlatıyor:
```
"No active budget envelope found for channel: NKA, period: 2026-02"
```
`test/helpers/seed-e2e.ts`'in `createAndApproveAgreement` fixture'ı **on suite**'e yayılıyor
(`settlement*`, `reversal`, `ledger-read-surface`, `plan-review-decision`,
`plan-escalate-to-finance`, `lta-parent-lifecycle-status-gate`, …).

⇒ **Kaskad indiğinde ve agreement yolu `agreement.categoryId`'yi geçirdiğinde bu suite'ler
KENDİLİĞİNDEN yeşile dönmeli** (`HAIR_CARE` / `CAT-KARMA-KOLI` zarfları ACTIVE ve dolu).
⛔ **Dönmezlerse bu bir BULGUDUR** — testi değiştirerek değil, **ölçerek** açıkla.

**`R2` ve `R3` — SANA AİT DEĞİL, DOKUNMA:**
```
R2  budget-variance.e2e-spec.ts   testin BAŞLIĞI eski dünyayı yazıyor:
    "seed envelope categoryId=NULL" varsayımı ⇒ CM artık kendi zarfını GÖRÜYOR
R3  role-journey.e2e-spec.ts (E bölümü) + kardeşleri
    eski CM ataması (category.manager→CAT-SAC-BOYASI) ürün-sahibi tablosuyla DEĞİŞTİ
```
⛔ Bunlar **eski modeli pinleyen testlerdir** ve düzeltmeleri **`qa` şeridinin** işidir
(`CLAUDE.md §3`: *bir ajan kendi yazdığı kodun testini yazmaz*). **Raporunda kalan kırmızıyı
LİSTE olarak ver**; testi sen düzeltme.

## E.3 · ⛔ VE ARA-KIRMIZI BU DALGANIN TASARIMIDIR

Ürün-sahibi hükmü: *"birleşme-anı: tam-e2e **TEK**"*. Yani `ADIM 2` ↔ `ADIM 1` arasında e2e
kırmızıdır ve bu **beklenen**dir. ⛔ Ama: kırmızıyken **hiçbir şey commit edilmez**, ve
*"e2e zaten kırmızıydı"* **hiçbir kırmızının mazereti değildir** — kendi getirdiğin her
kırmızıyı `R1/R2/R3`'ten **ayırt ederek** raporla.

## E.4 · `ADIM 2`'nin AÇIK BIRAKTIĞI, SANA YASAK İKİ KALEM

```
STA-2026-003 / STA-2026-004   adları "T-277 repro <epoch>" AMA ARTIK DEĞİL:
   canlı defter izinin TAMAMI bunlara bağlı (1 + 2 ledger_entry). SİLİNMEZ. Ayrı task.
cleanup-data.ts               main.ledger_entries HİÇ silmiyor ⇒ seed:cleanup-and-seed
   RESTRICT FK'ya çarpar. Bu turun kapsamı DEĞİL. Ayrı task.
```
