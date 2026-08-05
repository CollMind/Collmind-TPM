# CollMind — Paylaşılan Backlog (Sprint / Epic / Task)

> **Bu dosya git'e commit'lenir ve tüm ekip + agentlar arasında paylaşılır.**
> Team Lead her yeni görevte ÖNCE buraya bakar; aynı/benzer task varsa YENİ açmaz, mevcudu devam ettirir.
> Her oturum başında SessionStart hook'u bu dosyayı context'e enjekte eder.

---

## Dosya Şablonları

### Task — `.claude/backlog/tasks/<id>.md`
```markdown
---
id: T-001
title: Kısa başlık
epic: E-001            # bağlı epic id (yoksa boş)
sprint: S-001          # aktif sprint id (yoksa boş)
status: todo           # todo | in-progress | review | done | blocked | blocked-unreachable
assignee: backend-engineer   # bir subagent adı
created: 2026-05-29
updated: 2026-05-29
touches:            # ZORUNLU — dokunulacak dosya/modül listesi
  - collmind.backend/src/modules/...
migration_seq:      # migration yazılacaksa MIGRATION_SEQUENCE.md'den tahsis edilen numara
---

## Açıklama
Ne yapılacak.

## Acceptance Criteria
- [ ] ...

## Done tanımı (hepsi işaretlenmeden `done` yazılmaz)
- [ ] Testler yeşil (unit + ilgili e2e)
- [ ] `npm run guards` yeşil (backend'e dokunulduysa) — exit 0
- [ ] `bash scripts/guards/money-float.sh --ratchet` exit 0 — **hiçbir** Alan A dosyasının
      bulgu sayısı artmamış olmalı. Azalma beklenen ve iyidir: azaldıysa yeni referansı
      `--baseline > scripts/guards/money-float-baseline.txt` ile ayrı, gözden geçirilebilir
      bir commit'te güncelle (baseline asla kendini yazmaz). **Baseline commit'i, azalmayı
      üreten commit'ten SONRA gelir** — önce gelirse ratchet o aralıkta kör kalır.
      Alan A üyelik testi: bir modül para üretiyor, para kalıcılaştırıyor veya parayı bir
      eşikle karşılaştırıyorsa Alan A'dadır — liste: `scripts/guards/money-float-domain-a.txt`
- [ ] code-reviewer onayı
- [ ] Üretim çağrı yolu var (yoksa → `blocked-unreachable`)
- [ ] Bağlayıcı koşullar guard'a bağlandı (test/lint/DB constraint/CI) veya "tavsiye"ye düşürüldü
- [ ] `touches:` gerçekte dokunulan dosyalarla güncel
- [ ] Migration varsa catalogue guard'ları şema-nitelendirilmiş

## İlgili
- Dosya/PR/branch linkleri, bağımlı task'lar ([[T-002]])
```

Yeni status değeri: **`blocked-unreachable`** — kod yazıldı, testleri geçiyor, ama üretimden
çağrılmıyor. `done` değildir.

### Epic — `.claude/backlog/epics/<id>.md`
```markdown
---
id: E-001
title: Epic başlığı
sprint: S-001
status: todo
created: 2026-05-29
updated: 2026-05-29
---

## Hedef
## Kapsadığı Task'lar
- [[T-001]]
```

### Sprint — `.claude/backlog/sprints/<id>.md`
```markdown
---
id: S-001
title: Sprint başlığı
start: 2026-05-29
end: 2026-06-12
status: active        # planned | active | closed
---

## Hedef
## Kapsadığı Epic'ler
- [[E-001]]
```

---

## Aktif Sprint
- [[S-001]] Konsolidasyon Sprint 1 — 2026-06-23 → 2026-07-07 — `active`

## Epic'ler
- [[E-001]] TTM'i Collmind-TPM'e konsolide et, ana ürünü olgunlaştır — `in-progress`

## Açık Task'lar (todo / in-progress / review)
| ID | Başlık | Öncelik | Assignee | Durum |
|---|---|---|---|---|
| [[T-083a]] | Yetim anahtar **tedavisi** — 'pasif mekanik' ↔ 'olmayan kod' ayrımı + iki mesaj | P2 | backend-engineer | review |
| [[T-088]] | `PATCH mechanics`: açık `null` doğrulanan durumla yazılanı ayırıyor (`??` birleştirmesi) | P2 | backend-engineer | todo |
| [[T-086]] | **E16** — E15 muafiyeti dosya bazlı olsun, guard'a bağlansın (ratchet laundering yolunu kapatır) | P2 | backend-engineer | todo |
| [[T-087]] | `boundOf`/`toNullableNumber` tekilleştirmesi — T-086'yı bekler (dürüst taşıma) | P3 | backend-engineer | blocked |
| [[T-093]] | `finance-reporting` aynı string birleştirme — **iki canlı GET rotasında** | P1 | debugger | todo |
| [[T-094]] | `commitBudget`/`releaseBudget`: **tenant izolasyonu yok** + sıralama deterministik değil | P1 | backend-engineer | todo |
| [[T-092]] | `format`/`lint` değişen dosyalarla sınırlansın — repo genelini kirletiyorlar | P3 | backend-engineer | todo |
| [[T-091]] | **Para akümülatörleri string birleştiriyor** — biri diske yazıyor, biri yanlış 'yetersiz bütçe' üretiyor | P1 | debugger | review |
| [[T-089]] | **Birleşik indirim tavanı PERCENT mekaniklerde HİÇ çalışmıyordu** — akümülatör string birleştiriyordu | P1 | debugger | review |
| [[T-090]] | ÖLÇÜM: `DecimalTransformer`'ı 22 entity'ye yaymak — kökten çözüm mü? (önce transformer'ın kendisi) | P3 | architect | todo |
| [[T-085]] | min/max doğrulaması **string karşılaştırması** — gerçek ihlaller sessizce kaçıyor (canlı rota) | P1 | debugger | todo |
| [[T-084]] | min/max `null`+string coercion — açık üst sınırlı mekanikler **hiç PATCH edilemiyordu** (canlı: 6'da 3) | P2 | debugger | review |
| [[T-083b]] | Yetim anahtar **önlemesi** — pasifleştirme kullanan planlardaki anahtarı da temizler (katman sınırı açık) | P3 | backend-engineer | todo |
| [[T-083]] | ~~Yetim taktik anahtarı~~ → **T-083a (tedavi) + T-083b (önleme)** olarak bölündü | P2 | — | done |
| [[T-082]] | ~~`null` taktik değeri: yazma/okuma asimetrisi~~ → **ADR 0008: kusur değil, yönü doğru** | P2 | backend-engineer | done |
| [[T-081]] | `INVALID_SCALE` mesajı hangi mekanik/hangi sınır olduğunu söylemiyor (`violations` render edilmiyor) | P3 | frontend-engineer | todo |
| [[T-080]] | `PATCH tactics` replace → **merge**: ikinci mekaniği girmek birincisini artık silmiyor | P1 | debugger | review |
| [[T-079]] | `POST /plans/:id/fus` açık yazma yolu — `AddFuDto.tactics` kaldırıldı (kapı değil, yolun kendisi) | P1 | backend-engineer | review |
| [[T-078]] | ~~`mechanicValues[code] \|\| 0` — değer yok ile sıfır ayırt edilmiyor~~ → **ADR 0008: ayrım yok, bilinçli** | P2 | backend-engineer | done |
| [[T-077]] | `budget-allocation.service.ts` sayısal dönüşümü — tabanın %33'ü tek dosyada (F1'e bağlı) | P2 | backend-engineer | todo |
| [[T-072]] | `agreements.mechanic_value` dondurma (ADR 0007 A4/K13) | P3 | backend-engineer | todo |
| [[T-073]] | 🔴 Bütçe %100+ bloklamıyor (`// TODO`) — CLAUDE.md §2.3 ihlali | P1 | backend-engineer | todo |
| [[T-074]] | 🔴 spend-validation'da dört hardcoded oran eşiği (CLAUDE.md §2.3 ihlali) | P1 | backend-engineer | todo |
| [[T-075]] | Sınır doğrulaması çağıran envanteri — A10 kanonik seçimi buna bağlı | P2 | backend-engineer | todo |
| [[T-076]] | Dağıtım artığı kuralı yakınsaması — Karar 6 kanonik, üç kural teke iner | P2 | backend-engineer | todo |
| [[T-069]] | 🔴 Onay ekranında artımlı GP bilerek yanlış (`× 0`) — sunucudan oku | P1 | frontend-engineer | todo |
| [[T-070]] | 🔴 `unitPrice ?? 0` fabrikasyonu — T-027 null semantiğiyle hizala (T-069 ile tek teslimat) | P1 | frontend-engineer | todo |
| [[T-071]] | Grid'de gömülü 8 formül dinamik formül kapsamı dışında (main.kpis'e taşı/sunucudan oku) + R4 | P2 | architect | todo |
| [[T-065]] | Split'in üretime açılma ön koşulu — Y1/Y2/B1-artık aralığı (ADR Karar 5 kısıtı buna bağlı) | P2 | backend-engineer | todo |
| [[T-064]] | 🔴 on-invoice validateBatch hâlâ kırık (aynı .toISOString() hatası) — yarım çalışan finansal modül | P1 | backend-engineer | todo |
| [[T-066]] | finance-reporting sortField — whitelist'siz dinamik orderBy (injection + INV-N-001 kör noktası) | P1 | backend-engineer | todo |
| [[T-067]] | Şema ayırma — bir veritabanı, bir ürün şeması (INV-M-003; allowlist'teki tek susturmanın karşılığı) | P2 | data-engineer | todo |
| [[T-063]] | SpendDistributionService'in kaderi — sil/deprecate/bağla (test yok, çağrı yok, karar ihlali var) | P2 | architect | todo |
| [[T-058]] | /submit-for-approval endpoint'ini kaldır (deprecation faz 2) | P3 | backend-engineer | todo |
| [[T-061]] | on/off üçüncü türetim noktası (plan.service.ts:2227) — tek kaynağa bağla | P2 | backend-engineer | todo |
| [[T-059]] | Seed fixture: aynı agreement iki zarfta 150.000 encumber ediyor | P2 | data-engineer | todo |
| [[T-057]] | Kalan 4 tipsiz zarf çözümü — status, auto-create, ledger yolları | P2 | backend-engineer | todo |
| [[T-054]] | Seed 4→8 zarf (bölünmüş dünya fixture'ı) — yalnız temiz DB | P3 | data-engineer | todo |
| [[T-055]] | unsplit ucu — split'in geri alınması (append-only) | P3 | backend-engineer | todo |
| [[T-013]] | CLOSED agreement ↔ reversal etkileşimi (re-open/reversible) | P2 | architect | todo |
| [[T-006]] | Reports olgunlaştırma | P1 | backend-engineer | todo |
| [[T-009]] | Gap audit (attachments/baseline/cap/sales) | P2 | planner | todo |
| [[T-010]] | Wella demo dataset (CTPM) | P1 | data-engineer | in-progress (ürün ✅, actuals→T-020) |
| [[T-021]] | CSV parser konsolidasyonu + entity kaydı tek kaynağa | P2 | backend-engineer | todo |
| [[T-022]] | Actuals ↔ agreement eşleştirme + recognition-exceptions | P2 | architect | todo |
| [[T-024]] | Baseline türetme (actuals→BASE_VOL) — BRD onayı şart | P3 | architect | **blocked** |
| [[T-025]] | Frontend actuals upload ekranı + batch geçmişi | P1 | frontend-engineer | todo |
| [[T-031]] | Encumbrance relief (ACTIVE dönem çifte blokaj) | P2 | architect | todo |
| [[T-011]] | TTM repo freeze formalizasyonu (README+tag/archive) | P2 | architect | todo |
| [[T-015]] | Cap kontrolü reversed tx semantiği (BRD karar) | P1 | architect | todo |
| [[T-016]] | Playwright UI E2E — altyapı + 4 senaryo **done**, kalan ~10 senaryo | P2 | qa-engineer | in-progress |
| [[T-046c]] | Kısmi recalc — **gerekçesi değişti**, T-046b+T-046d'den sonra yeniden değerlendir | P2 | architect | blocked |
| [[T-046d]] | Frontend performanceMonitor — kod hazır, **render dahil gerçek ölçüm eksik** | P1 | frontend-engineer | in-progress |
## Tamamlanan (done)
- [[T-064]] 🟢 **Finansal invariant guard'ları — Faz 1 (rapor) + Faz 2 (bloklama).** Dört guard artık gerçek kapı: `GUARD_MODE` varsayılanı `block`, `/qa` + `code-reviewer` + Done checklist'inden çağrılıyor (CI yok, bunlar pipeline'ın yerine geçen çağrı yolu). 5 catalogue sorgusu şema-nitelendirildi; düzeltme kenar DB'de kanıtlandı (54 migration boştan → kısıtlar `main`'de). **İki code review turu üst üste gerçek sessiz yanlış negatif buldu** — ikisi de guard'ın kendi kör noktasıydı, ikincisi birincinin düzeltmesinin ürettiği regresyondu. Satır-sezgiseli üç denemeden sonra kaldırıldı: `migration-schema.awk` gerçek lexer. Kapanış 3. tur değil **mekanizma** oldu: `fixtures/` (5 dosya, her biri bir turda bulunmuş kusurun kaydı + pozitif kontrol) ve `self-test.sh`, `run-all.sh`'in ilk adımı. Negatif testle doğrulandı. unit 627/627, guards exit 0 — `backend-engineer` — 2026-08-03
- [[T-062]] 🔴 **LUMPSUM_SPEND hiçbir toplama katılmıyordu** — götürü harcamalı planlar bütçeden hiç düşmüyor, SKU ROI'si görmüyordu. `distributeSpendToSKUs` ilk commit'ten beri ölüymüş (git ile ölçüldü), silindi; yerine base-hacim orantılı `computeLumpsumDistribution` (null base pay almaz, kuruş artığı en büyük base'e). Tüm base'ler null ise sessiz 0 yerine `400 LUMPSUM_DISTRIBUTION_NO_BASE_VOLUME`. Kanıt: submit sonrası `RESERVE OFF_INVOICE=100.00` (önce 0'dı). unit 609/609, e2e 233/233 ×3 EXIT=0 — `backend-engineer` — 2026-08-03
- [[T-056]] 🔵 **Submit yolu yakınsaması (7 adım)** — on/off-invoice ayrımı artık frontend'in gerçekten çağırdığı `POST /plans/:id/submit` ucunda çalışıyor. Task açıldığında ayrım üründen **tamamen erişilemezdi** (makine `/submit-for-approval`'da, frontend orayı hiç çağırmıyor). Yol boyunca 2 canlı hata (F1 hayalet COMMIT, LUMPSUM_SPEND) + 1 kanıtlanmamış koruma bulundu. Her adım ayrı commit, ayrı mutasyon kanıtı; unit 606/606, e2e 231/231 ×3 koşum EXIT=0 — `backend-engineer` — 2026-08-03
- [[T-060]] [[T-047]] invaryantı **kördü** — kapsam 39 tablo ölçülerek yeniden belirlendi: `approval_requests` (+38/koşum, 9.154 birikmiş), `admin_audit_logs` (+6, 3.167), `users` (+1, 289). Kök nedenler kanıtlı (FK'siz polimorfik `entity_id`; `DELETE /users` ucunun olmaması). Ajanın mutasyonu **ikinci bir yaşayan sızıntı** daha buldu (`cleanupTestTransactions` sırası audit izini öksüz bırakıyordu). Team Lead notu: mutasyonda **testler yeşilken exit code 1** — 'Tests: passed' tek başına yeterli sinyal değil — `qa-engineer` — 2026-08-02
- [[T-019b]] On/Off-Invoice **Faz 2** — `POST /budget/envelopes/:id/split` + append-only re-home (`|REHOME` ayrı key uzayı) + `UNTYPED_ENCUMBRANCE_PRESENT` guard + §5.5 tip bazlı availability. Migration yok. Ayrıca `SPEND_TYPE_REQUIRED_FOR_SPLIT_DIMENSION` guard'ı (ADR Karar 5). **Guard'ın ilk hali yanlış-pozitif üretiyordu — Team Lead canlı ölçümle buldu** (NKA-Q2 bölünürse bölünmemiş NKA-Q1 de 400 alıyordu, `LIKE 'yıl%'` fallback'i yüzünden); kontrol kazanan adayın boyut grubuna daraltıldı. e2e 227/227 ×3, unit 585/585 — `backend-engineer` — 2026-08-02
- [[T-053]] 🔴 CANLI hata — [[T-048]]'in getirdiği regresyon: RELEASE satırı tipsiz yazıldığı için tipli kovalar teardown'ı görmüyor, `/submit-for-approval` yolunda reject→resubmit **hiç RESERVE yazmadan** onaya gidiyordu (BRD "Approved bütçeden düşer" ihlali). Fix: `releaseNetReservation` artık `(envelopeId, spendType)` grain'inde netliyor, RELEASE kovanın tipini taşıyor, **UNTYPED key formatı birebir korundu** (çift iade riski R2). A17 kapsama boşluğunu kapattı; A16 regresyonsuz — `backend-engineer` — 2026-08-02
- [[T-052]] `calculateAllSpendsForFU` taktikleri okumuyordu → gerçek UI akışı (tactics PATCH) **0/0 spend** hesaplıyordu. Fix: **tek türetim noktası** `SpendCalculationService#buildMechanicValues` (`enteredValue` + `plan_fus.tactics`; çakışmada tactics kazanır, toplama yok) — iki kanonik yol da onu çağırıyor. İki yol aynı sonuç: `14500 == 10000+4500`. A8c'nin geçici seed fixture'ı kaldırıldı, gerçek akış test ediliyor. Mutasyon (Team Lead koştu): tactics okuması geri alınınca `tsc` temiz + test KIRMIZI `Expected > 0, Received 0` — `backend-engineer` — 2026-08-02
- [[T-019]] On/Off-Invoice **Faz 1** — migration 1795 (`spend_type` zarf+transaction, nullable); **hiç para taşınmadan** (up→down→up üç durumda da reserved birebir aynı); ADR 0004: agreement `spend_type` NULL → 400, **atomik blok** (biri aşarsa hiçbir rezervasyon yazılmıyor); geriye uyum korundu — `backend-engineer` — 2026-08-02
- [[T-048]] 🔴 CANLI hata düzeltildi — asıl fix **idempotency'nin kova-farkındalı olması** (`(plan,envelope,spendType)`); mutasyon: kapatılınca A8c `Expected 2, Received 1` (orijinal hata birebir); artık **iki ayrı RESERVE satırı** SQL ile kanıtlı — `backend-engineer` — 2026-08-02
- [[T-051]] Playwright↔backend suite yarışı — **Team Lead'in hipotezi ölçümle çürütüldü**; gerçek neden: `DELETE /plans/:id` soft-delete, T-047 satır sayıyor → her koşum kalıcı satır bırakıyordu (12 birikmiş ölçüldü), jest'in `LIKE 'E2E-%'` temizliği yan etki olarak siliyordu. Playwright artık kendi satırını **id ile** hard-delete edip doğruluyor; invaryant gevşetilmedi — `qa-engineer` — 2026-08-02
- [[T-050]] Login hata mesajı — `/auth/login` + `/auth/refresh` 401-refresh akışından muaf (**pathname bazlı**, substring değil); asıl yenileme mekanizması korundu (mevcut testler değişmeden geçiyor); **task tanımımdaki beklenen metin yanlıştı**, ajan gerçek backend davranışına göre yazdı — `frontend-engineer` — 2026-08-02
- [[T-049]] 🔴 Planning Grid hiza hatası düzeltildi — başlık/satır **tek kaynak** `gridColumns` memo'suna indirildi (üç ayrı filtre yazılmadı: kök neden tekrar üretilemesin); T-016 offset telafisi kaldırıldı; hizayı doğrulayan test + mutasyon kanıtı (Team Lead koşturdu) — `frontend-engineer` — 2026-08-02
- [[T-023]] **Bütçe varyansı raporu** — kapsam BRD kanıtıyla daraltıldı (hacim varyansının BRD'de karşılığı YOK, "spend actuals" future phase, sales_actuals boş); `variance = consumed − allocated`, reserved varyansa girmiyor; eşik ConfigService'ten, div-by-zero → null; mutasyon kanıtlı — `backend-engineer` — 2026-08-01
- [[T-047]] E2E fixture adlandırma sızıntısı — tek dosyaydı (`optimistic-locking.e2e-spec.ts`, 5 rename noktası önek kaybediyordu, biri soft-delete'te de sızıyordu); 203 agreement + 292 plan artığı temizlendi; **kalıcı invaryant**: Jest globalSetup/Teardown ile suite başı/sonu satır sayısı karşılaştırması (yalnız zarf değil), CI'da KIRMIZI yapıyor; mutasyon kanıtlı (derleme bozulmadan invaryant KIRMIZI'ya döndüğü doğrulandı) — `qa-engineer` — 2026-08-01
- [[T-039]] KPI/formül konfigürasyonunda optimistic locking (migration 1794) — **Team Lead'in "@VersionColumn burada çalışır" öncülü ajan tarafından TypeORM kaynağıyla çürütüldü** (save() çakışma kontrolü yapmıyor); eklemeli rollout (frontend kırılmadı); **2. gerçek hata: formül cache'i 60 sn bayatlıyormuş, clearCache'in üretim çağıranı yokmuş** — `backend-engineer` — 2026-08-01
- [[T-041]] `addFu`/`updateFuTactic`/`updateSkuVolume` yanıtında **CAS-sonrası** `planVersion`, `removeFu`'da `X-Plan-Version` başlığı — frontend'in `version+1` tahmini gereksizleşti; eklemeli değişiklik (kırılma yok); ajan CORS dersini kendiliğinden uyguladı — `backend-engineer` — 2026-07-31
- [[T-043]] `ParseUUIDPipe` 28 controller'a — bozuk UUID artık **400**, 500 değil; sorun "hiç yok" değil **tutarsızlık**tı (settlement/reversal zaten doğruydu); iş-kodu parametrelerine dokunulmadı — `backend-engineer` — 2026-07-31
- [[T-046b]] Recalc telemetrisi + **kalıcı round-trip regresyon testi** — süreye değil SAYIYA assert (deterministik, yükten etkilenmez); mutasyon kanıtı: hoisting kapatılınca 24→336, test kırmızı (Team Lead koşturdu); eşik ConfigService'ten, aşımda yalnız warn — `backend-engineer` — 2026-07-31
- [[T-046a]] Recalc mikro-temizlik — 500 SKU+tactic: round-trip **4565→60 (%99)**, süre **7103→467 ms (%93)**; **T-046'nın "mikro-temizlik yetmez" tahmini ölçümle çürütüldü** (eşiğin altına inildi) → T-046c'nin gerekçesi değişti; KPI çıktıları byte-eşit — `backend-engineer` — 2026-07-31
- [[T-046]] Recalc ölçek analizi (TASARIM) — **ölçüldü, tahmin edilmedi**: eğri lineer, eşik ~150 SKU (tactic'li ~70) aşılıyor, 500 SKU'da 1532/3372 ms; **BRD'nin kendi referans tasarımı zaten kısmi recalc** (KPI_Details [148], Team Lead doğruladı) → async reddedildi; T-045'in ölçemediği mechanic N+1 isteğin %52'si çıktı — `architect` — 2026-07-31
- [[T-040]] Frontend suite onarıldı — **24→0 fail dosya, 226→388 test, 8/8 ardışık koşum 51/51·388/388** (Team Lead doğruladı); kırık suite **2 gerçek üretim hatası** gizliyormuş (FormData 3 akışta bozuk, bildirim ID çakışması); `auth.service` testi assertion'larına hiç ulaşmıyormuş (mutasyon kanıtıyla doğrulandı) — `qa-engineer` — 2026-07-31
- [[T-045]] Recalc N+1 temizliği — round-trip **379→173 (%54)**, HTTP recalc **540→421 ms**: BRD `<500ms` eşiğinin ALTINA inildi, mimari değişiklik gerekmeden; KPI çıktıları birebir aynı (eşdeğerlik kanıtlı) — `backend-engineer` — 2026-07-30
- [[T-044]] BRD `<500ms` kapsamı **uçtan uca** olarak karara bağlandı (ADR 0003); T-034c'nin "tek formül" yorumu kanıtla çürütüldü; profil darboğazın **N+1 (318 round-trip, %49'u tekrar)** olduğunu gösterdi, formül motoru değil — `architect` — 2026-07-30
- [[T-034c]] Recalc advisory lock — 3 auto-commit yazımı tek transaction'a alındı (**atomiklik kanıtlanmış kazanç**); ancak **lost-recalculation yarışı 15 iterasyonda yeniden ÜRETİLEMEDİ** (dürüst kayıt); performans BRD sapması çıktı → [[T-044]] — `backend-engineer` — 2026-07-30
- [[T-042]] `cancel()` T-034b desenine geçti — son korumasız geçiş kapandı (`CLOSED` artık sessizce `CANCELLED`'a dönemez); T-032'nin asimetri kompanzasyonu gerçek transaction gelince gereksizleşti ve kaldırıldı — `backend-engineer` — 2026-07-30
- [[T-034b]] State geçişleri — transaction + FOR UPDATE + status-CAS; **kompanzasyon gerçek atomiklikle değişti** (T-014'ün karşılığı); kilit kaldırılınca yarış testi `[200,500]` (çift COMMIT) veriyor; Team Lead bütçe sızıntısı + frontend submit kırığını yakaladı — `backend-engineer` — 2026-07-30
- [[T-034f]] Frontend optimistic locking — version gönderimi + 409 akışı; **otomatik retry YOK** (olsaydı lost update'i geri getirirdi), axios delete gövde tuzağı kapatıldı; gizli parse hatası 12 kırmızı testi açığa çıkardı — `frontend-engineer` — 2026-07-29
- [[T-034]] Optimistic locking — `@VersionColumn` ölü kalırdı (mutasyonlar `.update()`), manuel version CAS uygulandı; code-review `delete()`'in atlandığını yakaladı (en yıkıcı yol korumasızdı); mutasyon kanıtı 7 kırmızı ile doğrulandı; multi-tenant açığı da kapandı — `backend-engineer` — 2026-07-29
- [[T-037]] E2E izolasyon — diriltme hack'i silindi (BRD ihlali kapandı: onaylı agreement artık bütçeden düşüyor); invaryantlar agreement/app-scoped'a çevrildi; **paralel 5 ardışık koşum 154/154** (Team Lead doğruladı) — `qa-engineer` — 2026-07-29
- [[T-038]] SA-E2E-06 tenant-geneli invaryantı — aynı kök neden, [[T-037]]'ye katıldı — `qa-engineer` — 2026-07-29
- [[T-036]] E2E zarf tükenmesi çözüldü — `cleanupTestTransactions` **hiç çalışmıyormuş** (source_id agreement_id tutuyor, sorgu asla eşleşmiyordu) + role-journey C7-C9 agreement'ı APPROVED bırakıyordu; reset'siz 3 ardışık koşum 153/153 kanıtlı — `qa-engineer` — 2026-07-29
- [[T-014]] Transactional audit — audit artık reversal/settlement transaction'ının İÇİNDE (rollback→0 satır SQL kanıtlı); high-risk alarm commit sonrasına ertelendi; review sonrası flush idempotency referans-seviyesine çekildi — `backend-engineer` — 2026-07-29
- [[T-035]] Seed DataSource'ları namingStrategy'siz kuruluyordu (`seed:cleanup-and-seed` kırık); kök neden düzeltmesi — `Team Lead` — 2026-07-29
- [[T-033]] Rejected→Draft geçişi — BRD state machine tamamlandı; **6. çift-sayım hatası** bulundu (reserveForPlan tip-bazlı idempotency → resubmit'te rezervasyon hiç oluşmuyordu) — `backend-engineer` — 2026-07-28
- [[T-032]] Agreement lifecycle audit — submit/approve/reject/cancel/update loglanıyor (önce 0 satırdı); APPROVE+CANCEL high-risk; cancel'da bilinçli asimetri (state geri alınmaz, AUDIT LOG MISSING) — `backend-engineer` — 2026-07-28
- [[T-028e]] Agreement CM kategori-scope — kategori FU→GU'dan türetilir; findById ham (boş) kolonu kullanıyordu, CM scope'u fiilen bozuktu — `backend-engineer` — 2026-07-28
- [[T-028c]] Planner scope enforcement — flag'li (varsayılan kapalı), backfill migration 1792; code-review scope kaçağı yakaladı (calculate-kpis/recalculate actor'suzdu → kapsam dışı planı yazdırıyordu) — `backend-engineer` — 2026-07-28
- [[T-028d]] Scope kopyaları AccessScopeService'e taşındı + F6 latent bug (cplId=null → "hiçbiri" idi) fix; e2e bütçe sızıntısı kalıcı çözüldü (cleanupTestPlans, 3 koşum kanıtlı) — `backend-engineer` — 2026-07-28
- [[T-028b]] AccessScopeService + CM kategori-scoped onay — pair semantiği kanıtlı (düzleştirme tuzağı kapalı), fail-closed; F3/F4/F7 fix; submit() submittedById'yi kaydetmiyormuş (guard'ı devre dışı bırakacaktı) — `backend-engineer` — 2026-07-28
- [[T-028a]] Rol konsolidasyonu — BRD 4 rol; MANAGER/FINANCE deprecated alias + ESLint kalkanı; CM artık onaycı; F8/F9 fix; route-ordering bug'ı bulundu — `backend-engineer` — 2026-07-28
- [[T-030]] Agreement bütçe rezerv sızıntısı — net-tabanlı ortak release motoru + backfill (17 agreement, 395.000 iade); code-review 5. çift-sayım hatasını yakaladı (plan tarafı da ortak motora devredildi) — `backend-engineer` — 2026-07-28
- [[T-029]] Plan onay audit + reserve/commit semantiği — approve/reject artık history yazıyor; submit→RESERVE, approve→COMMIT; **onaylı planların bütçeyi düşürmediği ikinci sızıntı** kapatıldı (migration 1789) — `backend-engineer` — 2026-07-27
- [[T-027]] KPI eksik-veri kuralı — COGS null → ROI/RAG null (sahte %100/GREEN bitti); migration 1788; bonus: cleanup FK fix + reseed-dayanıklı e2e; T-030 zarf sızıntısı bulundu — `backend-engineer` — 2026-07-27
- [[T-026]] Planning-first akış onarımı — entity kaydı + 2 migration + DecimalTransformer (string `>=`/`+=` bug'ları); submit→approve→bütçe SQL kanıtlı; role-journey 43/43 — `backend-engineer` — 2026-06-24
- [[T-020]] Actuals (satış) modülü portu — sales-actuals modülü + migration 1785; ledger sınırı 5 katman + DB kanıtı; hard-delete yerine versiyonlama; Wella actuals yüklü — `backend-engineer` — 2026-06-24
- [[T-018]] Planlama mechanic master-data seed — CPP/VIS_LS/PRICE_SUP/DISPLAY spendingType/category/mechanicType + backfill migration (0 NULL); SpendCalc routing doğrulandı — `data-engineer` — 2026-06-24
- [[T-017]] SpendCalc parite tamamlama — includes('PCT') hardcode → mechanic config-driven; baseTo NIV; tenant-scope bug'ı yakalandı — `backend-engineer` — 2026-06-24
- [[T-012]] Budget/RAG threshold config-driven — BudgetThresholdService (tenant-scoped, fallback) + migration; 4 tüketici hardcode kaldırıldı; YELLOW→AMBER (backend+frontend); on-invoice 95-100→RED (BRD) — `backend-engineer` — 2026-06-24
- [[T-008]] Finansal-doğruluk paritesi — KPI/ROI BRD'ye getirildi (GP_ROI=INCR_GP/INCR_SPEND, NIV turnover); sayısal kanıt Set A ROI=%10.18; circular dep + hardcode fallback'ler temizlendi — `data-analyst ∥ backend` — 2026-06-24
- [[T-007]] E2E suite (backend supertest) — auth/reversal/settlement/dashboard 51 test; kritik user_scopes tablo eksikliği bug'ı yakalandı+düzeltildi — `qa-engineer` — 2026-06-24
- [[T-005]] Dashboard port — shared/dashboard orchestrator (finance-reporting reuse, no-recompute) + frontend persona kartları; polymorphic approval count bug'ı yakalandı — `backend ∥ frontend` — 2026-06-24
- [[T-004]] Settlements derinleştirme — summary + close (state geçişi, budget'a dokunmaz); tenant-sızıntısı bug'ı yakalandı — `backend-engineer` — 2026-06-24
- [[T-003]] Reversals akışı port — reversal modülü + ledger CREDIT + audit; çift-restore bug'ı yakalandı — `backend-engineer` — 2026-06-24
- [[T-002]] Karar & dondurma — CTPM ana ürün kararı (ADR + governance) — `architect` — 2026-06-24
- [[T-001]] Wella Customer.xlsx'ten CPL + müşteri master-data tanımı — `backend-engineer` — 2026-06-23
