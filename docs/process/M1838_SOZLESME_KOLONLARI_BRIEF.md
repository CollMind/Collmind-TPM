# 1838 · `sales_actuals`'a SÖZLEŞME KOLONLARI + EŞLEŞME DURUMU (tanım) — pinin ikinci gerçek müşterisi
### Şerit: `data-engineer` · Task: `T-403` · Hüküm: `Z111 §12 §2/§5` · `§13` (U2 · B1 · `§13.2 N2`) · `§38`–`§39` (ürün sahibi sırası, 2026-09-14)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`. **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.**
> Son madde her zaman **"⛔ NE ÖLÇEMEDİN"**. Koşum biçimi **§2.6**.
>
> ## ✅ ÜÇ DUR HÜKÜMLE KAPANDI — `Z111 §40` (2026-09-14) · §2 kayıt için DURUR, İŞ §3 bağlayıcıdır

---

## 0 · OKUMA SIRASI
```
1  docs/process/BRIEF_SABLONU.md (§2.3 · §2.6)
2  .claude/backlog/MIGRATION_SEQUENCE.md → 1836 · 1837 · 1838 satırları + "TAHSİS KURALI" (Z111 §35)
3  docs/brd-v2/04_KARAR_KAYDI.md → Z111 §12 §5 (ZARF YOK: match_status + reason; NO_ENVELOPE ASKI) · §13 (U2 net KALIR · B1 batch/index DEĞİŞMEZ) · §38–§39
4  docs/process/HALKA3_IS2_ACTUALS_OLAY_MODELI_BRIEF.md §3.2 (kolon YOK listesi) · §3.5 (eşleşmeme — ölçülmemiş aile sorusu)
5  docs/domain/ACTUALS_IMPORT_SOZLESMESI_v1.md §3 (alan tablosu: customer_code · invoice_date · unit_price)
6  collmind.backend/src/modules/shared/actuals-resolver/actuals-resolver.types.ts:77 (NotMatchedReason = never)
7  collmind.backend/src/database/migrations/1835000000000-AddSalesActualsEventTypeMembers.ts (son HEAD, şablon)
8  collmind.backend/scripts/migration-verify.sh (yalnız OKU, yalnız ÇAĞIR)
```

## 1 · PROBLEM
> ### Dış sözleşmenin (v1) üç alanı ve eşleşmeme hükmünün iki alanı `sales_actuals`'ta yok; İŞ-2 backend'i onlar olmadan yazılamaz.

## 1.1 · ÖLÇÜLEN TABAN (Team Lead, 2026-09-14)
```
[ÖLÇÜLDÜ: information_schema.columns main.sales_actuals]  28 kolon · YOK: invoice_date · unit_price · customer_code · match_status · match_reason
  para/adet kolonları numeric(18,2) (gross/net/discount) · numeric(18,3) (volume, raw_volume_input) · numeric(9,4) (conversion)
  cpl_code varchar NOT NULL VAR (sözleşmede "customer_code YA DA cpl_code")
[ÖLÇÜLDÜ: SELECT count(*) … ]                             3 satır · 3 batch · event_type HEPSİNDE NULL (1835 üye ekledi, satır doldurmadı)
[ÖLÇÜLDÜ: jsonb_object_keys(raw_row)]                     net_amount · gross_amount · fu_code · cpl_code · channel_code · discount_amount · category
                                                          ⇒ raw_row fatura tarihi / birim fiyat / müşteri kodu TAŞIMIYOR ⇒ bu üç kolon için BACKFILL KAYNAĞI YOK
[ÖLÇÜLDÜ: pg_type/pg_enum ILIKE %match%]                   match ailesinde enum yok (claim_match_variance_class_enum ayrı alan: TIMING/AMOUNT/SCOPE)
[ÖLÇÜLDÜ: actuals-resolver.types.ts:77]                   NotMatchedReason = never · yorum "ilk küme NOT_AGGREGATABLE · GRAIN_MISMATCH · …"
[ÖLÇÜLDÜ: ls migrations]                                  HEAD 1835 · 1836 ve 1837 YAZILMAMIŞ
```

## 2 · DUR — ürün sahibinin kararı (TARİHÇE — hüküm `Z111 §40`: DUR-1 (b) · DUR-2 tek aile DB-enum · DUR-3 (ii))

### DUR-1 · TAHSİS KURALI: 1838 uygulanırsa yazılmamış 1836 ve 1837 BOŞA DÜŞER
`[ÖLÇÜLDÜ: MIGRATION_SEQUENCE "TAHSİS KURALI" (Z111 §35)]` *"Tahsis edilmiş ama YAZILMAMIŞ bir numara, kendisinden BÜYÜK bir numara UYGULANDIĞI anda BOŞA DÜŞER."*
```
(a) sıra korunur: 1836 (seed düzeltme) · 1837 (on-invoice ölümü) ÖNCE yazılır, sonra 1838
    ⚠️ 1837 tablo DROP seçilirse → harness dal 3 bugün TABLO SAYISIYLA ölçüyor ⇒ ÖLÇEMEDİM körlük şüphesi;
       T-402 (Z111 §39: tablo-ADI kümesi) önce inmeli [ÖLÇÜLDÜ: §38 dal 3 tanımı · T-402 madde 4]
(b) 1838 önce: 1836 → 1840, 1837 → 1841 (F12 "BOŞA DÜŞTÜ → <yeni>"; 1839 İŞ-4a zaten tahsisli)
    1836 "kullanılmazsa BOŞ kalır" notu taşıyor (seed yeniden kurulumu yeterli ölçülürse) [ÖLÇÜLDÜ: 1836 satırı]
```

### DUR-2 · `match_status` / `match_reason`: DEĞER KÜMESİ tanımlı DEĞİL
```
bilinen      NO_ENVELOPE (reason, ASKI — Z111 §12 §5) · İŞ-3 ailesi NO_PLAN · NO_AGREEMENT · GRAIN_MISMATCH (KARAR_KAYDI :11335) ·
             resolver yorumu NOT_AGGREGATABLE · GRAIN_MISMATCH
tanımsız     match_status'un ÜYELERİ (MATCHED / PENDING / NOT_MATCHED …?) · reason'ın actuals ve İŞ-3 için TEK aile mi (iki aile → F8)
tip          enum mu varchar mı: enum → her yeni üye tip-yeniden-yaratma down'lı migration (1835 emsali, harness enum şeridi);
             varchar + CHECK → üye ekleme CHECK değişikliği; varchar CHECK'siz → DB sessiz (G5 ihlali adayı)
             ⛔ "tanım → yazar → kısıt" (1838 satırı): nullable doğar, kısıt yazar indikten sonra AYRI numarada
mevcut 3 satır  NULL mı kalır, yoksa bir başlangıç statüsü mü (o hâlde beyan DATA_CONDITIONAL, sayaç + N=0↔N=1 bilinen-kırmızı, T1 tuzağı)
```

### DUR-3 · MÜŞTERİ KİMLİĞİ KOLONU
```
sözleşme §3   customer_code (ERP cari) YA DA cpl_code — ikisinden biri zorunlu  [ÖLÇÜLDÜ: ACTUALS_IMPORT_SOZLESMESI_v1.md:54,77]
tablo         cpl_code varchar NOT NULL + cpl_id uuid NOT NULL zaten var       [ÖLÇÜLDÜ: information_schema]
soru          yeni kolon YALNIZ ham customer_code (nullable varchar) mı; yoksa çözülmüş müşteri kimliği (FK) de mi
              — [ÖLÇÜLDÜ: information_schema.tables] main.customers VAR (customer_group · customer_segment · customer_tier) ·
                emsal: on_invoice_entries customer_id + customer_code İKİSİ BİRDEN (1837'nin ölüme götürdüğü tablo)
                ⇒ seçenek (i) yalnız customer_code · (ii) customer_code + customer_id FK→customers (çözümlenmiş kimlik, İŞ-2 üreticisi doldurur)
```

## 3 · İŞ — BAĞLAYICI (`Z111 §40`)
```
DOSYA       collmind.backend/src/database/migrations/1838000000000-<Ad>.ts  (numara MIGRATION_SEQUENCE'dan — ajan seçmez)
TİPLER      CREATE TYPE main.sales_actuals_match_status_enum AS ENUM ('UNMATCHED','SUSPENDED')
            CREATE TYPE main.sales_actuals_match_reason_enum AS ENUM ('NO_ENVELOPE')
            ⛔ YALNIZ bu üyeler — MATCHED · ANOMALY · NO_PLAN · NO_AGREEMENT · GRAIN_MISMATCH · AMBIGUOUS_AGREEMENT İŞ-3'ün AYRI migration'ında
            ad kalıbı: mevcut <tablo>_<kolon>_enum [ÖLÇÜLDÜ: sales_actuals_event_type_enum · sales_actual_batches_status_enum] — TypeORM entity
            adıyla hizası şeritte ÖLÇÜLÜR
KOLONLAR    invoice_date   date           NULL
(hepsi      unit_price     numeric(18,2)  NULL   (tablonun para ölçeği — Alan A, float YOK)
 nullable,  customer_code  varchar        NULL   (ham, denetim izi)
 DEFAULT    customer_id    uuid           NULL   FK → main.customers(id) — ON DELETE davranışı ve index EMSALDEN ölçülür:
 YOK)                                             on_invoice_entries.customer_id [ÖLÇÜLMEDİ — ölçülecek: pg_constraint confdeltype · pg_indexes]
                                                  ⚠️ §13 B1 "index DEĞİŞMEZ" batch kapsamı içindir; FK index'i eklenecekse gerekçesi yazılır, yoksa DUR
            match_status   sales_actuals_match_status_enum  NULL
            match_reason   sales_actuals_match_reason_enum  NULL
⛔ BACKFILL YOK — mevcut 3 satır NULL kalır (§40 DUR-2) · net_amount KALIR (§13 U2) · batch kapsamı DEĞİŞMEZ (§13 B1) · 1835 üyeleri KULLANILMAZ
⛔ NOT NULL / CHECK YOK — yazar (İŞ-2) indikten sonra ayrı numarada (Z98 §3)
up          durum ölçülür (1835 şablonu, DISIPLIN "assert taşıyan migration ÜÇ durumu ayırt etmeli"):
            hiçbiri yok → uygula + assert · hepsi var ve biçim beklenen → NO-OP · kısmi / biçim farklı → İPTAL (açık hata)
down        yeni kolonlarda NULL-olmayan satır varsa → İPTAL (sessiz kayıp YOK, §2.5 · 1816 emsali) · aksi hâlde kolonlar DROP → tipler DROP
            (tipi kullanan başka kolon varsa İPTAL — udt_name + udt_schema ile, 1835 🟡-2 dersi)
BEYAN       YOK — up ↔ down simetrik (Z111 §32)
```

## 4 · KANIT — harness dört kol + ratchet (ürün sahibi, Z111 §39)
```
şema     H≠S0 · S0≠A · 0==2 · 1==3 · SON KONTROL — kolon ekleme şema hash'ini değiştirir, revert geri alır
veri     volatile-kimlikli satır ÜRETMEZ ⇒ veri byte-birebir beklenir [ÖLÇÜLMEDİ — harness söyler; kolon eklemenin satır-yapısı hash'ine etkisi koşumda görülür]
pin      yeni kolonlar DEFAULT'suz ⇒ birincil maske imza kümesi değişmez, "4 imza eşleşti", KALDIRILDI satırı YOK beklenir
         ⚠️ customer_id → customers.id FK: customers.id volatile-default'lu ise K1 GENİŞ maske sayısı +1 değişir [ÖLÇÜLMEDİ — koşumda görülür, adıyla raporla]
ratchet  --check rc=0 · baseline DEĞİŞMEZ (beyansız)
bilinen  K-a down sonrası kolonlar ve iki tip yok (information_schema + pg_type) · K-b üç durum: hiçbiri/hepsi/kısmi (kısmi → İPTAL, rollback'li)
kırmızı  K-c down, yeni kolonda NULL-olmayan satır varken → İPTAL (rollback'li, iz sıfır) · K-d mutasyon: down'dan bir DROP çıkarılır →
         harness "revert etkisiz" KIRMIZI (kopyala → mutasyon → satırı BAS → koş → geri yükle → shasum)
         ⛔ mutasyonlar YALNIZ kopyada ya da sha-doğrulamalı geri yüklemeyle; gerçek migration dosyası kapanışta tur-sonu sha'sıyla eşit
kapılar  backend npm run guards · npm run build · meta bash scripts/run-all.sh · declared-migrations --check
```

## 5 · SINIRLAR · ORTAM
- İlk komut hayalet kontrolü (`docker ps --filter label=com.docker.compose.project=tpm`) · taban HEAD 1835 n=90.
- Migration yalnız `data-engineer` · entity hizası (`sales-actual.entity.ts`) İŞ-2 backend şeridinde (bu migration değil) [ÖLÇÜLMEDİ — ölçülecek: entity'nin kolonsuz kalmasının `synchronize`/schema-diff guard'ına etkisi].
- ⛔ git checkout/restore/stash · npx · boru ile exit kodu. Commit/push YOK.

## 6 · ⛔ NE ÖLÇEMEDİM
- customers tablosunun doluluğu ve customer_code alanının nerede tutulduğu (DUR-3 (ii) için) · entity-şema farkının guard etkisi · İŞ-3 reason ailesinin güncel tanımı (yalnız KARAR_KAYDI :11335 satırı okundu).

## 7 · ŞERİT İNDİ — TL DOĞRULAMASI YEŞİL · REVIEWER 1 🔴 + 3 🟡 (2026-09-14)
Migration sha `32100a03…` · DB HEAD 1838 n=91
```
ŞERİT     iki enum (yalnız 1838 üyeleri) · altı kolon nullable/DEFAULT'suz · FK customer_id → main.customers(id) ON DELETE RESTRICT
          (emsal on_invoice_entries confdeltype='r' [reviewer ÖLÇTÜ]) · index ix_sa_tenant_customer (tenant_id, customer_id) (emsal
          IDX_ON_INVOICE_ENTRIES_TENANT_CUSTOMER_ID; B1 "index değişmez" batch kısmi UNIQUE'i için — reviewer B1 metniyle UYUMLU buldu) ·
          customer_code varchar(50) (emsal) · K-b hepsi→NO-OP · kısmi→İPTAL · K-c veri varken down İPTAL (rollback'li) ·
          K-d down'dan DROP çıkarılınca migration:revert rc=1 — ⚠️ etiket: harness "revert etkisiz" DEĞİL, Postgres 2BP01 bağımlılık hatası
          ⛔ İHLAL: harness rc'si OKUNMADI (log'daki YEŞİL satırına dayandı) · npx --no-install prettier kullanıldı (reviewer: prettier/eslint
          --check rc=0, node_modules/.bin ile — dosya bozulmamış)
TL        harness gerçek HEAD 1838 rc=0 (ayrı okundu) · H≠S0 · S0≠A · 0==2 · 1==3 · SON KONTROL ✓ · pin "4 imza eşleşti" · KALDIRILDI YOK ·
          beyansız yol · K1 GENİŞ 293/1000 — 1835 HEAD koşumunda 292/994 [ÖLÇÜLDÜ: runt395b REAL-HEAD-SON] ⇒ +1 geniş (customer_id FK) · +6 kolon
          harness/pin/migration sha koşum sonrası OK · _mv 0
REVIEWER  🔴 R1 fkState FK hedefini yalnız relname ile karşılaştırıyor — public.customers DA VAR [TL ÖLÇTÜ: pg_class iki satır] ⇒ yanlış şemaya
             giden FK "beklenen" sayılır, NO-OP + assert kör (§4.2 şema-nitelendirme); confkey=id ve tek-kolon da sınanmıyor
          🟡 S1 "hepsi var" DEFAULT yokluğunu doğrulamıyor (column_default seçiliyor, karşılaştırılmıyor [TL ÖLÇTÜ: :153/:158 dışında geçmiyor])
          🟡 S2 index biçimi includes('(tenant_id, customer_id)') — UNIQUE / kısmi / INCLUDE da "beklenen" [TL ÖLÇTÜ: kod]
          🟡 S3 down() kısmi durumlarda (FK/index/tip yok ya da farklı adla) else'siz — up ile simetrik değil, kapalı ama açıklamasız
          🔵 N1 etiketsiz enum "hiçbiri" sayılır · N2 enum sırası (enumsortorder) sınanmıyor · N3–N6 yorum iddiaları (PK tek kolonlu ·
             "her sorgu" ölçüsüz · §40.1 bölüm atfı · "bugün 3" sayı) · N7 varchar(50) hükümden dar (emsal gerekçeli)
          İŞ-2 NOTLARI: N8 çapraz-tenant — FK yalnız customers(id), (tenant_id,id) UNIQUE yok ⇒ tenant eşitliği üreticide + testte ·
             N10 brief'in entity emsali yanlış: sales-actual.entity.ts'te event_type YOK; TypeORM varsayılan enum adları bu tiplerle hizalı
```

## 8 · ✅ DAR DÜZELTME İNDİ — TL BAĞIMSIZ DOĞRULAMA YEŞİL (`Z111 §41`, 2026-09-14)
Migration sha `89e92952…` (tur öncesi `32100a03…`, kopya `scratchpad/t403b-pre/`)
```
ŞERİT   R1 fkState: ref şeması (pg_namespace) · ref kolonu confkey→'id' · tek kolon · RESTRICT · S1 column_default null şartı ·
        S2 indexdef TAM eşitlik · S3 up/down TEK ölçüm noktası (diagnoseState), kısmi → adıyla throw · N1 typeExists ayrı · N2 enumsortorder dizi ·
        N3–N6 yorumlar · money-float guard'ı Number(row.ncols)'u Alan A'da yakaladı → sarmalayıcı kaldırıldı
        rollback'li: K-b hepsi NO-OP · kısmi İPTAL · K-c veri varken down İPTAL · S1 DEFAULT → İPTAL · S2 aynı adla UNIQUE → İPTAL ·
        S3 FK yok → down açık İPTAL · K-d → Postgres 2BP01 (harness "revert etkisiz" DEĞİL — doğru adıyla)
        ⚠️ R1 uçtan uca up() üzerinden DEĞİL: app_migrate'in public.customers'ta REFERENCES yetkisi yok (K-2.6.13 ile tutarlı) ⇒ fkState sorgusu
           superuser ile aynı transaction'da birebir koşuldu → ref_schema='public' döndü [ÖLÇÜLMEDİ: migration sınıfının kendi akışı]
        ⚠️ ÖNCE/SONRA (eski kopyada NO-OP) R1/S1/S2 için raporlanmadı · onay bloğunun basıldığı TL tarafından GÖRÜLEMEDİ (yalnız son rapor okunur)
TL      kod: matchesExpected = ref_schema===main && ref_table===customers && ref_col==='id' && ncols===1 && confdeltype==='r' [ÖLÇÜLDÜ: :319-325]
        · column_default karşılaştırması :270 · indexdef === expectedDef :346 · enumsortorder :162
        harness gerçek HEAD 1838 rc=0 (DOSYADAN) · pin 4 imza · KALDIRILDI yok · GENİŞ 293/1000 · SON KONTROL ✓ · YEŞİL
        migration/harness/pin sha koşum sonrası OK · prettier --check 0 (node_modules/.bin) · HEAD 1838 n=91 _mv 0 · hayalet yok
```

### `8.1` · KAPANIŞ BEYANI (`Z111 §42`, 2026-09-14)
```
kapsandı    hüküm §40 birebir · R1/S1/S2/S3 + N1–N6 · harness gerçek HEAD rc=0 (dosyadan) · pin 4 imza · ratchet · guards · build · run-all
kapsanmadı  R1 migration akışından geçmedi (yetki modeli: migration kullanıcısının public.customers'a REFERENCES yetkisi yok — sorgu superuser'la
            birebir, kod okundu)
            R1/S1/S2 için "eski kod NO-OP derdi" ÖNCE kanıtı gösterilmedi (yalnız SONRA-İPTAL) — Z83'ün YARISI; yön güvenli (kontroller sıkılaştı,
            ürün koduna dokunulmadı, reviewer kusuru kodla göstermişti), "bilinen-kırmızı = önce/sonra" kuralı bu turda YARIM uygulandı
            koşum-biçimi onay bloğu görülemedi → T-404
savunma     yanlış-şema FK canlıda zaten KURULAMAZ (migration kullanıcısı public'e REFERENCES alamıyor) ⇒ R1 kontrolü savunma derinliğidir,
derinliği   tek savunma değil
kapı        money-float guard'ı dosyadaki Number(...) sarmalayıcısını Alan A'da yakaladı — kapı işletmede, migration'da bile (para hattının ilk
            migration yakalaması)
```
