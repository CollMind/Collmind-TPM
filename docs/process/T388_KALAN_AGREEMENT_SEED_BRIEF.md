# `T-388` KALAN — `agreement.seed.ts` **BULDUĞUNU SESSİZCE YENİDEN KULLANIYOR**
### Şerit: `data-engineer` · Hüküm: `Z108 §6` (hüküm 23) · ürün sahibi 2026-09-10 (kapsam notu) · ⏰ **TARİHSİZ**

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.** Raporunda da etiket kullan,
> **araç notlarını yaz**, son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

---

## 0 · OKUMA SIRASI — ⛔ her yol 2026-09-10'da `ls`/`grep`/`Read` çıktısında görüldü

```
1  docs/process/BRIEF_SABLONU.md
2  .claude/backlog/tasks/T-388.md                ← ⛔ "1 EKİM ÖLÇÜLDÜ — RİSK YOK" bloğu (:146-184)
3  docs/brd-v2/04_KARAR_KAYDI.md → Z108 §6 (hüküm 23) · Z108 §1.1 (hüküm 18) · Z83
4  docs/process/T388_SEED_ANAHTARI_VE_SEKIL3_BRIEF.md   ← ÖNCEKİ tur (zarf yarısı), §2.2 şekli
5  collmind.backend/src/database/seeds/agreement.seed.ts       :420-507
6  collmind.backend/src/database/seeds/budget-envelope.seed.ts  :200-300  ← ⭐ KONUŞAN ATLAMA EMSALİ
7  collmind.backend/test/helpers/seed-e2e.ts                    :80-130
8  collmind.backend/src/database/migrations/1832000000000-DemoPeriodQ3Realignment.ts  :120-140, :430-440
9  docs/DISIPLIN.md → "SEED bir DEMO'dur, FIXTURE bir SÖZLEŞMEDİR" · "SEED GÖRELİDİR, FIXTURE SABİTTİR"
                      "GERİ ALMA TERS İŞLEMLE DEĞİL, SNAPSHOT'TAN"
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | bu brief'te nerede |
|---|---|---|
| `Z108 §6` | hüküm 23 — **anahtar döneme özgü** + **`continue` konuşur** | `§3` |
| `Z108 §1.1` | hüküm 18 — demo-seed göreli; ⛔ **kapsamı YALNIZ ZARF** (`T-388` 1-Ekim ölçümü) | `§1` · `§5` |
| ürün sahibi 2026-09-10 | kalan **tarihsiz ve küçük**; *"göreli-seed kapsamı yalnız zarf, anahtar-döneme-özgü, ne atladığını basar"*; paralel şerit, kesişim yok | tümü |
| `Z83` | bilinen-kırmızı **ve** bilinen-yeşil | `§4` |
| `Z104 §1` / hüküm 13 | bir **kod** bir KİMLİKTİR — biçim değişikliği geçmişi etkiler mi, ÖLÇ | `§2` · `§3.2` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — tek cümle

> ### Seed, sabit `agreementCode` ile bulduğu anlaşmayı **dönemine/tarihine bakmadan**
> ### yeniden kullanıyor ve **atladığını söylemiyor**.

```
[ÖLÇÜLDÜ: agreement.seed.ts:493-503]
  const existing = await repo.findOne({ where: { agreementCode: agreement.agreementCode, tenantId } });
  if (!existing) { … save … } else { created.push(existing); }        ⛔ SESSİZ, karşılaştırma YOK
[ÖLÇÜLDÜ: agreement.seed.ts:505]   console.log(`✅ Seeded ${created.length} agreements`)
  ⇒ bulunan da yaratılan da AYNI sayıda "Seeded" — ayırt EDİLEMEZ
```

⭐ **Bu bir 1-Ekim riski DEĞİLDİR** — ölçüldü ve çürüdü:
```
[ÖLÇÜLDÜ: T-388.md:153-170]  faketime 2026-10-01, TAM e2e, iki dünya + pozitif kontrol
  zarflar Q4 · anlaşmalar Q3  → 64/887 ✅     zarflar Q4 · anlaşmalar Q4 → 64/887 ✅
  ⇒ "e2e seed zarflarının VARLIĞINA bağlı, DÖNEMİNE değil"
```
⇒ **Anlaşma seed'i GÖRELİ YAPILMAZ.** Bu tur bir **dürüstlük** turudur: seed ne yaptığını söyler.

---

## 2 · EVREN — ⛔ `agreementCode` BİR KİMLİKTİR, referansları ÖNCE

### `2.1` · ŞEKİLLER
```
Ş1  KOD DEĞERİYLE bulan    'STA-2026-0001' · 'STA-2026-0002' · 'LTA-2026-0001' literal
Ş2  STATÜYLE bulan         seed anlaşmasını statü + created_at ile seçen (kodsuz)
Ş3  MİGRATION ASSERT'İ     kod + tarih eşitliğiyle doğrulayan migration
Ş4  SEED ZİNCİRİ           anlaşmayı tüketen diğer seed'ler (budget-transaction, ledger …)
Ş5  VERİ                   DB'de aynı kodla kaç satır, hangi tarih/dönemde
```

### `2.2` · BAŞLANGIÇ LİSTESİ — ⛔ DEVRALMA, YENİDEN ÜRET
```
[ÖLÇÜLDÜ: for c in STA-2026-0001 STA-2026-0002 LTA-2026-0001; do grep -rn -F "$c" src test scripts | grep -v seeds/agreement.seed.ts; done]
  Ş3  1832000000000-DemoPeriodQ3Realignment.ts:127,132,137 (kod listesi) · :435-437 (kod + TARİH assert'i)
  Ş3  1828000000000-BackfillAgreementCategoryFromForecastingUnit.ts:16 (yalnız yorum)
  Ş4  budget-transaction.seed.ts:43 — description metni 'STA-2026-0002'
  Ş2  test/helpers/seed-e2e.ts:101-106,118-123 — kodla DEĞİL, status + ORDER BY created_at ASC LIMIT 1
  —   test/reversal.e2e-spec.ts:15 · test/settlement.e2e-spec.ts:18 — yalnız yorum
[ÖLÇÜLMEDİ — ölçülecek: Ş4 — budget-transaction.seed / ledger seed anlaşmayı ID ile mi KOD ile mi bağlıyor]
[ÖLÇÜLMEDİ — ölçülecek: Ş5 — SELECT agreement_code, status, start_date, end_date, period_month, created_at
                          FROM main.agreements ORDER BY created_at]
```
⚠️ **`Ş2` sinsi:** `seed-e2e.ts` **en eski** APPROVED / DRAFT'ı seçiyor. Döneme özgü bir anahtar
her yeni dönemde **YENİ SATIR** üretirse, *"en eski"* hâlâ eski satırdır — **ama** çakışma
evreni büyür:
```
[ÖLÇÜLDÜ: SELECT a1.agreement_code,a1.status,a2.agreement_code,a2.status FROM main.agreements a1
          JOIN main.agreements a2 ON a2.tenant_id=a1.tenant_id AND a2.cpl_id=a1.cpl_id
          AND a2.fu_id IS NOT DISTINCT FROM a1.fu_id AND a2.id>a1.id
          WHERE daterange(a1.start_date,a1.end_date,'[]') && daterange(a2.start_date,a2.end_date,'[]')]
  → 3 çift: LTA-2026-0001 DRAFT × STA-2026-0001 DRAFT · LTA-2026-0001 DRAFT × STA-2026-0002 APPROVED ·
            STA-2026-003 APPROVED × STA-2026-004 APPROVED
```

---

## 3 · İŞ

### `3.1` · İŞ 1 — **ATLAMA KONUŞUR** (`§2.5`) — ⭐ ZORUNLU, KÜÇÜK
`budget-envelope.seed.ts`'in deseni **izlenir, yeniden icat edilmez**:
```
[ÖLÇÜLDÜ: budget-envelope.seed.ts:208-215]  "skip NEDENİYLE konuşur … ATLANDI."
[ÖLÇÜLDÜ: budget-envelope.seed.ts:266-269]  "(period_from=…, period_to=…) — ATLANDI."
```
Bulunan her anlaşma için:
```
tarih/dönem seed tanımıyla AYNI   → "<kod> mevcut, aynı dönem — ATLANDI"
tarih/dönem FARKLI                → "<kod> mevcut, DB <start..end> ≠ seed <start..end> — ATLANDI,
                                     çünkü anlaşma seed'i göreli değil (T-388 1-Ekim ölçümü)"
son satır                         → yaratılan N · atlanan M AYRI sayılır
```
⛔ **Satırı GÜNCELLEME.** Anlaşmalar defter/rezervasyon taşıyor — güncellemek **defteri geriye yazmaktır**:
```
[ÖLÇÜLDÜ: SELECT a.agreement_code, count ledger_entries(source_id=a.id), count budget_transactions(source_id=a.id)
          FROM main.agreements a WHERE agreement_code IN (…)]
  kod             ledger   budget_tx
  STA-2026-0001      0        0
  STA-2026-0002      0        2      ⛔ SEED anlaşmasının KENDİSİ rezervasyon taşıyor
  LTA-2026-0001      0        0
  STA-2026-003       1        1      (seed değil — T-277 artığı, T-376)
  STA-2026-004       2        1      (seed değil — T-277 artığı, T-376)
```

### `3.2` · İŞ 2 — **ANAHTAR DÖNEME ÖZGÜ** (hüküm 23) — ⛔ ÖNCE EVREN, SONRA KARAR
Hüküm şekli: *"anahtar döneme özgü"*. İki biçim:
```
(a) KOD BİÇİMİ değişir     STA-<dönem>-0001            ⛔ Ş1/Ş3 KİMLİĞİ değişir
(b) BİLEŞİK arama          (agreementCode, periodMonth) ile findOne — kod AYNI kalır
```
⛔ **`(a)` seçilecekse DUR** — `1832`'nin kod+tarih assert'i ve `budget-transaction.seed:43`
kimliğe bağlı; bir kod biçimi değişikliği **geçmişi** etkiler (hüküm 13). Team Lead'e liste ile gel.
`(b)` için ölç: aynı kod iki dönemde **iki satır** olursa `agreements` üzerinde
`(tenant_id, agreement_code)` UNIQUE var mı?
```
[ÖLÇÜLDÜ: SELECT indexname,indexdef FROM pg_indexes WHERE schemaname='main' AND tablename='agreements' AND indexdef ILIKE 'CREATE UNIQUE%']
  → IDX_AGREEMENTS_TENANT_CODE (tenant_id, agreement_code) + PK · pg_constraint u/x → 0
  ⇒ (b) ikinci dönemde UNIQUE İHLALİ verir ⇒ (b) de ŞEMA değiştirmeden UYGULANAMAZ
```
> ### ⇒ Muhtemel sonuç: **İŞ 2 bugün UYGULANAMAZ** — ne `(a)` (kimlik) ne `(b)` (UNIQUE).
> ### Bu MEŞRU bir çıktıdır: ölç, **ÖLÇEMEDİM / UYGULANAMAZ** yaz, gerekçeyi LİSTEYLE ver.
> ### Anlaşma seed'i göreli olmadığı sürece döneme özgü anahtarın **tüketicisi de yok** —
> ### bunu da ölçüp yaz. ⛔ Migration YAZMA.

---

## 4 · KAPANIŞIN KANITI — `Z83`

```
BİLİNEN-KIRMIZI  (düzeltme ÖNCESİ)  seed'i DOLU bir DB'de koş → çıktıda "ATLANDI" YOK,
                 "Seeded 3 agreements" — yaratılanla atlanan AYIRT EDİLEMİYOR
BİLİNEN-YEŞİL    (düzeltme SONRASI) aynı koşum → 3 satır "ATLANDI" + sebebi · yaratılan 0 · atlanan 3
FARK VAKASI      seed tanımında bir anlaşmanın tarihini GEÇİCİ değiştir (mutate.sh ile, satır
                 numarasıyla) → "DB … ≠ seed …" satırı basılmalı; DB satırı DEĞİŞMEMELİ
                 (⛔ öncesi/sonrası SELECT ile göster)
```
⛔ **Mutasyon ARAÇLA:** `bash scripts/mutate.sh --file src/database/seeds/agreement.seed.ts --line <n> --to '<satır>' -- <ölçüm>`
— elle `sed`/`git checkout` YASAK. ⛔ `MUTASYON YAKALANDI` görülmeden fark vakası kanıt sayılmaz.

⚠️ **Seed koşumu DB'yi değiştirir** ⇒ öncesinde `agreements` + `budget_envelopes` **SNAPSHOT**,
sonrasında **birebir** karşılaştırma (`DISIPLIN F15`: geri alma snapshot'tan, ters işlemle değil).

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ ANLAŞMA SEED'İNİ GÖRELİ YAPMA — kapsam YALNIZ ZARF (ölçüldü, T-388 :176-184)
⛔ BULUNAN ANLAŞMAYI GÜNCELLEME — defter/rezervasyon taşıyabilir
⛔ agreementCode BİÇİMİNİ DEĞİŞTİRME — kimlik (hüküm 13); gerekiyorsa DUR, liste ile gel
⛔ MİGRATION YAZMA · docs/brd-v2/** YAZMA · yeni task AÇMA · commit/push YOK
⛔ git checkout YASAK — kopya + shasum -a 256 -c; mutasyon scripts/mutate.sh ile
⛔ budget-envelope.seed.ts'e DOKUNMA — emsal olarak OKU
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm"  (çıktı varsa DUR, bildir)
   ⚠️ Docker açılışında hayalet collmind-tpm-frontend/-backend KENDİLİĞİNDEN kalkıyor (2026-09-10)
⛔ test/.e2e-run.lock VARSA başka bir e2e koşuyor — DB'yi değiştiren seed koşumu YAPMA, DUR
⛔ KAPI İKİ ZİNCİR: `npm run guards` (backend) VE `bash scripts/run-all.sh` (META, kökten)
```

### `5.1` · ARAÇ NOTLARI (bu oturumda ölçüldü)
```
zsh'de P="docker exec …"; $P "…" KELİMEYE BÖLÜNMEZ → psql için heredoc
psql \echo içinde tek tırnak (') "unterminated quoted string" verir ve SONRAKİ satırın çıktısını
  yanlış etikete yapıştırır — \echo metninde ' kullanma
grep ugrep'e bağlı: karmaşık -E alternasyonu "complexity limits" → basit desen / grep -F -e … -e …
--include=*.ts zsh'de glob açılır → tırnakla: --include="*.ts"
git -C her zaman MUTLAK yolla
exit kodunu boruya sokma: cmd > log 2>&1; echo $?
```

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
collmind.backend/src/database/seeds/agreement.seed.ts     :493-507
```

## 7 · E2E KATMANI
```
Koşulmaz — seed çıktısı değişiyor, davranışı değil (bulunan satır yine yeniden kullanılır).
⚠️ Ama seed-e2e.ts (Ş2) seed anlaşmalarına dayanır ⇒ İŞ 2'de satır sayısı DEĞİŞİRSE e2e
   ZORUNLU olur — o durumda DUR, Team Lead koşar.
```

## 8 · KAPANIŞ ÇIKTISI
```
1  EVREN        — Ş1..Ş5, her biri AYRI; Ş4/Ş5 ölçümleri
2  İŞ 1         — diff + üç çıktı (kırmızı · yeşil · fark vakası) + snapshot birebir
3  İŞ 2         — (a)/(b) için UYGULANABİLİRLİK, gerekçe LİSTE; tüketicisi var mı
4  KAPI         — iki zincir + ilgili unit (varsa agreement.seed spec'i)
5  ÜÇ METRİK    — tur süresi · review-tur · DUR sayısı
6  ⛔ NE ÖLÇEMEDİN
```
