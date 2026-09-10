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
