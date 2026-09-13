# BEYANLI MİGRATION'LAR **LİSTESİZ ÇOĞALABİLİR** — her no-op'a beyan yazma yolu açık
### Şerit: `backend-engineer` (meta script'leri) · Hüküm: `Z111 §16 §2` · ⛔ harness genelleştirme şeridi İNDİKTEN SONRA

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.** Raporunda da etiket kullan,
> **araç notlarını yaz**, son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

---

## 0 · OKUMA SIRASI — ⛔ her yol 2026-09-11'de `ls`/`grep`/`Read` çıktısında görüldü

```
1  docs/process/BRIEF_SABLONU.md
2  docs/brd-v2/04_KARAR_KAYDI.md → Z111 §16 (§2 çıkış kodu + güvence) · §18 (A · HARNESS_DECLARED)
3  docs/process/HARNESS_PG_ENUM_KORLUGU_BRIEF.md §9.9.2 · §9.10  ← beyan sözleşmesi (export adları, değerler)
4  .claude/backlog/MIGRATION_SEQUENCE.md → en alttaki "BEYANLI MİGRATION'LAR" bölümü  ← TEK KAYNAK
5  scripts/push-order.sh :255-324   ← pre-push kapı zinciri · "koşulmadı:" satırı (:315)
6  scripts/run-all.sh                ← meta guard zinciri (push-order bunu :313'te koşar)
7  scripts/guards/sigpipe-hygiene.sh ← META RATCHET EMSALİ (modlar, exit 2, self-test)
8  collmind.backend/scripts/verification/read-declaration.ts  ← harness'ın ts-node beyan okuyucusu
9  docs/DISIPLIN.md → F04 "KAPI DOĞUM KURALI" + "KONTROL-KOLU BAŞINA" · F06 "bir KANIT ADI iki mekanizmada"
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | bu brief'te nerede |
|---|---|---|
| `Z111 §16 §2` | beyanlı satır push-order beyanına **taşınır** (`geri-alınamaz migration: <numara> <sebep>`) | `§3.2` |
| `Z111 §16 §2` | beyanlı migration'lar `MIGRATION_SEQUENCE`'te **adıyla listeli + ratchet**; liste artışı ayrı gerekçeli commit | `§3.1` |
| `Z111 §18` | `IRREVERSIBLE_ADD` → iki zorunlu satır + `HARNESS_DECLARED` | `§3.2` |
| `Z83` · `DISIPLIN F04` | bilinen-yeşil **ve** bilinen-kırmızı — **her kontrol kolu ayrı** | `§4` |
| `Z111 §27` · `§26.1 N33` | **ratchet eşiği ilk ölçümle doğar** — brief'te ve hükümde önceden YAZILMAZ; baseline dosyası taşır | `§3.1` |

⛔ **Numarasız hüküm = DUR.**

> ⭐ **`F12` (`Z111 §27`, 2026-09-13):** bu brief'in hiçbir yerinde beyansız/beyanlı migration **eşiği sabit sayı olarak
> yazılmaz.** Şerit ratchet'i koşar, **ilk ölçümü** baseline'a yazar, ve o sayı **ölçüm komutuyla birlikte** raporlanır
> (`[ÖLÇÜLDÜ: <komut>]`). Bugünkü kayıt: beyan export'u taşıyan migration dosyası **0 / 89** [ÖLÇÜLDÜ 2026-09-13: grep
> `^export const (REVERSIBILITY|EFFECT)`] — ⛔ bu bir EŞİK değil, **şeridin başlangıç ölçümüdür** ve şerit onu yeniden ölçer.
> Harness'ın **gördüğü** evren ile dosya evreninin farkı (`Z111 §24.1 N29` blokundaki öncülsüz iddia) şeridin ölçeceği ilk sorudur.

---

## 1 · PROBLEM — tek cümle

> ### Harness beyanlı bir migration'ı **YEŞİL** geçirir; beyanı **kimin, neden** yazdığını ve
> ### beyanların **çoğalıp çoğalmadığını** hiçbir kapı görmüyor.

```
[ÖLÇÜLDÜ: grep -rn -E '^export const (REVERSIBILITY|EFFECT)' collmind.backend/src/database/migrations/] → boş
[ÖLÇÜLDÜ: aynı desen collmind.backend/scripts/verification/synthetic-migrations/declaration-known/] → 2 satır (pozitif kontrol)
[ÖLÇÜLDÜ: grep -F REVERSIBILITY synthetic-migrations/ | yorum satırları] → desene TAKILMIYOR (negatif kontrol)
[ÖLÇÜLDÜ: scripts/push-order.sh:313] run_gate "meta · scripts/run-all.sh" ⇒ run-all'a giren guard PUSH KAPISINDADIR
[ÖLÇÜLDÜ: scripts/push-order.sh:315] "koşulmadı:" satırı SABİT bir echo — beyan satırlarının emsali
```

---

## 2 · EVREN

```
Ş1  GERÇEK ZİNCİR     collmind.backend/src/database/migrations/*.ts   ⛔ YALNIZ bu dizin
                      (synthetic-migrations/ DIŞARIDA — onlar harness'ın fixture'ı)
Ş2  BEYAN BİÇİMLERİ   export const REVERSIBILITY = …   (satır başı, çapalı)
                      export const EFFECT = …
                      ⚠️ AYNI SÖZLEŞMENİN BAŞKA YAZIMLARI: export { REVERSIBILITY } · export const REVERSIBILITY: X = …
                         · çok satırlı atama — [ÖLÇÜLMEDİ — ölçülecek: read-declaration.ts hangilerini okuyor]
Ş3  TEK KAYNAK LİSTE  MIGRATION_SEQUENCE.md işaretçileri arası:
                        <!-- declared-migrations:begin --> … <!-- declared-migrations:end -->
                      satır biçimi: <dosya adı>|<REVERSIBILITY|EFFECT>=<değer>|<sebep ya da not>
```
⛔ **İKİ OKUYUCU RİSKİ (`DISIPLIN F06`):** harness beyanı **ts-node import** ile okur; bu guard'ın hızlı yolu
**satır deseni**. Aynı sözleşmeye iki mekanizma = biri görüp öbürü görmeyebilir.
⇒ guard: dosyada `REVERSIBILITY` ya da `EFFECT` kelimesi geçip çapalı desene **takılmayan** her dosyayı
`read-declaration.ts` ile **ayrıca** okur (az dosya — maliyet düşük) ve iki okuyucu **çelişirse KIRMIZI**.

---

## 3 · İŞ

### `3.1` · GUARD — `scripts/guards/declared-migrations.sh` (META)
```
MODLAR        --check (varsayılan, run-all çağırır) · --self-test · --report
KARŞILAŞTIRMA kod kümesi (Ş1 × Ş2)  ↔  liste kümesi (Ş3)
  kodda VAR, listede YOK   → KIRMIZI "beyanlı migration listede yok: <dosya> — AYRI, GEREKÇELİ commit ile listeye ekle"
  listede VAR, kodda YOK   → KIRMIZI "bayat liste: <dosya> — beyan kaldırıldıysa listeden de çıkar"
  değer farklı             → KIRMIZI "liste ↔ kod değer uyuşmazlığı: <dosya>"
  IRREVERSIBLE_ADD sebepsiz → KIRMIZI (liste satırının sebep alanı boş)
  NONE_BY_DESIGN sebepsiz   → KIRMIZI (Z111 §19 B-2: "beyan bir iddiadır, sebepsiz iddia yok" — kodda EFFECT_REASON,
                              listede sebep alanı; ikisi de ZORUNLU)
  iki okuyucu çelişkisi    → KIRMIZI (§2)
ÖLÇEMEDİM (exit 2)
  işaretçi yok / birden fazla / sırası ters · liste satırı biçim dışı · evren boş (migrations dizini yok ya da 0 .ts)
  read-declaration.ts koşamadı
ÇIKTI         taranan dosya SAYISI basılır (DISIPLIN F12: döngünün tur sayısı evrenle karşılaştırılır)
```
⛔ `sigpipe-hygiene` kapısından geçer: `pipefail` + `grep -q` / `head` / `grep -m` YASAK · exit kodu boruya sokulmaz ·
döngü içinde stdin açık komut → `</dev/null`.
⛔ `run-all.sh`'a bağla — bağlanmayan guard, guard değildir.

### `3.2` · PUSH-ORDER BEYANI — `scripts/push-order.sh` (:315'in yanı)
```
listedeki her satır için:
  REVERSIBILITY=IRREVERSIBLE_ADD  → "-- geri-alınamaz migration: <dosya> <sebep>"
  EFFECT=<değer>                  → "-- beyanlı migration: <dosya> EFFECT=<değer> <not>"
liste boşsa                        → "-- beyanlı migration: yok"   (sessiz DEĞİL — boş olduğu da beyanın parçası)
KAYNAK                              YALNIZ MIGRATION_SEQUENCE listesi — guard (run-all, :313) liste ↔ kod eşitliğini
                                    AYNI koşumda doğruladığı için liste burada GÜVENİLİR kaynak
⛔ satırlar kapı zinciri YEŞİL olsa da KIRMIZI olsa da basılır
⛔ push-order-self-test.sh'ın izole senaryolarını BOZMA — [ÖLÇÜLMEDİ — ölçülecek: PUSH_ORDER_SELFTEST_DONE dalında
   bu blok nerede durmalı; self-test koşup exit 0 göster]
```

### `3.3` · YAPILMAYACAK
```
⛔ harness'ın HARNESS_DECLARED satırını push-order'a BAĞLAMA — push-order harness koşmaz; kaynak LİSTE
⛔ MIGRATION_SEQUENCE.md'ye SATIR EKLEME — Team Lead dosyası; liste bugün boş ve boş kalır
⛔ "ayrı gerekçeli commit" kuralını guard'la zorlamaya çalışma — git geçmişi okumak bu turun kapsamı DEĞİL; başlıkta SINIR olarak yaz
```

---

## 4 · KAPANIŞIN KANITI — `Z83` · her kol ayrı

```
BİLİNEN-YEŞİL          gerçek zincir (0 beyan) + boş liste → exit 0 · "taranan: <N> dosya" · "beyanlı migration: yok"
KOL: kodda var/listede yok   fixture: sentetik migrations dizini + beyanlı dosya + boş liste → KIRMIZI, dosya ADIYLA
KOL: listede var/kodda yok   fixture: liste satırı + beyansız dosya → KIRMIZI "bayat liste"
KOL: değer uyuşmazlığı       → KIRMIZI
KOL: sebepsiz IRREVERSIBLE   → KIRMIZI
KOL: iki okuyucu çelişkisi   fixture: `export { REVERSIBILITY }` biçimi (desen görmez, ts-node görür) → KIRMIZI
ÖLÇEMEDİM                    işaretçi yok · biçim dışı satır · boş evren → exit 2
PUSH-ORDER                   liste boş → "-- beyanlı migration: yok" basılı (gerçek koşum çıktısı)
                             liste dolu (fixture ortamı) → "-- geri-alınamaz migration: …" basılı
                             push-order-self-test.sh → exit 0
```
⛔ fixture'lar `scripts/guards/` altında **self-test içinde** kurulur ve silinir (emsal: `sigpipe-hygiene --self-test`) —
gerçek `MIGRATION_SEQUENCE.md` ve gerçek migrations dizini **DEĞİŞMEZ** (`shasum -a 256` öncesi/sonrası).

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ HARNESS GENELLEŞTİRME ŞERİDİ İNMEDEN BAŞLAMA — paylaşılan ağaçta yarım bir run-all.sh onun meta kapısını bozar
⛔ collmind.backend/scripts/migration-verify.sh ve read-declaration.ts'e DOKUNMA (yalnız ÇAĞIR)
⛔ MIGRATION_SEQUENCE.md YAZMA · docs/** YAZMA · task AÇMA · commit/push YOK
⛔ git checkout YASAK — kopya + shasum -a 256 -c
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" (çıktı varsa DUR)
⛔ KAPI İKİ ZİNCİR: collmind.backend içinde npm run guards VE kökten bash scripts/run-all.sh
```

### `5.1` · ARAÇ NOTLARI (bu oturumda ölçüldü)
```
zsh: değişkene konmuş komut/yol listesi KELİMEYE BÖLÜNMEZ — yolları AÇIK yaz
grep → ugrep: karmaşık -E alternasyonu "complexity limits" → basit desen / grep -F -e … -e …
dosyadan okuyan while-read döngüsünde docker exec -i / npx gibi stdin açık komut → </dev/null (F12)
git -C ve kök script'ler MUTLAK yolla · exit kodunu boruya sokma
read-declaration.ts çağrısı: npx ts-node collmind.backend/scripts/verification/read-declaration.ts <dosya> (~1.1 s)
```

## 6 · `touches`
```
scripts/guards/declared-migrations.sh      YENİ
scripts/run-all.sh                         bağlama
scripts/push-order.sh                      beyan satırları (:315 civarı)
```

## 7 · E2E KATMANI
```
Koşulmaz — meta script'leri. Kanıt §4 + push-order-self-test.sh + iki zincir.
```

## 8 · KAPANIŞ ÇIKTISI
```
1  DİFF — guard · run-all bağlantısı · push-order satırları
2  İKİ OKUYUCU — read-declaration.ts hangi yazımları okuyor (ölçüm) · guard'ın ikinci yolu
3  Z83 — §4'ün her satırı ÇIKTISIYLA
4  SINIR — "ayrı gerekçeli commit" guard'ın dışında (başlıkta yazılı mı)
5  KAPI — iki zincir + push-order-self-test
6  ÜÇ METRİK
7  ⛔ NE ÖLÇEMEDİN
```

---

## 9 · ⭐ `F12` — GÜNCELLEME: HARNESS DOKUZ TUR + PİN SONRASI BUGÜNKÜ SÖZLEŞME (Team Lead, 2026-09-13) · ⛔ §1–§8'İN ÜSTÜNE YAZAR

> Bu brief harness'ın beşinci turundan önce yazıldı. Aşağıdaki satırlar **bugünkü** beyan sözleşmesidir; §2, §3, §4 ile çeliştiği yerde
> **bu bölüm kazanır**. Eski metin silinmedi (`F12` deseni).

### `9.1` · BEYAN SÖZLEŞMESİ — bugün (harness başlığı "BEYAN SÖZLEŞMESİ" · `Z111 §16` · `§19` · `§24` · `§26`)
```
EXPORT                  DEĞER                  SEBEP ALANI (zorunluluk)                          push-order SATIRI (§3.2'nin YERİNE)
REVERSIBILITY           IRREVERSIBLE_ADD       REVERSIBILITY_REASON — ZORUNLU                    "-- geri-alınamaz migration: <dosya> <sebep>"
EFFECT                  NONE_BY_DESIGN         EFFECT_REASON — ZORUNLU (Z111 §19 B-2)            "-- etkisiz beyanlı migration: <dosya> <sebep>"
EFFECT                  DATA_CONDITIONAL       sebep alanı YOK — stdout MIGRATION_AFFECTED_ROWS  "-- koşullu-veri migration: <dosya>"
EFFECT                  DATA_VOLATILE_INSERT   EFFECT_REASON — ZORUNLU (Z111 §24 K1)             "-- veri-kolu ÖLÇÜLEMEZ migration: <dosya> <sebep>"
⛔ boş / yalnız-boşluk sebep = SEBEPSİZ (Z111 §24 K2) — guard ve liste için de KIRMIZI
⛔ REVERSIBILITY ∧ EFFECT birlikte = harness'ta ÖLÇEMEDİM "beyan çelişkili" — guard da ÖLÇEMEDİM
⛔ tanınmayan değer = harness'ta ÖLÇEMEDİM — guard da ÖLÇEMEDİM (tanıma kümesi harness'la AYNI olmalı; iki liste yazma — okuma
   read-declaration.ts'ten ya da harness başlığından TÜRETİLİR, [ÖLÇÜLMEDİ — şerit hangisinin mümkün olduğunu ölçer])
LİSTE SATIRI            <dosya adı>|<EXPORT>=<DEĞER>|<sebep — DATA_CONDITIONAL için "-">
```
[ÖLÇÜLDÜ 2026-09-13] `read-declaration.ts` artık `node_modules/.bin/ts-node` ile çağrılıyor (§5.1'deki `npx` notu BAYAT) ·
beyan export'u taşıyan gerçek migration dosyası **0** [grep `^export const (REVERSIBILITY|EFFECT)`, `collmind.backend/src/database/migrations/`] ·
harness'ın doğrulama fixture'larında dört türün de bilinen-yeşili/kırmızısı var (`HARNESS_PG_ENUM_KORLUGU_BRIEF.md` §9.16.7, §9.13.8)

### `9.2` · "RATCHET" — NEYİN EŞİĞİ? (`Z111 §16 §2` · `§27`)
```
BU BRIEF'İN UYGULADIĞI (hükümlü)
  (a) LİSTE ↔ KOD EŞİTLİĞİ     §3.1'in karşılaştırması — sayı yok, küme eşitliği
  (b) BEYANLI SAYI              "liste artışı ayrı gerekçeli commit" (Z111 §16 §2) — guard'ın --report modu beyanlı migration SAYISINI tür başına basar;
                                EŞİK ilk ölçümle doğar (Z111 §27): şerit ilk koşumda sayıyı baseline dosyasına YAZAR, komutuyla raporlar;
                                sonraki koşumda artış = "beyanlı migration arttı — listede AYRI gerekçeli satır var mı" (liste↔kod eşitliği bunu zaten
                                yakalar; baseline ARTIŞIN GÖRÜNÜR olması içindir)
                                ⛔ baseline dosyası kendini yazmaz — --baseline modu ayrı, gözden geçirilebilir commit (CLAUDE.md §4.2 emsali)
⛔ REDDEDİLDİ — Z111 §32 (ürün sahibi, 2026-09-13)
  (c) BEYANSIZ SAYI ARTAMAZ     OLMAZ. Beyan bir İSTİSNA mekanizmasıdır; sağlıklı migration (tam geri-alınabilir, up etkili, revert etkisiz)
                                beyan TAŞIMAZ ve genel kontrolden geçer — beyansız = VARSAYILAN-SAĞLIKLI. Ratchet beyanlı sayıdadır (istisna artışı gerekçe ister).
                                ⇒ şerit (c)'yi YAZMAZ; --report modu beyansız sayıyı yalnız BİLGİ olarak basar (tutarlı-durum notu, çelişki değil — F04)
                                ⇒ yeni bir migration İSTİSNA durum taşıyorsa beyan zorunlu; taşımıyorsa beyansız doğar

### `9.3` · KANIT — `Z83` EKLERİ (§4'e)
```
KOL: sebepsiz NONE_BY_DESIGN · sebepsiz DATA_VOLATILE_INSERT · yalnız-boşluk sebep   → KIRMIZI
KOL: DATA_CONDITIONAL liste satırı "-" sebep                                       → YEŞİL (sebep alanı yok)
KOL: tanınmayan EFFECT değeri · REVERSIBILITY ∧ EFFECT birlikte                     → ÖLÇEMEDİM
KOL: baseline — ilk koşum sayıyı yazar (--baseline) · artış → görünür satır · --check baseline'ı KENDİSİ YAZMAZ [ÖLÇÜLDÜ: sha öncesi/sonrası]
PUSH-ORDER: dört türün satır biçimi (fixture ortamında) + liste boş → "-- beyanlı migration: yok"
```

### `9.4` · SIRA VE ORTAM
```
⛔ BAŞLAMA ŞARTI (§5'in yerine): harness pin eki (HARNESS_PG_ENUM_KORLUGU_BRIEF.md §9.13.9) İNDİ ve Team Lead doğrulaması BİTTİ —
   paylaşılan ağaçta Team Lead'in geçici mutasyon kopyaları (collmind.backend/scripts/.tl*-*) meta kapı zincirinin ölçümünü bozabilir
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" · ls -a collmind.backend/scripts | grep '^\.tl' → boş olmalı, değilse DUR
⛔ koşum biçimi BRIEF_SABLONU §2.6 · git checkout/restore/stash YASAK · commit/push YOK · MIGRATION_SEQUENCE.md ve docs/** YAZILMAZ
```

---

## 10 · ⭐ ŞERİT İNDİ — TL DOĞRULAMASI + REVIEWER: DÖRT BLOKLAYICI · ⛔ PUSH'TAN ÖNCE DAR DÜZELTME (2026-09-13)
```
ŞERİT   scripts/guards/declared-migrations.sh (YENİ, 811 satır, --check/--report/--baseline/--self-test) · baseline (ilk ölçüm: 0 beyanlı, 89 taranan) ·
        run-all.sh (+self-test +check) · push-order.sh (+beyan bloğu, GATE_FAIL öncesi) · self-test 12/12 · mutasyon (REASON zorunluluğu) → kırmızı ·
        iki zincir exit 0 · push-order-self-test 7/7 · gerçek MIGRATION_SEQUENCE + migrations sha DEĞİŞMEDİ
TL      [ÖLÇÜLDÜ] self-test rc=0 (12) · --check gerçek rc=0 "taranan .ts: 89" "beyanlı migration: yok" · --report rc=0 · MIGRATION_SEQUENCE sha değişmedi ·
        ⛔ BASELINE YOK iken --check → rc=0 + "baseline yok — ratchet görünürlüğü …" BİLGİ satırı (dosya kopyadan geri, sha eşit)
        ⇒ DISIPLIN F04 (gözlenen ≠ beklenen asla bilgi satırı) ihlali — reviewer B4 ile AYNI
```
**REVIEWER** — push edilmemeli
```
🔴 B1 --baseline ÖLÇEMEDİM yolunda (ts-node yok / dizin yok / türetme düştü) GEÇERLİ görünen "0 beyanlı, 0 dosya" baseline basıyor, exit 0 ·
      rc atanıyor, OKUNMUYOR (T-391 sınıfı) · KIRMIZI (sebepsiz) durumda da eksik sayılı baseline üretir   [reviewer ÖLÇTÜ: kopya]
🔴 B2 boş evren (dizin var, 0 .ts) + boş liste → YEŞİL · brief §3.1 "0 .ts → ÖLÇEMEDİM" diyor · "taranan" find'ın kendi çıktısıyla sayılıyor (totolojik)
🔴 B3 bozuk baseline satırı ("abc") → `[: integer expression expected` stderr'de, rc=0 · money-float :306 / sigpipe :233 emsali exit 2 — F04 vaka 1'in tekrarı
🔴 B4 baseline YOK → --check rc=0 bilgi (TL de ölçtü) · money-float :281 / sigpipe :221 exit 2 · self-test s10 bu davranışı SABİTLİYOR (rc bakmıyor)
⛔ DUR  ARTTI / AZALDI satırlarının RENGİ — brief §9.2(b) "görünürlük, bloklamaz" dedi; aynı gün DISIPLIN F04 "ratchet bu kuralın özel hâli" terfi etti
🟡 S1 push-order listeyi OKUYAMAZSA (dosya yok · işaretçi 2× · ters · end eksik) "beyanlı migration: yok" basıyor [reviewer ÖLÇTÜ: 4 durum rc=0]
      — push yine durur (guard ÖLÇEMEDİM → run-all FAIL) ama BEYAN METNİ YANLIŞ (sessiz sıfır)
🟡 S2 liste parse'ı İKİ KOPYA (guard ↔ push-order), farklı davranıyor (F12 iki desen) → guard'a --list-lines, push-order onu çağırsın
🟡 S3 tanınan DEĞERLER harness'tan türetiliyor ✓ ama SEBEP ZORUNLULUĞU kümesi elle yazılı · grep -m1 eşleşme sayısını kontrol etmiyor ·
      harness'ın "sahipsiz REASON" ÖLÇEMEDİM'i guard'da yok (DATA_CONDITIONAL + EFFECT_REASON guard'da yeşil)
🟡 S4 json_field yalnız \" \\ açıyor — "\t\n " sebebi guard'da DOLU, harness'ta BOŞ (K2 kırmızı) · jq ile tek ayrıştırıcı
🟡 S5 self-test bilinen-yeşili "beyanlı migration: yok" metnini şart koşuyor ⇒ ilk beyanlı migration (1835 beyanlı doğarsa) run-all'u KIRMIZI yapar
🟡 S6 guard find -maxdepth 1 · TypeORM **/*.ts [reviewer ÖLÇTÜ: typeorm.config.ts:63] · bugün alt dizin 0
🔵 N1 yinelenen liste satırı sessiz (join 2 eşleşme) · N2 anahtar kelime ön filtresi (export * / yalnız _REASON) — bugün ilgili dosya 0 ·
   N3 run-all exit 2'yi 1'e katlıyor (önceden var) · N4 ÖLÇEMEDİM yolunda "beyanlı migration: yok" basılıyor (B1 ile kapanır) · N5 self-test trap'siz
✅ run-all bağlantısı · push-order bloğu koşulsuz + self-test dalı dışında · set -e yok · dört satır biçimi · R1 sınıfı YOK · sigpipe temiz ·
   self-test guard'ı ÇAĞIRIYOR (kopya değil) · tanınan değerler harness'taki TEK eşleşmeden türetiliyor
```
**⇒ Team Lead önerisi — DAR DÜZELTME (push öncesi):** B1 · B2 · B3 · B4 · S1 · S5 · N1 · N4 — her biri çıkış kodunu değiştiren bilinen-kırmızıyla (F04)
**T-task:** S2 · S3 · S4 · S6 · N2 · N3 · N5  ·  **KARAR BEKLER:** ARTTI/AZALDI rengi

### `10.1` · ⭐ DAR DÜZELTME — ONAYLI (`Z111 §33`, 2026-09-13) · §9.2(b)'NİN "görünürlük, bloklamaz" CÜMLESİNİN ÜSTÜNE YAZAR
```
KARAR  (3): baseline HER ZAMAN gerçek beyanlı sayıya EŞİT (tür başına)
         ARTTI (ölçülen > baseline)  → KIRMIZI "beyanlı migration arttı — liste satırı + baseline güncellemesi AYRI gerekçeli commit (--baseline)"
         AZALDI (ölçülen < baseline) → KIRMIZI "bayat baseline — beyan kaldırıldı; baseline'ı --baseline ile düşür, AYRI commit"
         YENİ tür (baseline'da yok)  → KIRMIZI (ARTTI ile aynı sınıf)
         ⛔ §9.2(b)'deki "baseline artışın GÖRÜNÜR olması içindir" cümlesi DÜŞER (F12) — baseline bir KAPIDIR
```
```
İŞ (yedi madde — her biri çıkış kodunu DEĞİŞTİREN bilinen-kırmızıyla, DISIPLIN F04 "kapı yazılmış ≠ kapı işliyor")
B1  --baseline: tarama ÖLÇEMEDİM ya da KIRMIZI döndüyse baseline YAZILMAZ → exit 2 (ÖLÇEMEDİM) / exit 1 · erken dönüşler bulgularını OUT_* dosyalarına yazar
    · rc atanıp okunmadan bırakılmaz (DISIPLIN F12 onuncu üye — üçüncü vaka)
B2  boş evren: dizin var ama 0 .ts → ÖLÇEMEDİM (brief §3.1) · "taranan" sayısı find'ın kendisinden bağımsız bir sayımla karşılaştırılır
    (ör. ls/glob sayımı) — totolojik karşılaştırma YOK · self-test fixture dizinlerine beyansız bir .ts eklenir (s2/s7/s11 beklenenleri hükme göre)
B3  bozuk baseline satırı (sayısal olmayan · biçim dışı) → ÖLÇEMEDİM "baseline satırı bozuk" (money-float :306 / sigpipe :233 emsali)
B4  baseline YOK → --check ÖLÇEMEDİM "baseline yok — önce --baseline" (money-float :281 / sigpipe :221 emsali)
    + ARTTI / AZALDI / YENİ tür → KIRMIZI (yukarıdaki karar)
S1  push-order: liste OKUNAMAZSA (dosya yok · işaretçi ≠ 1 · ters sıra · end eksik) "!! beyanlı migration listesi OKUNAMADI" — "yok" DEĞİL
S5  self-test bilinen-yeşili bugünkü durumu (metin "beyanlı migration: yok") SABİTLEMEZ — rc==0 + "taranan .ts:" satırı + liste↔kod eşitliği
N1  yinelenen liste satırı (aynı dosya|EXPORT) → ÖLÇEMEDİM "yinelenen liste satırı"
N4  ÖLÇEMEDİM yolunda "beyanlı migration: yok" satırı BASILMAZ (B1 ile kapanır)
⛔ SELF-TEST BEKLENTİLERİ HÜKME ATIF TAŞIR (DISIPLIN F03 yeni kural, Z111 §33 kayıt 2): her senaryonun yorumunda "bu sonuç doğru çünkü §X"
   — s10'un bugünkü "bilgi satırı" beklentisi bu kuralın vaka 2'si; beklentiler koddan kopyalanmaz, hükümden yazılır
```
```
KANIT (her kol ayrı · gerçek dosyalar DEĞİŞMEZ, sha öncesi/sonrası)
  B1 ts-node yok + --baseline → exit 2, baseline dosyası sha DEĞİŞMEDİ · KIRMIZI tarama + --baseline → exit 1, yazılmadı
  B2 0 .ts dizin → exit 2 · B3 bozuk satır → exit 2 · B4 baseline yok → exit 2
  RATCHET: baseline'dan fazla beyanlı (fixture) → exit 1 "arttı" · az → exit 1 "bayat baseline" · yeni tür → exit 1 · eşit → exit 0
  S1 dört okunamama durumu → "OKUNAMADI" satırı (push-order bloğu, fixture ROOT) · N1 yinelenen satır → exit 2
  S5 fixture ortamında BEYANLI bir gerçek-zincir simülasyonu → bilinen-yeşil hâlâ exit 0
  MUTASYON: B4'ün kontrolü bozulur (kopya+sha) → self-test KIRMIZI (çıkış kodu, satır değil) · değişen satır BASILIR
  KAPI: backend npm run guards · meta bash scripts/run-all.sh · bash scripts/push-order-self-test.sh — üçü exit 0
```
```
T-TASK (bu işin DIŞINDA): T-397 elle yazılmış sebep kümesi (S3 — G5, ÖNCELİKLİ) · T-398 liste parse iki kopya (S2) · json_field kaçış (S4) ·
       alt dizin tarama (S6) · N2 · N3 · N5 · T-399 "atanmış ama okunmamış rc" statik tarama aracı
SINIR  touches: scripts/guards/declared-migrations.sh · scripts/guards/declared-migrations-baseline.txt (yeniden --baseline ile, gerekiyorsa) ·
       scripts/push-order.sh · (run-all.sh yalnız gerekiyorsa) · ⛔ migration-verify.sh / read-declaration.ts / MIGRATION_SEQUENCE.md / docs YAZILMAZ ·
       commit/push YOK · git checkout/restore/stash YASAK · koşum biçimi BRIEF_SABLONU §2.6
```

### `10.2` · ⭐ DAR DÜZELTME İNDİ — TL DOĞRULAMASI TEMİZ · REVIEWER İKİ 🔴 · §26/§33 GEREĞİ İKİNCİ DAR DÜZELTME (2026-09-13) · YENİ TUR DEĞİL
```
TL (gerçek dosyalar, geri yükleme + sha)  self-test 0 · --check 0 "taranan .ts: 89" · baseline YOK → 2 · bozuk satır → 2 "sayısal olmayan" ·
      ölçülmeyen tür baseline'da → 1 "bayat baseline" · boş evren (env) → 2 · MUT B3 (kopya+sha) → self-test rc=1 "FAIL [B3/baseline-bozuk]" ·
      run-all 0 · push-order-self-test 0 (7) · backend guards 0 · gerçek baseline ve MIGRATION_SEQUENCE sha DEĞİŞMEDİ
REVIEWER
🔴-1  liste OKUNAMAZ (chmod 000) → guard `[: : integer expression expected`, rc=0 "beyanlı migration: yok" · push-order AYNI "yok", rc=0
      (-f geçer, grep -c boş, [ "" -ne 1 ] hata → koşul yanlış) · blok yorumu "GATE_FAIL zaten set" YANLIŞ — guard da yeşil ⇒ BİLEŞİMSEL FAIL-OPEN ·
      baseline OKUNAMAZ → "Permission denied", rc=0 (beyanlı 0 iken sessiz yeşil)                                     [reviewer ÖLÇTÜ: kopya]
🔴-2  B2 "bağımsız sayımla KARŞILAŞTIRMA" YAPILMAMIŞ — ls sayımı yalnız sıfır kontrolünde · SCAN_DIR symlink → find 0, ls 89 → "taranan 0", rc=0 ·
      yalnız sub.ts/ alt dizini → rc=0 · beyanlı dosya symlink (-type f görmez) → beyan KAÇIRILIR, rc=0 · gizli .x.ts ls görmez   [ÖLÇTÜ]
🟡-1  başlık yorumu hâlâ "yalnız GÖRÜNÜRLÜK — artış BLOKLAMAZ" (§9.2(b) düşmedi) · çıkış tablosu ratchet/baseline kollarını anmıyor
🟡-2  --baseline erken dönüşlerde SEBEP kaybolur ("ÖLÇEMEDİM madde(ler) var:" boş) — B1'in "bulgular OUT_* dosyalarına" maddesi yarım
🟡-3  F03: self-test senaryolarının çoğu HÜKME ATIF taşımıyor (s1–s9, yeni-tür, s11) · s6 adı "boş-evren", sınadığı "dizin yok"
🟡-4  baseline biçim delikleri: "EFFECT 3" → yanıltıcı "bayat baseline" rc=1 · "FOO=BAR 0" → rc=0 · aynı tür iki satır → rc=0 · # total karşılaştırılmıyor
🟡-5  fixture senaryoları GERÇEK baseline'ı okuyor (yazmıyor) — gerçek baseline bozulursa fixture'lar yanlış sebeple düşer
🟡-6  S1 için push-order-self-test'te senaryo YOK
✅ B1 rc'ler okunuyor (29 atama, hepsi okunuyor) · B3 · B4 · KARAR (3) · rc birleştirme 2>1>0 · S1 dört durum (okunur dosyada) · S5 · N1 · N4 · bash -n
```
```
İKİNCİ DAR DÜZELTME (§26/§33: bloklayıcı → dar düzeltme + push)
R-1  ÜÇ OKUMA NOKTASI (liste · baseline · push-order listesi): [ -r ] değilse guard ÖLÇEMEDİM "okunamadı: <yol>" · push-order "!! … OKUNAMADI" +
     GATE_FAIL=1 (kapıyı başka yerde VARSAYMAZ — bileşimsel fail-open kapanır) · grep -c çıktısı sayısal doğrulanır (boş → ÖLÇEMEDİM/OKUNAMADI)
R-2  döngü sonrası: taranan (find) ≠ bağımsız sayım (ls -1A … .ts) → ÖLÇEMEDİM "sayım uyuşmazlığı (find=… ls=…)" · symlink dizin / symlink dosya /
     yalnız alt dizin / gizli .ts → hepsi ya eşit sayım ya ÖLÇEMEDİM — hiçbiri "taranan 0, rc=0" DEĞİL
Y-1  başlık yorumu karar (3) ile tutarlı · çıkış kodu tablosu ratchet + baseline yok/bozuk/okunamaz kollarını anar
Y-2  --baseline erken dönüşleri SEBEBİ OUT_UNMEASURED dosyasına yazar — çıktı sebebi ADIYLA basar
Y-3  self-test senaryolarının her birine hüküm atfı ("doğru çünkü §X") · s6'nın adı sınadığı şeyle hizalanır (DISIPLIN F03) — yalnız yorum/ad
KANIT (her kol çıkış kodunu değiştirir · fixture'lar mktemp altında · gerçek dosyalar sha öncesi == sonrası)
  liste chmod 000 → guard 2 · push-order bloğu OKUNAMADI + GATE_FAIL=1 · baseline chmod 000 → 2
  SCAN_DIR symlink (gerçek migrations'a) → 89 ya da ÖLÇEMEDİM, ASLA "0, rc=0" · yalnız sub.ts/ → 2 · symlink beyanlı dosya → yakalanır ya da 2
  --baseline dizin yok → çıktıda SEBEP satırı · MUTASYON: R-2 karşılaştırması bozulur → self-test rc=1 · KAPI: run-all · push-order-self-test · backend guards
T-398'E (bu işin dışında): 🟡-4 baseline biçim delikleri · 🟡-5 fixture'ların gerçek baseline'ı okuması · 🟡-6 S1 self-test senaryosu · 🔵 notlar
```

### `10.3` · ✅ İKİNCİ DAR DÜZELTME KAPANDI — TL DOĞRULAMASI TEMİZ · RATCHET İŞLETMEDE (2026-09-13)
```
ŞERİT   R-1 üç okuma noktasında [ -r ] + grep -c sayısal doğrulama · push-order okunamazlıkta KENDİSİ GATE_FAIL=1 ·
        R-2 find ↔ ls -1A karşılaştırması · Y-1 başlık karar (3) ile hizalı · Y-2 erken dönüş sebepleri OUT_UNMEASURED'da ·
        Y-3 senaryolara hüküm atfı, s6 → "dizin-yok" · yeni senaryolar R-1 ×2, R-2 ×3 · mutasyon R-2 → self-test rc=1
        evren kararı: symlink İZLENMEZ (find -type f) — R-2 uyuşmazlığı ÖLÇEMEDİM'e çevirir, sessiz 0 YOK
TL      [ÖLÇÜLDÜ — gerçek dosyalar, izin + sha geri]
        self-test 0 · --check 0 "taranan .ts: 89"
        MIGRATION_SEQUENCE.md chmod 000 → rc=2 "liste dosyası okunamadı (izin)" · izin + sha geri ✓
        baseline chmod 000 → rc=2 "baseline okunamadı (izin)" · sha geri ✓
        SCAN_DIR = gerçek migrations'a symlink → rc=2 "sayım uyuşmazlığı (find=0 ls=89)" ✓ (önceki hâl: taranan 0, rc=0)
        MUT R-1 (liste [ -r ] → false, şeridin seçmediği kol) → self-test rc=1 "FAIL [R-1/liste-okunamaz] … exit=2"
          ⇒ guard yine exit 2 verdi AMA başka bir sebeple — self-test SEBEBİ sınadığı için yakaladı ("kanıt rengin sebebidir")
        run-all 0 · push-order-self-test 0 · backend guards 0 · baseline / MIGRATION_SEQUENCE / guard sha başta == sonda
```
⇒ **RATCHET İŞLETMEDE** (`Z111 §33`). Açık kalanlar: T-397 (P1, G5) · T-398 · T-399. Sıradaki: tek push (onay) → 1835.
