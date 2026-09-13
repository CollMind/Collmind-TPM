# `migration-verify.sh` **ENUM ÜYELERİNE KÖR** — geri alınamayan bir ekleme SESSİZ YEŞİL geçiyor
### Şerit: `data-engineer` · Hüküm: `Z111 §13` (enum onayı), ürün sahibi 2026-09-10 · ⛔ 1834/1835'ten ÖNCE

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.** Raporunda da etiket kullan,
> **araç notlarını yaz**, son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

---

## 0 · OKUMA SIRASI — ⛔ her yol 2026-09-11'de `ls`/`grep` çıktısında görüldü

```
1  docs/process/BRIEF_SABLONU.md
2  docs/brd-v2/04_KARAR_KAYDI.md → Z111 §13 (enum onayı) · Z109 (harness, hüküm 26) · Z100 (migration şablonu) · Z83
3  docs/process/HALKA3_IS2_ACTUALS_OLAY_MODELI_BRIEF.md §3.1  ← ÖLÇÜMÜN KENDİSİ (üç down() seçeneği)
4  .claude/backlog/MIGRATION_SEQUENCE.md → 1834 · 1835 satırları (F12 notları)
5  collmind.backend/scripts/migration-verify.sh        :258-300 snapshot bloğu
6  collmind.backend/scripts/verification/synthetic-datasource.ts
   collmind.backend/scripts/verification/synthetic-migrations/     ← SENTETİK MİGRATION EMSALİ
   collmind.backend/scripts/verification/check-fixtures/
7  docs/DISIPLIN.md → F04 KAPI ve DOĞUM · "Bir AD, koruduğu SINIFTAN dar olabilir" ·
                      "Bir DB nesnesinin YOKLUĞUNU iddia etmeden önce iki katalogu da sorgula"
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | bu brief'te nerede |
|---|---|---|
| `Z111 §13` | harness enum-körlüğü **ayrı küçük şerit, 1834/1835'ten ÖNCE**; `pg_enum` snapshot'a; bilinen-kırmızı = `IF NOT EXISTS` + boş-down → kırmızı | `§3` · `§4` |
| `Z111 §13` | enum `down()` = **tipi yeniden yaratmak** | `§4` bilinen-yeşil |
| `Z109` hüküm 26 | migration doğrulaması **araçla**, elle değil | `§3` |
| `Z83` | kapı doğum kuralı: bilinen-yeşil **ve** bilinen-kırmızı | `§4` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — tek cümle

> ### Harness'ın "önce/sonra aynı mı" sorusu **enum üyelerini sormuyor** — bir üye eklenip
> ### geri alınmasa da snapshot'lar **eşit** çıkıyor.

```
[ÖLÇÜLDÜ: grep -c -F pg_enum collmind.backend/scripts/migration-verify.sh]  → 0
[ÖLÇÜLDÜ: aynı dosyada pozitif kontrol]  pg_constraint 3 · pg_indexes 1 · pg_trigger 1 · information_schema.columns 1
[ÖLÇÜLDÜ: migration-verify.sh:258-300]   snapshot = kolonlar (data_type enum için hep "USER-DEFINED") ·
                                          kısıtlar · index · trigger · tablo satır-hash'i
[ÖLÇÜLDÜ: şerit deneyi, HALKA3_IS2 brief §3.1]
  boş down() + ADD VALUE IF NOT EXISTS  →  exit 0, "YEŞİL" — üye GERİ ALINMADI
```
📌 Sınıf: *"Bir AD, koruduğu SINIFTAN dar olabilir"* — harness **şemayı** koruduğunu söylüyor,
**şemanın bir kataloğuna** bakıyor.

---

## 2 · EVREN — snapshot'ın görmediği ŞEKİLLER

```
Ş1  enum ÜYELERİ          pg_enum (enumtypid, enumlabel, enumsortorder)     ⭐ BU TURUN İŞİ
Ş2  enum TİPİNİN varlığı   pg_type WHERE typtype='e'                          ⭐ BU TURUN İŞİ (tip yeniden yaratma bunu değiştirir)
Ş3  diğer katalog türleri  view tanımları · fonksiyonlar · sequence'ler · kolon default'larının çözümü …
                           ⛔ BU TURDA EKLENMEZ — yalnız LİSTE olarak raporla
                           [ÖLÇÜLMEDİ — ölçülecek: migration-verify.sh snapshot'ında pg_views / pg_proc / pg_sequence VAR mı]
```
⛔ **Ş3'ü "hazır buradayken" ekleme** — her yeni katalog, mevcut sentetik ve gerçek migration'larda
**yeni farklar** üretebilir; kapsam kayar, bilinen-yeşil bozulur. Ş3 bir **bulgu listesidir**.

---

## 3 · İŞ

```
1  snapshot'a Ş1 + Ş2: şema-nitelendirilmiş (nspname = $PG_SCHEMA), DETERMİNİSTİK sıralı
     typname | enumsortorder | enumlabel   (ORDER BY typname, enumsortorder)
   ⚠️ enumsortorder float4'tür — tip yeniden yaratmada DEĞERİ değişebilir (1,2 → 1,2 mi, 1,1.5 mi?)
     [ÖLÇÜLMEDİ — ölçülecek: sıra DEĞERİ mi, sıra RANKI mı karşılaştırılmalı — tip yeniden yaratma
      sonrası enumsortorder'ı ölç; rank (row_number) daha kararlıysa onu kullan, gerekçesiyle]
2  K2/K3 farkı RAPORLARKEN hangi kataloğun farklı olduğunu ADIYLA bas ("pg_enum: <tip> <üye>")
3  mevcut çıkış kodu sözleşmesini KORU (YEŞİL / KIRMIZI / ÖLÇEMEDİM / araç hatası)
4  sigpipe-hygiene: pipefail + grep -q YASAK · exit kodu boruya sokulmaz
```

---

## 4 · KAPANIŞIN KANITI — `Z83` · ⛔ üçü de ÇIKTISIYLA

```
BİLİNEN-KIRMIZI  sentetik enum + ADD VALUE IF NOT EXISTS + BOŞ down()   → harness KIRMIZI,
                 farkı "pg_enum" adıyla basar          (bugün: YEŞİL — düzeltme öncesi AYNI koşum YEŞİL olmalı)
BİLİNEN-YEŞİL    sentetik enum + ADD VALUE + down() TİPİ YENİDEN YARATIR → harness YEŞİL
REGRESYON        mevcut sentetik migration(lar) (scripts/verification/synthetic-migrations/) → önceki sonucu AYNEN verir
                 + gerçek zincirin HEAD migration'ı (1833) → önceki sonucu AYNEN verir
```
⛔ **Düzeltme öncesi bilinen-kırmızı koşumu YEŞİL görülmeden** kırmızı kanıt sayılmaz — rengin
**sebebi** gösterilir (`K2: snapshot0 ≠ snapshot2 — pg_enum …`).
⛔ Sentetik enum migration'ları **kalıcı fixture** olarak `synthetic-migrations/` altına girer
(emsal: `9999999999999`) — ama **ürün şemasına** hiçbir iz bırakmaz; öncesi/sonrası
`SELECT typname FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace WHERE n.nspname='main'` **birebir**.
⚠️ Harness'ın bir self-test'i varsa ona da iki vaka eklenir: `[ÖLÇÜLMEDİ — ölçülecek: ls collmind.backend/scripts/ | grep -F migration-verify]`

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ YALNIZ harness + sentetik fixture — 1834 / 1835 migration'larını YAZMA (sırası bu şeritten SONRA)
⛔ Ş3 kataloglarını EKLEME — liste olarak raporla
⛔ ürün şemasına/enumlarına DOKUNMA · docs/brd-v2/** YAZMA · task AÇMA · commit/push YOK
⛔ git checkout YASAK — kopya + shasum -a 256 -c
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" (Docker açılışında hayalet KENDİLİĞİNDEN kalkar)
   + collmind.backend/test/.e2e-run.lock varsa DUR
⛔ KAPI İKİ ZİNCİR: npm run guards (backend) VE bash <kök>/scripts/run-all.sh (META — sigpipe-hygiene orada)
```

### `5.1` · ARAÇ NOTLARI (ölçüldü)
```
zsh: değişkene konmuş komut/yol listesi KELİMEYE BÖLÜNMEZ (P="docker exec…"; $P / F="a b"; tool $F) — yolları AÇIK yaz
psql için heredoc; \echo metninde tek tırnak YOK · her sorgu şema-nitelendirilmiş
enum karşılaştırması: customers.channel gibi enum kolonları varchar ile ::text cast'siz karşılaştırılamaz
aynı transaction'da eklenen enum değeri KULLANILAMAZ ("unsafe use of new value") — sentetik migration'da ekleme ve kullanımı AYIR
git -C ve kök script'ler MUTLAK yolla · exit kodunu boruya sokma
```

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
collmind.backend/scripts/migration-verify.sh
collmind.backend/scripts/verification/synthetic-migrations/   (yeni sentetik enum fixture'ları)
```

## 7 · E2E KATMANI
```
Koşulmaz — harness ürün kodu değil. Kanıt §4'ün üç koşumu.
```

## 8 · KAPANIŞ ÇIKTISI
```
1  DİFF              — snapshot'a eklenen sorgu(lar), fark raporlama satırı
2  enumsortorder     — değer mi rank mı, ölçümle
3  ÜÇ KOŞUM          — bilinen-kırmızı (öncesi YEŞİL, sonrası KIRMIZI + sebep) · bilinen-yeşil · regresyon
4  Ş3 LİSTESİ        — snapshot'ın hâlâ görmediği kataloglar (ekleme YOK)
5  KAPI              — iki zincir
6  ÜÇ METRİK         — tur süresi · review-tur · DUR
7  ⛔ NE ÖLÇEMEDİN
```

---

## 9 · ⭐ İKİNCİ TUR — GENELLEŞTİRME (`Z111 §15`, 2026-09-11) · ⛔ §1–§8'İN ÜSTÜNE YAZAR

İlk tur (enum snapshot + `K_ENUM`) **indi ama commit edilmedi**; ürün sahibi *"önce genelleştir"*
dedi. Bu bölüm o işin **devamıdır** — aynı ağaçta, aynı dosyalar üstünde.

### `9.0` · OKUMA
```
docs/brd-v2/04_KARAR_KAYDI.md → Z111 §15 (hüküm) · §15.2 (N6 · N7 · N8 — ölçülmüş öncüller)
code-reviewer bulguları bu bölümde AYNEN listelendi (§9.3) — rapor dosyası YOK, liste burada
```

### `9.1` · ⛔ İŞ 0 — ÖNKOŞUL: VERİ KONTROLÜ 51 TABLONUN YALNIZ İLKİNİ GÖRÜYOR (`§15.2 N8`)
```
[ÖLÇÜLDÜ: migration-verify.sh:64-82]  psql_out / psql_val → docker exec -i  (stdin açık)
[ÖLÇÜLDÜ: migration-verify.sh:241-249, 302-310]  while read tbl … done < "$ALL_TABLES_OUT" — gövde psql_val çağırır
[ÖLÇÜLDÜ: Team Lead, SELECT 1 döngüsü, 3 satırlık dosya]  -i → 1 tur · </dev/null → 3 tur · -i yok → 3 tur
[ÖLÇÜLDÜ: pg_tables main]  51 tablo · sıralı ilk _t019_backfilled_tx
```
Düzeltme **iki parça, birlikte**:
```
1  docker exec'e </dev/null (ya da heredoc olmayan çağrılarda -i'yi kaldır) — İKİ yardımcıda da
2  main.migrations DATA hash'inden ÇIKAR ya da id'siz hash'le
   [ÖLÇÜLDÜ: migrations.id = nextval('main.migrations_id_seq') · max 400 · seq 408]
   ⇒ yapılmazsa düzeltme sonrası HER koşum snapshot1 ≠ snapshot3 KIRMIZI (sinyal sabitlenir — ters yönde kapı kaybı)
```
**Z83 — İŞ 0'ın kendi doğum şartı:**
```
BİLİNEN-KIRMIZI  sentetik: UPDATE <sentetik tablo, _t019_backfilled_tx'ten SONRA sıralanan bir ad> + BOŞ down()
                 düzeltme ÖNCESİ → YEŞİL (ilk tablo dışını görmüyor) · SONRASI → KIRMIZI, tablo ADIYLA
T-047 SAYIMI     harness çıktısında taranan tablo sayısı BASILIR ve 51'e eşit (bugün: fiilen 1)
```

### `9.2` · İŞ 1 — GENEL KONTROL (`Z111 §15`)
Harness HEAD'den başlar; hükmün üç snapshot'ının bu akıştaki karşılığı:
```
H   hedef uygulanmış (HEAD) — ön-revert ÖNCESİ, TAM snapshot
S0  ön-revert SONRASI (hükmün "öncesi")
A   run SONRASI (snapshot1)
B   revert SONRASI (snapshot2)

KONTROL          ASSERT            KIRMIZI MESAJI
revert etkisiz   H ≠ S0            "revert etkisiz — down() hedefin etkisini geri almadı" (katalog ADIYLA)
up etkisiz       S0 ≠ A            "migration etkisiz — up() hiçbir şey değiştirmedi"
revert tam       B == S0           (mevcut 0==2 assert'i)
tekrarlanabilir  A == snapshot3    (mevcut 1==3 assert'i)
```
⚠️ Neden `H ≠ S0` da gerekli: boş `down()` ile S0 **kirli** doğar (S0 == H == A) — hükmün `S0 ≠ A`'sı
bu durumu yakalar ama mesajı yanlış adlandırır ("up etkisiz"); `H ≠ S0` sebebi **doğru adla** basar.
```
K_ENUM METİN KONTROLÜ      SİLİNİR (migration_uses_add_value dahil) — enum katalogları snapshot'ta KALIR
```

### `9.3` · İŞ 2 — BEYAN: adıyla tanımlı "geri alınamaz" durum (`Z111 §15`)

> ### ⭐ `F12` — `Z111 §16` (2026-09-11) BU BÖLÜMÜN SORULARINI CEVAPLADI · aşağıdaki eski metnin ÜSTÜNE YAZAR
> ```
> DURUM                          BEYAN (migration dosyasında export)       HARNESS ÇIKTISI
> beyansız etkisiz up            —                                        KIRMIZI  "migration etkisiz" (bilinmeyen no-op)
> assert-only migration          EFFECT = 'NONE_BY_DESIGN'                YEŞİL + ZORUNLU satır:
>                                                                         "etkisiz — beyanlı: assert-only"
> sıfır-satır backfill           EFFECT = 'DATA_CONDITIONAL'              migration kendi "N etkilendi" sayacını BASAR;
>                                                                         N = 0 ⇒ ÖLÇEMEDİM (koşul bu ortamda kurulamadı —
>                                                                         yeşil DEĞİL) · N > 0 ⇒ normal kontroller
> beyansız etkisiz down          —                                        KIRMIZI  "revert etkisiz" (yazım YASAK)
> geri alınamaz ekleme           REVERSIBILITY = 'IRREVERSIBLE_ADD'       YEŞİL + ZORUNLU satır:
>   (+ sebep)                     + sebep metni                           "GERİ ALINAMAZ — beyanlı: <sebep>"
> ```
> ```
> ÇIKIŞ KODU     YENİ KOD YOK — sözleşme YEŞİL 0 · KIRMIZI 1 · ÖLÇEMEDİM 2 aynen
> GÖRÜNÜRLÜK     beyanlı satırlar push-order beyanına TAŞINIR ("koşulmadı:" satırı gibi):
>                  geri-alınamaz migration: <numara> <sebep>
>                ⛔ push-order.sh META'da (kök scripts/) — bu şeridin touches'ı DEĞİL ⇒ taşıma mekanizmasını
>                   ÖLÇ ve ÖNER (harness bir makine-okunur satır basar; push-order onu nasıl okur), YAZMA
> KÖTÜYE KULLANIM beyanlı migration'lar .claude/backlog/MIGRATION_SEQUENCE.md'de ADIYLA listeli + RATCHET
>                (liste artışı = ayrı, gerekçeli commit) — her no-op'a beyan yazma yolu KAPALI
>                ⛔ MIGRATION_SEQUENCE Team Lead dosyası; ratchet guard'ı bu şeridin işi DEĞİL ⇒ şekli ÖNER
> 1833           düzeltilmiş harness'la YENİDEN KOŞULUR (HEAD) → kaydı gerçek kanıta döner (§9.6 bilinen-yeşil satırı)
> ```
> ⇒ "⛔ çıkış kodu … DUR" maddesi **KAPANDI**; beyan okuma yöntemi (ts-node import ↔ satır deseni) hâlâ **ölçülerek** seçilir.
```
migration dosyası bir işaret EXPORT eder (METİN DEĞİL BEYAN) — ör. export const REVERSIBILITY = 'IRREVERSIBLE_ADD'
harness bunu OKUR: [ÖLÇÜLMEDİ — ölçülecek: ts-node ile modülü import edip değeri almak mümkün mü (tercih) ·
  değilse satır-başı sabit bir export deseni; hangisi ölçülerek, gerekçesiyle]
beyanlı migration'da H == S0 → KIRMIZI DEĞİL, AYRI DURUM: çıktıda ADIYLA ("GERİ ALINAMAZ EKLEME — beyanlı")
  ⛔ çıkış kodu sözleşmesi: yeni durum için yeni kod mu, YEŞİL + uyarı mı → DUR, Team Lead'e (script başlığı :11-14)
beyansız migration'da H == S0 → KIRMIZI (hüküm: "o yazım YASAK")
⚠️ "BİLEREK ETKİSİZ up" (eşleşmeyen backfill · yalnız assert eden migration) için hüküm SESSİZ (§15.2 N7) ⇒
   bu turda KIRMIZI kalır; beyan türü EKLEME — ürün sahibine gider
```

### `9.4` · İŞ 3 — SNAPSHOT'IN KÖR KATALOGLARI: view + fonksiyon tanımları (`§15.2 N7`)
```
[ÖLÇÜLDÜ: 1789000000000-FixBudgetSummaryCommitDoubleCounting.ts:30-32,132-134] up/down YALNIZ CREATE OR REPLACE VIEW
[ÖLÇÜLDÜ: grep pg_views|pg_proc migration-verify.sh → boş]
⇒ genel kontrol view/fonksiyon-yalnız bir migration'a YANLIŞ "etkisiz" der
⇒ snapshot'a: pg_get_viewdef (main view'ları) · pg_get_functiondef (main fonksiyonları) — şema-nitelendirilmiş, sıralı
   ⚠️ Team Lead teknik kararı (ürün sahibinin "genelleştir" hükmünün DOĞRULUK şartı) — kayıtta adıyla
⛔ sequence'ler · domain tipleri · kolonun udt_name'i (reviewer N2) → yine LİSTE, eklenmez
```

### `9.5` · İŞ 4 — REVIEWER BULGULARI (commit öncesi kapanır)
```
S1  K_ENUM metin tetikleyicisi        → İŞ 1 ile SİLİNİYOR (kapanır)
S2  snapshot/enum-snapshot alınamazsa KIRMIZI veriliyor (:473, :500, :512 deseni) → ölçüm başarısızlığı = ÖLÇEMEDİM (exit 2)
S3  diff çıkış kodu okunmuyor (:502-503, :360) → rc ayrılır: 0 aynı · 1 farklı · diğer ÖLÇEMEDİM
S4  erken KIRMIZI DB'yi yarım bırakıyor ve söylemiyor (:485, :520, :555) → mesaja mevcut HEAD + gereken
    `npm run migration:run` komutu (BİLGİ; otomatik koşturma YOK)
S5  yeni fixture'larda 3 prettier hatası (9999999999002…:19 · 9999999999012…:15,:34) → düzelt (--fix'siz, elle), shasum ile doğrula
S6  sentetik fixture'ların ÇAĞRI KOMUTU hiçbir yerde yazılı değil → harness başlığına: MIGRATION_VERIFY_RUN_CMD /
    REVERT_CMD tam komutları + kurulum + temizlik adımları (her fixture seti için)
```

### `9.6` · KAPANIŞIN KANITI — `Z83`
```
BİLİNEN-KIRMIZI (genel)   sentetik: CREATE TABLE IF NOT EXISTS + BOŞ down()  (enum-DIŞI — genellik kanıtı)
                          düzeltme ÖNCESİ (HEAD harness) → YEŞİL · SONRASI → KIRMIZI "revert etkisiz"
                          ⚠️ HEAD harness kopyası scratchpad'den KOŞAMAZ: [ÖLÇÜLDÜ: migration-verify.sh:31-33]
                          SCRIPT_DIR'den BACKEND_DIR türetir ve cd eder ⇒ kopya collmind.backend/scripts/ ALTINDA,
                          geçici ad, koşum sonrası SİLİNİR, git status ile temizlik gösterilir
BİLİNEN-KIRMIZI (veri)    §9.1'in UPDATE + boş down vakası
BİLİNEN-KIRMIZI (up)      sentetik: up() hiçbir şey yapmaz → "migration etkisiz"
BİLİNEN-KIRMIZI (enum)    mevcut enum-known-red → KIRMIZI "revert etkisiz" (K_ENUM SİLİNDİĞİ HÂLDE)
BİLİNEN-YEŞİL             enum-known-green · null-collapse sentetiği (önceki sonuç: K4 KIRMIZI — AYNEN) ·
                          gerçek HEAD 1833 → YEŞİL
                          ⛔ "89 migration" UYGULANAMAZ (§15.2 N6 — harness HEAD-only)
BEYAN                     sentetik: IRREVERSIBLE beyanlı boş down → ADIYLA ayrı durum (çıkış kodu §9.3 DUR'una bağlı)
VIEW                      sentetik: yalnız CREATE OR REPLACE VIEW (up/down farklı tanım) → YEŞİL, "etkisiz" DEMEZ
T-047                     taranan tablo sayısı = 51 basılır
TEMİZLİK                  her koşum sonrası: HEAD 1833 · 89 migration · 68 enum · sentetik tip/tablo 0
```

### `9.7` · SINIRLAR — §5 geçerli, ek olarak
```
⛔ gerçek zincire (src/database/migrations) DOKUNMA — 1776/1789 yalnız OKUNUR
⛔ 1834 / 1835 / 1838 YAZMA
⛔ geçici HEAD-harness kopyası dışında scripts/ altına kalıcı olmayan dosya BIRAKMA
⛔ çıkış kodu sözleşmesini değiştirmek (yeni kod) → DUR (§9.3)
```

### `9.8` · KAPANIŞ ÇIKTISI
```
0  ⭐ (2026-09-11, ikinci tur indi — İŞ 0/1/3/4 TAMAM, İŞ 2 DUR'da; devamı §9.9)
1  DİFF — İŞ 0..4, her biri ayrı
2  N8 ETKİSİ — düzeltme sonrası T-047 51 tablo; migrations tablosu nasıl ele alındı
3  Z83 — §9.6'nın her satırı ÇIKTISIYLA (öncesi/sonrası renk + sebep)
4  BEYAN — okuma yöntemi (ölçüm + gerekçe) · çıkış kodu DUR'u
5  HÂLÂ KÖR — sequence · domain · udt_name · …  (LİSTE)
6  KAPI — iki zincir
7  ÜÇ METRİK
8  ⛔ NE ÖLÇEMEDİN
```

---

## 9.9 · ⭐ ÜÇÜNCÜ TUR — BEYANIN BAĞLANMASI (`Z111 §16` §1–§2) · ikinci turun DUR'unun cevabı

### `9.9.0` · İKİNCİ TURUN DURUMU (şerit raporu, 2026-09-11 — Team Lead bağımsız doğrulaması bu turdan SONRA, son diff üzerinde)
```
İŞ 0  stdin (</dev/null) + migrations tablosu (timestamp, name) ile hash — İNDİ · gerçek HEAD 1833: 51 tablo sayıldı
İŞ 1  H ≠ S0 "revert etkisiz" · S0 ≠ A "migration etkisiz" · K_ENUM METİN kontrolü SİLİNDİ — İNDİ
İŞ 3  ## VIEWS (pg_get_viewdef) · ## FUNCTIONS (pg_get_functiondef + imza) — İNDİ
İŞ 4  S2–S6 — İNDİ
İŞ 2  BEYAN — ⛔ DUR: çıkış kodu A (ÖLÇEMEDİM) / B (yeni kod) / C (YEŞİL + uyarı)
      okuma yöntemi ÖLÇÜLDÜ: ts-node dinamik import() ile export okunuyor · ~1.1 s/çağrı · beyansız dosyada UNDECLARED
```

### `9.9.1` · DUR'UN CEVABI — `Z111 §16 §2` (ürün sahibi, 2026-09-11)
> ### **YENİ ÇIKIŞ KODU YOK.** Seçenek **C'nin sertleştirilmiş hâli**: YEŞİL + **ZORUNLU görünür satır**,
> ### ve satır push-order beyanına **taşınır**. Sessiz yeşil DEĞİL.

### `9.9.2` · İŞ — `§9.3` F12 tablosunu harness'a BAĞLA
```
BEYAN OKUMA   ts-node dinamik import() (§9.9.0'da ölçüldü) — metin araması YOK
              ⛔ import başarısızsa (derleme hatası, modül yok) → ÖLÇEMEDİM (beyan OKUNAMADI ≠ beyan YOK)

EXPORT                            KOŞUL                        ÇIKTI
REVERSIBILITY='IRREVERSIBLE_ADD'  H == S0                      YEŞİL (exit 0) + ZORUNLU satır:
  + REVERSIBILITY_REASON (metin)                                 "GERİ ALINAMAZ — beyanlı: <sebep>"
                                  ⛔ sebep boş/yok               → KIRMIZI ("beyan sebepsiz")
EFFECT='NONE_BY_DESIGN'           S0 == A                      YEŞİL + ZORUNLU satır: "etkisiz — beyanlı: assert-only"
EFFECT='DATA_CONDITIONAL'         migration "N etkilendi"      N = 0 → ÖLÇEMEDİM (exit 2) "koşul bu ortamda kurulamadı"
                                  sayacını basar               N > 0 → normal kontroller (H≠S0 · S0≠A · 0==2 · 1==3)
                                                               sayaç okunamazsa → ÖLÇEMEDİM
(beyan yok)                       H == S0 / S0 == A            KIRMIZI (bugünkü davranış — DEĞİŞMEZ)

⛔ BEYAN KAPSAMI DAR: IRREVERSIBLE_ADD yalnız H == S0'ı affeder — S0 ≠ A (up etkili) ve 1==3 (tekrarlanabilir)
   YİNE İSTENİR. NONE_BY_DESIGN yalnız S0 == A'yı affeder — H ≠ S0 ya da 0 ≠ 2 çıkarsa KIRMIZI (beyan YALAN).
   ⇒ her beyan için bir "beyan yalan" bilinen-kırmızısı (§9.9.4)
```
```
SAYAÇ SÖZLEŞMESİ (DATA_CONDITIONAL) — [ÖLÇÜLMEDİ — ölçülecek: iki şekil, ölçerek seç, gerekçesiyle]
  (a) migration up() stdout'a SABİT biçimli bir satır basar (ör. "MIGRATION_AFFECTED_ROWS=<N>"),
      harness run çıktısından okur — ⚠️ biçim bir SÖZLEŞME, serbest metin DEĞİL; tek satır, çapalı desen
  (b) migration kendi etkisini ölçülebilir bir yere yazar (ör. queryRunner.query sonucu rowCount) ve harness
      snapshot farkından N'yi TÜRETİR (S0 ↔ A DATA bölümü) — beyan yalnız "N = 0 meşru" der
  ⇒ (b) metinsiz; (a) açık. Hangisi TypeORM CLI çıktısında güvenilir — ÖLÇ
```
```
MAKİNE-OKUNUR SATIR   harness her beyanlı durumda AYRICA tek satır basar (push-order'ın okuyacağı):
                        HARNESS_DECLARED|<IRREVERSIBLE_ADD|NONE_BY_DESIGN|DATA_CONDITIONAL>|<sınıf adı>|<sebep/N>
                      ⛔ push-order.sh'a BAĞLAMA — o META repoda, Team Lead yazar (Z111 §16.3 AÇIK İŞ)
                      ⛔ MIGRATION_SEQUENCE ratchet'i YAZMA — Team Lead dosyası; ŞEKLİNİ ÖNER (hangi dosya, hangi guard zinciri)
```

### `9.9.3` · SINIRLAR — §5 ve §9.7 geçerli, ek olarak
```
⛔ çıkış kodu sözleşmesi DEĞİŞMEZ (0/1/2) — script başlığı :11-14 aynı kalır; beyan satırları başlığa BELGELENİR
⛔ "bilerek etkisiz up" için YENİ beyan türü ekleme — yalnız §9.9.2 tablosundaki üç export
⛔ İŞ 0/1/3/4'ün indiği kodu YENİDEN YAZMA — yalnız beyan dallarını ekle
```

### `9.9.4` · KAPANIŞIN KANITI — `Z83` (her beyan KOLU ayrı doğar — `DISIPLIN F04` "kontrol-kolu başına")
```
IRREVERSIBLE_ADD + sebep + boş down        → YEŞİL + "GERİ ALINAMAZ — beyanlı: <sebep>" + HARNESS_DECLARED satırı
IRREVERSIBLE_ADD + sebep YOK               → KIRMIZI "beyan sebepsiz"
IRREVERSIBLE_ADD + up ETKİSİZ (S0 == A)    → KIRMIZI (beyan up'ı affetmez)
NONE_BY_DESIGN + assert-only up            → YEŞİL + "etkisiz — beyanlı: assert-only"
NONE_BY_DESIGN + up aslında ETKİLİ         → KIRMIZI (beyan yalan)
DATA_CONDITIONAL + N = 0                   → ÖLÇEMEDİM
DATA_CONDITIONAL + N > 0 + doğru down      → YEŞİL
beyan import EDİLEMEZ (bozuk export)       → ÖLÇEMEDİM
REGRESYON                                  ikinci turun 9 fixture'ı AYNI renk · gerçek HEAD 1833 YEŞİL + "51 tablo"
TEMİZLİK                                   her koşum sonrası HEAD 1833 · 89 migration · 68 enum · sentetik 0
```

### `9.9.5` · `touches`
```
collmind.backend/scripts/migration-verify.sh
collmind.backend/scripts/verification/synthetic-datasource-declaration-*.ts        (gerekirse yeni)
collmind.backend/scripts/verification/synthetic-migrations/declaration-*/           (beyan kollarının fixture'ları)
```

### `9.9.6` · KAPANIŞ ÇIKTISI
```
1  DİFF — yalnız beyan dalları
2  SAYAÇ SÖZLEŞMESİ — (a) mı (b) mi, ölçüm + gerekçe
3  Z83 — §9.9.4'ün her satırı ÇIKTISIYLA
4  MAKİNE-OKUNUR SATIR — biçim + push-order/ratchet için ÖNERİ (yazılmadı)
5  KAPI — iki zincir
6  ÜÇ METRİK
7  ⛔ NE ÖLÇEMEDİN
```

---

## 9.10 · ⭐ DÖRDÜNCÜ TUR — **A** DÜZELTMESİ + BEYAN OKUMA SERTLEŞTİRMESİ (`Z111 §18`, 2026-09-11)

### `9.10.0` · ÜÇÜNCÜ TURUN DUR'U VE CEVABI
```
DUR   §9.9.2'nin "IRREVERSIBLE_ADD S0≠A'yı AFFETMEZ" kuralı YAPISAL OLARAK karşılanamaz:
      boş down() → S0 zaten "etki uygulanmış" · idempotent up() ikinci koşuda no-op → S0 == A HER ZAMAN
      [ÖLÇÜLDÜ: şerit, decl_known_after.log — EFFECT_HASH_S0 == EFFECT_HASH_A]
      ⚠️ o kural Z111 §16'da YOKTU — Team Lead'in brief eklemesiydi (§18 kayıt 1)
CEVAP Z111 §18 = A: beyan İKİ kontrolü birlikte affeder, kanıt sınırı çıktıda ADIYLA
```
⛔ **§9.9.2 ve §9.9.4'teki şu iki satır bu bölümle ÜSTÜNE YAZILDI:**
```
§9.9.2  "IRREVERSIBLE_ADD yalnız H == S0'ı affeder — S0 ≠ A … YİNE İSTENİR"   → ~~~~ (A: ikisini birlikte affeder)
§9.9.4  "IRREVERSIBLE_ADD + up ETKİSİZ (S0 == A) → KIRMIZI"                  → ~~~~ (A: bu vaka YEŞİL + iki satır)
```

### `9.10.1` · İŞ 1 — **A**
```
REVERSIBILITY='IRREVERSIBLE_ADD' ∧ REVERSIBILITY_REASON dolu:
  H == S0  VE/VEYA  S0 == A   → YEŞİL (exit 0) + İKİ ZORUNLU SATIR:
                                  "GERİ ALINAMAZ — beyanlı: <sebep>"
                                  "up etkisi bu döngüde ÖLÇÜLEMEZ — etki revert'ten sağ çıkıyor (harness sınırı)"
                                + HARNESS_DECLARED|IRREVERSIBLE_ADD|<sınıf>|<sebep>
  0 == 2 (revert tam) ve 1 == 3 (tekrarlanabilir) → YİNE İSTENİR (beyan bunları AFFETMEZ)
REVERSIBILITY_REASON boş/yok  → KIRMIZI "beyan sebepsiz" (DEĞİŞMEDİ)
```

### `9.10.2` · İŞ 2 — "BEYAN VAR AMA OKUNAMADI" → **ÖLÇEMEDİM** (`Z111 §18` ek hüküm + `§18.1 Y1`)
```
[ÖLÇÜLDÜ: migration-verify.sh:341-349] jq -r … 2>/dev/null ⇒ jq başarısızsa alan "" ⇒ "beyan YOK" dalı — SESSİZ DÜŞÜŞ
[ÖLÇÜLDÜ: migration-verify.sh:350-360] tanınmayan değer · çelişen kombinasyon ⇒ "?? … BEYANSIZ gibi işlem görecek"

DURUM                                          BUGÜN          OLACAK
jq başarısız (bozuk JSON, jq yok, rc≠0)        beyansız       ÖLÇEMEDİM (exit 2) — "beyan okunamadı (jq)"
JSON geçerli, iki alan da null/yok             beyansız       beyansız (DEĞİŞMEZ) — "beyan YOK" YALNIZ burada
tanınmayan değer (REVERSIBILITY='FOO' …)       beyansız+??    ÖLÇEMEDİM — "beyan tanınmıyor: <alan>=<değer>"   ⚠️ Y1, Team Lead yorumu
çelişen kombinasyon (REVERSIBILITY ∧ EFFECT)   beyansız+??    ÖLÇEMEDİM — "beyan çelişkili"                      ⚠️ Y1, Team Lead yorumu
```
⛔ **"beyan YOK" kararı jq'nun BOŞ çıktısından değil, jq'nun BAŞARIYLA okuduğu `null`'dan verilir** — her jq
çağrısının rc'si ayrı okunur (`cmd > dosya; rc=$?` — boruya sokma).

### `9.10.3` · KAPANIŞIN KANITI — `Z83` (her kol ayrı — `DISIPLIN F04` kontrol-kolu başına)
```
IRREVERSIBLE_ADD + sebep + boş down + idempotent up   → YEŞİL + iki zorunlu satır + HARNESS_DECLARED   (declaration-known)
IRREVERSIBLE_ADD + sebep YOK                          → KIRMIZI "beyan sebepsiz"                        (declaration-no-reason)
IRREVERSIBLE_ADD + sebep + up etkili + 0≠2 (bozuk)    → KIRMIZI (beyan 0==2'yi affetmez)                 ⭐ YENİ fixture
bozuk JSON / jq başarısız                              → ÖLÇEMEDİM                                       ⭐ YENİ (kopya + mutate + shasum-restore)
tanınmayan değer                                       → ÖLÇEMEDİM                                       ⭐ YENİ
çelişen kombinasyon                                    → ÖLÇEMEDİM                                       ⭐ YENİ
beyansız (iki alan null)                               → önceki davranış AYNEN                           (general-known-red: KIRMIZI)
⛔ declaration-irr-ineffective fixture'ı artık neyi kanıtlıyor — A ile anlamı DEĞİŞTİ ⇒ ya YEŞİL'e çevrilir ve
   adı düzeltilir, ya silinir: ÖLÇÜLEREK ve GEREKÇESİYLE (sessizce eski adla YEŞİL kalmasın — "ad ≠ mekanizma")
```
⛔ **Regresyon ve kapanış doğrulaması BU ŞERİDİN İŞİ DEĞİL** — Team Lead + code-reviewer son diff üzerinde yapar
(1833 yeniden · enum-dışı bilinen-kırmızı önce/sonra · 51 basılı · koşulmamış 5 fixture). Şerit yalnız §9.10.3'ün
KENDİ satırlarını koşar.

### `9.10.4` · HARNESS SINIRI — kayıt (`Z111 §18` kayıt 2)
```
geri alınamaz migration'ın up etkisi ANCAK taze DB'de ölçülür (S_pre → up) — bu harness'ın modeli DEĞİL
⇒ Faz-3 harness adayı: "taze-DB kolu" · bugün beyan sınırı yeter · ⛔ bu turda YAZILMAZ
⇒ harness başlığındaki beyan belgesine bir satır: "IRREVERSIBLE_ADD: up etkisi bu modelde ölçülemez"
```

### `9.10.5` · SINIRLAR · `touches`
```
touches   collmind.backend/scripts/migration-verify.sh · scripts/verification/synthetic-*declaration*
⛔ §5 · §9.7 · §9.9.3 geçerli · çıkış kodu 0/1/2 DEĞİŞMEZ · yeni beyan türü YOK · push-order.sh / MIGRATION_SEQUENCE YAZILMAZ
```

### `9.10.6` · KAPANIŞ ÇIKTISI
```
1  DİFF — A dalı · jq rc ayrımı · tanınmayan/çelişen → ÖLÇEMEDİM
2  Z83 — §9.10.3'ün her satırı ÇIKTISIYLA
3  declaration-irr-ineffective'in kaderi — ölçüm + gerekçe
4  KAPI — iki zincir
5  ÜÇ METRİK
6  ⛔ NE ÖLÇEMEDİN
```

---

## 9.11 · ⭐ BEŞİNCİ TUR — SON REVIEW'UN KARARSIZ BULGULARI (Team Lead, 2026-09-11)

### `9.11.0` · DURUM — dördüncü tur indi; Team Lead bağımsız doğrulaması + code-reviewer
```
[ÖLÇÜLDÜ: Team Lead doğrulama betiği, scratchpad harness-verify/tl-verify.sh — 20 vaka, SIRALI, her vaka sonrası durum]
  PRE  (HEAD harness kopyası)  general-known-red rc=0 · data-known-red rc=0          → düzeltme ÖNCESİ YEŞİL (beklenen)
  POST general-known-red 1 · data-known-red 1 · up-noop-known-red 1 · enum-known-red 1 · enum-known-green 0 ·
       view-only-known-green 0 · declaration-known 0 (+ iki zorunlu satır + HARNESS_DECLARED) · declaration-no-reason 1 ·
       declaration-irr-both-noop 0 · declaration-irr-repeat-break 1 · declaration-nbd-green 0 · declaration-nbd-red 1 ·
       declaration-data-zero 2 · declaration-data-nonzero 0 · declaration-unrecognized 2 · declaration-conflict 2 ·
       null-collapse 1 (K4) · GERÇEK HEAD 1833 0                                    → 20 / 20 TUTTU
  her vaka sonrası HEAD 1833 · 89 migration · 68 enum · 51 tablo · sentetik 0
  ⚠️ KALINTI: general-known-red (PRE ve POST, iki koşumda da) belgelenen "revert x1" sonrası
     _mv_synthetic_general_red_table BIRAKTI — boş down(); başka hiçbir set kalıntı bırakmadı
⛔ code-reviewer: review TEMİZ DEĞİL — 3 blocker (B-1 kararsız · B-2/B-3 ürün sahibi DUR'u) + S-1…S-10 + nit
```

### `9.11.1` · ⛔ BU TURUN DIŞINDA — ürün sahibi kararı bekliyor (koda DOKUNMA)
```
B-2  NONE_BY_DESIGN + idempotent up + boş down → H==S0 ∧ S0==A → YEŞİL "assert-only" (etkili migration geçer;
     "beyan sebepsiz" kapısı dolanılır) — (a) "ölçülemez" satırı · (b) sebep zorunlu · (c) ÖLÇEMEDİM
B-3  IRREVERSIBLE_ADD "VE/VEYA": H≠S0 ∧ S0==A da YEŞİL — "etki revert'ten sağ çıkıyor" satırı o durumda YANLIŞ;
     harness sonu DB ≠ H — (a) af H==S0'a bağlanır · (b) effect(H)==effect(snapshot3) kontrolü
     + beyanlı ama aslında geri alınabilir (H≠S0 ∧ S0≠A) → bugün bilgi satırıyla YEŞİL (bayat beyan)
⇒ migration-verify.sh'ta NONE_BY_DESIGN ve IRREVERSIBLE_ADD KARAR DALLARI bu turda DEĞİŞMEZ
```

### `9.11.2` · İŞ — kararsız bulgular (reviewer satır numaraları dördüncü tur sonrası diff'e göre)
```
B-1  "N tablonun rowcount'u alındı" satırı LİSTE uzunluğu (:440, :461, :1151) — döngünün TUR sayısı DEĞİL
     ⇒ rowcounts_snapshot ve DATA döngüsünün YAZDIĞI satır sayısını ölç; TABLE_COUNT'a eşit değilse ÖLÇEMEDİM;
       basılan sayı BU ölçüm olur
     ⇒ stdin düzeltmesinin DAVRANIŞSAL bilinen-kırmızısı: </dev/null'ı mutate.sh ile kaldır → harness ÖLÇEMEDİM
       ("taranan 1 ≠ 51") vermeli · data-known-red bunu AYIRT ETMEZ (iki hâlde de H==S0 kırmızısı)
S-1  "beyan YOK" dalına null dışı değerler düşüyor (:353-375): REVERSIBILITY='' · EFFECT='null' (string) ·
     REVERSIBILITY=false · sahipsiz REVERSIBILITY_REASON ⇒ jq has()/type ile ayır; bunlar → ÖLÇEMEDİM
S-2  sebepte satır sonu ya da '|' HARNESS_DECLARED satırını bozuyor (:840) ⇒ → ÖLÇEMEDİM (kaçış kuralı YAZMA)
S-3  HARNESS_DECLARED 0==2 / 1==3'ten ÖNCE basılıyor (:840, :847, :895) ⇒ değişkende tut, NİHAİ YEŞİL'den hemen önce bas
S-4  MIGRATION_AFFECTED_ROWS birden çok kez basılırsa SON satır kazanıyor (:863-869) ⇒ eşleşme sayısı ≠ 1 → ÖLÇEMEDİM
S-5  başlıkta beyan sözleşmesi YOK: üç export · HARNESS_DECLARED biçimi · MIGRATION_AFFECTED_ROWS · ve §9.10.4'ün
     "IRREVERSIBLE_ADD: up etkisi bu modelde ölçülemez" satırı (dördüncü tur YAZMADI — brief'i yanlış okudu)
S-6  başlıktaki fixture notları eksik/yanlış (:48-72 sınıf adıyla çağrı öğretiyor · :108-109 "data-zero temizliğe gerek
     yok" YANLIŞ · conflict/unrecognized/irr-repeat-break kayıtsız) + ⭐ Team Lead ölçümü: general-known-red'in
     "revert x1" temizliği tabloyu BIRAKIYOR ⇒ her set için ÖLÇÜLMÜŞ temizlik adımı (gerekiyorsa DROP, CASCADE'SİZ)
S-7  fixture yorumları A öncesi mantığı anlatıyor (declaration-known 9081/9082 · datasource-declaration-known.ts:3 ·
     9132 "RETURNING'li DML" — §18.1 T1'e göre KOMUT TİPİ · var olmayan _tmp_test_query_shape.ts atfı)
S-8  ad ≠ mekanizma: declaration-irr-repeat-break adı 1==3 diyor, kırmızısı 0≠2'den ⇒ ADI düzelt ·
     declaration-nbd-red H≠S0 kolunda; S0≠A "beyan yalan" kolunun bilinen-kırmızısı YOK ⇒ o kola ayrı fixture (F04)
     + EFFECT tanınmayan değer kolunun fixture'ı YOK ⇒ ekle
S-9  sorgusu başarısız tablo iki snapshot'ta da "ERR" yazılıp EŞİT sayılıyor (:452, :547) ⇒ to_regclass ile
     "tablo yok" ayrı işaretlenir; başka her sorgu hatası → ÖLÇEMEDİM
NIT  view/fonksiyon tanımı boşluk sıkıştırması string literal içindeki farkı yutuyor (:518, :523) ⇒ md5(pg_get_viewdef)
     · npx ts-node → node_modules/.bin/ts-node ya da npx --no-install (ağdan indirme riski) · "beyan sebepsiz"
     kırmızısında red() DB'ye dokunulmamışken "DB OLASI YARIM" diyor (:390) ⇒ o erken çıkışta mesaj doğru olsun ·
     read-declaration.ts catch (e: any) eslint uyarısı
```

### `9.11.3` · İŞ — S-10 ÖLÇÜMÜ (1835/1838 ÖNCESİ ZORUNLU, düzeltme DEĞİL)
```
[REVIEW İDDİASI — DOĞRULANMADI, koddan izlendi] 51 tablo artık gerçekten hash'leniyor ve t::text serial/uuid/now()
  değerlerini içeriyor ⇒ INSERT eden ya da updated_at = now() yazan her migration'da run1 ≠ run2 ⇒ 1==3 HER SEFER KIRMIZI
⇒ ÖLÇ: iki sentetik — (i) up() bir tabloya INSERT (serial id) + doğru down() · (ii) up() UPDATE … SET updated_at = now()
  + doğru down() → harness sonucu ve farkın hangi kolondan geldiği
⇒ ÇIKTI bir ÖLÇÜM ve ÖNERİ: kırmızı çıkarsa çözüm seçenekleri (ör. DATA hash'inde volatil kolonların maskelenmesi ·
  migration-başına beyan · 1==3'ün veri kolunu şema koluyla ayırmak) — ⛔ UYGULAMA YOK, Team Lead'e liste
```

### `9.11.4` · KAPANIŞIN KANITI — `Z83`
```
B-1   stdin mutasyonu → ÖLÇEMEDİM "taranan 1 ≠ 51" (mutate.sh, YAKALANDI) · düzeltilmiş hâl → "taranan 51"
S-1   dört vaka (boş string · "null" string · false · sahipsiz sebep) → ÖLÇEMEDİM
      ⭐ F12 (Z111 §24 K2): "boş string" TİP alanı içindir · SEBEP alanında boş/yalnız-boşluk → KIRMIZI "beyan sebepsiz" — §9.14 sonu şerh
S-2   sebepte satır sonu · sebepte '|' → ÖLÇEMEDİM
S-3   declaration-irr-repeat-break → KIRMIZI ve çıktıda HARNESS_DECLARED YOK
S-4   sayaç iki kez basılır → ÖLÇEMEDİM
S-8   yeni: NONE_BY_DESIGN S0≠A "beyan yalan" kolu → KIRMIZI · EFFECT tanınmayan değer → ÖLÇEMEDİM
S-9   sorgusu başarısız tablo → ÖLÇEMEDİM · down'un drop ettiği tablo → "tablo yok" (eşit SAYILMAZ)
REGR  §9.11.0'ın 20 vakası AYNI sonuç — ⛔ bu turda şerit KENDİSİ koşar (kalıntı süpürmesi dahil, her set sonrası
      HEAD 1833 · 89 · 68 · 51 · sentetik 0) — Team Lead betiği emsal: scratchpad değil, şerit kendi scriptini yazar
S-10  §9.11.3 ölçüm çıktısı
```

### `9.11.5` · SINIRLAR · `touches`
```
touches  collmind.backend/scripts/migration-verify.sh · scripts/verification/read-declaration.ts ·
         scripts/verification/synthetic-* (yorum/ad düzeltmeleri, yeni kol fixture'ları, S-10 sentetikleri)
⛔ §9.11.1: NONE_BY_DESIGN ve IRREVERSIBLE_ADD KARAR DALLARI DEĞİŞMEZ
⛔ §5 · §9.7 · §9.9.3 · §9.10.5 geçerli · çıkış kodu 0/1/2 · yeni beyan türü YOK · push-order.sh / MIGRATION_SEQUENCE YAZILMAZ
⛔ gerçek zincire dokunma · ürün şemasına kalıcı iz YOK · DROP yalnız _mv_synth önekli sentetik nesnelere, CASCADE'SİZ
```

### `9.11.6` · KAPANIŞ ÇIKTISI
```
1  DİFF — B-1 · S-1…S-9 · nit, her biri ayrı
2  Z83 — §9.11.4'ün her satırı ÇIKTISIYLA
3  S-10 — ölçüm + seçenek listesi (uygulanmadı)
4  KAPI — iki zincir
5  ÜÇ METRİK
6  ⛔ NE ÖLÇEMEDİN
```

---

## 9.12 · ⭐ ALTINCI TUR — B-2 · B-3 · BAYAT BEYAN (`Z111 §19`, 2026-09-11) · ⛔ BEŞİNCİ TUR İNDİKTEN SONRA

### `9.12.0` · HÜKÜM
```
B-2  NONE_BY_DESIGN → sebep ZORUNLU + YEŞİL'e "up etkisi bu döngüde ÖLÇÜLEMEZ" satırı + MIGRATION_SEQUENCE listesi (ratchet)
     (c) — ÖLÇEMEDİM — REDDEDİLDİ: meşru assert-only koşumlarını gürültüye çevirir
B-3  IRREVERSIBLE_ADD affı YALNIZ H == S0 · H ≠ S0 ∧ S0 == A → KIRMIZI "yarım down"
     + beyandan BAĞIMSIZ son kontrol: başlangıç (H) == son snapshot — "harness iz bırakmaz"
BAYAT IRREVERSIBLE_ADD beyanlı ama H ≠ S0 ∧ S0 ≠ A (aslında geri alınabilir) → KIRMIZI "bayat beyan"
     (ölçüm tam — ÖLÇEMEDİM değil; beyan düzeltilir, listeden düşer)
```

### `9.12.1` · İŞ
```
B-2   EFFECT='NONE_BY_DESIGN' için sebep export'u: EFFECT_REASON
        [ÖLÇÜLMEDİ — ölçülecek: read-declaration.ts'in bu export'u okuyup okumadığı; okumuyorsa ekle]
      EFFECT_REASON boş/yok                     → KIRMIZI "beyan sebepsiz" (IRREVERSIBLE_ADD ile AYNI kapı)
      S0 == A (beyan geçerli)                    → YEŞİL + "etkisiz — beyanlı: <EFFECT_REASON>"
                                                   + "up etkisi bu döngüde ÖLÇÜLEMEZ — etki revert'ten sağ çıkabilir (harness sınırı)"
                                                   + HARNESS_DECLARED|NONE_BY_DESIGN|<sınıf>|<sebep>
      H ≠ S0 ya da S0 ≠ A                        → KIRMIZI "beyan yalan" (DEĞİŞMEZ)
B-3   IRREVERSIBLE_ADD + sebep:
      H == S0                                    → YEŞİL + iki zorunlu satır (DEĞİŞMEZ)
      H ≠ S0 ∧ S0 == A                           → KIRMIZI "yarım down — down() bir şey geri aldı, up() onu yeniden uygulamadı"
      H ≠ S0 ∧ S0 ≠ A                            → KIRMIZI "bayat beyan — migration geri alınabilir, IRREVERSIBLE_ADD beyanı yanlış"
SON KONTROL (beyandan bağımsız) effect(H) == effect(son snapshot) → aksi KIRMIZI "harness iz bıraktı"
      ⛔ BAĞ (Z111 §19.1): bu kontrol INSERT'li migration'da volatil kolonlara (uuid · zaman · sequence) takılır ⇒
         S-10 volatil maskesi OLMADAN yanlış KIRMIZI üretir ⇒ SON KONTROL, S-10 hükmü verildiğinde AYNI turda iner.
         Bu turda: kontrolü YAZ ama volatil maske yoksa ÖLÇEMEDİM "son kontrol volatil kolon maskesi bekliyor" basıp
         kararını ertele — ya da S-10 hükmü bu turdan önce gelirse maskeyle birlikte uygula. ⛔ Hangisi olduğu raporda ADIYLA.
```

### `9.12.2` · S-10 ÖN-HÜKÜM YÖNÜ (`Z111 §19`) — beşinci turun ölçümü + seçenek listesiyle KESİNLEŞİR

> ### ⭐ `F12` — `Z111 §20` (2026-09-11) S-10 HÜKMÜ VERİLDİ · aşağıdaki ön-hüküm bloğunun ÜSTÜNE YAZAR
> ```
> VOLATİL MASKE   hash'ten dışlanan kolonlar = volatil default'lu kolonlar (TÜRETİLMİŞ, desen YOK — G5)
>                 satır SAYIMI maskelenmez · maskelenen kolonlar çıktıda LİSTELENİR ("n kolon maskelendi")
> SINIR           maskelenen kolonda gerçek değişim ölçülemez — harness şema + satır-yapısını doğrular (adıyla, çıktıda)
> BAŞLANGIÇ==SON  maskeyle birlikte iner; maske yoksa ÖLÇEMEDİM
> ```
> ⛔ **DUR — ÖLÇÜT (`Z111 §20.1` N14/N15, ürün sahibi kararı bekleniyor):** hüküm metni `provolatile = 'v'` diyor;
> ```
> [ÖLÇÜLDÜ: pg_proc] now() 's' · transaction_timestamp 's' — STABLE · CURRENT_TIMESTAMP bir SQLVALUEFUNCTION düğümü
> [ÖLÇÜLDÜ: pg_depend] yerleşik fonksiyonlara (now, nextval) bağımlılık kaydı YOK — yalnız eklenti uuid_generate_v4
> (A) funcid'ler adbin düğüm ağacından + provolatile IN ('v','s') ∨ SQLVALUEFUNCTION → 145 kolon  ← Team Lead önerisi
> (B) yalnız provolatile='v'                                               →  49 kolon (96 zaman kolonu maskesiz)
> (C) (B) + pg_depend izi                                                  →  48 kolon (nextval da düşer)
> ```
> ⇒ **altıncı tur maskeyi ölçüt kararı gelmeden YAZMAZ.** Karar gelmezse: B-2/B-3/bayat beyan iner, maske ve
> "başlangıç == son" ÖLÇEMEDİM ile ertelenir (§9.12.1'deki erteleme yolu) — raporda ADIYLA.
> ⛔ **N16:** varsayılansız `updated_at` bir VIEW kolonu (`v_budget_summary`) — harness'ta özel durum GEREKMEZ, T-351'e de girmez.

> ### ⭐ `F12` #2 — `Z111 §21` (2026-09-11): ÖLÇÜT **(A) ONAYLI** · yukarıdaki DUR KAPANDI (pin şekli hariç)
> ```
> VOLATİL KOLON   pg_attrdef.adbin düğüm ağacındaki ':funcid N' → pg_proc.provolatile ∈ {'v','s'}
>                 ∨ ağaçta SQLVALUEFUNCTION düğümü · YALNIZ relkind='r' (view kolonu hiçbir zaman — F02)
>                 [ÖLÇÜLDÜ: main, sentetik hariç] 145 kolon · 49 tablo · 4 ifade türü
>                 (CURRENT_TIMESTAMP 74 · uuid_generate_v4() 48 · now() 22 · nextval(migrations_id_seq) 1)
>                 ⛔ metin/ad deseni YOK — pg_get_expr() çıktısı SINIFLANDIRMADA kullanılmaz (yalnız ÇIKTI listesinde)
> MASKE           DATA hash'i bu kolonları DIŞLAR · satır SAYIMI maskelenmez
> GÖRÜNÜR MASKE   her koşumda: "N kolon maskelendi" + LİSTE (tablo.kolon · ifade türü) — sessiz değil
> SINIR (çıktıda) "maskelenen kolonda gerçek değişim ölçülemez — harness şema + satır-yapısını doğrular"
> BAŞLANGIÇ==SON  maskeli effect(H) == effect(son snapshot) — maskeyle AYNI turda iner
> ```
> ```
> SINIR 2 GÜVENCESİ — CANLILIK PROBU (Z111 §21.1 N18: harness'ın self-test modu YOK ⇒ Team Lead teknik kararı, adıyla)
>   harness HER KOŞUMDA, geri alınan bir transaction içinde (BEGIN … ROLLBACK):
>     geçici tablo: DEFAULT CURRENT_TIMESTAMP · DEFAULT now() · DEFAULT gen_random_uuid() ya da uuid_generate_v4() ·
>                   DEFAULT nextval(<geçici sequence>) · kontrol: DEFAULT 'SABIT'::text · DEFAULT 0
>     → aynı sınıflandırıcıyla ayrıştır → beklenen: dört volatil + iki volatil DEĞİL
>     → farklıysa ÖLÇEMEDİM "adbin düğüm ayrıştırması bu Postgres sürümünde beklenen sonucu vermiyor"
>   + Postgres sürümü (version(), server_version_num) HER koşumda BASILIR
>   ⛔ prob ÜRÜN şemasına iz BIRAKMAZ — ROLLBACK sonrası durum kontrolü (pg_class / pg_type sayıları öncesi == sonrası)
>   [ÖLÇÜLMEDİ — ölçülecek: geçici (TEMP) tablo mu main'de rollback'li tablo mu — pg_attrdef TEMP tablo için de dolar mı]
> ```
> ```
> ⛔ DUR — PİN ŞEKLİ (Z111 §21.1 N17, ürün sahibi kararı bekleniyor)
>   hüküm: "maskelenen kolon SAYISI 145" pinli
>   [ÖLÇÜLDÜ] 46/49 tablo 3 maskeli kolon ⇒ yeni tablo ekleyen HER migration sayıyı +3 değiştirir ⇒ pin ayırt etmez
>   Team Lead önerisi: pin = maskelenen İFADE TÜRÜ kümesi (bugün 4); sayı yalnız bilgi
>   ⇒ bu turda: sınıflandırıcı + görünür liste + canlılık probu İNER; PİN YAZILMAZ (şekil kararı gelince ayrı küçük adım)
> ```
>
> ⭐ **`F12` #3 — `Z111 §22` (2026-09-11): N17 KAPANDI** · pin = maskelenen ifade-türlerinin KÜMESİ, sayı yalnız bilgi.
> **Altıncı turda HÂLÂ yazılmaz** — ayrı küçük adım, reviewer + bağımsız doğrulamadan SONRA: **§9.13**.
> "Tür" kimliği = **kolon başına imza** (`Z111 §22.1` N19 (iii)) — fonksiyon-başı küme sınır-1'i kaçırıyor (ölçüldü).
> ```
> KANIT (§9.12.3'e EK — Z83)
>   MASKE ÖNCESİ/SONRASI  sentetik: up() bir tabloya INSERT (uuid/serial + CURRENT_TIMESTAMP) + DOĞRU down()
>                         düzeltme ÖNCESİ (maskesiz) → KIRMIZI 1≠3 (volatil kolondan) · SONRASI → YEŞİL + "N kolon maskelendi"
>   BAŞLANGIÇ==SON        sentetik yarım-down → KIRMIZI "harness iz bıraktı" (maskeli karşılaştırma)
>   CANLILIK PROBU        sınıflandırıcı mutate.sh ile bozulur (ör. 's' dışlanır) → prob ÖLÇEMEDİM (YAKALANDI)
>   SÜRÜM                 çıktıda "PostgreSQL 16.15" satırı
> ```
```
volatil kolon listesi TÜRETİLİR — elle liste YASAK (G5)
  kaynak: information_schema.columns.column_default
  hüküm deseni: nextval | now | CURRENT_TIMESTAMP + updated_at sınıfı
  ⚠️ Z111 §19.1 N13 [ÖLÇÜLDÜ]: uuid üreticileri (uuid_generate_* · gen_random_uuid) 48 kolon · 48 tablo — DESENDE YOK;
     INSERT'li her migration her koşumda yeni uuid üretir ⇒ türetme bunları KAPSAMALI (ürün sahibinin F12'si bekleniyor)
  ⚠️ updated_at: 48 kolonun 47'sinde default now() — 1 kolon default'suz; ad-tabanlı seçim bir PROXY'dir (F00), ölçerek ele al
hash bu kolonları DIŞLAR
```

### `9.12.3` · KAPANIŞIN KANITI — `Z83` (her kol ayrı)
```
NONE_BY_DESIGN + EFFECT_REASON + assert-only          → YEŞİL + iki satır + HARNESS_DECLARED (declaration-nbd-green güncellenir)
NONE_BY_DESIGN + EFFECT_REASON YOK                     → KIRMIZI "beyan sebepsiz"                    ⭐ YENİ fixture
NONE_BY_DESIGN + idempotent up + boş down (B-2 vakası)  → YEŞİL + "ÖLÇÜLEMEZ" satırı (dolanma GÖRÜNÜR, sessiz değil)  ⭐ YENİ
IRREVERSIBLE_ADD + H ≠ S0 ∧ S0 == A                    → KIRMIZI "yarım down"                        ⭐ YENİ
IRREVERSIBLE_ADD + H ≠ S0 ∧ S0 ≠ A                     → KIRMIZI "bayat beyan"                       ⭐ YENİ
SON KONTROL: harness sonu ≠ H (sentetik)               → KIRMIZI "harness iz bıraktı" — ya da maske yoksa ÖLÇEMEDİM (adıyla)
REGRESYON                                              beşinci turun vaka listesi AYNI sonuç (kalıntı süpürmesi + durum kontrolü)
```

### `9.12.4` · SINIRLAR · ÇIKTI
```
touches  collmind.backend/scripts/migration-verify.sh · scripts/verification/read-declaration.ts · scripts/verification/synthetic-*
⛔ §5 · §9.7 · §9.9.3 · §9.10.5 · §9.11.5 geçerli · çıkış kodu 0/1/2 · MIGRATION_SEQUENCE / push-order.sh YAZILMAZ
ÇIKTI    1 DİFF · 2 Z83 (§9.12.3 çıktısıyla) · 3 SON KONTROL: maskeyle mi ÖLÇEMEDİM'le mi — adıyla · 4 KAPI · 5 ÜÇ METRİK · 6 ⛔ NE ÖLÇEMEDİN
```

### `9.12.5` · ⭐ BEŞİNCİ TUR İNDİ — BU TURUN BAŞLANGIÇ DURUMU (şerit raporu, 2026-09-11; Team Lead bağımsız doğrulaması altıncı turdan SONRA, son diff'te)
```
B-1   taranan satır sayısı ölçülüyor · stdin mutasyonu → ÖLÇEMEDİM "taranan 1 ≠ 51"
S-1…S-9 · nit   İNDİ (md5 view/fonksiyon tanımı · node_modules/.bin/ts-node · DB_TOUCHED mesajı · catch unknown)
ADLAR  declaration-irr-repeat-break → declaration-irr-nonidempotent-up (YENİDEN ADLANDIRILDI)
YENİ   declaration-nbd-s0a-red (NONE_BY_DESIGN S0≠A "beyan yalan" kolu) · declaration-effect-unrecognized
S-10   ÖLÇÜLDÜ: s10-insert-serial · s10-update-now — ikisi de DOĞRU down() taşıyor, ikisi de KIRMIZI 1≠3 (## DATA),
       0==2 sağlam ⇒ reviewer iddiası DOĞRULANDI · şeridin seçenek listesi Z111 §20–§21 hükmüyle GEÇERSİZ (A seçildi)
REGR   beşinci turun kendi koşumu: önceki 20 vaka + 2 yeni kol · gerçek HEAD 1833
```
```
⭐ BU TURDA KULLAN
  MASKE ÖNCESİ/SONRASI bilinen-kırmızısı HAZIR: s10-insert-serial · s10-update-now
    maske ÖNCESİ (beşinci tur kodu) → KIRMIZI 1≠3 · maske SONRASI → YEŞİL + "N kolon maskelendi" + liste
    ⚠️ bu iki fixture artık ÖLÇÜM değil KANIT: adları mekanizmayı söylüyor mu — "ad ≠ mekanizma" (F06); gerekirse
       adlandır (ör. mask-insert-serial-known-green) ve başlıktaki çağrı notlarını güncelle
  REGRESYON listesi: beşinci turun listesi + declaration-nbd-s0a-red + declaration-effect-unrecognized
    + altıncı turun yeni kolları (§9.12.3) + s10 iki fixture (maske sonrası YEŞİL)
```
⛔ **Beşinci turun raporundaki "geri alma planı: `git checkout -- scripts/migration-verify.sh`" satırı KURAL İHLALİDİR** —
`git checkout` YASAK (`CLAUDE.md §3` · `§5.1`): tracked dosyada commit edilmemiş işi siler. Geri alma yalnız
**kopya + `shasum -a 256 -c`** ile; bu turun raporunda böyle bir öneri YAZILMAZ.

### `9.12.6` · ⭐ ALTINCI TUR İNDİ — BAĞIMSIZ DOĞRULAMA + REVIEWER (Team Lead, 2026-09-11) · ⛔ PİN ADIMINDAN ÖNCE YEDİNCİ TUR ÖNERİLİR
```
ŞERİT     ilk deneme API kotasıyla düştü (DEĞİŞİKLİK YOK — dört ölçüm) · yeniden koşum indi
          migration-verify.sh sha256 128cf938…→0b861963… · read-declaration.ts 9cf3b15d…→95dfb087…
          yeni setler: declaration-irr-halfdown-red · declaration-irr-stale-red · declaration-nbd-no-reason
          nbd-red / nbd-s0a-red'e EFFECT_REASON eklendi (aksi "beyan sebepsiz"e düşüp "beyan yalan" kolunu sınamazlardı)
⛔ İHLAL   raporun geri-alma planı "git restore … ile geri alınabilir" — tracked dosyada git checkout ile AYNI etki
          (commit edilmemiş işi siler) · §9.12.5 uyarısının İKİNCİ vakası · uygulanmadı
```
**TL BAĞIMSIZ DOĞRULAMA** — `scratchpad/harness-verify/tl-verify-r6.sh` · 29/29 TUTTU · harness sha başta==sonda · `.tl-*` 0 · taban aynı
```
MUT probe-s (probdan 's' dışlandı, satır 410 BASILDI) · REAL 1833  rc=2  ÖLÇEMEDİM "volatil=3" (beklenen 4)       ✓ prob-kırma
MUT mask-s  (MASKEDEN 's' dışlandı, satır 863)        · REAL 1833  rc=0  prob "✓ 4/2" · maske 145→123 · YEŞİL
            ⇒ ⛔ İKİNCİ KOPYA DAVRANIŞSAL KANITLANDI: asıl sınıflandırıcı bozuldu, prob GÖRMEDİ (§2.7 #8 · reviewer BLOCKER-2)
MUT mask-off (WHERE false, satır 863) · s10-insert-serial        rc=1  "snapshot1 ≠ snapshot3"                  ✓ maske ÖNCESİ
s10-insert-serial (maske SONRASI)                                  rc=0  YEŞİL · SON KONTROL ✓                    ✓ maske SONRASI
SON KONTROL bilinen-kırmızı: s10-insert-serial + ön-kanca (aynı etiketli İKİNCİ satır — down ikisini siler, replay birini koyar)
                                                                   rc=1  "harness iz bıraktı"                     ✓ (H≠S1 ∧ 0==2 ∧ 1==3)
declaration-irr-halfdown-red  rc=1 "yarım down" ✓ · declaration-irr-stale-red rc=1 "bayat beyan" ✓
declaration-nbd-no-reason     rc=1 "beyan sebepsiz" (DB dokunulmadan) ✓ · nbd-green rc=0 + "ÖLÇÜLEMEZ" + HARNESS_DECLARED ✓
regresyon: general/data/up-noop/enum-known-red 1 · enum/view-only-known-green 0 · declaration-known 0 · no-reason 1 ·
           irr-both-noop 0 · irr-nonidempotent-up 1 ("snapshot0 ≠ snapshot2") · nbd-red 1 · nbd-s0a-red 1 · data-zero 2 ·
           data-nonzero 0 · unrecognized 2 · conflict 2 · effect-unrecognized 2 · s10-update-now 1 · nullcollapse 1 (K4)
REAL 1833 rc=0 · PG 16.15 (160015) basıldı · maske 145 · SON KONTROL ✓
⚠️ general-known-red kalıntısı (_mv_synthetic_general_red_table) — BİLİNEN, belgelenen temizlik boş down'u kapsamıyor
⚠️ sentetik koşumlarda maske 146, gerçek koşumda 145 — [ÖLÇÜLDÜ: iki koşumun maske LİSTESİ diff'lendi] fark TEK satır:
   _mv_synthetic_enum_green_table.id · nextval('main._mv_synthetic_enum_green_table_id_seq') — sentetik setin kendi serial'ı
   ⇒ maske türetiminde AD FİLTRESİ YOK (sentetik tablolar maskeye GİRER) — §9.13.2 (b) ve Z111 §23.1 N21 için veri noktası
```
**REVIEWER** (code-reviewer, salt-okuma) — **temiz DEĞİL**
```
🔴 B1  :913 maskeli hash row_text üzerinden, sıralama ORDER BY t::text (maskeli uuid dahil TAM satır)
       ⇒ uuid-PK'li tabloya ≥2 satır ekleyen up() → S1/S3 sırası değişir → ARALIKLI "1≠3" / "harness iz bıraktı"
       [reviewer ÖLÇTÜ: aynı ifade, 10 koşumda 2 farklı hash; ORDER BY row_text 5/5 tek hash] [TL: kod okundu, DOĞRU]
       s10-insert-serial TEK satır ekler ⇒ yanlış şekilli kanıt (§2.7 #6)
🔴 B2  prob (:408-413) sınıflandırıcının İKİNCİ kopyası + farklı yüzey (pg_my_temp_schema, relkind yok) — TL mutasyonu DOĞRULADI
       + probun negatifleri funcid TAŞIMIYOR ⇒ 'i' genişlemesini göremez [reviewer ÖLÇTÜ: 45 kolon yalnız immutable funcid]
🟡 D1  prob SQLVALUEFUNCTION kolunu ayrıca sınamıyor — timestamp kolonda cast funcid'i zaten yakalıyor (a → timestamptz)
🟡 D2  pg_class/pg_type sayımı: rc okunmuyor, "" == "" → "iz yok" · paralel oturum → red (ÖLÇEMEDİM olmalı) · DB_TOUCHED=0 mesaj çelişkisi
🟡 D3  :904 grep rc'siz → hata "tamamı maskeli/COUNT_ONLY"a düşer · mask-fully-masked-tables.txt HİÇ basılmıyor (görünür maske ihlali)
🟡 D4  shasum|awk boş hash eşitliği → IRREVERSIBLE_ADD affı / SON KONTROL ✓ (eşitlik varlığın kanıtı değil)
🟡 D5  SON KONTROL mesajı tek sebep söylüyor ("harness iz bıraktı") — ulaşılabilen sebep: ilk uygulama ≠ harness replay'i
       (TL bilinen-kırmızısı bunu kurdu; fixture kalıcılaşmalı)
🟡 D6  §9.12.3 "dolanma-görünür" fixture'ı YOK (NONE_BY_DESIGN + idempotent etkili up + boş down)
🟡 D7  DATA döngüsünün taradığı tablo sayısı ölçülmüyor (B-1 yalnız rowcounts'ta)
🟡 D8  sebep kapısı boşlukla aşılıyor ('   ' → YEŞİL) · boş dizge: S-1 ÖLÇEMEDİM ↔ §9.12.1 KIRMIZI çelişkisi
🔵    başlık fixture listesi eksik · s10 fixture yorumları bayat ("BEKLENEN KIRMIZI") · sürüm satırı prob rc'siz ·
       :1175 "✓ beyan GEREKMEDİ" ardından kırmızı · array_to_string '|' kaçırmıyor (çakışma) · kodda sabit sayılar
       (1833·89·68·51 · 145·49) · SON KONTROL mesajındaki sayı S3'ün · read-declaration.ts:3 "npx" yorumu ·
       main dışı fonksiyon volatilite değişimi hash'e girmiyor (uzak)
```
**⛔ KARAR DEĞİL — ürün sahibine**
```
K1  s10-update-now kapsamı — maske DEFAULT-türevli (Z111 §20); migration gövdesindeki `SET updated_at = now()` KAPSAMDA DEĞİL
    [ÖLÇÜLDÜ] maskeyle de rc=1 "1≠3" · §9.12.5'teki "ikisi de YEŞİL" cümlesi Team Lead'in ÖLÇÜLMEMİŞ varsayımıydı (F00)
    (a) kapsam DEĞİŞMEZ — fixture bilinen-kırmızı, adı mekanizmayı söyler (F06)  (b) kapsam genişler — yeni hüküm
    reviewer gözlemi: uuid PK'ye bağlı FK kolonları maskesiz [reviewer ÖLÇTÜ: 147 FK] ⇒ parent+child ekleyen migration maskeyle
    de KIRMIZI · N16'ya göre main'de default'suz tablo updated_at yok — bu fixture bugünkü şemada olmayan bir şekli sınıyor
K2  boş sebep dizgesi: S-1 (§9.11) ÖLÇEMEDİM mi, §9.12.1 "boş/yok → KIRMIZI beyan sebepsiz" mi — iki hüküm çelişiyor
    (yalnız-boşluk sebebin REDDİ her iki okumada gerekli — karar değil, düzeltme)
K3  SIRA: B1/B2 bloklayıcı ⇒ §9.13 pin adımından ÖNCE yedinci tur (B1 · B2 tek sınıflandırıcı + immutable-funcid negatifi ·
    D1–D8 · 🔵'ler · TL bilinen-kırmızılarının kalıcı fixture'ı: SON KONTROL + mask-off + ≥2 uuid satır) — Team Lead önerisi
```

## 9.13 · ⭐ TÜR-KÜMESİ PİNİ (`Z111 §22`, 2026-09-11) · ⛔ ALTINCI TUR + REVIEWER + BAĞIMSIZ DOĞRULAMA İNDİKTEN SONRA

### `9.13.0` · HÜKÜM
```
PİN    maskelenen ifade-TÜRLERİNİN KÜMESİ · SAYI YALNIZ BİLGİ (değer-pini değil — Z56)
       kümeye yeni tür girer → KIRMIZI → insan bakar "bu tür maskelenmeli mi" · sayı değişimi gürültü, pin DEĞİL
TÜR    KOLON başına İMZA = maskeleme ölçütünü tetikleyen düğüm-anahtarlarının (provolatile ∈ {'v','s'} fonksiyon adı ·
       SQLVALUEFUNCTION op) sıralı birleşimi — Z111 §22.1 N19 (iii) · pg_get_expr metni KULLANILMAZ
BUGÜN  [ÖLÇÜLDÜ Z111 §22.1] dört imza: CURRENT_TIMESTAMP+timestamp · now+timestamp · uuid_generate_v4 · nextval
```

### `9.13.1` · İŞ
```
1  pinli küme bir artefaktta: [ÖLÇÜLMEDİ — Team Lead önerisi] collmind.backend/scripts/verification/volatile-mask-signatures.txt
   satır biçimi <imza>|<gerekçe> · gerekçesiz satır → ÖLÇEMEDİM (sessiz kabul yok) · kod okur ⇒ submodule'de (CLAUDE.md §5 doküman yeri)
2  harness sınıflandırıcıdan imza kümesini TÜRETİR (altıncı turun sınıflandırıcısı — İKİNCİ KOPYA YAZILMAZ, §2.7 #8)
3  karşılaştırma:  gözlenen ⊄ pinli (yeni imza)  → KIRMIZI "maskede yeni ifade türü: <imza> (tablo.kolon…) — maskelenmeli mi?"
                   pinli ⊄ gözlenen (kaybolan imza) → [KARAR DEĞİL — şerit ölçer, seçenekleri raporlar] bilgi mi kırmızı mı
                     ⭐ F12 — Z111 §23 ÖN-HÜKÜM: kırmızı DEĞİL · ÖLÇEMEDİM-sınıfı uyarı + çapraz-kontrol (tablo-sayımı)
                        tablo-sayısı(S0) == tablo-sayısı(H) ∧ imza kayboldu → BİLGİ "maske daraldı: <imza>"
                        tablo-sayısı(H)  <  tablo-sayısı(S0)                → ÖLÇEMEDİM "körlük şüphesi"
                        ⛔ sabit sayı ("51") YAZILMAZ — ilişki (Z111 §23.1 N20) · ayrıntı ve açık ölçümler §9.13.5
                   eşit → bilgi satırı "maske türleri pinle eşleşti (K imza) · N kolon"
4  sayı yalnız bilgi satırında — hiçbir kolda sayıya bağlı renk YOK
```

### `9.13.2` · ⛔ ÖLÇÜLECEK ÖNCE (varsayılmaz)
```
a  pin HANGİ snapshot'ta değerlendirilir (H mi, her snapshot mu) — sentetik fixture setleri H'ye kendi tablolarını ekler:
   hangi sentetik set bugün pinde OLMAYAN bir imza üretir? [ÖLÇÜLMEDİ] ⇒ o setlerin beklenen sonucu raporda ADIYLA
b  sentetik tablolar (_mv_synth%) imza türetimine girer mi — girmesi gerekiyor mu (girmezse sentetik bilinen-kırmızı kurulamaz)
c  canlılık probunun geçici tablosu imza türetimine SIZMAZ (prob ROLLBACK'li — ölç)
```

### `9.13.3` · KANIT — `Z83`
```
BİLİNEN-YEŞİL   gerçek HEAD 1833 → dört imza, pin eşleşti
BİLİNEN-KIRMIZI sentetik: timestamp kolon DEFAULT '2020-01-01'::timestamptz (stable-cast sabit, SINIR 1) → KIRMIZI "yeni ifade türü"
GÜRÜLTÜ-DEĞİL   sentetik: serial + uuid + CURRENT_TIMESTAMP'lı YENİ tablo (mevcut imzalar) → YEŞİL, sayı bilgi satırında değişir
PİN-MUTASYON    artefakttan bir satır silinir (kopya + shasum) → KIRMIZI · gerekçe alanı boşaltılır → ÖLÇEMEDİM
REGRESYON       altıncı turun tam listesi AYNI sonuç
```

### `9.13.4` · SINIRLAR
```
touches  scripts/migration-verify.sh · scripts/verification/volatile-mask-signatures.txt · scripts/verification/synthetic-*
⛔ §5 · §9.7 · §9.12.4 geçerli · çıkış kodu 0/1/2 · git checkout/stash YASAK · commit/push YOK
```

### `9.13.5` · ⭐ `Z111 §23` — KAYBOLAN İMZA · GÜRÜLTÜ SAYIMI · ÖLÇÜLECEKLER
```
KAYBOLAN İMZA (ön-hüküm)  kırmızı DEĞİL — ÖLÇEMEDİM-sınıfı uyarı + çapraz-kontrol
  tablo-sayısı(S0) == tablo-sayısı(H) ∧ imza kayboldu → BİLGİ "maske daraldı: <imza>" (migration kolonları kaldırdı)
  tablo-sayısı(H)  <  tablo-sayısı(S0)                → ÖLÇEMEDİM "körlük şüphesi — imza ve tablo birlikte kayboldu"
  ⛔ sabit sayı YAZILMAZ — aynı koşumdaki iki snapshot'ın İLİŞKİSİ (Z111 §23.1 N20)
⛔ ÖLÇÜLECEK ÖNCE (varsayılmaz — raporda ADIYLA)
  d  "kaybolan"ın referansı: pin artefaktı mı, S0'daki imza kümesi mi — imza S0'da da yoksa kaybolma bu migration'dan
     değil ⇒ BAYAT PİN; hangi sınıfa düşer (N20)
  e  sınıflandırıcıda AD FİLTRESİ var mı (ör. sentetik dışlama: relname deseni) — varsa desene uyan gerçek tablo imzadan
     düşer, filtresiz sayımda kalır ⇒ YANLIŞ "maske daraldı"; çapraz-kontrol sayımı imza türetimiyle AYNI evren
     tanımından gelmeli (N21 · F06 · F02)
  f  BİLİNEN-KIRMIZI: sentetik — tablo DROP eden migration → ÖLÇEMEDİM "körlük şüphesi" (gürültü yönü, kabul) ·
     sentetik — tablo kalır, DEFAULT kaldırılır → BİLGİ "maske daraldı"
GÜRÜLTÜ SAYIMI (Z111 §23)  pin doğduktan sonra ilk iki hafta sayılır; gürültü yüksekse tanım daraltılır
  ⇒ pin'in doğduğu commit'te TARİHLİ bir TASK açılır (Team Lead) — kaynak: pin artefaktının git log'u
  ⚠️ reddedilen kırmızılar log'da GÖRÜNMEZ [ÖLÇÜLMEDİ] — task bu açığı ADIYLA taşır (N22)
```

### `9.13.6` · ⭐ PİN ADIMI İNDİ — TL DOĞRULAMASI + REVIEWER: İKİ KAPI FAIL-OPEN · ⛔ PUSH'TAN ÖNCE DAR DÜZELTME (2026-09-13)
```
ŞERİT   migration-verify.sh sha 927e2bf5…→a2d71e14… (yalnız EKLEME, K8 bölümü) · artefakt volatile-mask-signatures.txt (5 satır) ·
        pin-vanish-table-drop · pin-narrow-default-removed · kanıtlar: vanish→2 · narrow→0+"maske daraldı" · uuid satırı silme→1 ·
        gerekçe boşaltma→2 · ⛔ tam regresyon KOŞULMADI · ⛔ sınır-1 kalıcı fixture'ı YOK · test imzası üretim pinine EKLENDİ (kendi işaretledi)
```
**TEAM LEAD — GERÇEK HARNESS** (`scratchpad/harness-verify/tl-verify-pin.sh`) · taban sağlam · artefakt kopyadan geri yüklendi (sha eşit) · `.tlp-*` 0
```
MUT sig-empty-H   imza sorgusu rc 0 ama SIFIR satır   → rc=0 ✅ YEŞİL   ⛔ beklenen ÖLÇEMEDİM
                  çıktı: "gözlenen (snapshot H): 0 imza / 145 kolon" · "BAYAT PİN" + "maske daraldı (BİLGİ)" · "✅ YEŞİL"
                  ⇒ PİN KAPISI FAIL-OPEN: kendi girdisi boşken tutarsızlığı BASIYOR, RENGİ DEĞİŞTİRMİYOR (DISIPLIN F04 kalıcı örnekle AYNI desen)
PIN uuid satırı silindi      → rc=1 "YENİ ifade türü"  ✓        PIN nextval gerekçesi boş → rc=2  ✓
MUT probe-s                  → DUR "desen 2 kez geçiyor" ⇒ sınıflandırıcının volatilite kümesi İKİNCİ KEZ yazılmış (:550) — ölçülmüş kanıt
REGRESYON                    → erken DUR yüzünden KOŞULMADI
```
**REVIEWER** — push edilmemeli
```
🔴 B-1 test imzası SQLVALUEFUNCTION:op0 ÜRETİM pininde ⇒ cast'siz DEFAULT CURRENT_DATE ekleyen GERÇEK migration KIRMIZI VERMEZ
       [reviewer ÖLÇTÜ: plan ağacı + K8 kopyası] — Z111 §23 CURRENT_DATE'i "bedel kabul: kırmızı versin" diye ADIYLA anıyor ⇒ hükme aykırı,
       fail-open · + gerçek HEAD'de HER koşumda "BAYAT PİN" ⇒ §9.13.3 bilinen-yeşili ("pin eşleşti") karşılanmıyor · sabit sinyal
       öneri: MIGRATION_VERIFY_PIN_EXTRA_FILE (üretim pinine EKLENİR, aktifse ?? UYARI — MIGRATION_VERIFY_RUN_CMD emsali); üretim pini 4 satır
🔴 B-2 :550 regexp_match(':op (\d+)') İLK :op'u alıyor, SQLVALUEFUNCTION düğümüne bağlı DEĞİL · `g` yok
       GREATEST(LOCALTIMESTAMP, …) → MINMAXEXPR :op 0 önce gelir → imza "op0" ⇒ LOCALTIMESTAMP (op 7) sessizce kabul · ikinci SVF hiç görülmez
       ⇒ §23'ün adını koyduğu KİMLİK KÖRLÜĞÜ · düzeltme tek satır: regexp_matches('\{SQLVALUEFUNCTION :op (\d+)', 'g')
🟡 D-1 artefakt: boş imza ("|gerekçe") ve yinelenen satır kabul ediliyor · NULL imza "" olur → "✓ eşleşti"
🟡 D-2 gözlenen imza kümesi maske sayısıyla karşılaştırılmıyor — TL'nin sig-empty-H ölçümüyle AYNI kusur (reviewer T-task dedi;
       TL gerçek harness'ta YEŞİL ölçtü ⇒ Team Lead sınıflaması: BLOKLAYICI)
🟡 D-3 K8 T-047-sonrası ve R2 kırmızılarından ÖNCE çalışıyor ⇒ tablo düşüren + T-047 ihlali "körlük şüphesi" (ÖLÇEMEDİM) görünür — sebep örtülür
🟡 D-4 ⛔ KARAR: bayat pin ve "maske daraldı" KALICI yalnız-bilgi ⇒ pin daralması hiç kapanmaz; imza geri gelirse sessizce kabul
       (ratchet'in kapanmamış improved satırı deseni) · H > S0 dalı hükümde YOK · seçenek: (a) bilgi (b) ÖLÇEMEDİM (c) kırmızı "pini daralt"
🔵 N-1 volatilite kümesi iki yerde · N-2 string_agg sırası collation'a bağlı (COLLATE "C") · N-3 pg_tables relkind r+p ↔ imza r ·
   N-4 yorum "main.ts ~950" bayat atıf · N-5 başlık "K1..K7" · N-6 S0 imza hatasında DB yarım uyarısı yok · N-7 gürültü-sayımı task'ı YOK
```
**⇒ Team Lead önerisi — pin adımına DAR DÜZELTME (onuncu tur DEĞİL: `Z111 §26` "bloklayıcı → dar-düzeltme + push")**
```
1  B-1  test imzası üretim pininden ÇIKAR · fixture'lar ek pin dosyasını override ile verir (uyarı basılır)
2  B-2  SVF op anahtarı regexp_matches('\{SQLVALUEFUNCTION :op (\d+)', 'g') — tüm SVF'ler
3  D-2  gözlenen imza satır sayısı == maskelenmiş kolon sayısı, değilse ÖLÇEMEDİM (boş küme dahil)
4  D-1  boş imza · yinelenen imza · boş gözlenen imza → ÖLÇEMEDİM
5  N-1  volatilite kümesi TEK değişkende (sınıflandırıcı ve anahtar türetimi aynı kümeyi okur)
KANIT (GERÇEK harness): sig-empty-H → 2 · GREATEST(LOCALTIMESTAMP…) sentetik → 1 · cast'siz CURRENT_DATE sentetik → 1 ·
      sınır-1 '2020-01-01'::timestamptz sentetik → 1 (§9.13.3'ün kendi vakası) · override'sız pin fixture'ı → farkı görünür ·
      gerçek 1833 → "✓ pin eşleşti" (bayat pin satırı YOK) · TAM regresyon
T-TASK: D-3 · N-2…N-6 · N-7 gürültü sayımı (pin commit'inde tarihli)
KARAR BEKLER: D-4 (bayat pin sınıfı) — karar gelmezse bugünkü (a) bilgi kalır ve T-task olur
```

### `9.13.7` · ⭐ PİN DAR DÜZELTMESİ — BEŞ MADDE + D-4 (c) (`Z111 §30`, 2026-09-13) · ONUNCU TUR DEĞİL
```
HÜKÜM  §26: bloklayıcı → dar düzeltme + push · kapsam GENİŞLEMEZ · kanıt GERÇEK harness'ta · gerçek 1833'te "pin eşleşti"
D-4    (c) KARAR: kaybolan imza —
         tablo sayısı(H) < tablo sayısı(S0)          → ÖLÇEMEDİM "körlük şüphesi"          (DEĞİŞMEZ)
         tablo sayısı sabit (ve H > S0 dahil)         → KIRMIZI "pini daralt — kaybolan imza artefakttan gerekçeyle, AYRI commit'te çıkarılır"
         imza S0'da da YOK (bayat pin)                → KIRMIZI "pini daralt" (aynı sınıf — pin gözlenenden GENİŞ)
         ⛔ "bilgi" satırı YOK — gözlenen ≠ beklenen asla bilgi değildir (DISIPLIN F04, Z111 §30 kayıt 1)
         ⚠️ H > S0 dalı hükümde adıyla yoktu (reviewer D-4) ⇒ Team Lead yorumu: "düşmedi" = sabit sınıfı → KIRMIZI; aksi istenirse değişir
```
```
İŞ
1  B-1  üretim pini (volatile-mask-signatures.txt) YALNIZ gerçek şemadan ölçülen imzaları taşır — SQLVALUEFUNCTION:op0 test satırı ÇIKAR
        + MIGRATION_VERIFY_PIN_EXTRA_FILE: fixture'ın ek pin satırları üretim pinine EKLENİR (ikinci doğruluk kaynağı DEĞİL, dört satırın kopyası YOK)
          override aktifse HER koşumda "?? UYARI: pin EK dosyası aktif — <yol>" (MIGRATION_VERIFY_RUN_CMD emsali)
          ek dosya da aynı doğrulamadan geçer (gerekçe · boş imza · yineleme)
        + pin fixture'larının başlığına ve çağrı komutuna override yazılır — override'sız koşumda farkın GÖRÜNÜR olduğu ölçülür
2  B-2  SQLVALUEFUNCTION op anahtarı: regexp_matches(ad.adbin::text, '\{SQLVALUEFUNCTION :op (\d+)', 'g') — TÜM SVF düğümleri,
        her biri ayrı anahtar (DISIPLIN F03 kimlik körlüğü: ilk eşleşme DEĞİL, hepsi)
3  D-2  imza dosyasının satır sayısı == maskelenmiş kolon sayısı (aynı snapshot) — değilse ÖLÇEMEDİM · boş gözlenen küme dahil
        + comm/sort/cut adımlarının rc'si okunur (T-391 ailesi — bu blokta boru YOK, dosyadan)
4  D-1  artefakt ve gözlenen kümede: boş imza · yalnız-boşluk imza · yinelenen imza → ÖLÇEMEDİM
5  N-1  volatilite kümesi ('v','s') TEK değişkende — sınıflandırıcı (VOLATILE_CLASSIFIER_EXPR) ve imza anahtar türetimi AYNI değişkeni
        genişletir · dosyada `provolatile IN (` metni TEK geçer [ÖLÇÜLDÜ olarak raporlanır]
+  D-4  yukarıdaki (c) eşlemesi
⛔ R1 sınıfı: hata yolu olan fonksiyon değer döndürmez · $( ) içinde unmeasured/red YOK · üçüncü desen YOK
```
```
KANIT — GERÇEK HARNESS (izole kopya DEĞİL · Z111 §28 not 1) · her kol ÖNCE (pin-pre-fix kopyası) / SONRA
K1  imza sorgusu rc 0 + SIFIR satır (mutasyon)          ÖNCE rc=0 YEŞİL (TL ölçtü §9.13.6)   SONRA rc=2 ÖLÇEMEDİM "imza sayısı ≠ maske"
K2  sentetik: timestamp kolonda DEFAULT GREATEST(LOCALTIMESTAMP, '2020-01-01'::timestamp)
                                                         ÖNCE rc=0 (op0 pinli)                SONRA rc=1 "YENİ ifade türü: …op7…"
K3  sentetik: date kolonda cast'siz DEFAULT CURRENT_DATE ÖNCE rc=0 (op0 test satırı)          SONRA rc=1 "YENİ ifade türü: …op0"
K4  SINIR-1 KALICI FIXTURE: timestamp kolonda DEFAULT '2020-01-01'::timestamptz                SONRA rc=1 "YENİ ifade türü: timestamp"
K5  pin-vanish-table-drop  (override İLE)               SONRA rc=2 "körlük şüphesi"
K6  pin-narrow-default-removed (override İLE)           SONRA rc=1 "pini daralt"  (D-4 (c) — önceden BİLGİ/rc=0 idi)
K7  bayat pin: üretim pinine ölçülmemiş bir imza satırı eklenir (mutasyon, kopya+sha) → gerçek 1833 SONRA rc=1 "pini daralt"
K8  override aktif → çıktıda "?? UYARI: pin EK dosyası aktif"
K9  artefakt: boş imza satırı · yinelenen imza → ÖLÇEMEDİM
K10 MUT: VOLATILE_CLASSIFIER_EXPR'in volatilite kümesinden 's' dışlanır (TEK değişken) → prob ÖLÇEMEDİM (N-1 tek yer kanıtı)
K11 GERÇEK HEAD 1833 → rc=0 · "✓ maske türleri pinle eşleşti (4 imza)" · "bayat pin" / "pini daralt" satırı YOK
REGR TAM: Team Lead doğrulama listesinin tamamı (§9.16.7: 30 set + nullcollapse) + pin fixture'ları AYNI/yeni beklenen sonuç
     ⛔ bir sentetik set pin yüzünden yeni kırmızı verirse beklenen sonucu şerit DEĞİŞTİRMEZ — ADIYLA listeler, DUR
```
```
SINIRLAR  touches: scripts/migration-verify.sh · scripts/verification/volatile-mask-signatures.txt · scripts/verification/synthetic-*
          (pin ek dosyaları fixture dizinlerinde) · ⛔ T-391…T-394 ve D-3 BU İŞ DEĞİL · performansa dokunulmaz
```

### `9.13.8` · ✅ PİN DAR DÜZELTMESİ KAPANDI — TL GERÇEK HARNESS 44/45 · REVIEWER BLOKLAYICI YOK · SESSİZ A/B (2026-09-13)
```
ŞERİT     harness sha a2d71e14…→b767cd25… · artefakt 33d6195c…→d2fb1a2c… (4 imza, test satırı ÇIKTI) · pin-extra.txt ×2 ·
          yeni fixture pin-new-type-{greatest,current-date,stable-cast-boundary} · K1–K11 + tam regresyon bildirdi
```
**TEAM LEAD — GERÇEK HARNESS** (`scratchpad/harness-verify/tl-verify-pinfix.sh`) · harness ve artefakt sha başta == sonda · `.tlf-*` 0 · taban aynı
```
MUT sig-empty-H (rc 0 + sıfır satır)     rc=2 "imza dosyası satır sayısı (0) ≠ maskelenmiş kolon sayısı (145)"   ✓ (önceki turda rc=0 YEŞİL)
MUT probe-s (TEK değişken, 's' dışlandı) rc=2 CANLILIK PROBU "4+3 beklenen"                                        ✓ N-1 tek kaynak
MUT mask-off (maske sorgusu AND false)   rc=2 "imza dosyası satır sayısı (146) ≠ maskelenmiş kolon sayısı (0)"   ⚠️ beklenen 1 idi
    ⇒ İYİLEŞME: pin'in D-2 çapraz kontrolü maskenin çöküşünü "1≠3"ten ÖNCE tutarsızlık olarak yakalıyor — kapı fail-CLOSED ve DAHA ERKEN
    ⇒ "maske 1≠3'ü önler" kanıtı §9.12.6–§9.15.5'te alınmıştı; bu mutasyonun beklenen sonucu artık ÖLÇEMEDİM
PIN bayat satır eklendi (kopya+sha)      rc=1 "pini daralt"                                                        ✓ D-4 (c)
pin-vanish-table-drop  + EXTRA           rc=2 "körlük şüphesi (S0=52 → H=51)" + "?? UYARI: pin EK dosyası aktif"   ✓
pin-narrow-default-removed + EXTRA       rc=1 "pini daralt" + UYARI                                                ✓ (önceden BİLGİ/rc=0)
pin-narrow-default-removed OVERRIDE YOK  rc=0 "✓ maske türleri pinle eşleşti (4 imza)"                             ⚠️ reviewer Y-1 DAVRANIŞLA doğrulandı
pin-vanish-table-drop     OVERRIDE YOK   rc=0 "✓ … eşleşti"                                                        ⚠️ aynı
pin-new-type-greatest · -current-date · -stable-cast-boundary   rc=1 "maskede YENİ ifade türü"                     ✓ B-2 · B-1 · sınır-1
REGRESYON 30 set + nullcollapse          hepsi beklendiği gibi · pin'li her yeşil vakada "✓ pin eşleşti (4 imza)"
REAL 1833                                rc=0 "✓ maske türleri pinle eşleşti (4 imza) · 145 kolon" · bayat/daralt satırı YOK ✓ K11
```
**SESSİZ A/B** (başka koşum yok — `pgrep` boş · ardışık · gerçek 1833 · 2+2)
```
pin ÖNCESİ harness (927e2bf5)   72 s · 71 s
ŞİMDİKİ harness (b767cd25)      72 s · 73 s
⇒ pin'in maliyeti ölçülebilir DEĞİL (±1 s) · şeridin 477 s'si ortam yükü — reviewer'ın kod okuması (yeni psql çağrısı YOK) TEYİT edildi
```
**REVIEWER** — bloklayıcı YOK (§9.13.7 beş madde + D-4 (c) koddan ve canlı DB salt-okumasıyla doğrulandı: `GREATEST(LOCALTIMESTAMP…)` → op7, iç içe SVF, stable-cast → `timestamp`)
```
C-1  commit kapısı: üretim artefaktında TL mutasyon satırı görüldü — KOŞUM ANIYDI; artefakt koşum sonunda d2fb1a2c… (başta ile EŞİT) ✓ kapandı
Y-1  override unutulursa pin fixture'ları sessiz "✓" — kök: S0 imzaları pinle KARŞILAŞTIRILMIYOR · TL davranışla doğruladı
     ⛔ KARAR: "S0'da pinde olmayan imza" KIRMIZI mı ÖLÇEMEDİM mi — D-4 (c) kapsamında YOK · push'u durdurmaz → T-task
Y-2  ek pin dosyası VAR ama OKUNAMIYORSA hiç satır eklenmez, uyarı yok (reviewer izole ölçtü: chmod 000 → exit 0) — brief "okunamıyorsa
     ÖLÇEMEDİM" diyordu · tek satır ([ -r ] / döngü rc) · push'u durdurmaz
Y-3  yorum kirliliği: vanish Base başlığı hâlâ "volatile-mask-signatures.txt'e TEST-ÖZEL satır eklendi" · pin-extra "HER satırda UYARI"
     (koşum başına bir kez) · artefakt :37 "TEK METİN" çelişkisi · stable-cast başlığı "planlayıcı" (adbin parse ağacı)
N-a…N-f  ÖLÇEMEDİM'in KIRMIZI'yı örtmesi · pg_get_expr satırsonu / `|` · dosyadaki önceden var olan F04 adayları (:966 "bilgi amaçlı" sorgu
     hatası · :2150 · :2209 "Elle incele" exit yok) · başlıkta override yok + "K1..K7" · override kontrolü döngü sonunda
```
⇒ **PİN ADIMI KAPANDI.** Sıradaki: Y-2 + Y-3 (commit öncesi küçük ek, onaylanırsa) → push-order-satırı + beyan-ratchet'i → tek push → 1835.

> ### ⛔ KAPANIŞ BEYANI — KAPSANMADI (`Z111 §31`, adıyla)
> **S0-imza kontrolü:** K8 yalnız snapshot H imzalarını pinle karşılaştırır. **Override unutulursa pin fixture'ları sessiz YEŞİL**
> verir [ÖLÇÜLDÜ: iki fixture, override'sız rc=0]. Hüküm: S0'da görülen pinsiz imza **KIRMIZI** → **`T-395`, 1838 harness koşumundan ÖNCE.**
> 1835'te risk YOK (override yok, S0 = gerçek DB — `Z111 §31.1`).
> Diğer kapsanmayanlar: F04 retro-tarama + pin notları → **`T-396`** · T-391…T-394 (dokuzuncu tur).

### `9.13.9` · ⭐ COMMIT ÖNCESİ EK — Y-2 + Y-3 (`Z111 §31`, 2026-09-13) · KOD DEĞİŞİKLİĞİ TEK SATIR SINIFINDA
```
Y-2  MIGRATION_VERIFY_PIN_EXTRA_FILE: dosya VAR ama OKUNAMIYORSA → ÖLÇEMEDİM (bugün: hiç satır eklenmez, uyarı yok, exit 0)
     + read_pin_file'ın döngü/yönlendirme rc'si okunur · üretim pini için de aynı (okunamayan üretim pini → ÖLÇEMEDİM, "YENİ tür" DEĞİL)
     ⛔ hata yolu olan fonksiyon değer döndürmez · $( ) içinde unmeasured yok · üçüncü desen YOK (DISIPLIN F12)
Y-3  YORUM düzeltmeleri (davranış DEĞİŞMEZ):
     · pin-vanish-table-drop Base başlığı — "volatile-mask-signatures.txt'e TEST-ÖZEL satır eklendi" → B-1 sonrası gerçek (ek dosya)
     · pin-narrow-default-removed Base başlığı — aynı devralınmış hata
     · iki pin-extra.txt — "HER satırda ?? UYARI" → "koşum başına bir kez"
     · volatile-mask-signatures.txt yorumu — "op0 satırının TEK METNİ" çelişkisi (iki ayrı ek dosya)
     · pin-new-type-stable-cast-boundary başlığı — "planlayıcı Const'a katlamaz" → default adbin'e PARSE ağacı yazılır
     · iki pin fixture'ına: "override'sız koşum SESSİZ YEŞİL verir — T-395 kapanana kadar" uyarısı
KANIT (GERÇEK harness)
     Y-2  ek dosya chmod 000 → ÖLÇEMEDİM (ÖNCE: rc=0) · geri alma: chmod geri + sha eşit
     Y-3  yorum-dışı kod diff'i YALNIZ Y-2 satırları [ÖLÇÜLDÜ: diff] · artefakt imza satırları DEĞİŞMEZ (sha karşılaştırması imza kısmında)
     REGR pin fixture'ları (override ile) + gerçek 1833 "✓ pin eşleşti" + tam liste aynı sonuç
SINIR touches: migration-verify.sh · volatile-mask-signatures.txt (YALNIZ yorum) · synthetic-migrations/pin-* · synthetic-datasource-pin-*
      ⛔ T-395 / T-396 BU İŞ DEĞİL · koşum biçimi BRIEF_SABLONU §2.6 · git checkout/restore/stash YASAK · commit/push YOK
```

### `9.13.10` · ✅ EK KAPANDI — TL GERÇEK HARNESS 46/46 · HARNESS İŞLETMEDE (2026-09-13)
**`scratchpad/harness-verify/tl-verify-pinek.sh`** · harness sha `79b0e856…` · artefakt sha `c18cdae7…` — ikisi de başta == sonda · `.tle-*` 0 · taban aynı
```
ŞERİT        Y-2 read_pin_file döngü rc'si okunuyor · yorum-dışı kod diff'i YALNIZ Y-2 · imza satırları birebir · Y-3 altı dosyada yorum
             ⛔ tam regresyon ve üretim-pini-okunamaz vakası KOŞMADI ⇒ Team Lead kapattı
TL (gerçek)  ÜRETİM PİNİ chmod 000 → rc=2 "ÖLÇEMEDİM: TÜR-KÜMESİ PİNİ: artefakt … OKUNAMADI" · izin + sha geri ✓ (şeridin sınamadığı vaka)
             sig-empty-H 2 · probe-s (tek değişken) 2 · mask-off 2 (§9.13.8 güncel beklenti) · bayat pin 1 "pini daralt"
             pin-vanish+EXTRA 2 · pin-narrow+EXTRA 1 · override'sız ikisi 0 (T-395 açığı — bilinen, adıyla) · üç yeni tür 1
             30 set + nullcollapse beklendiği gibi · gerçek 1833 rc=0 "✓ pin eşleşti (4 imza)" · 70 s
$?-DÖNGÜ     döngü gövdesinin son komutları continue/printf>> — normalde 0 · yönlendirme hatası → 1 ✓ · printf>> YAZMA hatası → "okunamadı"
             diye YANLIŞ adlanır (kapı kapalı) ⇒ T-391 kardeş madde (Z111 §32)
```
⇒ **HARNESS + PİN İŞLETMEDE** (`Z111 §31`). Açık kalanlar T-391…T-396'da, adıyla. Sıradaki: ratchet şeridi → tek push → 1835.
          ⛔ git checkout/restore/stash YASAK · commit/push YOK · MIGRATION_SEQUENCE/push-order.sh/docs YAZILMAZ · koşum biçimi BRIEF_SABLONU §2.6
ÇIKTI     1 DİFF (madde başına) · 2 artefakt tam içerik + ölçüm komutu · 3 Z83 (ÖNCE/SONRA · SEBEP satırı) · 4 KAPI · 5 ⛔ NE ÖLÇEMEDİN · 6 taban + kalıntı
```

## 9.14 · ⭐ YEDİNCİ TUR — İKİ BLOKLAYICI · TEK SINIFLANDIRICI · VERİ-KOLU SINIRI (`Z111 §24`, 2026-09-11) · ⛔ §9.13 PİNİNDEN ÖNCE

> ⚠️ Numara: bu bölüm §9.13'ten SONRA yazıldı ama ÖNCE koşar — sıra `Z111 §24 K3`: altıncı tur → **yedinci tur (§9.14)** →
> pin (§9.13) → push-order-satırı + ratchet → tek push.

### `9.14.0` · HÜKÜM (`Z111 §24`)
```
K1  (a) maske kapsamı DEFAULT'ta kalır · migration GÖVDESİNİN ürettiği değer tahmin edilmez (gövde okunmaz — G5)
    VERİ-KOLU ÜÇ DEĞERLİ: byte-birebir / KIRMIZI / ÖLÇEMEDİM "migration volatile-kimlikli satır üretiyor (N satır, tablolar)"
    EFFECT='DATA_VOLATILE_INSERT' + EFFECT_REASON → veri-kolu ÖLÇEMEDİM, şema-kolu TAM
    sınır harness başlığına: KAPSAM/SINIR + BEYAN SÖZLEŞMESİ (Z111 §24.1 — "kapı-sözleşmesi" bu iki bölüm)
K2  boş ya da YALNIZ-BOŞLUK sebep → KIRMIZI "beyan sebepsiz" (REVERSIBILITY_REASON ve EFFECT_REASON, DB'ye dokunmadan)
    TİP alanındaki boş string → ÖLÇEMEDİM KALIR (S-1) — Z111 §24.1 N27
K3  iki bloklayıcı + sınıflandırıcı tek yer + fonksiyon-kimlikli sabit negatif + 8 bulgu + üç kalıcı fixture
KAYIT "bilinen-kırmızı, kusurun doğduğu KARDİNALİTEDE kurulur" — sıralama kusuru ≥2 satırda doğar, tek satır göremez
```

### `9.14.1` · İŞ — BLOKLAYICILAR
```
B1  :913 maskeli dal ORDER BY t::text (maskeli uuid dahil) → hash'lenen metinle AYNI anahtar (row_text)
    ⚠️ :913 array_to_string(…,'|') değer-içi '|' kaçırmıyor → ('a|b','c') == ('a','b|c') (reviewer 🔵) — sıralama anahtarı
       ve hash metni ÇAKIŞMASIZ bir kodlamayla kurulsun (ör. yalnız maskelenmemiş kolonlardan bir ROW(...)::text —
       tırnaklar) [ÖLÇÜLMEDİ — şerit ölçer, seçimini adıyla yazar]
B2  SINIFLANDIRICI TEK YER — prob ve asıl maske AYNI SQL parçasını çağırır (şema/relkind/relname filtresi PARAMETRE)
    ⛔ §2.7 #8: kopya, orijinaldeki regresyonu görmez · F04 :3794 · Z111 §24.1 N26: prob asıl KODU çağırır, BAĞIMSIZ olan
       BEKLENEN değerdir
    PROB KOLONLARI (D1 dahil) — her kol AYRI bir dalı sınar:
      a  timestamptz DEFAULT CURRENT_TIMESTAMP      → volatil  (SQLVALUEFUNCTION kolu — cast'SİZ, funcid yok)  ← D1
      b  timestamptz DEFAULT now()                  → volatil  (funcid 's')
      c  uuid        DEFAULT uuid_generate_v4()     → volatil  (funcid 'v')
      d  bigint      DEFAULT nextval(<temp seq>)    → volatil  (funcid 'v')
      e  varchar     DEFAULT 'X'::varchar           → volatil DEĞİL (IMMUTABLE funcid TAŞIR — 'i' genişlemesini yakalar) ← YENİ
      f  text        DEFAULT 'SABIT'                → volatil DEĞİL (funcid yok)
      g  int         DEFAULT 0                      → volatil DEĞİL (sabit)
    [ÖLÇÜLMEDİ — şerit TEMP tabloda ölçer] e'nin adbin'inde gerçekten immutable bir :funcid var mı (yoksa başka bir
    immutable-cast'li sabit seç ve adıyla yaz — reviewer ÖLÇTÜ: main'de 45 kolon yalnız immutable funcid taşıyor)
```

### `9.14.2` · İŞ — VERİ-KOLU SINIRI (K1)
```
TESPİT (katalog-türevi, desen YOK — G5):
  "volatile-kimlikli kolon" = maskeli bir kolona FK ile bağlı kolon (pg_constraint contype='f', confkey → maskeli kolon)
  [ÖLÇÜLDÜ Z111 §24.1: main'de uuid'e bağlı 147 FK kolonu]
  DATA iki hash ile: (1) maskeli · (2) maskeli + volatile-kimlikli kolonlar da dışlanmış
  S1≠S3 yalnız (1)'de, (2)'de eşit → "volatile-kimlikli satır" (N satır, tablo listesi) · (2)'de de fark → KIRMIZI (bugünkü)
  [Team Lead teknik önerisi — şerit daha dar/doğru bir türetim bulursa ADIYLA önerir, uygulamadan önce raporlar]
ÇIKIŞ EŞLEMESİ (Z111 §24.1 N28 — Team Lead yorumu, Z111 §16 emsali):
  beyanlı DATA_VOLATILE_INSERT + sebep ∧ tespit VAR  → exit 0 · zorunlu satır "veri-kolu ÖLÇEMEDİM: volatile-kimlikli satır
                                                        (N satır: <tablolar>) — şema-kolu TAM" · HARNESS_DECLARED|DATA_VOLATILE_INSERT|<sınıf>|<sebep>
  beyansız ∧ tespit VAR                               → exit 2 ÖLÇEMEDİM (aynı satır + "beyan: EFFECT='DATA_VOLATILE_INSERT' + EFFECT_REASON")
  beyanlı ∧ tespit YOK                                → KIRMIZI "bayat beyan — veri byte-birebir, DATA_VOLATILE_INSERT gereksiz"
  beyanlı + sebepsiz/yalnız-boşluk                    → KIRMIZI "beyan sebepsiz" (K2)
  ⛔ DATA_VOLATILE_INSERT, EFFECT'in üçüncü değeri — EFFECT tek değer taşır; REVERSIBILITY ile birlikteyse mevcut
     "beyan çelişkili" kuralı [ÖLÇÜLMEDİ — şerit mevcut conflict dalının bu değeri kapsayıp kapsamadığını ölçer]
s10-update-now → ADI mekanizmayı söyler (ör. body-now-update-known-red) · başlık yorumu: "maske DEFAULT-türevli; gövdenin
  now()'ı kapsam dışı — Z111 §24 K1" · KIRMIZI kalır
```

### `9.14.3` · İŞ — 8 BULGU + NOTLAR (reviewer, §9.12.6)
```
D2  pg_class/pg_type sayımı: psql rc okunur · boş değer → ÖLÇEMEDİM · öncesi≠sonrası → ÖLÇEMEDİM (migration kusuru DEĞİL)
    · DB_TOUCHED=0 iken "DB OLASI YARIM" çelişkisi kalkar
D3  :904 grep rc'si ayrı okunur (boru YOK — sigpipe-hygiene) · tamamen maskeli tablolar KONSOLA basılır (görünür maske)
D4  her shasum/effect hash'i için boş → ÖLÇEMEDİM (iki boş hash EŞİT SAYILMAZ)
D5  SON KONTROL KIRMIZI mesajı mekanizmayı söyler: "ilk uygulamanın etkisi (H) harness'ın yeniden uygulamasından (son) farklı"
    · sayı H'nin maskesinden basılır (bugün S3'ün)
D6  "dolanma-görünür" fixture: NONE_BY_DESIGN + EFFECT_REASON + ETKİLİ ama idempotent up + boş down → YEŞİL + "ÖLÇÜLEMEZ" satırı
D7  DATA döngüsünün YAZDIĞI satır sayısı == TABLE_COUNT, değilse ÖLÇEMEDİM (B-1'in DATA hâli) + stdin mutasyonu bilinen-kırmızısı
D8  = K2
🔵  başlık fixture listesi (yeni setler + ölçülmüş temizlik adımı, S-6) · s10 fixture yorumları · sürüm satırı prob rc'sine bağlı ·
    :1175 "✓ beyan GEREKMEDİ" satırı kırmızıdan önce basılmaz · koddaki sabit sayılar (1833·89·68·51 · 145·49) kaldırılır
    ("dokümanda sayı yazma") · read-declaration.ts:3 "npx" yorumu · main dışı fonksiyon volatilite değişimi → başlıkta SINIR satırı
```

### `9.14.4` · KANIT — `Z83` (kol başına; bilinen-kırmızı KUSURUN KARDİNALİTESİNDE)
```
B1  YENİ fixture uuid-tabloya-iki-satır: uuid-PK (DEFAULT uuid_generate_v4()) tabloya up() ≥2 satır (FK YOK) + doğru down()
      düzeltme SONRASI → YEŞİL — 10 koşum, 10/10 aynı sonuç
      mutasyon (mutate.sh): sıralamayı ORDER BY t::text'e geri çevir → 10 koşumda en az bir "1≠3"/"iz bıraktı"
      (reviewer yöntemi) — koşum sayısı ve kırmızı sayısı ADIYLA
B2  prob-kırma DÖRT UÇTA (mutate.sh, her biri ayrı, değişen satır BASILIR):
      's' dışla → ÖLÇEMEDİM · 'i' ekle → ÖLÇEMEDİM · SVF kolunu sil → ÖLÇEMEDİM · funcid kolunu sil → ÖLÇEMEDİM
    + TEK-YER kanıtı: asıl maskenin kullandığı parça mutasyona uğrar → PROB DA ÖLÇEMEDİM (altıncı turda "✓" diyordu)
K1  YENİ fixture parent+child: uuid-PK parent + ona FK'li child, up() ikisine de satır + doğru down()
      beyansız → exit 2 "volatile-kimlikli satır (N satır: <tablolar>)" · beyanlı+sebep → exit 0 + zorunlu satır + HARNESS_DECLARED
      beyanlı ama uuid-tabloya-iki-satır (tespit yok) → KIRMIZI "bayat beyan"
K2  YENİ: EFFECT_REASON='' → KIRMIZI · EFFECT_REASON='   ' → KIRMIZI · REVERSIBILITY_REASON='   ' → KIRMIZI (DB dokunulmadan)
    S-1 tip alanı boş string → ÖLÇEMEDİM (DEĞİŞMEZ)
D5  YENİ KALICI fixture SON-KONTROL: base aynı etiketli bir satır ekler, target aynı etiketle bir satır ekler, down etikete göre
      siler (ikisini de) → H(2) ≠ son(1) ∧ 0==2 ∧ 1==3 → KIRMIZI (SON KONTROL mesajı) [Team Lead bu şekli ön-kancayla ÖLÇTÜ, §9.12.6]
MASKE-KAPALI KALICI bilinen-kırmızısı: s10-insert-serial + mutate.sh ile maske parçası boşaltılır → "1≠3" — çağrı biçimi başlıkta
D6  dolanma-görünür → YEŞİL + "ÖLÇÜLEMEZ" · D7 DATA döngüsü stdin mutasyonu → ÖLÇEMEDİM · D2/D3/D4 her biri mutasyonla ÖLÇEMEDİM
REGR  §9.12.6 tablosunun tamamı AYNI sonuç (s10-update-now yeni adıyla KIRMIZI) + gerçek HEAD 1833 YEŞİL
```

### `9.14.5` · SINIRLAR · ÇIKTI
```
touches  collmind.backend/scripts/migration-verify.sh · scripts/verification/read-declaration.ts · scripts/verification/synthetic-*
⛔ §5 · §9.7 · §9.12.4 · §9.13 (pin YAZILMAZ) geçerli · çıkış kodu 0/1/2 · MIGRATION_SEQUENCE / push-order.sh / docs YAZILMAZ
⛔ geri alma YALNIZ kopya + shasum -a 256 -c — git checkout / git restore / git stash YASAK, raporda ÖNERİLMEZ (DISIPLIN F15)
⛔ turun başında migration-verify.sh ve read-declaration.ts'in TAM KOPYASI alınır (hash değil — altıncı turun dersi)
ÇIKTI  1 DİFF (bulgu başına) · 2 Z83 tablosu (vaka · beklenen · gerçek · exit · SEBEP satırı) · 3 N28 eşlemesi uygulandı mı ·
       4 KAPI (backend npm run guards + meta bash scripts/run-all.sh) · 5 ⛔ NE ÖLÇEMEDİN · 6 tur sonu taban + kalıntı + geçici dosya
```

### `9.14.6` · ⛔ KOŞUM BİÇİMİ — İKİ TAKILMA ÖLÇÜLDÜ (Team Lead, 2026-09-12)
```
OLGU  yedinci tur şeridi İKİ KEZ aynı noktada düştü: "no progress for 600s", ikisinde de harness koşumuna BAŞLARKEN
      1. düşüş  DB'yi YARIM bıraktı: HEAD 1832 / n=88 — harness'ın ön-adım revert'ü koşmuş, hedef yeniden UYGULANMAMIŞ
                ⇒ Team Lead `npm run migration:run` ile 1833'ü geri getirdi [ÖLÇÜLDÜ: n=89 · enum=68 · tables=51 · _mv 0]
      2. düşüş  taban TEMİZ kaldı · koşan süreç yok · geçici dosya yok · dosya değişiklikleri DURUYOR
HİPOTEZ (şerit ölçer) `</dev/null` OLMADAN başlatılan koşum girdi bekleyip ASILIR — harness `npm` ve `docker exec -i`
      çağırır, ikisi de stdin tüketir (bu şeridin kendi bulduğu sınıf: DISIPLIN F12 · §9.1 · Z111 §15.2 N8)
      ⇒ Team Lead'in doğrulama betiği HER çağrıda `</dev/null` kullanıyor ve 29 vakayı sorunsuz koşturdu [ÖLÇÜLDÜ]
ZORUNLU (bu tur ve sonraki turlar)
  bash scripts/migration-verify.sh <hedef> </dev/null > <log> 2>&1; echo "rc=$?"      ← exit kodu BORUYA GİRMEZ
  npm run typeorm -- migration:run -d <ds> </dev/null > <log> 2>&1; echo "rc=$?"
  çok vakalı ölçüm (10-koşum · regresyon) TEK BİR BETİĞE → betik `</dev/null` ile koşar → yalnız ÖZET grep'lenir
  uzun adım arka planda başlatılır, bitince logu okunur
⇒ HARNESS ERKEN ÇIKARSA DB YARIM KALIR (red() bunu zaten basıyor): hedefi geri getirmek KOŞANIN işidir; tur HER ZAMAN
  taban geri gelmiş hâlde biter ve bu raporda ÖLÇÜMLE yazılır
```

### `9.14.7` · ⭐ YEDİNCİ TUR — KOD İNDİ, KANIT İNMEDİ (şerit raporu + Team Lead ölçümü, 2026-09-12) · ⛔ TUR KAPANMADI
```
ŞERİT     migration-verify.sh 0b861963… → 4df9a5e4… · read-declaration.ts 95dfb087… → a4a802c0…
          YENİ FIXTURE YOK (synthetic-migrations 24 dizin — tur öncesiyle AYNI) [ÖLÇÜLDÜ: ls]
          şerit ÜÇ KEZ düştü (iki kez watchdog, §9.14.6) · raporunda ne YAPILMADIĞINI ADIYLA yazdı — doğru davranış
İNDİ      B1 (ROW(...)::text — ORDER BY ve md5 AYNI ifade, :1077) · B2 (VOLATILE_CLASSIFIER_EXPR :420, prob :483 ve
          maske :993 AYNI değişkeni genişletir) · K1 (FK türevi geniş maske :1018 · compute_row_hash_pair :1080 ·
          DATA_VOLATILE_INSERT beyanı :787-792 · N28 dört dal) · K2 (is_blank_or_empty :645) · D2 · D3 · D4 · D5 · D7 · 🔵'lerin çoğu
İNMEDİ    §9.14.4'ün KANIT YÜKÜ: uuid-tabloya-iki-satır (10 koşum) · prob-kırma DÖRT UÇ + tek-yer kanıtı ·
          parent+child (K1 üç dal) · SON-KONTROL kalıcı fixture · maske-kapalı kalıcı bilinen-kırmızı ·
          D6 dolanma-görünür · TAM REGRESYON (yalnız 2 fixture + gerçek HEAD koşuldu)
          ⇒ DÜZELTMELER DOĞRULANMADI (reprodüksiyon şartı KARŞILANMADI) — N28 dalları yalnız KODDA
ŞERİDİN ÖLÇÜMÜ (brief'in bir varsayımını DÜZELTTİ): 'X'::varchar typmod'suz cast PLANLAYICIDA CONST'a katlanır ve
          funcid'i KAYBEDER ⇒ prob negatifi varchar(10) ile yazıldı — §9.14.1'in "e" kolonu sorusu YANITLANDI

TEAM LEAD BAĞIMSIZ ÖLÇÜMÜ (2026-09-12, sessiz ortam)
  gerçek HEAD 1833, YENİ harness   rc=0 YEŞİL · 104 s · prob 4 volatil + 3 değil · maske 145 · SON KONTROL ✓ · taban döndü
  gerçek HEAD 1833, TUR ÖNCESİ kopya (scratchpad/round7-pre, sha 0b861963…, scripts/ altına geçici, sonra SİLİNDİ)
                                   rc=0 YEŞİL · 95 s · maske 145
  ⇒ ⛔ ŞERİDİN "PERFORMANS REGRESYONU" İDDİASI ÇÜRÜDÜ: A/B farkı ~%10 (95 s → 104 s), "38 s → 487 s (13x)" DEĞİL
    [ÖLÇÜLDÜ: aynı makine, aynı DB, ardışık koşum, harness dışında yük yok]
    ⇒ şeridin 487 s'i KENDİ paralel süreçlerinin yükünü taşıyordu — "ölçüm ortamının bayatlığı/gürültüsü" sınıfı (DISIPLIN)
    ⇒ performans SEKİZİNCİ TURUN İŞİ DEĞİL; daraltma önerisi (ikinci alt-sorguyu sınırlama) GEREKSİZ — ölçüm olmadan
      yapılacak bir iyileştirme, olmayan bir kusuru "düzeltir" (F-sınıfı: ölçülmemiş öncülle iş)
  KOD DOĞRULAMASI (salt-okuma): sınıflandırıcı yüklem METNİ dosyada 1 kez · VOLATILE_CLASSIFIER_EXPR 7 kullanım ·
    maskesiz dal kendi metnine göre sıralıyor (:1054) ⇒ B1/B2 kod düzeyinde TUTUYOR (davranışsal kanıt HÂLÂ YOK)
```

## 9.15 · ⭐ SEKİZİNCİ TUR — YALNIZ KANIT (`Z111 §25`, 2026-09-12) · ⛔ KOD YAZIMI YOK · PERFORMANSA DOKUNULMAZ

### `9.15.0` · HÜKÜM (`Z111 §25`)
```
DAR TUR   yedinci turun İNDİRDİĞİ düzeltmelerin DAVRANIŞSAL kanıtı kurulur — kod-düzeyi doğrulama REPRODÜKSİYON DEĞİLDİR
⛔ PERFORMANSA DOKUNULMAZ  [ÖLÇÜLDÜ §9.14.7: A/B 95 s → 104 s, ~%10] "13x regresyon" iddiası ÇÜRÜDÜ — daraltma YAPILMAZ
⛔ YENİ DAVRANIŞ YAZILMAZ   yalnız fixture + koşum + (kanıt bir kusuru gösterirse) o kusurun DÜZELTMESİ, adıyla
KOŞUM BİÇİMİ  §9.14.6 zorunlu (artık brief ŞABLONUNDA da: BRIEF_SABLONU.md §2.6)
```

### `9.15.1` · İŞ — ÜÇ KALICI FIXTURE (sentetik migration: data-engineer)
```
F1  uuid-tabloya-iki-satır   base: uuid-PK (DEFAULT uuid_generate_v4()) tablo · target: up() İKİ satır INSERT (FK YOK) + doğru down()
      ⇒ B1'in kardinalitesi: kusur ≥2 satırda doğar (tek satır YAPISAL olarak göremez — Z111 §25 kayıt 1 / §24 kayıt 1)
F2  parent+child             base: uuid-PK parent + parent'a FK'li child · target: up() İKİSİNE de satır + doğru down()
      üç dal: beyansız · EFFECT='DATA_VOLATILE_INSERT'+sebep · beyanlı ama tespit YOK (F1'e beyan konularak)
F3  son-kontrol-drift        base: bir tabloya '<etiket>' satırı EKLER · target: AYNI etiketle bir satır daha ekler ·
      down(): etikete göre SİLER (ikisini de) ⇒ H(2) ≠ son(1) ∧ 0==2 ∧ 1==3 → SON KONTROL KIRMIZI
      [Team Lead bu şekli ön-kancayla ÖLÇTÜ, §9.12.6 — fixture o ölçümün KALICI hâli]
F4  D6 dolanma-görünür       EFFECT='NONE_BY_DESIGN' + EFFECT_REASON + ETKİLİ ama idempotent up + boş down → YEŞİL + "ÖLÇÜLEMEZ"
⛔ HER FIXTURE'DA: adı mekanizmayı söyler (F06) · başlık yorumunda BEKLENEN sonuç ve temizlik adımı ÖLÇÜLMÜŞ olarak yazılır
```

### `9.15.2` · İŞ — MUTASYON KANITLARI (mutate.sh ya da kopya+shasum; değişen satır BASILIR)
```
M1  B1 eski sıralama          maskeli daldaki ORDER BY row_text → ORDER BY t::text · F1 ile 10 KOŞUM
      beklenen: en az bir koşumda "1≠3"/"harness iz bıraktı" · düzeltilmiş hâl 10/10 YEŞİL
      ⇒ koşum sayısı ve kırmızı sayısı ADIYLA (reviewer yöntemi)
M2  prob-kırma DÖRT UÇ        VOLATILE_CLASSIFIER_EXPR üzerinde, her biri AYRI: 's' dışla · 'i' ekle ·
      SQLVALUEFUNCTION kolunu sil · funcid kolunu sil → DÖRDÜ DE ÖLÇEMEDİM
M3  TEK-YER kanıtı            M2'nin mutasyonu ASIL maskeyi de bozar ⇒ aynı koşumda maske sayısı DEĞİŞİR ve prob ÖLÇEMEDİM verir
      ⛔ altıncı turda prob "✓" derken maske 145→123 düşüyordu (Z111 §24 kayıt 2) — bu kanıt o kapının kapandığını gösterir
M4  maske-kapalı (kalıcı)     maske sorgusu boşaltılır → s10-insert-serial "1≠3" · çağrı biçimi harness BAŞLIĞINA yazılır
```

### `9.15.3` · KANIT — `Z83` (kol başına, SEBEP satırıyla)
```
F1  düzeltilmiş → YEŞİL (10/10) · M1 ile → aralıklı KIRMIZI (sayıyla)
F2  beyansız → exit 2 "volatile-kimlikli satır (N satır: <tablolar>)" · beyanlı+sebep → exit 0 + zorunlu satır + HARNESS_DECLARED
    beyanlı ama tespit yok (F1+beyan) → KIRMIZI "bayat beyan"   ⇒ N28 eşlemesinin ÜÇ dalı da DAVRANIŞLA
F3  → KIRMIZI "harness iz bıraktı" (SON KONTROL)     F4 → YEŞİL + "ÖLÇÜLEMEZ" satırı
K2  EFFECT_REASON='' · '   ' · REVERSIBILITY_REASON='   ' → KIRMIZI "beyan sebepsiz" (DB'ye dokunmadan)
    TİP alanı boş string → ÖLÇEMEDİM (S-1, DEĞİŞMEZ)
D7  DATA döngüsü stdin mutasyonu → ÖLÇEMEDİM · D2/D3/D4 mutasyonları → ÖLÇEMEDİM
REGR §9.12.6'nın TAM listesi AYNI sonuç + gerçek HEAD 1833 YEŞİL (süre de yazılır — §9.14.7 A/B ile karşılaştırılabilir olsun)
```

### `9.15.4` · SINIRLAR · ÇIKTI
```
touches  scripts/verification/synthetic-* (YENİ fixture'lar) · scripts/migration-verify.sh (YALNIZ başlık notu — M4 çağrı
         biçimi, fixture listesi, s10 yorumlarının tazelenmesi; DAVRANIŞ DEĞİŞMEZ) · ⛔ kanıt bir KUSUR gösterirse
         düzeltme yapılır ve raporda AYRI başlıkla yazılır
⛔ §5 · §9.7 · §9.12.4 · §9.14.5 geçerli · pin (§9.13) YAZILMAZ · performans daraltması YAPILMAZ · çıkış kodu 0/1/2
⛔ git checkout / git restore / git stash YASAK (DISIPLIN F15) · koşum biçimi §9.14.6 / BRIEF_SABLONU §2.6
ÇIKTI  1 fixture listesi (dosya + BEKLENEN + temizlik) · 2 Z83 tablosu (vaka · beklenen · gerçek · exit · SEBEP satırı) ·
       3 M1'in 10 koşumunun SAYILARI · 4 KAPI (backend guards + meta run-all) · 5 ⛔ NE ÖLÇEMEDİN · 6 tur sonu taban + kalıntı
```

> ⭐ **`Z111 §25` kayıt 3:** prob negatifi `varchar(10)` — çünkü `'X'::varchar` (typmod'suz) **planlayıcıda CONST'a katlanır ve
> funcid'i KAYBEDER** [ÖLÇÜLDÜ: yedinci tur şeridi]. Bu **gerekçe satırı fixture/prob yorumunda DURUR** — sonraki okuyan
> *"neden 10"* diye sormasın.

### `9.15.5` · ⭐ SEKİZİNCİ TUR İNDİ — TL BAĞIMSIZ DOĞRULAMA 32/33 · REVIEWER İKİ 🔴 (2026-09-12) · ⛔ TUR KAPANMADI
```
ŞERİT   6 fixture ailesi (uuid-two-row-insert · parent-child-fk-{undeclared,declared} · uuid-two-row-declared-stale ·
        son-kontrol-drift · nbd-effective-idempotent) · harness'ta KOD SATIRI DİFF'İ SIFIR (yalnız yorum)
        [ÖLÇÜLDÜ: diff round8-pre vs şimdi, yorum-dışı satır = 0] ⇒ tur gerçekten "yalnız kanıt" oldu
```
**TEAM LEAD BAĞIMSIZ DOĞRULAMA** — `scratchpad/harness-verify/tl-verify-r8.sh` · harness sha başta==sonda · `.tl8-*` 0 · taban aynı
```
MUT probe-s ('s' dışlandı)          rc=2 ÖLÇEMEDİM "volatil=3 (beklenen 4)"            ✓ prob-kırma
MUT mask-off (maske sorgusu AND false) rc=1 "1≠3" · maske 0 kolon (s10-insert-serial)  ✓ maske ÖNCESİ
MUT b1-oldsort (ORDER BY t::text) · uuid-two-row-insert 10 KOŞUM   YEŞİL=3 KIRMIZI=7   ✓ kusur KARDİNALİTEDE görünüyor
    düzeltilmiş hâl 5 KOŞUM                                        YEŞİL=5 KIRMIZI=0   ✓ B1 DAVRANIŞLA kapandı
REGRESYON (29 set + nullcollapse + gerçek 1833): 32/33 beklendiği gibi
    yeni kollar: uuid-two-row-insert 0 · parent-child-fk-undeclared 2 ("volatile-kimlikli satır, 2 satır: _mv_synthetic_pc_child")
    parent-child-fk-declared 0 + HARNESS_DECLARED|DATA_VOLATILE_INSERT + iki "veri-kolu ÖLÇEMEDİM" satırı
    son-kontrol-drift 1 "harness iz bıraktı" · nbd-effective-idempotent 0 + "ÖLÇÜLEMEZ"
    ⛔ TEK UYUŞMAZLIK: uuid-two-row-declared-stale rc=0, brief beklentisi 1 ⇒ "bayat beyan" kolu BAĞIMSIZ OLARAK DA AÇIK
REAL 1833 rc=0 · 95 s (tur öncesi ölçümüyle AYNI) ⇒ performans sorunu YOK — §9.14.7'nin sonucu TEYİT EDİLDİ
```
**REVIEWER (code-reviewer) — temiz DEĞİL: iki 🔴, beş 🟡**
```
🔴 R1  unmeasured() KOMUT İKAMESİ içinde çağrılıyor ⇒ exit 2 yalnız ALT KABUĞU öldürür, ana süreç BOŞ değerle devam eder
       sha256_file :1425 · sekiz çağrının SEKİZİ de $( ) içinde (:1490 :1506 :1507 :1574 :1587 :1704 :1758 :1813)
       [TEAM LEAD DOĞRULADI: koddan okundu] ⇒ shasum boş/hatalı olursa HASH0==HASH2=="" ⇒ "✓ snapshot0 == snapshot2" YEŞİL
       ⇒ D4 kapısı YAZILDI ama ATEŞLEYEMİYOR — tam olarak yasakladığı şeye izin veriyor (fail-open)
       aynı sınıf: build_row_hash_expr (:1146/:1147 — yanlış teşhis) · classify_table_query_failure (:944 — S-9 T-047 kolunda ÖLÜ)
       ⛔ doğru desen bu dosyada ZATEN VAR: psql_val yazar · psql_val_rc ayrı okunur · unmeasured ÇAĞIRANDA
🔴 R2  "bayat beyan" (DATA_VOLATILE_INSERT) üç `if` bloğunun İÇİNDE (:1725 :1780 :1832) ⇒ FARK YOKSA beyan HİÇ sınanmıyor
       + mesaj metni "veri byte-birebir" diyor ama kod farkın OLDUĞU vakayı etiketliyor ⇒ hükmün (N28) adlandırdığı vakanın
       kodda KARŞILIĞI YOK · IRREVERSIBLE_ADD'in bayat-beyan kolu KOŞULSUZ else, bu koşullu ⇒ SİMETRİK DEĞİL
       + :1780 gerçek "1≠3" kırmızısından ÖNCE çıkıyor ⇒ gerçek tekrarlanabilirlik kusuru "beyan bayat" diye raporlanır (yanlış teşhis)
🟡 D-1 s10-update-now YENİDEN ADLANDIRILMADI (F06) · başlık notu Z111 §24 K1 gerekçesini taşımıyor
🟡 D-2 geniş (K1) maske 293/996 kolon (%29) [reviewer ÖLÇTÜ] ⇒ beyanlı bir migration'da FK kolonundaki GERÇEK kusur YEŞİL'e
       düşebilir — hüküm ihlali DEĞİL (N28 böyle emrediyor) ama SINIRIN BÜYÜKLÜĞÜ başlıkta yazılı değil
🟡 D-3 SON KONTROL'ün K1 karşılaştırması asimetrik girdi alıyor (effect vs ham snapshot — migrations satırı taşıyor)
🟡 D-4 uuid-two-row-{insert,declared-stale} ve parent-child-fk-{declared,undeclared} AYNI tablo adlarını paylaşıyor —
       bağımlılık başlıkta yazılı değil (temizlik atlanırsa ikinci setup patlar, sebebi görünmez)
🟡 D-5 DEFERRED_DECLARED_MSG DATA_VOLATILE_INSERT kolunda boş satırla başlıyor (kozmetik)
✅ KAPANDI: B1 (davranışla: 10 koşum 7 kırmızı ↔ düzeltilmiş 5/5 yeşil) · B2 kod düzeyi + prob dört uçta ÖLÇEMEDİM ·
   D1 · D2 · D5 · D6 · D7 · D8/K2 (boş · yalnız-boşluk · tab · newline → KIRMIZI, DB'ye dokunmadan)
```

## 9.16 · ⭐ DOKUZUNCU TUR — SON TUR · İKİ BLOKLAYICI + BEŞ MADDE + REGRESYON (`Z111 §26`, 2026-09-13)

### `9.16.0` · HÜKÜM (`Z111 §26`)
```
DAR       iki bloklayıcı (R1 · R2) + beş madde (D-1…D-5) + regresyon — KAPSAM GENİŞLEMEZ
⛔ SON TUR  reviewer'da yeni bloklayıcı çıkarsa DAR-DÜZELTME + push; ONUNCU TUR AÇILMAZ; kalan bulgular T-task
⛔ pin (§9.13) YAZILMAZ · performansa DOKUNULMAZ · beyan-ratchet'i YAZILMAZ (ayrı şerit)
KURAL     bir dosyada iki desen varsa YANLIŞ olan DOĞRU olana hizalanır; üçüncüsü YAZILMAZ (DISIPLIN F12 onuncu üye)
KOŞUM     BRIEF_SABLONU §2.6 (her çağrı </dev/null · log dosyasına · exit ayrı · çok vaka tek betikten)
```

### `9.16.1` · İŞ — R1 · `$( )` İÇİNDE HATA-ÇIKIŞI (§9.15.5)
```
KONUM   sha256_file :1425 (8 çağrı, hepsi $( ) içinde) · build_row_hash_expr :1114 (:1146/:1147) ·
        classify_table_query_failure :914 (:944 T-047 kolu, :1190 DATA kolu)
DESEN   bu dosyadaki psql_val / psql_val_rc'ye HİZALA: fonksiyon değeri bir dosyaya/global'e yazar, rc döndürür;
        unmeasured ÇAĞIRANDA çağrılır · global hata bayrağı ANA KABUKTA set edilir
        ⛔ yeni (üçüncü) bir desen icat edilmez
```

### `9.16.2` · İŞ — R2 · BAYAT BEYAN KOŞULSUZ (§9.15.5)
```
BAYRAK  K1 tespitinin (0==2 · 1==3 · SON KONTROL) EN AZ BİRİNDE görüldüğü, farkın var olup olmamasından BAĞIMSIZ izlenir
SONDA   DECL_EFFECT='DATA_VOLATILE_INSERT' ∧ tespit HİÇ görülmedi → KIRMIZI "bayat beyan — veri byte-birebir,
        DATA_VOLATILE_INSERT gereksiz" (Z111 §24.1 N28 metni) — IRREVERSIBLE_ADD'in koşulsuz-else emsali
ETİKET  :1725 / :1780 / :1832'deki "bayat beyan" kırmızıları KALDIRILIR → fark geniş maskeyle açıklanamıyorsa ANA
        kırmızıya düşülür ("snapshot0 ≠ snapshot2" · "snapshot1 ≠ snapshot3" · "harness iz bıraktı") — kırmızının SEBEBİ
        gerçek kusurun adıdır
```

### `9.16.3` · İŞ — BEŞ MADDE
```
D-1  s10-update-now → mekanizmayı söyleyen ad (ör. body-now-update-known-red) + datasource + başlık notu:
     "maske DEFAULT-türevli; migration gövdesinin now()'ı kapsam dışı — Z111 §24 K1" · tüm başlık atıfları güncellenir
D-2  geniş (K1) maskenin büyüklüğü HER KOŞUMDA GÖRÜNÜR satır: "geniş maske N kolon / toplam M kolon" [çalışma anında ÖLÇÜLÜR]
     + başlıkta SINIR cümlesi (beyanlı migration'da FK kolonundaki gerçek kusur geniş maskeye düşebilir) — ⛔ SABİT SAYI YAZILMAZ
D-3  SON KONTROL'ün K1 girdisi simetrik: DATA_WIDE dosyalarından da migrations satırı çıkarılır (effect_data_wide yardımcısı)
D-4  paylaşılan tablo adları başlıkta: uuid-two-row-{insert,declared-stale} · parent-child-fk-{declared,undeclared} aynı
     tabloları kullanır — biri temizlenmeden diğeri kurulamaz
D-5  DEFERRED_DECLARED_MSG DATA_VOLATILE_INSERT kolunda boş satırla başlamaz
```

### `9.16.4` · KANIT — `Z83` (kol başına; bilinen-kırmızı ÖNCE/SONRA)
```
R1a  mutasyon: sha256_file'ın okuduğu shasum çıktısı BOŞ bırakılır (kopya+shasum, satır BASILIR)
       ÖNCE (round9-pre kopyası, scripts/ altına geçici) → rc=0 YEŞİL "✓ snapshot0 == snapshot2"  ← kusurun KANITI
       SONRA (düzeltilmiş) → rc=2 ÖLÇEMEDİM "boş hash"
R1b  mutasyon: T-047 kolunda bir tablonun COUNT sorgusu beklenmeyen hatayla bozulur
       ÖNCE → bayrak kaybolur (ÖLÇEMEDİM YOK) · SONRA → ÖLÇEMEDİM (S-9)
R1c  mutasyon: build_row_hash_expr'in grep adımı hata verir → SONRA ÖLÇEMEDİM + DOĞRU mesaj (grep, "tablo sorgusu" DEĞİL)
R2a  uuid-two-row-declared-stale → KIRMIZI "bayat beyan — veri byte-birebir …" (bugün YEŞİL — TL ölçtü §9.15.5)
R2b  YENİ fixture: body-now-update + EFFECT='DATA_VOLATILE_INSERT' + sebep (gerçek, FK-dışı 1≠3 kusuru)
       → KIRMIZI "snapshot1 ≠ snapshot3" · ⛔ "bayat beyan" DEĞİL (bugünkü yanlış teşhisin bilinen-kırmızısı)
R2c  parent-child-fk-declared → YEŞİL (DEĞİŞMEZ) · parent-child-fk-undeclared → exit 2 (DEĞİŞMEZ)
REGR TL doğrulamasının 33 vakası (§9.15.5) AYNI sonuç + R2a/R2b + gerçek HEAD 1833 YEŞİL (süresiyle)
```

### `9.16.5` · SINIRLAR · ÇIKTI
```
touches  scripts/migration-verify.sh · scripts/verification/synthetic-* (D-1 yeniden adlandırma, R2b fixture) ·
         read-declaration.ts yalnız gerekiyorsa
⛔ §5 · §9.7 · §9.12.4 · §9.14.5 geçerli · çıkış kodu 0/1/2 · MIGRATION_SEQUENCE / push-order.sh / docs YAZILMAZ · commit YOK
⛔ git checkout / git restore / git stash YASAK — geri alma YALNIZ kopya + shasum -a 256 -c (tam kopyalar: scratchpad/round9-pre/)
⛔ harness erken çıkarsa tabanı geri getirmek şeridin işi; tur taban geri gelmiş hâlde biter
ÇIKTI  1 DİFF (R1 · R2 · D-1…D-5 ayrı) · 2 Z83 tablosu (ÖNCE/SONRA · SEBEP satırı) · 3 KAPI (backend guards + meta run-all) ·
       4 ⛔ NE ÖLÇEMEDİN · 5 tur sonu taban + kalıntı + geçici dosya
```

### `9.16.6` · ⭐ DOKUZUNCU TUR REVIEW'U — BLOKLAYICI YOK · DÖRT T-TASK · 1835 İÇİN İLK ŞÜPHELİ (`Z111 §28`, 2026-09-13)
```
REVIEWER   🔴 YOK — R1 ve R2 kod + izole denemede KAPANDI · dört 🟡 + notlar → T-task (Z111 §26: onuncu tur YOK)
           T-391 (P2) rc'si okunmayan yardımcılar · T-392 başlıkta satır-numarası atfı · T-393 başlık semantiği · T-394 notlar
           🟡-2 ("scripts/.tl9-r1a-pre.sh untracked kopya") = Team Lead doğrulama betiğinin koşum sırasındaki GEÇİCİ mutasyon
           kopyası — betik her vakadan sonra siler ve sonda .tl9-* sayısını basar (koşum bitince ÖLÇÜLÜR)
KANIT      şeridin R1 kanıtı izole betikteydi ⇒ Team Lead R1a'yı GERÇEK harness'ta ÖNCE/SONRA koşuyor (Z111 §28 not 1):
           fonksiyonun KOPYASI kopyayı doğrular, harness'ı değil
```
> ### ⛔ 1835 — HARNESS'IN İLK GERÇEK MÜŞTERİSİ — BİLİNEN ADAY (`Z111 §28` not 2 · `§28.1 N36`)
> 1835 koşumu **beklenmedik** bir sonuç verirse — **ÖLÇEMEDİM ya da kırmızı**, **ya da beyanlı yolda beklenmedik YEŞİL** —
> ilk şüpheli: **`T-391` "rc'si okunmayan yardımcı"** (yazma hatasında iki boş dosya *"eşit"* sayılır ⇒ yanlış *"tespit var"*).
> ⚠️ Yön **iki taraflı**: beyansız yolda yanlış ÖLÇEMEDİM, **beyanlı `DATA_VOLATILE_INSERT` yolunda sahte YEŞİL** [ÖLÇÜLDÜ: kod].
> Sahte-kırmızıyı sahte-yeşil kadar hızlı tanımak için: sonucun **sebep satırı** okunur, renk değil.

### `9.16.7` · ✅ DOKUZUNCU TUR KAPANDI — TL BAĞIMSIZ DOĞRULAMA 36/36 (2026-09-13) · harness DOĞDU
**`scratchpad/harness-verify/tl-verify-r9.sh`** · harness sha `927e2bf5…` başta == sonda · `.tl9-*` kalıntısı 0 · taban aynı
```
R1a GERÇEK HARNESS — shasum çıktısı BOŞ, vaka declaration-nbd-green (NONE_BY_DESIGN: boş hash'ler tüm eşitlikleri geçer)
    ÖNCE (round9-pre kopyası)  rc=0 YEŞİL — stderr'de SEKİZ "ÖLÇEMEDİM: shasum BOŞ çıktı" satırı VARKEN
                               "✓ snapshot0 == snapshot2" + "✅ YEŞİL" basıldı  ⇒ KUSUR GERÇEK HARNESS'TA YENİDEN ÜRETİLDİ
    SONRA (şimdiki kod)        rc=2 ÖLÇEMEDİM "snapshot0: shasum BOŞ çıktı" — İLK boş hash'te durdu
    ⇒ şeridin izole-betik kanıtı (Z111 §28 not 1: kopya kopyayı doğrular) GERÇEK koşumla TEYİT edildi
MUT probe-s rc=2 ÖLÇEMEDİM "volatil=3" · MUT mask-off rc=1 "snapshot1 ≠ snapshot3" (maske 0 kolon)
REGRESYON 30 set + nullcollapse + gerçek 1833 — hepsi beklendiği gibi, iki yeni bilinen-kırmızı DAHİL:
    uuid-two-row-declared-stale    rc=1 "bayat beyan — veri byte-birebir, DATA_VOLATILE_INSERT gereksiz (K1 tespiti HİÇBİRİNDE
                                   tetiklenmedi)"  ⇒ R2 KAPANDI (sekizinci turda rc=0 idi)
    body-now-update-declared-wrong rc=1 "snapshot1 ≠ snapshot3" — "bayat beyan" DEĞİL  ⇒ yanlış teşhis KAPANDI
    body-now-update-known-red (eski s10-update-now) rc=1 · parent-child-fk-declared rc=0 · -undeclared rc=2 (DEĞİŞMEDİ)
REAL 1833 rc=0 · 99 s · primer maske 145 · geniş maske satırı çalışma anında basılıyor (D-2)
⚠️ SÜRE ANOMALİSİ [ÖLÇÜLDÜ, KAYNAĞI ÖLÇÜLMEDİ]: beş ardışık vaka normal (~60 s) yerine 11–61 dk sürdü
    (irr-stale-red · nbd-green · nbd-red · nbd-s0a-red · data-zero); öncesi ve sonrası normal; sonuçları DEĞİŞMEDİ
    ⇒ SEBEP YAZILMADI (DISIPLIN: "sayım farkı kaynağı gösterilmeden yorumlanamaz" · F14) — aynı saatlerde code-reviewer
      salt-okuma sorguları koşuyordu, ama bu ölçülmüş bir bağ DEĞİL
⚠️ "toplam kolon" koşumdan koşuma değişiyor (sentetik tablolar ekler) — payda evreni T-394'te
```
⇒ **TUR KAPANDI** — `Z111 §26` son-tur hükmü karşılandı: reviewer'da bloklayıcı yok, kalanlar T-391…T-394.
⇒ **Sıradaki:** §9.13 pin (kolon-imza, gerekçeli artefakt) → push-order-satırı + beyan-ratchet'i (eşik ilk ölçümle) → tek push → 1835.



> **⛔ BEŞİNCİ TURUN S-1'İNE `F12` (`Z111 §24 K2`):** §9.11.2 S-1 ve §9.11.4 S-1'deki *"boş string → ÖLÇEMEDİM"*
> **TİP** alanı içindir (`REVERSIBILITY=''`). **SEBEP** alanında boş ya da yalnız-boşluk değer **okundu ve geçersiz** —
> KIRMIZI *"beyan sebepsiz"*. *(S-1 metni silinmedi; sınır bu şerhle çizildi — Z111 §24.1 N27.)*
