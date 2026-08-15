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
| [[T-205]] | `submittedById` bir yolda **boşaltılıyor** — `K-2.5.16` ihlali, bypass'ı sıfır maliyetle açıyor | P1 | backend-engineer | todo |
| [[T-207]] | **`S13`** — `plans.last_modified_by`: `K-2.5.11` kapsamının ikinci veri ayağı | P1 | data-engineer | todo |
| [[T-206]] | `sales_actuals`'ta SKU/hacim yokluğu: **veri kaynağı sınırı mı, domain kararı mı** | P2 | architect | todo |
| [[T-202]] | Lumpsum dağıtım tabanı: `ADR 0006` base seçti, BRD `§5.2` **planned** yazıyor — ADR'nin öncülü yanlışlandı | P1 | architect | todo |
| [[T-200]] | `Super Admin` altıncı rol olarak beliriyor — karar **[[T-165]] ile birlikte** verilmeli | P2 | architect | todo |
| [[T-201]] | `EA-001` admin yasak matrisi — üç madde karşılığı **aranmadan** duruyor (önce ölç) | P2 | architect | todo |
| [[T-083a]] | Yetim anahtar **tedavisi** — 'pasif mekanik' ↔ 'olmayan kod' ayrımı + iki mesaj | P2 | backend-engineer | review |
| [[T-088]] | `PATCH mechanics`: açık `null` doğrulanan durumla yazılanı ayırıyor (`??` birleştirmesi) | P2 | backend-engineer | todo |
| [[T-086]] | **E16** — E15 muafiyeti dosya bazlı oldu, guard'a bağlandı (T-087'yi açar) | P2 | backend-engineer | review |
| [[T-087]] | `boundOf`/`toNullableNumber` tekilleştirmesi — **blokaj kalktı** (T-086 indi) | P3 | backend-engineer | todo |
| [[T-093]] | `finance-reporting` string birleştirme — **12 nokta, beş rota** (3 sanılıyordu) | P1 | debugger | review |
| [[T-096]] | `budget_transaction_logs` 42701 + bakiye log'suz kalıcılaşıyor — üç commit (map · transaction · sıra) | P1 | debugger | review |
| [[T-095]] | `idempotency_key` **kısmi UNIQUE** (`WHERE key IS NOT NULL`) + okuma deseni | P1 | data-engineer | review |
| [[T-094]] | `commitBudget`/`releaseBudget`/`adjustUtilization`: **tenant izolasyonu yok** (üç nokta) | P1 | backend-engineer | review |
| [[T-092]] | `format`/`lint` değişen dosyalarla sınırlandı; **`lint:check`** tam repo denetimi | P3 | backend-engineer | review |
| [[T-091]] | **Para akümülatörleri string birleştiriyor** — biri diske yazıyor, biri yanlış 'yetersiz bütçe' üretiyor | P1 | debugger | review |
| [[T-089]] | **Birleşik indirim tavanı PERCENT mekaniklerde HİÇ çalışmıyordu** — akümülatör string birleştiriyordu | P1 | debugger | review |
| [[T-097]] | `DecimalTransformer` — NaN/Infinity **iki uçta da** reddediliyor; dört boşluk F4'e kayıtlı | P2 | backend-engineer | done |
| [[T-098]] | Hata veri kılığından çıkarıldı — **üç** canlı rota + hata nesnesi + UI | P1 | backend-engineer | review |
| [[T-099]] | `Number.isNaN(Infinity)===false` — **T-105'e devredildi**, iki nokta açık | P1 | debugger | blocked |
| [[T-104]] | C1 — kanonik sayı ayrıştırma biçim sözleşmesi (kararlar alındı) | P1 | planner | done |
| [[T-105]] | C2 — tek parser + dört çağrı yeri + `isFinite` | P1 | backend-engineer | done |
| [[T-106]] | Frontend tr-TR gösterip en-US ayrıştırıyor — 37 çağrı yeri, `\|\| 0` sessiz sıfır | P1 | frontend-engineer | todo |
| [[T-107]] | Excel import: seri-tarih + `raw: true` + `pickCell` — **iki adım da bitti** | P1 | backend-engineer | review |
| [[T-100]] | lint kapısı commit sonrası hiçbir şey ölçmüyor (§2.7 #9) | P2 | backend-engineer | todo |
| [[T-101]] | Eşikler bütün olarak alınıyor + `source`/`reason` + aralık CHECK | P1 | backend-engineer | review |
| [[T-108]] | RAG eşikleri üretimde konfigüre EDİLEMİYOR — admin ucu + provisioning | P2 | architect | todo |
| [[T-112]] | Escape **yazma** tetikliyor ve geçersiz girdi hücreyi kilitliyor | P1 | frontend-engineer | review |
| [[T-113]] | ✅ `lint-ratchet` KAPI — baseline `(dosya,kural)` çifti (dosya-toplamı körlüğü self-test case 9 ile sınandı); iki yönlü kırmızı kanıtı. ⚠️ `T-100` hâlâ açık | **P1** | qa-engineer | review |
| [[T-114]] | lint ratchet + self-test kuruldu (taban 488/112); `npm run lint` kapsamı değişmedi | P2 | frontend-engineer | review |
| [[T-115]] | `ledger.service.test.tsx` flaky — tam suite'te 4 koşumda 1 düşüyor | P3 | qa-engineer | todo |
| [[T-116]] | `type-check` artık `tests/`'i kapsıyor — 210 hata düzeltildi, bir kör test bulundu | P2 | frontend-engineer | review |
| [[T-117]] | Grid düzenleme: sessiz min/max clamp + kaydetme ucunda `canEdit` yok (iki karar) | P2 | architect | todo |
| [[T-118]] | Ölü `PlanningGrid.tsx` kapattığımız dört kusurun kopyasını taşıyor | P3 | frontend-engineer | todo |
| [[T-119]] | Runner yazıldı; **self-test'ler setup dallarına kör** (B4'te sertleştirdiğimiz sınıf) | P2 | frontend-engineer | in-progress |
| [[T-120]] | Frontend tiplerinde `Date` iddiası ile telden gelen string uyuşmuyor | P2 | frontend-engineer | todo |
| [[T-121]] | Müşteri import tarihleri: bir ay kayma + satır-bazlı teslim + katı gramer — **kapandı** | P1 | backend-engineer | review |
| [[T-122]] | Kalıcılaştırma tarih-yalnız değeri `Date`'e geri sokuyor (batıda bir gün) | P2 | backend-engineer | todo |
| [[T-123]] | Tarih grameri üç parser'da birleşti — `3.4.2026` artık 3 Nisan | P1 | backend-engineer | review |
| [[T-124]] | `amount <= 0` off-invoice'ta ret, on-invoice'ta serbest — dayanaksız asimetri | P3 | architect | todo |
| [[T-125]] | Yüzde biçimli para hücresi `raw:true` altında sessizce 100'e bölünüyor | P2 | backend-engineer | todo |
| [[T-126]] | Parse hataları satır kanalına bağlandı — kanal zaten vardı, kablolama eksikti | P2 | backend-engineer | review |
| [[T-127]] | `.slice(0,7)` dönem üretiminde güvenli değil — ISO genişletilmiş yıl sessizce geçiyor | P3 | backend-engineer | todo |
| [[T-128]] | Mutasyon aracı (`scripts/mutate.sh`) — bu oturumda bir dosya kaybettik | P2 | backend-engineer | todo |
| [[T-129]] | İki parser'ın dört getter'ı byte-for-byte aynı — §7 turu yarım | P2 | backend-engineer | todo |
| [[T-130]] | on/off-invoice import'ta HTTP e2e yok — T-126'nın vaadi iddia edilmiyor | P2 | qa-engineer | todo |
| [[T-131]] | `getDiscountType`'ın iki Türkçe yazımı ulaşılamaz (`toUpperCase` tuzağı) | P3 | backend-engineer | todo |
| [[T-132]] | **ÖLÇÜM:** D-15/D-16/D-17 — üç DUR da tetiklendi; F4'ün *bitişini* blokluyorlar | P1 | architect | review |
| [[T-133]] | "Toplam Hacim" aslında birim fiyat toplamı — alan `skus`'ta değil, FU'da | P2 | frontend-engineer | todo |
| [[T-134]] | Onay ekranında "Ortalama ROI" **iki+ planda `NaN%`** (tek planda kazara doğru) | P1 | frontend-engineer | todo |
| [[T-135]] | `null` ROI raporda/ekranda `0` — T-027'nin "never a fabricated 0" ihlali | P1 | backend-engineer | todo |
| [[T-136]] | **Alan B çıktısı para olarak kalıcılaşıyor** (`PLANNED_GP`→`total_gp`) — ADR 0007 R1 gerçekleşti | P1 | architect | todo |
| [[T-137]] | **ÖLÇÜM:** `max_combined_discount` semantiği — `0` = "mekanik kullanılamaz"; BRD okundu | P1 | architect | done |
| [[T-138]] | Hardcoded 50/30/**60** — BRD'de 50 ve 60 **dayanaksız**, ve BRD *uyarı* diyor kod *ERROR* | P2 | architect | todo |
| [[T-139]] | Yaptırım en katıyı, tavsiye en gevşeği söylüyor (`Math.max`) — sıfırdan bağımsız | P2 | backend-engineer | todo |
| [[T-140]] | BRD'nin `can_combine_with_others` + `typical_range_*` alanları bizde **hiç yok** | P2 | architect | todo |
| [[T-141]] | **ADR 0009 uygulaması** — `max_combined` için `CHECK (IS NULL OR > 0)` | P1 | data-engineer | todo |
| [[T-142]] | İki BRD çatışması **çözüldü** — paket bağlayıcı, PDF süperseded ([[ADR 0010]]) | P0 | architect | done |
| [[T-143]] | **Bağlayıcı BRD okuması** — tur 1/N bitti (Glossary); ~11.700 satır okunmadı | **P0** | architect | in-progress |
| [[T-144]] | Bütçe eşikleri: BRD'de **iki sistem** (RAG 80/95 · alert 80/**90**/100), kod birleştirmiş | **P1** | backend-engineer | todo |
| [[T-146]] | BRD `agreements` şemasının yedi kısıtı kodla hiç karşılaştırılmadı | P2 | data-engineer | todo |
| [[T-147]] | ~~`TRANSFER`/`ADJUST` BRD'de yok~~ → **ikisi de BRD tipi** (§3.3), sapma yok | P3 | backend-engineer | done |
| [[T-148]] | **`tactic_policies` tablosu YOK** — mod/mekanik izni/süre/onay eşiği mekanizması | **P1** | architect | todo |
| [[T-149]] | Price Simulation: dört kolon inmiş, **ekran yok** — şema var, giriş yolu yok | P2 | architect | todo |
| [[T-150]] | ~~kayıp ayrım~~ → `Committed` **Phase 2 durumu**; T-169'un semptomu | P3 | architect | todo |
| [[T-151]] | `ledger_entries`: BRD'nin `CHECK (amount >= 0)` **yok**, `status` kolonu **yok** | **P1** | data-engineer | todo |
| [[T-152]] | `spend_type: ACCRUAL` var, **yazan yol yok** — tahakkuk mekanizması tanımsız | P2 | architect | todo |
| [[T-153]] | Onay **politika katmanı yok** — `approval_policy_id` olmayan tabloya bakıyor | **P1** | architect | todo |
| [[T-154]] | Addendum H2: `SERIALIZABLE` yok, retry ölçülmedi, **kabul testi yazılmadı** | P2 | qa-engineer | todo |
| [[T-155]] | ~~H5.4 tarayıcıda emrediyor~~ → **dört katmandan biri**; §2.3 ayakta | P1 | architect | done |
| [[T-156]] | **EPIC:** BRD konfigürasyon modeli tanımlamış, ürün sabit koda çevirmiş — altı vaka | **P1** | architect | todo |
| [[T-157]] | Phase 2 kapısının üç ölçütü karşılanmadı — CI/CD perf regresyonu **yapısal yok** | P2 | architect | todo |
| [[T-158]] | `EXPIRED` + zaman aşımı → **UAT'ye ertelenmiş edge case** (CANDIDATE-004) | P3 | architect | todo |
| [[T-159]] | ~~§2.1 boşluğu~~ → **çelişki yokmuş**: Candidate Log Addendum'dan türetilmiş | P1 | architect | done |
| [[T-160]] | Formül motoru: BRD'nin sekiz `Math.*`'ı yazılamıyor + yetenek **iki kez** yazılmış | P2 | architect | todo |
| [[T-161]] | ~~`04_Reviews`~~ → review **girdisi**, çıktı değil; H1-H5 tartışması yok | P2 | architect | done |
| [[T-162]] | RAG toplama kuralı + negatif ROI *"flag for review"* ölçülmedi | P3 | qa-engineer | todo |
| [[T-163]] | ⛔ **`GP_ROI_PCT` paydası BRD'den farklı** — ana metrik, onay eşikleri ona uygulanıyor | **P1** | architect | todo |
| [[T-164]] | **Koruma:** BRD pseudo-kodunun `\|\| 0`'ı ve doğrulanmayan sırası bize bulaşmamalı | P2 | architect | todo |
| [[T-165]] | Yetki: BRD **yetenek** tabanlı (`agreements.create`), bizde **rol enum'u** | P2 | architect | todo |
| [[T-166]] | D-13: **altı biçim, ikisi çakışan** + actuals overwrite guardrail'i ölçülmedi | P2 | architect | todo |
| [[T-167]] | **D-11 KAPANDI:** RLS **Phase 1 gereksinimi** — karar değil, yazılmamış koruma | **P1** | architect | todo |
| [[T-168]] | **`INV-A-*` audit ailesi YOK** — kaynak 20 olay tanımlıyor, sözleşme boş | P2 | architect | todo |
| [[T-169]] | **Ürün Phase 1 kapsamının ÖNÜNDE** — iki sinyal, hiçbir yerde yazılı değil | **P1** | architect | todo |
| [[T-170]] | **Regülasyon boyutu yok:** 7 yıl saklama · KVKK anonimleştirme · E-Fatura arşivi | **P1** | architect | todo |
| [[T-171]] | `GrandTotals` ROI hedefi **sabit (20.0)** — kardeş okuyucu konfigürasyondan alıyor | P2 | frontend-engineer | todo |
| [[T-172]] | ✅ KAPANDI — iki yön düzeltildi (`BELOW_TARGET` · `AMBER`); kapsam üç kez büyüdüğü için tam sayım → [[T-220]] | **P1** | architect | done |
| [[T-173]] | Onay kaydı `who`'yu tutuyor, **`on what basis`'i tutmuyor** — `metadata`'nın 0 yazarı | P2 | architect | todo |
| [[T-174]] | **UOM dönüşümü yok:** birim taşınıyor, dönüştürülmüyor — uykuda 12× sessiz hata | P2 | architect | todo |
| [[T-175]] | Kaynak-doğruluk **sahipliği işaretli değil** — ilk ERP entegrasyonunun ön koşulu | P3 | architect | todo |
| [[T-176]] | Port öncesi iki karar: **LTA dönem↔tarih** semantiği · **CAP aşımında üç davranış** | P2 | architect | todo |
| [[T-177]] | Kesişim + `coverageRatio` JSONB'ye indi — **FU seviyesi kapandı**, plan seviyesi T-191'de | **P1** | backend-engineer | review |
| [[T-178]] | Üçüncü KPI varsayılan listesi bir **HTTP rotasında**, hiçbir test bağlamıyor | P2 | backend-engineer | todo |
| [[T-179]] | 🔴 `CATEGORY_MANAGER` onay ekranına giremiyordu — **12 kapı** düzeltildi + regresyon guard'ı | **P1** | frontend-engineer | review |
| [[T-180]] | Dört ölü tenant/admin mekanizması — ikisi `x-tenant-id`'ye **JWT'siz** güveniyor → sil | P2 | backend-engineer | todo |
| [[T-181]] | `RolesGuard` **fail-open** — 236 route'un 77'sinde rol filtresi yok, biri gerçek yazma | P2 | architect | todo |
| [[T-182]] | 🔴 Sayfa içi rol kontrolleri hizalandı — `hasRole`, ADMIN bypass'ı geri geldi | **P1** | frontend-engineer | review |
| [[T-183]] | Blok sınırına bağlanan tarama yardımcısı — `grep -A/-B` **aynı gün üç kez** maskeledi | P2 | backend-engineer | todo |
| [[T-184]] | Yetkinin **dördüncü** kopyası (`useAgreementPermissions`) — bugün doğru, kalıbı yanlış | P3 | frontend-engineer | todo |
| [[T-185]] | ⛔ Actuals-first anlaşma KPI'ları **uydurulmuş** SKU'dan — `// 10% uplift assumption` | **P1** | architect | todo |
| [[T-186]] | 🔴 `finance-reporting` bilinmeyen RAG'ı **`GREEN`** yapıyor — biri **risk** raporu | **P1** | backend-engineer | todo |
| [[T-187]] | 🔴 Girilen taktik değeri **geri okunamıyor** — grid düşürülmüş kolonu okuyor | **P1** | frontend-engineer | todo |
| [[T-188]] | ✅ Migration indi (`1802`) — 22 FK `RESTRICT`, 1231 satır tasfiye, tablo boşaldı | **P1** | data-engineer | review |
| [[T-189]] | 🔴 `/finance` **çöküyor** (hooks ihlali) + 6× 400 — ve ESLint zaten söylüyordu | **P1** | frontend-engineer | todo |
| [[T-190]] | `aggregationMethodFu` API'den yazılabiliyor — oran dalı iki sessiz regresyon üretiyor | P2 | backend-engineer | todo |
| [[T-191]] | ⛔ **B1 plan seviyesinde AÇIK** — kesişim FU'lar üzerinde, kusur SKU'larda | **P1** | architect | todo |
| [[T-192]] | ⚠️ `docs/brd/` kökünde **envanterlenmemiş altı dosya** — biri bağlayıcı (`Sprint_0`) | **P1** | architect | todo |
| [[T-193]] | ⛔ Bütçe hareketinin **log tablosu VAR ve BOŞ** (T-096); audit kapsamı ölçülecek | **P1** | architect | todo |
| [[T-194]] | ⛔ `Available` **iki aileyi topluyor** — `consumed` yarısı bugün **sessizce sıfır** | **P1** | architect | todo |
| [[T-195]] | **Tenant offboarding yolu yok** — `*/tenants` FK'ları ADR 0012 migration'ının dışında | P2 | architect | todo |
| [[T-196]] | 🔴 `type: 'date'` entity'de `Date` diye tipli, **string** dönüyor — iki canlı 500 | **P1** | debugger | todo |
| [[T-197]] | 🔺 decimal kolon tabanı **BAYATLADI**: 89→101 (üç günde, `B` dalgası) · 57 transformer'sız kaldı — taban yeniden alınmalı, tercihen guard'a bağlı | **P1** | architect | todo |
| [[T-198]] | `migration:generate` taban çizgisi bozuk — ilgisiz **188 FK** DROP+RECREATE istiyor | P2 | data-engineer | todo |
| [[T-199]] | 🔴 `seed:cleanup` **atfı imha eden yol** — `RESTRICT` kırmıyor, **yakalıyor**; iki tablo eksik | **P1** | architect | todo |
| [[T-203]] | `ADR 0012`'nin 4. adımı **inmedi** — şema guard'ı yok, `INV-L-001` hâlâ `HOLDS` | **P1** | backend-engineer | todo |
| [[T-204]] | 🔴 Soft-delete yolu **yok**, ve `v_budget_summary`'de yön ADR'nin korktuğunun **tersi** | **P1** | architect | todo |
| [[T-210]] | 🔴 Gönderen `PLANNER` taslağa dönen planına **erişemiyor** (`404 OUT_OF_SCOPE`) | **P1** | backend-engineer | todo |
| [[T-211]] | **`B` dalgası** — ✅ KAPANDI: `S1`–`S15` · `R1`/`R2a`/`R3` · seed 4.5/5 · enum pini mutasyon kanıtlı. `EŞİKLİ` → [[T-214]] | **P1** | data-engineer | done |
| [[T-212]] | ✅ dört kalem de kırmızı-kanıtlı: `mode-split` kimlik · `money-float` kapı · `guard.sh` `⏸️` · `find-importers.sh` (yeni araç) | **P1** | qa-engineer | review |
| [[T-213]] | `agreement_transactions.fiscal_period` sekiz kolonun tek nullable'ı — bilinçli mi kaza mı, ölçülmedi | P2 | data-analyst | todo |
| [[T-214]] | `approval_policies`: katalog seçeneği ile tenant politikası aynı satırda — `EŞİKLİ` şablonu bu yüzden yazılamıyor | P2 | architect | todo |
| [[T-215]] | gri→yeşil sızıntısı: `|| 'GREEN'` iki canlı rotada — `INV-N-004`, ve bugünkü veriyle ÇOĞUNLUK durumu | **P1** | backend-engineer | todo |
| [[T-216a]] | `GRİ` — GRID satırları: veri JSONB'de var, frontend tipi görmüyor | **P1** | frontend-engineer | todo |
| [[T-216b]] | `GRİ` — PLAN seviyesi: taşıyıcı kolon yok, [[T-218]]'e bağlı | **P1** | frontend-engineer | blocked |
| [[T-218]] | `plans.coverage_ratio` — değer hesaplanıyor, `plan.service` atıyor (iki ajan bağımsız buldu) | **P1** | data-engineer | todo |
| [[T-217]] | `GRİ`'nin üçüncü öğesi: eksik listesi — veri bugün taşınmıyor | P2 | architect | todo |
| [[T-219]] | ✅ İddia ÇÜRÜTÜLDÜ: `S5`'ten geliyordu, ve e2e suite'inin **tamamı** (17/17) kırıktı — düzeltildi | **P1** | qa-engineer | done |
| [[T-220]] | **TAM ENUMERASYON**: hesaplanamayan değer nerede bir iş yargısına çöküyor — liste, sayı değil | **P1** | code-reviewer | todo |
| [[T-221]] | ✅ `plan.entity.ts` 24 kolon — string→number, çökme koşarak reprodüklendi ve kapandı. ⚠️ `T-197` sayımı bayatladı (89→101) | **P1** | backend-engineer | done |
| [[T-222]] | İki grid implementasyonu, biri karanlıkta — `PlanningGrid.tsx` ölü kod (`İlke 4`) | P2 | frontend-engineer | todo |
| [[T-223]] | 🔒 `utils/export.ts` sıfır çağıran — mekanizma var, yol yok | P2 | frontend-engineer | blocked-unreachable |
| [[T-224]] | ✅ Entity listesi TEK KAYNAK — `index.ts` kaldırıldı; **pin ARTIK AKTİF** ([[T-225]] kapandı, `it.skip` → `it`) | **P1** | backend-engineer | review |
| [[T-225]] | ✅ **ÖLÜ İSKELE — silindi**: migration `1805` (üç durum ayrımı, üçü ampirik) + entity + `cleanup-data` + JSDoc + pin unskip. `BudgetReservationService` KALDI (canlı) | **P1** | architect | review |
| [[T-228]] | **TÜKETİM tarafı**: `string` bir değer sayı gibi tüketiliyor (`.toFixed()` · sözlüksel · `+`) — `T-220` bu sınıfı SORMUYOR (ölçüldü) | **P1** | code-reviewer | todo |
| [[T-229]] | **`Karar 6` YARIM uygulanacak**: 49 `DecimalTransformer` kolonunun **37'si PARA** — yuvarlama `MoneyTransformer`'a konursa atlanırlar (ölçüldü) | **P1** | architect | todo |
| [[T-230]] | **`§2.5` ALAN A'da**: eksik sayı sessizce `0` oluyor — `\|\| 0` 59 · `?? 0` 14 (Alan A). SAYAR, düzeltmez | **P1** | code-reviewer | todo |
| [[T-231]] | 🔴 `BudgetTransactionType` **İKİ KEZ** tanımlı — aynı TS adı, 7 vs 8 değer, küçük vs BÜYÜK harf. Tip kapısı SUSAR | **P1** | architect | todo |

> **Karar turu 2026-08-10:** [[T-163]] → **ADR 0011** (`TOTAL_PLANNED_SPEND`) · [[T-169]] → **Phase 2 bekler, taban sırası: T-167/T-165 → T-168 → T-156** · [[T-170]] → karar yok, `INV-C-*` ailesi açıldı, üç ölçüm sırada.
| [[T-145]] | ~~BRD tek ledger~~ → **bulgu yanlıştı**: iki-tablolu model BRD'nin modeli | P2 | architect | done |
| [[T-109]] | satır-içi editörler silindi; düzenleme `EditableCell`'e devredildi (2a+2b) | P1 | frontend-engineer | review |
| [[T-110]] | `formatForEdit` sessiz yuvarlama + fixture ayırt edemiyor | P2 | frontend-engineer | review |
| [[T-111]] | Frontend money-float ratchet + self-test kuruldu — taban 20 dosya / 68 bulgu | P2 | frontend-engineer | review |
| [[T-102]] | `formula-parser`: hata-null ile BRD'nin kural-null'ı ayırt edilemiyor | P2 | backend-engineer | todo |
| [[T-103]] | `GET /on-invoice/entries` iç mesajı 4xx gövdesine koyuyor — T-098'in dönen ucu | P2 | backend-engineer | todo |
| [[T-090]] | ~~ÖLÇÜM: transformer kökten çözüm mü?~~ → **hayır, üç sebeple**; beş faz önerildi, F3 ürün kararı bekliyor | P3 | architect | done |
| [[T-085]] | `spend-validation` **dört** string-karşılaştırma kusuru — kaçan ihlal + her istekte false positive (canlı rota) | P1 | debugger | review |
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
| [[T-024]] | Baseline türetme — **blokaj kalktı**, onay Addendum H4'te (MVB kademeleri) | P2 | data-engineer | todo |
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

> **Açık kararlar:** [docs/decisions/OPEN_DECISIONS.md](../../docs/decisions/OPEN_DECISIONS.md)
> — ürün sahibi · hukuk · danışman · teknik ölçüm bekleyen tüm kararların **indeksi**
> (içerik taşımaz, yere işaret eder). Yeni bir açık karar doğduğunda oraya satır eklenir.
