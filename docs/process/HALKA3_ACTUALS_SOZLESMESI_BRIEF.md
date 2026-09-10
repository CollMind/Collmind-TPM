# `HALKA-3` İŞ 1 — **İKİ İNDİRİM BACAĞI BİRBİRİNİ TANIMIYOR**: türev mi, ölüm mü
### Şerit: `architect` (salt-okunur ölçüm + DB `SELECT`) · Hüküm: `Z111 §3` (`Z-K3` ⛔ ilk madde), ürün sahibi 2026-09-10

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.** Raporunda da etiket kullan,
> **araç notlarını yaz**, son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

> ### ⛔ BU TUR BİR **ÖLÇÜM** TURUDUR — KOD, MİGRATION, BELGE YAZILMAZ.
> Çıktı bir **hüküm önerisi + kanıtıdır**. *"Türev"* ya da *"ölüm"* **kararını ürün
> sahibi verir**; sen hangisinin **ölçümle ayakta kaldığını** gösterirsin.

---

## 0 · OKUMA SIRASI — ⛔ her yol 2026-09-10'da `ls`/`find`/`grep` çıktısında görüldü

```
1  docs/process/BRIEF_SABLONU.md
2  docs/brd-v2/04_KARAR_KAYDI.md  → Z111 (tamamı, özellikle §3 · §4 · §7)
                                    Z98 §0–§3 (halka-2 kapanışı: "match-ready, matched değil")
3  collmind.backend/src/database/entities/sales-actual.entity.ts
4  collmind.backend/src/database/entities/on-invoice-entry.entity.ts
5  collmind.backend/src/modules/modes/actuals-first/on-invoice/on-invoice.service.ts   :417-610
6  collmind.backend/src/modules/modes/actuals-first/sales-actuals/services/sales-actuals-validation.service.ts :420-505
7  collmind.backend/src/modules/shared/actuals-resolver/actuals-resolver.types.ts
8  docs/contracts/SYSTEM_INVARIANTS.md → INV-R-001 (:648) · INV-R-002 (:667)
9  collmind.backend/test/on-invoice-ledger-invariants.e2e-spec.ts
10 docs/brd-v2/03_IS_KURALLARI/L2_01_veri_butce_defter_hesaplama.md → K-2.1.8a1 (:140) · K-2.3.12 (:1006)
11 docs/brd-v2/03_IS_KURALLARI/L2_04_hakedis_ai_kurulum.md → K-2.13.14l (:364)
12 docs/DISIPLIN.md → "Bir TANIMIN evreni, tanımın ŞARTIYLA seçilemez"
                      "ENJEKSİYON kullanım değildir"
                      "YARGI SORUSUNA MEKANİK PROXY YAZILMAZ"
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | bu brief'te nerede |
|---|---|---|
| `Z111 §3` | `Z-K3` ⛔ ilk madde: on-invoice indirim **actuals satırıyla gelir**; ayrı bacak **türev ya da ölüm** | `§1` · `§3` |
| `Z111 §3` | `INV-R-001` / `INV-R-002` **taşınır** | `§3.4` |
| `Z111 §3` | on-invoice actuals'la **otomatik kapanır**, tolerans yok, fark = plansız on-invoice | `§3.3` |
| `Z111 §1` | `Z-K1` her indirim **bir anlaşmaya bağlı**, aksi anomali | `§3.2` |
| `Z111 §4` | `Z-K4` `NO_AGREEMENT` anomali | `§3.2` |
| `Z98 §3` | halka-2 **kapsamadı**: eşleştirme gövdesi · plan/anlaşma bağı · hakediş etkisi | `§5` |
| `Z91` | üretici yoksa üye yok | `§5` |
| `Z83` | ölçüm/kapı doğum kuralı: bilinen-yeşil **ve** bilinen-kırmızı | `§4` |
| `Z111 §8 F12-c` | `Z-K2` iade satırı red **mesajı** "bu sürümde kapsam dışı" — actuals-sözleşmesi maddesine | `§3.6` |
| `Z111 §8 F12-a` | `NO_EXPECTED` → halka-4; halka-3 **üç** üyeyle | `§9` · `§10` |
| `Z111 §9` | `Z-K6` plan iptali · AKTİF tanımı · onay-anı tekilliği | `§9` |
| `Z111 §8 F12-c` | `Z-K5` halka-4 kapanış/defter — **ölçülecek** | `§10` |
| `Z111 §10` | kayıt anında ölçülen öncüller (Ö1–Ö7) — **karar değil** | `§3.6` · `§9` · `§10` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — tek cümle

> ### Ürün **tek** bir indirim kaynağı istiyor (actuals satırı); kod **iki** kaynak
> ### taşıyor, ve ikisi **birbirini tanımıyor**.

```
[ÖLÇÜLDÜ: sales-actual.entity.ts:100-108]      actuals satırı discount_amount taşır (nullable)
[ÖLÇÜLDÜ: sales-actual.entity.ts:31-35]        JSDoc: "asla bütçeye/ledger'a/spend'e yazılmaz …
                                                on-invoice zaten kendi akışında ledger'a yazıyor,
                                                burada tekrar kullanılırsa ÇİFT SAYIM olur"
[ÖLÇÜLDÜ: on-invoice-entry.entity.ts:95-108]   ayrı bacak: discount + discount_type
[ÖLÇÜLDÜ: on-invoice.service.ts:556-597]       ayrı bacak DEFTERE yazar: spendType ON_INVOICE,
                                                amount = entry.discount, sourceType MANUAL
[ÖLÇÜLDÜ: grep -rn -i -E "on_invoice|onInvoice|on-invoice" src/modules/modes/actuals-first/sales-actuals | grep -v spec]
                                                → yalnız discount_* satırları, on-invoice referansı YOK
[ÖLÇÜLDÜ: grep -rn -i -E "sales_actual|salesActual|sales-actual" src/modules/modes/actuals-first/on-invoice | grep -v spec]
                                                → BOŞ
```
⇒ Bugün defteri besleyen **ayrı bacak**; `Z-K3` defteri besleyecek olanın **actuals** olmasını
istiyor. Aradaki mesafe **ölçülmedi** — bu turun işi o mesafe.

---

## 2 · EVREN — ⛔ ÖNCE ŞEKİLLER ADLANDIRILIR, SONRA HER BİRİ AYRI TARANIR

> ⚠️ **Sembol evreni ≠ yetenek evreni.** `onInvoice` kelimesi bu kod tabanında **iki ayrı
> şeyin** adı: (i) **ayrı yükleme bacağı** (`on_invoice_entries` ve akışı), (ii) **harcama
> tipi** `ON_INVOICE` (zarf bölünmesi, `K-2.3.12`, dashboard). **(ii) bu turun konusu DEĞİL**
> ve bacak ölse de yaşar. Bir frontend dosyasının `onInvoice` içermesi onu (i)'ye koymaz.
> ```
> [ÖLÇÜLDÜ: grep -rln -i -E "on-invoice|onInvoice" collmind.frontend/src | grep -v -E "\.test\.|\.spec\."]
>   → 25 dosya — ⛔ çoğu (ii) olabilir; SINIFLANDIRILMADI
> ```

### `2.1` · ŞEKİLLER
```
Ş1  YAZMA       on_invoice_entries / on_invoice_batches'e kim yazar (rota, servis, seed, test)
Ş2  DEFTER      bacaktan doğan ledger_entries (sourceType, idempotencyKey 'LEDGER|ON_INVOICE|…')
Ş3  OKUMA       on_invoice_entries'i kim okur — rapor, dashboard, finance-reporting, rota
Ş4  BAĞ         agreement_id · budget_envelope_id · batch · customer · sku FK'ları
Ş5  SÖZLEŞME    INV-R-001/002 ve e2e'leri; bacağa bağlı DİĞER invaryantlar (INV-R-* tam liste)
Ş6  YÜZEY       frontend yükleme sayfası, uçlar, tipler — yalnız (i) sınıfı
Ş7  VERİ        canlı satır sayıları: on_invoice_entries · batches · ledger (ON_INVOICE kaynaklı)
                · sales_actuals.discount_amount DOLU satır sayısı
```

### `2.2` · BAŞLANGIÇ LİSTESİ — ⛔ **DEVRALMA, YENİDEN ÜRET**
```
[ÖLÇÜLDÜ: grep -rln -E "OnInvoiceEntry|OnInvoiceBatch|on_invoice_entries|on_invoice_batches" collmind.backend/src | grep -v spec | grep -v migrations]
  12 dosya — ⚠️ aralarında baseline-volume-import-batch*.entity.ts ve
  off-invoice-file-parser.service.ts VAR: sembol eşleşmesi mi yetenek mi, SINIFLANDIR
[ÖLÇÜLDÜ: grep -rln -E "on_invoice|on-invoice|OnInvoice" collmind.backend/test]   13 dosya
[ÖLÇÜLDÜ: grep -rln -E "on_invoice_entries|on_invoice_batches" src/database/migrations | wc -l]  8
[ÖLÇÜLMEDİ — ölçülecek: Ş3 OKUMA]  finance-reporting / dashboard / spend-calculation içinde
  on_invoice_entries'e HAM SQL ile giden sorgu var mı — ⛔ entity adıyla grep HAM SQL'İ KAÇIRIR,
  tablo adıyla da ara ("soru TABLO'ysa, terim de TABLO olmalı")
```

### `2.3` · Ş7 VERİ — ⭐ ÖLÇÜLDÜ 2026-09-10 (Team Lead, brief yazımı sırasında)
```
[ÖLÇÜLDÜ: SELECT count(*) FROM main.on_invoice_entries]                       → 0
[ÖLÇÜLDÜ: SELECT status,count(*) FROM main.on_invoice_batches GROUP BY 1]      → satır yok
[ÖLÇÜLDÜ: SELECT count(*) FROM main.ledger_entries
          WHERE idempotency_key LIKE 'LEDGER|ON_INVOICE|%']                    → 0
[ÖLÇÜLDÜ: SELECT count(*),count(discount_amount),sum(discount_amount),
                 count(sku_id),count(invoice_no) FROM main.sales_actuals]      → 3 · 3 · 65000.00 · 0 · 0
[ÖLÇÜLDÜ: SELECT status,count(*) FROM main.sales_actual_batches GROUP BY 1]    → ACTIVE 3
```
> ### ⛔ AYRI BACAĞIN CANLI VERİSİ **SIFIR** — bu iki şeyi söyler, üçüncüsünü **söylemez**:
> ```
> ✅ söyler     ölüm senaryosunda VERİ GÖÇÜ yok
> ✅ söyler     INV-R-001/002'nin TEK kanıtı e2e'dir (üret → ölç → sil) — DB'de iz yok
> ⛔ SÖYLEMEZ   "tüketicisi yok" — 0 satır bir ÇAĞRI YOLU yokluğu değildir.
>              Ş1/Ş3/Ş6 kodla ölçülür (DISIPLIN: "verinin yokluğu örter")
> ```
> ⚠️ Ve actuals tarafı: indirim **dolu** geliyor (3/3), ama `sku_id` ve `invoice_no` **0/3** —
> `§3.1`'in grain sorusunun **canlı** hâli.

⚠️ **Ş7'yi yeniden koş** — bu sayılar brief anının fotoğrafı; tur başladığında veri değişmiş olabilir.

---

## 3 · İŞ — `Z111 §3` ⛔ ilk madde

### `3.1` · ALAN-ALAN TÜRETİLEBİLİRLİK TABLOSU
Ayrı bacağın **her** alanı için bir satır. ⛔ **Yalnız bir TÜKETİCİSİ olan alan** sayılır —
tüketicisi yoksa satıra *"tüketici yok"* yaz ve **kanıtını** ver (Ş3 çıktısı).

```
alan               tüketici (dosya:satır)     actuals'tan türetilebilir mi   nasıl / neden değil
discount           on-invoice.service.ts:561  ?                              discount_amount grain'i?
discount_type      ?                          ?                              actuals'ta YOK [ÖLÇÜLDÜ: sales-actual.entity.ts]
agreement_id       ?                          ?                              actuals'ta YOK [ÖLÇÜLDÜ: sales-actual.entity.ts:31]
invoice_no/date    ?                          ?                              actuals invoice_no OPSİYONEL [ÖLÇÜLDÜ: :138-139]
customer / sku     ?                          ?                              actuals grain CPL × kategori × kanal × dönem, sku_id nullable
quantity/list/actual_price ?                  ?
status / validation_errors  INV-R-001        ?
```
⛔ **"Türetilebilir" iki şart ister:** (a) **belirsizsiz** — tek bir kaynak alan ya da master
veriden tek bir yol; (b) **grain korunur** — `actuals-resolver.types.ts:14-23` agregasyon
yönü: **alt → üst toplanır, üst → alt DAĞITILMAZ** (`§2.5`). Actuals `CPL × kategori × kanal ×
dönem` ise ve tüketici SKU-satırı istiyorsa, bu **türev değildir** — dağıtımdır.
⚠️ Ve `K-2.1.8a1` [ÖLÇÜLDÜ: L2_01:140] tersini yasaklıyor: fatura-içi kayıt **dağıtım tabanı
olamaz**. İki yönü de tabloya işle.

### `3.2` · ANLAŞMA BAĞI — `Z-K1` + `Z-K4 NO_AGREEMENT`
```
[ÖLÇÜLDÜ: grep -rn "agreementId\|agreement_id" collmind.backend/src/modules/modes/actuals-first/on-invoice → BOŞ]
[ÖLÇÜLDÜ: grep -rc "budgetEnvelopeId" …/on-invoice/on-invoice.service.ts → 2]   (pozitif kontrol: desen bu dosyada ÇALIŞIYOR)
  ⇒ K-2.13.14l'nin açtığı kolonun on-invoice modülünde YAZARI YOK
[ÖLÇÜLMEDİ — ölçülecek: tüm src/ + test/ + seeds + HAM SQL'de agreement_id yazarı]
[ÖLÇÜLDÜ: SELECT status,count(*),count(agreement_id) FROM main.on_invoice_entries GROUP BY 1 → satır yok]
  ⛔ tablo BOŞ ⇒ "agreement_id dolu 0" BOŞ KÜMEDE SAĞLANIR — yazar yokluğunun kanıtı DEĞİL.
     Yazar sorusu yalnız KODLA cevaplanır.
```
Soru: `Z-K1` *"her indirim bir anlaşmaya bağlı"* — **bağı kim kurar**, hangi alanlardan
(CPL · FU · dönem · taktik/discount_type)? Bir actuals satırı bu bağı kurmaya **yetecek
alanı taşıyor mu**? ⛔ Taşımıyorsa bu **türevi öldürmez** ama **sözleşmeyi genişletir** —
o bir **ürün kararıdır** ⇒ `§5` DUR.

### `3.3` · OTOMATİK KAPANIŞ ŞARTI — `Z-K3`
*"On-invoice actuals'la otomatik kapanır, tolerans yok, fark = plansız on-invoice."*
⇒ Kapanış iki şeyi karşılaştırır: **beklenen** (HALKA-4) ve **gerçekleşen**. Gerçekleşenin
kaynağı hangisi olursa olsun, **kapanış grain'i** (`CPL × kategori × FU × dönem`, `Z111 §3`)
o kaynakta **toplanabilir** olmalı. Her iki bacak için ölç: bu grain'e **alt → üst** toplanıyor mu?

### `3.4` · `INV-R-001` / `INV-R-002` — **TAŞINIR**, ölmez
```
[ÖLÇÜLDÜ: SYSTEM_INVARIANTS.md:648]  INV-R-001  COMPLETED partide her satır POSTED+DEBIT ya ERROR+validation_errors
[ÖLÇÜLDÜ: SYSTEM_INVARIANTS.md:667]  INV-R-002  Σ DEBIT == Σ POSTED discount
[ÖLÇÜLDÜ: test/on-invoice-ledger-invariants.e2e-spec.ts:84,211]  e2e kanıtı
```
Her senaryo için yaz: invaryantın **yeni metni** ne olur, **hangi tablo** üzerinde, ve
**bugünkü e2e'nin hangi assertion'ı** onu taşımaya devam eder. ⛔ *"Aynen kalır"* bir
iddiadır: `on_invoice_entries` ölürse o tablo üzerindeki her assertion **ölü** demektir.

### `3.5` · SENARYOLAR — ⛔ İKİ DEĞİL, ÜÇ SONUÇ MEŞRU
```
TÜREV    ayrı bacak kalır ama actuals'tan ÜRETİLİR (yükleme ucu ölür, tablo türev olur)
ÖLÜM     ayrı bacak tümüyle kalkar; defter/rapor/invaryant tüketicileri actuals'a bağlanır
ÖLÇEMEDİM / İKİSİ DE DEĞİL   bir tüketici alanı actuals'tan türetilemiyor ve öldürülemiyor
         ⇒ DUR, alanı ADIYLA getir. Sözleşmeyi GENİŞLETMEK (actuals'a alan eklemek) SENİN
           önerin olabilir, SENİN kararın DEĞİL.
```
Her senaryo için: **kırılan tüketici listesi** (dosya:satır, SAYI DEĞİL LİSTE) · **veri göçü
gerekir mi** (Ş7) · **çift sayım riski** (`sales-actual.entity.ts:31-35`'in uyarısı bu
senaryoda ne olur).

### `3.6` · `Z-K2` — İADE SATIRI AÇIK RED (`Z111 §8 F12-c`) — ⛔ bu turda ÖLÇÜM, değişiklik DEĞİL
~~Hüküm: iade satırı **açık red**, mesaj *"bu sürümde kapsam dışı"* — **mevcut red-kodu, yalnız mesaj**.~~
⭐ **`F12` (`Z111 §11 Ö1`, hükmü DEĞİŞTİRDİ):**
```
gross < 0   → YENİ red-kodu NEGATIVE_AMOUNT (üreticisiyle) — "iade satırı — bu sürümde kapsam dışı"
okunamadı   → INVALID_GROSS_AMOUNT YALNIZ "okunamadı"
gross = 0   → ÖLÇ: veride var mı? Z77-tersi — GERÇEK SIFIR REDDEDİLMEZ (sıfır-satış ayı meşru olabilir)
              ⇒ bugünkü `grossAmount <= 0` (validation.service.ts:400) sıfırı da reddediyor —
                bu bir BULGU mu, meşru mu: iki taraflı fixture karar verir, TERCİH değil
```
⭐ **gross = 0 ÖLÇÜTÜ — önceden yazılı (ürün sahibi, 2026-09-10, `Z111 §11 Ö1` notu):**
```
Z77-tersi: "0 VERİDE VARSA, reddetmek MEŞRU SIFIRI yok eder."
İLK SORU   canlı + seed actuals'ta gross_amount = 0 satırı VAR MI
  VARSA    <= 0 reddi meşru sıfırı yok ediyor ⇒ bulgu, hüküm ölçümden sonra
  YOKSA    "kusur mu meşru mu" BUGÜN CEVAPSIZ ⇒ <= 0 reddi KORUMACI VARSAYIMLA DURUR
           (yanlışsa FAZLADAN RED — sessiz kabul DEĞİL); hüküm ölçümden sonra
```
[ÖLÇÜLMEDİ — ölçülecek: SELECT count(*) FILTER (WHERE gross_amount = 0) FROM main.sales_actuals
 + seed dosyalarında gross_amount 0 üreten satır — şerit ölçüyor]

⚠️ **Bu `F12` şerit başladıktan SONRA geldi** — şerit eski metinle ölçüyor. Ölçümün kendisi
(`1`–`3` aşağıda) değişmedi; **yorumu** Team Lead bu `F12`'ye göre yapar.
⚠️ **Hükmün öncülü ölçümle uyuşmuyor** (`Z111 §10 Ö1`) — sen **yeniden ölç**, devralma:
```
[ÖLÇÜLDÜ: grep -rn NEGATIVE_VOLUME collmind.backend/src]      → YALNIZ baseline-volume modülü
[ÖLÇÜLDÜ: sales-actuals-validation.service.ts:76-90]           actuals red kodları 14 üye — NEGATIVE_VOLUME YOK
[ÖLÇÜLDÜ: grep -rn -i volume src/modules/modes/actuals-first/sales-actuals | grep -v spec]
                                                                → yalnız yorum ⇒ actuals yüklemesi HACMİ OKUMUYOR
[ÖLÇÜLDÜ: sales-actuals-validation.service.ts:128,400]         tutar <= 0 → INVALID_GROSS_AMOUNT
                                                                mesaj "gross_amount okunamadı ya da <= 0"
```
Ölç ve raporla:
```
1  bir iade satırı actuals CSV'sinde BUGÜN hangi şekillerde gelebilir (negatif gross ·
   negatif net · negatif discount · negatif volume) — her şekil için HANGİ kod reddediyor,
   ya da HİÇBİRİ mi (sessiz kabul = §2.5 ihlali, ayrı bulgu)
2  "mevcut red-kodu" hangisi olmalı — INVALID_GROSS_AMOUNT "okunamadı" ile "iade" yı
   AYNI kodda birleştiriyor ⇒ mesaj değişikliği okunamayan hücreyi de "kapsam dışı" diye
   yanlış teşhis eder mi? İKİ tarafta FARKLI değer taşıyan fixture ile göster (§2.7 #6)
3  ⛔ KOD DEĞİŞTİRME — öneri + kanıt; mesaj/kod kararı ürün sahibinin
```

---

## 4 · KAPANIŞIN KANITI — `Z83`

Bu bir ölçüm turu, kapı doğmuyor. Ama **her negatif sonuç pozitif kontrollüdür**:
```
"X'in tüketicisi yok"   ⇒ aynı komutun BİLİNEN bir tüketiciyi bulduğunu göster (bilinen-yeşil)
"türetilemez"           ⇒ türetmeyi DENEYEN sorguyu ve BOŞ/ÇELİŞKİLİ sonucunu yapıştır
"ayırt edilemez"        ⇒ iki tarafta FARKLI değer taşıyan fixture — yoksa ÖLÇEMEDİM
```
⛔ **Yargı sorusuna mekanik proxy yazılmaz** (`DISIPLIN` F00): *"grep 0 döndü ⇒ ölü"* bir
proxy'dir. Ölüm iddiası **çağrı yolu** ister: rota → servis → tablo.

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ KOD · MİGRATION · SEED · TEST YAZMA — bu tur salt-okunur
⛔ DB'ye yalnız SELECT, ve HER sorgu şema-nitelendirilmiş (main.) — TTM public aynı instance'ta
⛔ docs/brd-v2/** YAZMA · yeni task AÇMA · commit/push YOK
⛔ git checkout YASAK (ihtiyaç doğmamalı — doğarsa zaten sınırı aşmışsın)
⛔ "türev/ölüm" KARARI verme — öner, kanıtla
⛔ actuals sözleşmesini GENİŞLETMEK (alan eklemek) bir ÜRÜN KARARIDIR ⇒ DUR, öneri olarak getir
⛔ İŞ 2–4'e (resolver gövdesi · NotMatched üyeleri · plan-tekilliği kısıtı) GİRME — ayrı brief'ler
⛔ NotMatchedReason'a üye EKLEME. actuals-resolver.types.ts:74-75'teki "beklenen ilk küme
   NOT_AGGREGATABLE · GRAIN_MISMATCH" yorumu Z111 §4 ile BAYATLADI (Z-K4'te NOT_AGGREGATABLE YOK)
   — bir İDDİA olarak oku, kural olarak değil
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm"  (hayalet proje → DUR, bildir)
   ⚠️ [ÖLÇÜLDÜ: docker ps --filter "label=com.docker.compose.project=tpm", Docker açıldıktan hemen sonra, 2026-09-10]
      Docker Desktop açılınca hayalet collmind-tpm-frontend/-backend
      KENDİLİĞİNDEN KALKTI — "Docker'ı ben açtım, hayalet yoktu" varsayımı YANLIŞ olur.
      Docker'ın her açılışından SONRA filtreyi yeniden koş; çıkan her şeyi durdur.
   ⚠️ collmind-tpm-postgres Docker'la birlikte KALKMADI (durmuş hâlde bulundu) —
      DB ölçümü öncesi `docker start collmind-tpm-postgres` + `pg_isready`
```

### `5.1` · ⚠️ ARAÇ NOTLARI — bu brief yazılırken ölçüldü
```
grep bu makinede ugrep'e bağlı: karmaşık -E alternasyonları "exceeds complexity limits"
  ile REDDEDİLİR ⇒ SONUÇ DEĞİL ARAÇ HATASI. Basit desenler ya da `grep -F` döngüsü kullan.
rg xargs altında BULUNAMADI ("xargs: rg: No such file or directory") ⇒ boru içinde rg kullanma.
grep -rc 'x' test/*.ts YASAK — glob özyinelemesiz (BRIEF_SABLONU §2.1)
exit kodunu boruya sokma (CLAUDE.md §2.6)
```

---

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
YOK — salt-okunur tur.
Tek çıktı: şerit raporu (Team Lead'e). Belgeye Team Lead işler.
```

## 7 · E2E KATMANI
```
Koşulmaz — kod değişmiyor.
⚠️ INV-R-001/002 e2e'sinin BUGÜNKÜ hâlini okumak §3.4 için ZORUNLU; koşmak değil.
```

---

## 8 · KAPANIŞ ÇIKTISI

```
1  EVREN          — Ş1..Ş7 her biri AYRI; (i) bacak ↔ (ii) harcama tipi sınıflandırması
                     (frontend 25 dosya + backend 12 dosya — HER BİRİ bir sınıfta, LİSTE)
2  TÜRETİLEBİLİRLİK TABLOSU — §3.1, her alan: tüketici · türev mi · kanıt
3  ANLAŞMA BAĞI   — §3.2, agreement_id yazar evreni + DB dolu-oranı
4  KAPANIŞ GRAIN'İ — §3.3, iki bacak için alt→üst toplanabilirlik
5  INV-R-001/002  — §3.4, her senaryoda yeni metin + yaşayan assertion
6  ÜÇ SENARYO     — §3.5, kırılan tüketici LİSTESİ · göç · çift sayım
7  İADE SATIRI    — §3.6, her iade şekli → hangi red kodu (ya da sessiz kabul) · mesaj
                     değişikliğinin "okunamadı" teşhisini bozup bozmadığı (iki taraflı fixture)
8  ÖNERİ          — hangisi ölçümle ayakta kaldı, ve ürün sahibinden hangi KARAR gerekiyor
9  ÜÇ METRİK      — tur süresi (duvar saati) · review-tur · DUR sayısı
10 ⛔ NE ÖLÇEMEDİN — "ölçemedim" MEŞRU bir çıktıdır
```

---

## 9 · HALKA-3'ÜN KALANI — ⛔ BU BRIEF'İN İŞİ DEĞİL, SIRA KAYDI

```
İŞ 2  grain-resolver gövdesi          ⇐ İŞ 1'in hükmüne bağlı (resolver hangi satırı okur)
İŞ 3  NotMatched ÜÇ üye + üreticileri — NO_PLAN · NO_AGREEMENT · GRAIN_MISMATCH (Z-K4)
      ⭐ Z111 §8 F12-a: NO_EXPECTED HALKA-4'te doğar (fatura→beklenen eşleştirmesi, Z91)
      ⛔ actuals-resolver.types.ts:74-75 NOT_AGGREGATABLE yorumu bu işte Z-K4'e hizalanır
İŞ 4a PlanStatus.CANCELLED + ÜRETİCİSİ (Z111 §9 Z-K6 · §11 Ö5) — APPROVED→CANCELLED,
      rol ADMIN + PLANNER (~~Planner/CM~~ — CM ÇIKTI: iptal plan-sahibinin; "onayı geri çekme"
      ayrı ve bugün yok), gerekçe ZORUNLU, audit, rezerv RELEASE
      ⭐ EMSAL DE HİZALANIR: agreement cancel `reason?` → ZORUNLU — iki nesne aynı cevap
        [ÖLÇÜLMEDİ — ölçülecek: POST /agreements/:id/cancel'in ÇAĞIRAN LİSTESİ — frontend,
         e2e, seed; gerekçesiz çağıran varsa zorunluya çekmek onu KIRAR ⇒ liste ÖNCE]
      ⭐ MIGRATION NUMARASI TAHSİS EDİLDİ: 1834000000000 (.claude/backlog/MIGRATION_SEQUENCE.md)
        ⛔ yalnız data-engineer yazar · enum ADD VALUE geri alınabilirliği ÖLÇÜLMEDEN şablon yok
        ⚠️ ürün sahibi notu (2026-09-10) [REVIEW İDDİASI — DOĞRULANMADI]: Postgres'te enum DROP VALUE
          yok ⇒ down() CANCELLED'ı silemez ⇒ harness'ın dört-durum assert'i TASARIM GEREĞİ çarpar
          ("silen-migration'ın tersi: geri alınamayan EKLEME"). Aday çözümler: harness'ta 5. durum
          `irreversible-add` · ya da statü enum'u TABLO-TABANLI (Faz-3). ŞİMDİ KARAR YOK — İŞ-4a'da ölçülür
İŞ 4b plan-tekilliği (Z-K1 · Z-K6 · §11 Ö3) — ONAY-ANI kontrolü, AÇIK RED; DRAFT/PENDING'de UYARI, bloklamaz
      AKTİF = APPROVED ∧ ¬CANCELLED ∧ dönem-aralığı içinde · iptal grain'i serbest bırakır
      PENDING = PENDING_APPROVAL ∧ PENDING_FINANCE_REVIEW — UYARI ikisinde;
      KISIT ikisinden APPROVED'a GEÇİŞTE
      ⚠️ EXPIRED = onay zaman-aşımı (K-2.5.10b), dönem-bitişi DEĞİL — AKTİF hesabına girmez (§11 Ö2)
      "uyar, durdurma" deseni K-2.2.7c'nin EMSALİ, kuralın kendisi değil (§11 Ö6)
      [ÖLÇÜLMEDİ — ölçülecek: onay-anı kontrolü tek başına mı, yoksa DB tarafında da bir
       kısıt/trigger mı — yarış (iki eşzamanlı onay) ölçülerek seçilir, TERCİHLE değil]
      [ÖLÇÜLDÜ: plan.entity.ts:36,301] tekillik yalnız (tenant,planCode) ve (plan,fu)
      [ÖLÇÜLDÜ: pg_constraint u/x/c + pg_indexes UNIQUE + pg_trigger, main.plans/plan_fus/plan_skus]
        → yalnız UNIQUE INDEX (tenant_id,plan_code) · (plan_id,fu_id) · (plan_fu_id,sku_id);
          kısıt 0 · trigger 0   ⇒ entity ile katalog UYUMLU
      [ÖLÇÜLDÜ: plans×plan_fus self-join, aynı tenant+CPL+FU, daterange(start_date,end_date,'[]') &&]
        → çakışan çift 0 · pozitif kontrol (self-pair dahil) 2 · plans: APPROVED 1, PENDING_APPROVAL 1
        ⇒ kısıtın önünde bugün VERİ KİLİDİ YOK
        ~~⛔ "aktif plan" TANIMI (hangi status'ler) Z-K1'de YAZILI DEĞİL ⇒ İŞ 4 brief'inden ÖNCE ürün sahibine~~
        ⭐ F12 — TANIMLANDI: Z111 §9 Z-K6 (AKTİF = APPROVED ∧ ¬CANCELLED ∧ dönem-aralığı içinde)
      [ÖLÇÜLDÜ: 1831000000000-BudgetEnvelopePeriodRange.ts:76] btree_gist KURULU DEĞİL —
      aralık-kesişme emsali TRIGGER ile çözülmüştü
```

---

## 10 · HALKA-4'E DEVREDİLENLER — ⛔ SIRA KAYDI, halka-4 brief'inin GİRDİSİ

```
NO_EXPECTED     fatura → beklenen eşleştirmesinin üyesi; üreticisi beklenen-hesap (Z111 §8 F12-a)
Z-K5            kapanış/defter maddesinin TANIMI (Z111 §8 F12-c) — hüküm ÖLÇÜMDEN SONRA kesinleşir
  [ÖLÇÜLMEDİ — ölçülecek: bugünkü v_budget_summary formülü ↔ Z-K5, FARK LİSTE olarak;
   ve "planlı tüketim rezervden düşer" geçişi bugün nasıl işliyor (RESERVE/COMMIT → CONSUME)]
  Başlangıç girdisi (Z111 §10 Ö7, ölçüldü):
    bugün   available = allocated − (RESERVE+COMMIT−RELEASE) − Σ ledger(DEBIT−CREDIT) TÜMÜ
    Z-K5    available = allocated − reserved − consumed_plansız
    CONSUME enum'da VAR, satırı 0 · ledger_entries'te plan_id YOK · budget_envelopes.consumed_amount 0/10
  ⛔ formülde çelişki çıkarsa ⇒ ürün sahibine, şerit KARAR VERMEZ

⭐ F12 (Z111 §11 Ö7) — Z-K5 formülü TANIMDIR; uygulaması ÜÇ PARÇA:
  (i)   defter satırına plan_id   — tanım → yazar → kısıt (Z98 §3 sırası)
        "plansız" ancak böyle ayırt edilir [ÖLÇÜLDÜ: information_schema.columns main.ledger_entries → plan_id YOK]
  (ii)  CONSUME üreticisi         — enum var, satır yok (Z91)
        [ÖLÇÜLDÜ: pg_enum budget_transactions_tx_type_enum → CONSUME var · tx_type dağılımı → CONSUME 0]
  (iii) v_budget_summary → Z-K5   — çift-düşüm şüphesi: planlı tüketim rezervden düşülmüyorsa İKİ KEZ
        [ÖLÇÜLMEDİ — ölçülecek: halka-4; hüküm ölçümden SONRA]
⚠️ atıf düzeltmeleri (§11 Ö7): "RESERVE→CONSUME hiç yazılmıyordu" Z96'da YOK · consumed_amount
   T-351'e ÜYE olarak girdi (T-351.md EK 3, 10/10 zarf sıfır)
```

---

## 11 · `F12` — ŞERİDİN BULDUĞU ÜÇ BRIEF KUSURU (Team Lead, 2026-09-10, bağımsız doğrulandı)

Kusurlu metin **silinmedi**; bir sonraki brief bu listeyi okur.
```
B1  §3.1 "customer / sku … actuals grain CPL × kategori × kanal × dönem, sku_id nullable"
    ETİKETSİZ ve EKSİK: sales_actuals.fu_id NOT NULL (M2 · 1825)
    [ÖLÇÜLDÜ: sales-actual.entity.ts:118-125 · information_schema.columns main.sales_actuals]
    ⇒ şerit DUR yerine devam etti, sapmayı KAYDETTİ — satır bir soru-şablonuydu, §0 okuması düzeltiyordu
B2  §2.2 "12 dosya" listesi EKSİK: on-invoice.controller.ts · on-invoice-validation.service.ts
    (+ app.module.ts · capabilities.ts). Desen ENTITY/TABLO adı arıyordu; bu dosyalar
    OnInvoiceService / OnInvoiceDiscountType kullanıyor
    ⇒ DISIPLIN: "sembol evreni ≠ yetenek evreni" — brief'i YAZAN turda, UYARIYI YAZDIĞIM SATIRIN altında
B3  §3.4 yalnız INV-R-001/002 sayıyordu; bacağa bağlı DİĞERLERİ: INV-R-005 · INV-R-007 ·
    INV-B-003 · INV-B-005 · INV-B-006 · INV-L-006 kapsamı
    [ÖLÇÜLDÜ: grep -n "^### INV-R-" docs/contracts/SYSTEM_INVARIANTS.md · :725-730 INV-R-005]
```
📌 `B2` ve `B3` aynı şekil: **brief bir LİSTE verdi, EVRENİ tanımlamadı** — `BRIEF_SABLONU §3.4`.
