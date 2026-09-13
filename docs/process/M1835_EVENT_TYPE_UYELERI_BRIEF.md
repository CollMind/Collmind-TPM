# 1835 · `sales_actuals_event_type_enum`'a İKİ ÜYE — harness · pin · ratchet'in İLK GERÇEK MÜŞTERİSİ
### Şerit: `data-engineer` · Task: `T-400` · Hüküm: `Z111 §13` (+ `§13.2 N2` F12) · `§24` · `§26`–`§34` (ürün sahibi çerçevesi, 2026-09-13)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`. **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.**
> Raporda da etiket kullan; son madde her zaman **"⛔ NE ÖLÇEMEDİN"**. Koşum biçimi **§2.6** (her çağrı `</dev/null`, log dosyasına, exit ayrı).

---

## 0 · OKUMA SIRASI — ⛔ her yol 2026-09-13'te `ls`/`grep`/`Read` ile görüldü
```
1  docs/process/BRIEF_SABLONU.md                      (§2.3 exit kodu · §2.6 koşum biçimi)
2  docs/brd-v2/04_KARAR_KAYDI.md → Z111 §13 (enum hükmü, :11619 civarı) · §24 (beyan/veri-kolu) · §31–§34 (pin · ratchet · işletme)
3  .claude/backlog/MIGRATION_SEQUENCE.md → 1835 satırı (F12'ler: "YALNIZ ENUM ÜYELERİ", "harness'ın ilk gerçek müşterisi", T-391 ilk şüpheli)
4  docs/process/HALKA3_IS2_ACTUALS_OLAY_MODELI_BRIEF.md §0.0 (ENUM satırı: down = tipi yeniden yarat · ekleme ile kullanım AYRI dosya)
5  collmind.backend/src/database/migrations/1824000000000-AddSalesActualsGrainAnchors.ts   ← tipi YARATAN migration (tek üye, gerekçesi)
6  collmind.backend/src/database/migrations/1816000000000-AddBudgetFinanceReviewNotificationTypeAndEnvelopeTier.ts
                                                       ← ENUM YENİDEN YARATMA EMSALİ (down: etiket evreni ölçümü + kullanım sayısı → İPTAL)
7  collmind.backend/scripts/migration-verify.sh        ← başlık: BEYAN SÖZLEŞMESİ · KAPSAM/SINIR · K8 pin (yalnız OKU, yalnız ÇAĞIR)
8  docs/DISIPLIN.md → F04 (kapı yazılmış ≠ işliyor · gözlenen ≠ beklenen) · F12 (koşum </dev/null · $( ) hata-çıkışı) · F15 (geri alma snapshot'tan)
```

## 0.1 · HÜKÜM-ATIF TABLOSU
| Z-no | madde | bu brief'te |
|---|---|---|
| `Z111 §13` + `§13.2 N2` | 1835 **YALNIZ** enum üyeleri (`ON_INVOICE_DISCOUNT` · `FREE_GOODS`); aynı dosyada kullanım YOK; **down() = tipi YENİDEN YARATMAK** | §3.1 |
| `Z111 §13` (Postgres ölçümü) | yeni enum değeri **aynı transaction'da kullanılamaz** — ekleme 1835, kullanım 1838; sıra kilitli | §5 |
| `Z111 §32` | beyan bir **istisna** mekanizmasıdır; tam geri-alınabilir, up etkili migration **beyansız** doğar | §3.2 |
| `Z111 §31` · `§33` | pin (4 imza) ve ratchet (baseline = gerçek beyanlı sayı) işletmede — 1835 ikisinin de ilk gerçek müşterisi | §4 |
| `Z111 §28` · `§28.1 N36` | beklenmedik sonuçta **ilk şüpheli T-391** (rc'si okunmayan yardımcı — iki yönlü) | §4 |
| `CLAUDE.md §2.5` · 1816 emsali | down'da **sessiz kayıp yok**: yeni değeri taşıyan satır ya da beklenmeyen etiket → açık hata, İPTAL | §3.1 |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — tek cümle
> ### Actuals olay modelinin iki yeni olay türü (`ON_INVOICE_DISCOUNT` · `FREE_GOODS`) DB tipinde yok; 1838'in onları kullanabilmesi için
> ### önce **ayrı bir migration'da, tam geri-alınabilir** biçimde eklenmeleri gerekiyor.

```
[ÖLÇÜLDÜ: psql pg_enum, main]  sales_actuals_event_type_enum = { SALE }  — TEK üye
[ÖLÇÜLDÜ: information_schema.columns]  tek kullanıcı: sales_actuals.event_type · nullable YES · default YOK
[ÖLÇÜLDÜ: pg_depend]  tipe bağımlı: array tipi (pg_type, i) + sales_actuals kolonu (pg_class, n) — view/fonksiyon/index/kısıt YOK
[ÖLÇÜLDÜ: SELECT event_type, count(*)]  sales_actuals 3 satır · event_type HEPSİ NULL
[ÖLÇÜLDÜ: grep src/database/entities · src/modules]  event_type'ın ENTITY eşlemesi YOK — yalnız actuals-resolver.types.ts'te bir YORUM
                                                     ⇒ bugün bu kolona yazan/okuyan TS kodu YOK ⇒ 1835 entity değişikliği GEREKTİRMEZ
[ÖLÇÜLDÜ: ls migrations]  1834 ve 1835 dosyası YOK · DB HEAD = EnforceAgreementCategoryIdNotNull1833000000000
```

---

## 2 · EVREN
```
Ş1  TİP          main.sales_actuals_event_type_enum — etiketler: SALE (+ ON_INVOICE_DISCOUNT · FREE_GOODS)
Ş2  KULLANICI    main.sales_actuals.event_type (tek) — ölçülen evren; YENİ kullanıcı çıkarsa down'ın ALTER COLUMN listesi DEĞİŞİR ⇒ down
                 kullanıcıları ELLE yazmaz, katalogdan ölçer ya da ölçüp beklenenle karşılaştırır (1816 emsali · "elle yazılmış üye sayısı")
Ş3  VERİ         event_type değeri yeni etiketlerden birini taşıyan satır — bugün 0, üretici YOK (entity eşlemesi yok)
⚠️  AD ÇAKIŞMASI  `ON_INVOICE_DISCOUNT` adı kodda BAŞKA bir enum'da da var: MechanicCategory.ON_INVOICE_DISCOUNT = 'on_invoice_discount'
                 (küçük harf) [ÖLÇÜLDÜ: src/database/entities/mechanic.entity.ts:27] — DB olay tipi etiketi BÜYÜK harf (SALE ile aynı biçim,
                 Z111 §13) ⇒ iki ayrı kavram, AYNI ad (DISIPLIN F06 "ad ≠ mekanizma"); migration yorumunda ADIYLA ayrılır
```

---

## 3 · İŞ

### `3.1` · MIGRATION — `1835000000000-<ad>.ts` (numara Team Lead tahsisi: MIGRATION_SEQUENCE 1835)
```
up()    ⭐ F12 (Z111 §35.1 N50 — Team Lead'in brief hatası düzeltildi): MIGRATION_SEQUENCE "KABUL KRİTERİ" §1 — up() ÜÇ durumu ayırt eder:
        etiket kümesi ÖLÇÜLÜR (pg_enum, şema-nitelendirilmiş):
          {SALE}                                  → ADD VALUE 'ON_INVOICE_DISCOUNT' · ADD VALUE 'FREE_GOODS' + sonra küme yeniden ölçülür (assert)
          {SALE, ON_INVOICE_DISCOUNT, FREE_GOODS} → NO-OP (zaten uygulanmış — taze/prod DB'de TIKANMAZ)
          başka her küme                          → throw, İPTAL (beklenmeyen)
        ~~IF NOT EXISTS YOK — değer zaten varsa AÇIK hata~~ (kabul kriteriyle çelişiyordu) · Z111 §13'ün bilinen-kırmızısı "IF NOT EXISTS
        + BOŞ down" — kusur BOŞ DOWN'dır; idempotent up kusur değildir
        ⛔ aynı dosyada bu değerleri KULLANAN hiçbir şey yok (Z111 §13 — aynı transaction kısıtı)
        [ÖLÇÜLMEDİ — ölçülecek: migrationsTransactionMode 'each' altında iki ADD VALUE aynı migration'da sorunsuz mu (kullanım yoksa beklenen evet)]
down()  TİPİ YENİDEN YARAT (Z111 §13 · 1816 emsali):
        1 etiket evreni ÖLÇÜLÜR (⭐ F12 — Z111 §36: Z100 şablonu kazanır — "eksik = hata" YANLIŞTI, "eksik" ile "hiçbiri" karıştırılmıştı):
            {SALE, ON_INVOICE_DISCOUNT, FREE_GOODS} (hepsi)  → yeniden yaratma
            {SALE} (hiçbiri — zaten geri alınmış)            → idempotent dönüş, kayıt silinir, veri kaybı YOK
            kısmi ya da başka her küme                         → throw, İPTAL
            ~~canlı = {SALE, ON_INVOICE_DISCOUNT, FREE_GOODS} olmalı — sapma (fazla/eksik) → throw, İPTAL~~
            ⛔ brief kabul kriteri İCAT ETMEZ — şablon atfıyla yazar (MIGRATION_SEQUENCE "KABUL KRİTERİ" · "MIGRATION ŞABLONU — KALICI SATIRLAR")
        2 yeni iki etiketi taşıyan satır sayısı ÖLÇÜLÜR — > 0 → throw, İPTAL (sessiz veri kaybı yasağı, CLAUDE.md §2.5)
        3 tipi kullanan kolonlar katalogdan ÖLÇÜLÜR ve beklenenle (Ş2) karşılaştırılır — sapma → throw
        4 CREATE TYPE <geçici> AS ENUM('SALE') → ALTER COLUMN … TYPE <geçici> USING event_type::text::<geçici> → DROP TYPE eski → RENAME
        ⛔ TypeORM TUZAĞI (Z111 §18.1 T1): SELECT count sonucu rows dizisi; UPDATE/DELETE yok ama sayım okuması açıkça ayrıştırılır
```

### `3.2` · BEYAN — YOK (`Z111 §32`)
```
1835 tam geri-alınabilir (down tipi yeniden yaratır) · up etkili (pg_enum'a iki etiket) · volatil veri üretmez ⇒ BEYANSIZ doğar
⛔ REVERSIBILITY / EFFECT export'u YAZILMAZ · harness genel kontrolden geçirir
⛔ harness beklenmedik biçimde "revert etkisiz" (H == S0) derse: bu down'ın tipi GERÇEKTEN yeniden yaratmadığı anlamına gelir — beyan
   eklenerek "susturulmaz" (IRREVERSIBLE_ADD YANLIŞ olur, bayat beyan) ⇒ DUR, down düzeltilir
```

### `3.3` · YAPILMAYACAK
```
⛔ entity / TS enum / resolver / import kodu — 1838 + İŞ-2 backend şeridinin işi
⛔ seed değişikliği (bedelsiz taktik seed turu İŞ-2 ŞERİT A'da, 1835'e bağlı değil)
⛔ 1834 (İŞ-4a) — bu şeridin işi DEĞİL; sıra sorusu §5 DUR
⛔ harness / pin / ratchet dosyaları — yalnız ÇAĞRILIR
```

---

## 4 · KAPANIŞIN KANITI — `Z83` · harness'ın ilk gerçek koşumu (dört sınıf kol, her biri adıyla)

> Rapor **"yeşil"** değil, **her kolun ne söylediği**: `koşuldu · ölçüldü · ölçemedim` üçlüsüyle.

```
KOŞUM   npm run migration:run </dev/null → HEAD = 1835 [ÖLÇÜLÜR]
        bash scripts/migration-verify.sh src/database/migrations/1835000000000-<ad>.ts </dev/null > <log> 2>&1; echo "rc=$?"
BEKLENEN (her biri çıktının SEBEP satırıyla raporlanır)
  şema/katalog kolu   H ≠ S0 (down etiketleri kaldırdı) · S0 ≠ A (up ekledi) · 0 == 2 · 1 == 3 — ENUM_MEMBERS bölümünde fark adıyla
  veri kolu           byte-birebir (1835 veri üretmez; uuid-veri yok) — "volatile-kimlikli satır" tespiti OLMAMALI
  pin (K8)            "✓ maske türleri pinle eşleşti (4 imza)" — enum etiketi bir imza DEĞİLDİR; yeni imza / pini daralt / körlük şüphesi YOK
  beyan kolu          beyan YOK · HARNESS_DECLARED satırı YOK
  SON KONTROL         effect(H) == effect(son)
  çıkış               rc=0 ✅ YEŞİL
RATCHET  bash scripts/guards/declared-migrations.sh --check → rc=0 · "taranan .ts:" bir ARTTI · "beyanlı migration: yok" · baseline DEĞİŞMEZ
         (kapının değişmeyen tabanı da bir kanıttır — sha öncesi == sonrası)
BİLİNEN-KIRMIZI (bu migration'ın kendi kolları — fixture değil, geçici kopya + shasum ile, gerçek dosya geri yüklenir)
  K-a  down'ın etiket evreni ölçümü: canlı tipe elle bir üçüncü etiket eklenmiş SENTETİK durum [ÖLÇÜLMEDİ — ölçülecek: DB'ye yazmadan
       mümkün mü; değilse migration down'ı transaction içinde rollback'li koşturulur] → down throw "etiket evreni beklenenden farklı"
  K-b  yeni etiketi taşıyan satır varken down → throw (rollback'li transaction içinde bir satır UPDATE edilip down çağrılır, sonra ROLLBACK)
  K-c  up'ta IF NOT EXISTS'e mutasyon + boş down → harness KIRMIZI "revert etkisiz" (Z111 §13'ün adını koyduğu bilinen-kırmızı)
⛔ BEKLENMEDİK SONUÇ (ÖLÇEMEDİM / KIRMIZI / beyansız yolda beklenmedik şey): ilk şüpheli T-391 (rc'si okunmayan yardımcı) — sebep satırı okunur,
   renk değil; harness DEĞİŞTİRİLMEZ, DUR ve Team Lead'e raporla
KAPI     collmind.backend npm run guards · npm run build (tsc) · meta bash scripts/run-all.sh — üçü exit 0
TABAN    koşum sonunda DB HEAD = 1835 (uygulanmış hâlde BIRAKILIR — İŞ-2 bunu bekler) · _mv% sentetik 0 · hayalet yok
```

---

## 5 · SINIRLAR (⛔ DUR)
```
⛔ DUR-1  1834 SIRASI — [ÖLÇÜLDÜ: migration-verify.sh:714, :721] harness hedefi "ORDER BY timestamp DESC LIMIT 1" ile bulur ve YALNIZ HEAD'i ölçer ·
          [ÖLÇÜLDÜ] 1834 (İŞ-4a, PlanStatus CANCELLED) TAHSİSLİ ama YAZILMAMIŞ
          ⇒ 1835 uygulandıktan SONRA 1834 yazılırsa: 1834 hiçbir zaman "HEAD" olmaz ⇒ harness 1834'ü ÖLÇEMEZ (ÖLÇEMEDİM "hedef ≠ HEAD")
          [ÖLÇÜLMEDİ — ölçülecek değil, KARAR: TypeORM migration:revert'ün sırası ve 1834'ün 1835'ten sonra koşması]
          ⇒ ŞERİT 1835'İ DB'YE UYGULAMAZ VE HARNESS'I KOŞMAZ — ürün sahibi / Team Lead kararı gelene kadar (brief'in §4'ü bu karara bağlı).
            Migration KODU yazılabilir, tsc/lint koşulabilir; migration:run YOK.
          ✅ F12 — KARAR GELDİ (Z111 §35, 2026-09-13): (b) — 1834 BOŞA DÜŞTÜ, İŞ-4a → 1839000000000 (MIGRATION_SEQUENCE "TAHSİS KURALI").
            ⇒ DUR-1 KALKTI: şerit migration:run + harness §4'ü KOŞAR. Koşumdan önce ölç: 1835'ten KÜÇÜK, tahsisli ama yazılmamış numara
            YOK (1834 boş işaretli) · migrations dizininde 1834 dosyası YOK.
⛔ entity · seed · 1834 · harness/pin/ratchet dosyaları · MIGRATION_SEQUENCE.md · docs/** YAZILMAZ · commit/push YOK
⛔ git checkout / git restore / git stash YASAK — geri alma kopya + shasum -a 256 -c · DB'de deneysel değişiklik YALNIZ ROLLBACK'li transaction
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" · ls -a collmind.backend/scripts | grep '^\.tl' (ikisi de boş olmalı)
⛔ harness erken çıkarsa DB yarım kalır — tabanı geri getirmek şeridin işi (BRIEF_SABLONU §2.6)
```

## 6 · `touches`
```
collmind.backend/src/database/migrations/1835000000000-<ad>.ts   YENİ   [ÖLÇÜLDÜ: dosya yok]
```

## 7 · E2E KATMANI
```
Koşulmaz — şema-yalnız migration, TS tüketicisi yok [ÖLÇÜLDÜ: entity eşlemesi yok]. Kanıt: harness (gerçek HEAD) + bilinen-kırmızılar + iki zincir.
```

## 8 · KAPANIŞ ÇIKTISI
```
1  DİFF — migration dosyası (up/down, yorumda AD ÇAKIŞMASI notu)
2  HARNESS — her kol için koşuldu/ölçüldü/ölçemedim + SEBEP satırı (şema · veri · pin · beyan · SON KONTROL) + rc
3  RATCHET — --check çıktısı + baseline sha öncesi/sonrası
4  Z83 — K-a · K-b · K-c ÇIKTISIYLA
5  KAPI — guards · build · run-all
6  TABAN — HEAD · sentetik · hayalet
7  ⛔ NE ÖLÇEMEDİN
```
