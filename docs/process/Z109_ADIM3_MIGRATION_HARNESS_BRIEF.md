# `Z109 ADIM 3` — MİGRATION DOĞRULAMA HARNESS'I: 80 dk elle → ~10 dk araçla
### Şerit: `data-engineer` · Hüküm: `Z109 §3` (ürün sahibi hükmü 26, 2026-09-08)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR — VE ONUN İLK MÜŞTERİSİDİR
> Her iddia etiketli: `[ÖLÇÜLDÜ: <komut/dosya:satır>]` · `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`
> **Etiketsiz bir iddia görürsen DUR ve brief'i İADE ET.**
> ⛔ **Raporunda da etiket kullan**, ve **araç notlarını yaz** — bir sonraki el (Team Lead)
> bağımsız ölçüm yapacak; senin düştüğün tuzağa yeniden düşmemesi buna bağlı.

---

## 0 · OKUMA SIRASI (ZORUNLU, bu sırayla)

```
1  docs/process/BRIEF_SABLONU.md        ← bu brief'in SÖZLEŞMESİ, §2 tarama desenleri dahil
2  docs/brd-v2/04_KARAR_KAYDI.md        → Z100 (migration şablonu) · Z87 (NULL-collapse)
                                          Z83 (kapı doğum kuralı) · Z109 §3
3  docs/DISIPLIN.md                     → "Assert taşıyan migration ÜÇ durumu ayırt etmeli"
                                          "Bir KAPI, ölçümün BAŞARISINI hata sayamaz"
                                          "Bir şema kararını geri alırken entity metadata'sını da geri al"
4  CLAUDE.md §2.6 · §2.7 · §4.2         → ölçüm disiplini · Done tanımı
5  .claude/backlog/tasks/T-359.md       → pipefail + grep -q ⇒ SAHTE KIRMIZI (bu harness'ın tuzağı)
6  collmind.backend/src/database/migrations/1831000000000-*.ts
                                        → EN KARMAŞIK örnek: CHECK + TRIGGER + backfill + assert
7  scripts/guards/sigpipe-hygiene.sh    → geçmen gereken kapı — ⛔ META KÖKÜNDE
   ⛔ F12 (Team Lead, 2026-09-08): ilk yazımda `collmind.backend/scripts/guards/…`
   yazıyordu ve BU YOL YOKTU (`T-359b` ile meta köküne taşınmış; iz
   `collmind.backend/scripts/guards/run-all.sh:293-294`'te). Şerit ölçüp bildirdi.
   ⇒ Bir brief'teki DOSYA YOLU da bir İDDİADIR ve BAYATLAR — `[ÖLÇÜLDÜ: ls -l <yol>]`.
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | bu brief'te nerede |
|---|---|---|
| `Z109 §3` | hüküm 26 — harness · üç çıktı · doğum şartı · hedef ~10 dk | tamamı |
| `Z100` | migration şablonu: `run→revert→run` bayt-birebir · şema-nitelendirme · şema↔entity | `§3.1` `§3.2` |
| `Z87` | `NULL`-collapse: `NULL` değerlenen `CHECK` **sağlanmış** sayılır | `§3.4` `§4` |
| `Z83` | kapı doğum kuralı: **bilinen-yeşil VE bilinen-kırmızı** | `§4` |
| `Z98 §3` | bir kolonun ömrü: `tanım → yazar → kısıt` | `§3.5` |

⛔ **Numarasız bir hüküm görürsen DUR** — Team Lead'e gelir.

---

## 1 · PROBLEM — tek cümle

> ### Bir migration'ın doğru olduğunu bugün **elle**, **her seferinde yeniden**, ve
> ### **her seferinde biraz farklı** ölçüyoruz.

```
[ÖLÇÜLDÜ: T-375/DALGA-B turları, 2026-09-07/08]
  bir migration turunda elle koşulan ölçüm ~80 dk
  ve her turda ADIM'lar UNUTULDU: bir turda revert kontrolü atlandı,
  bir turda CHECK'in NULL-girdi vakası yazılmadı (Z87 ancak review'da yakalandı),
  bir turda migration:revert CANLI bir e2e ile ÇAKIŞTI → 18 suite/89 test SAHTE KIRMIZI
[ÖLÇÜLMEDİ — ölçülecek: bu harness] aynı ölçüm ~10 dk'ya iner mi
```

⛔ **Hedef bir hız hedefi DEĞİL, bir TUTARLILIK hedefidir:** elle koşulan bir liste
**hatırlanmak zorundadır**; bir script değildir. `DISIPLIN`: *"kuralı hatırlamak yerine
ARACI çağır."*

---

## 2 · ÜRÜN — `collmind.backend/scripts/migration-verify.sh`

```bash
bash scripts/migration-verify.sh <MigrationSinifAdi|dosya-yolu>
```

### `2.1` · ÜÇ ÇIKTI — ve üçüncüsü MEŞRU

```
YEŞİL      exit 0   tüm kontroller geçti
KIRMIZI    exit 1   bir kontrol BAŞARISIZ — hangisi, NEDEN, ve GÖZLENEN/BEKLENEN
ÖLÇEMEDİM  exit 2   DB yok · bağlanılamadı · migration bulunamadı · ortam eksik
```

> ### ⛔ `ÖLÇEMEDİM` **`YEŞİL`'e DÜŞMEZ.** Bir kapı, ölçemediğini **geçti** sayamaz.
> ### Ve `KIRMIZI` da olamaz — *"ölçemedim"* bir başarısızlık değil, bir **durumdur**.

⛔ **Ve `ÖLÇEMEDİM` bir ÇIKIŞ YOLU DEĞİLDİR:** hangi ön koşulun eksik olduğu ve **nasıl
sağlanacağı** basılır. Sessiz `exit 2` yasak.

### `2.2` · KONTROLLER — hepsi, sırayla

```
K1  ORTAM        docker ps --filter "label=com.docker.compose.project=tpm"  → hayalet varsa DUR
                 DB erişilebilir mi · şema `main` var mı        ⇒ değilse ÖLÇEMEDİM
                 ⛔ CANLI BİR e2e KOŞUMU VAR MI — test/.e2e-run.lock KONTROL EDİLİR
                    (T-325 kilidi; varsa DUR — "migration:revert canlı e2e ile çakıştı"
                     vakası bir kez 18 suite'i SAHTE kırmızıya çevirdi)

K2  SNAPSHOT     şema parmak izi: katalog + kısıtlar + rowcount → shasum
                 ⛔ pg_dump YOK (yavaş, sürüm-bağımlı, gürültülü)
                 ⛔ ŞEMA-NİTELENDİRME ZORUNLU: nspname/schemaname predicate'i olmadan
                    pg_constraint/pg_indexes SORGULANMAZ (aynı instance'ta `public` de var)
                 ⛔ İKİ KATALOG: @Index({unique:true}) bir INDEX yaratır, constraint DEĞİL
                    ⇒ pg_constraint'teki YOKLUK, yokluk DEĞİLDİR

K3  DÖNGÜ        snapshot0 → run → snapshot1 → revert → snapshot2 → run → snapshot3
                 ⛔ snapshot0 == snapshot2   (revert GERÇEKTEN geri aldı)
                 ⛔ snapshot1 == snapshot3   (run BAYT-BİREBİR tekrarlanabilir)
                 fark varsa: HANGİ nesnede, ve iki tarafın DEĞERİ basılır

K4  CHECK'LER    migration'ın eklediği HER CHECK için ÜÇ vaka:
                   (+) sağlayan satır      → INSERT GEÇMELİ
                   (−) ihlal eden satır    → INSERT 23514 ile REDDEDİLMELİ
                   (∅) NULL girdi          → ⛔ Z87: NULL değerlenen CHECK SAĞLANMIŞ sayılır
                                              ⇒ NULL'ın hangi tarafa düştüğü YAZILIR
                 ⛔ Üçü de zorunlu. (−) yoksa CHECK'in ayırt etme gücü ÖLÇÜLMEMİŞTİR.
                 ⛔ Her vaka BEGIN/ROLLBACK içinde — veri BIRAKMA (T-047 invaryantı)

K5  ASSERT'LER   Z100 üç-durum kuralı, ⛔ ve ürün sahibi DÖRT diyor (Z109 §3):
                   S0  beklenen ön-durum        → devam
                   S1  zaten uygulanmış         → idempotent geç, SESSİZ DEĞİL — BASARAK
                   S2  beklenmeyen veri         → DUR, ve NE GÖRDÜĞÜNÜ bas
                   ELSE ⛔ SİLEN bir migration ise: NE SİLİYOR, KAÇ SATIR — ÖNCEDEN bas
                 ⛔ Sessiz atlama YASAK (§2.5)

K6  ŞEMA↔ENTITY  Z100: aynı turda hizalanır (nullable · tip · kolon adı)
                 [ÖLÇÜLMEDİ — ölçülecek: NASIL] TypeORM metadata'sını migration sonrası
                 şemayla karşılaştırmanın ucuz bir yolu var mı — YOKSA "bu kontrol
                 harness'ta YOK" diye AÇIKÇA yaz, sessizce atlama

K7  VERİ-MALİYET  migration `plans` ailesine dokunuyorsa (plans · plan_fus · plan_skus ·
                 plan_mechanic_values · plan_approval_history) satır sayısı ve
                 ETKİLENEN satır sayısı ÖNCEDEN basılır
```

---

## 3 · ⛔ TUZAKLAR — hepsi ÖLÇÜLMÜŞ, hepsi bu harness'ı ISIRIR

### `3.1` · `pipefail` + `grep -q` ⇒ **SAHTE KIRMIZI**
```
[ÖLÇÜLDÜ: .claude/backlog/tasks/T-359.md]
  printf … | grep -q …   →  grep ilk eşleşmede KAPANIR  →  yazan taraf SIGPIPE alır
  →  `set -o pipefail` onu HATA sayar  →  BAŞARILI bir ölçüm KIRMIZI görünür
  →  guard exit 1  →  PUSH YAPILMADI
```
⛔ Bu harness `scripts/guards/sigpipe-hygiene.sh` kapısından **geçmek zorundadır**.

### `3.2` · Exit kodunu boruya sokma
```bash
psql … > /tmp/out.txt 2>&1; rc=$?      # ✅
psql … | grep 'x'; rc=$?                # ⛔ grep'in kodu
```

### `3.3` · Şema-nitelendirme
Aynı PostgreSQL instance'ı hem `main` (bu ürün) hem `public` (TTM, **dondurulmuş**) taşıyor.
⛔ Şemasız bir `SELECT … FROM migrations` **YANLIŞ ÜRÜNÜN** geçmişini döndürür.

### `3.4` · `Z87` — `NULL`-collapse
```sql
CHECK (category IS NOT NULL)          -- category NULL  ⇒ FALSE ⇒ reddeder
CHECK (a = 'X' OR b IS NOT NULL)      -- a NULL, b NULL ⇒ NULL  ⇒ ⛔ SAĞLANMIŞ SAYILIR
```
Bir `CHECK` `NULL` değerlenirse Postgres onu **ihlal saymaz**. `K4`'ün `(∅)` vakası bunun içindir.

### `3.5` · `git checkout` ile geri alma **YASAK**
Kopyala → uygula → **kopyadan geri yükle** → `shasum -a 256 -c` ile **doğrula**.
`git checkout` untracked dosyada **sessizce hiçbir şey yapmaz**, tracked dosyada
**başkasının commit edilmemiş işini siler**.

---

## 4 · ⛔ DOĞUM ŞARTI (`Z83`) — HARNESS BUNLARSIZ DOĞMAZ

```
BİLİNEN-YEŞİL   son inen gerçek migration (1832000000000-DemoPeriodQ3Realignment)
                → harness YEŞİL vermeli

BİLİNEN-KIRMIZI SENTETİK bir migration: OR-zincirli bir CHECK ki NULL-collapse'a düşsün
                  ör.  CHECK (kind = 'A' OR note IS NOT NULL)
                → K4'ün (∅) vakası bunu YAKALAMALI ve harness KIRMIZI vermeli
                 ⛔ SENTETİK MIGRATION numara TAHSİS EDİLMEZ, src/database/migrations/
                   ALTINA KONMAZ. Yeri: scripts/verification/.
                 ~~COMMIT EDİLMEZ~~ ⛔ F12 (Team Lead, 2026-09-08): **COMMIT EDİLİR.**
                   İlk kural KANITI ÖLDÜRÜYORDU — commit edilmezse harness'ın
                   BİLİNEN-KIRMIZISI bir sonraki temiz checkout'ta YOK OLUR, ve Z83'e göre
                   bilinen-kırmızısı olmayan bir kapı KAPI DEĞİLDİR.
                   Güvenlik endişesi ÖLÇÜLDÜ ve YOK:
                   [ÖLÇÜLDÜ: src/config/typeorm.config.ts:61-84] gerçek zincir
                   `src/database/migrations/**` (dev) / `dist/database/migrations/**` (prod)
                   globunu kullanır; sentetik İKİSİNİN DE DIŞINDA ve yalnız açık
                   `-d scripts/verification/synthetic-datasource.ts` ile koşar.

ÖLÇEMEDİM       DB kapalıyken koş → exit 2, ve EKSİK ÖN KOŞUL basılmalı
```

> ### ⛔ Üçü de üretilmeden bu harness **bir kapı değildir**, bir **niyet beyanıdır**.
> ### Ve mutasyon kanıtı: harness'ın bir kontrolünü **devre dışı bırak** → bilinen-kırmızı
> ### **yeşile dönmeli**. Dönmüyorsa o kontrol **hiçbir şey ölçmüyor**.
> ⛔ Mutasyonu **satır numarasıyla hedefle ve değiştirdiğin satırı BAS** — `replace(…,1)`
> ilk metin eşleşmesine düşer ve o çoğu zaman bir **yorumdur** (üç kez oldu).

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ ÜRÜN KODU     DOKUNMA. Bu tur yalnız scripts/ (+ gerekirse package.json script satırı).
⛔ MIGRATION     GERÇEK bir migration YAZMA. Numara TAHSİS ETME.
                 (Sentetik fixture COMMIT EDİLİR — bkz. §4 F12.)
⛔ L2 / BRD      docs/brd-v2/** YAZMA — kural metnini yalnız Team Lead yazar
⛔ VERİ          Her kontrol BEGIN/ROLLBACK içinde. T-047 invaryantı: satır sayıları
                 harness ÖNCESİ/SONRASI BİREBİR AYNI olmalı — ve bunu SEN ÖLÇ, iddia etme
⛔ E2E           Koşum sırasında test/.e2e-run.lock varsa DUR (K1). Kendin e2e KOŞMA;
                 bu turun e2e katmanı: YOK (ürün koduna dokunulmuyor). tsc+guards yeter.
⛔ GERİ ALMA     git checkout YASAK — kopya + shasum -a 256 -c
⛔ COMMIT/PUSH   YOK. Belirsizlikte DUR.
⛔ HÜKÜM         Numarasız bir hüküm görürsen DUR — Team Lead'e gelir
```

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
collmind.backend/scripts/migration-verify.sh            YENİ
collmind.backend/package.json                            (script satırı — GEREKİYORSA)
collmind.backend/scripts/verification/                   (sentetik fixture — commit EDİLMEZ)
```

## 7 · E2E KATMANI
```
YOK — ürün koduna dokunulmuyor. Kapı: tsc 0 · npm run guards 0 (sigpipe-hygiene DAHİL).
```

## 8 · KAPANIŞ ÇIKTISI (bu başlıklarla)

```
1  scripts/migration-verify.sh          — ne yapıyor, K1..K7 hangileri UYGULANDI
2  DOĞUM ŞARTI                          — bilinen-yeşil · bilinen-kırmızı · ÖLÇEMEDİM,
                                          ÜÇÜNÜN DE ÇIKTISI YAPIŞTIRILIR
3  MUTASYON KANITI                      — bir kontrol devre dışı → bilinen-kırmızı YEŞİLE döndü mü
4  SÜRE                                 — harness'ın 1832 üzerindeki DUVAR SAATİ süresi
                                          (hedef ~10 dk; ⛔ ölç, tahmin etme)
5  T-047                                — harness öncesi/sonrası satır sayıları BİREBİR
6  KAPI                                 — tsc 0 · guards 0 (sigpipe-hygiene dahil)
7  ⛔ NE ÖLÇEMEDİN                       — "ölçemedim" MEŞRU bir çıktıdır.
                                          K6 (şema↔entity) burada olabilir — SESSİZCE ATLAMA
```

⛔ **Ve `§1`'in hız iddiası (`80 dk → ~10 dk`) bir HEDEFTİR, bir ölçüm değil.**
Raporunda onu `[ÖLÇÜLDÜ: duvar saati]` ile **değiştir** — ya da tutmadıysa **tutmadığını yaz**.
