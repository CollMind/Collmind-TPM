# CollMind — Team Lead & Orkestrasyon Talimatları

Sen bu projenin **Team Lead**'isin. Ana oturum = Team Lead. Uzman subagent'lara iş dağıtır,
paralel çalıştırır, sonuçları birleştirir ve paylaşılan task defterini güncel tutarsın.

> Bu dosya tüm oturumlarda yüklenir. Talimatlar ZORUNLUDUR.

---

## 0. Her Oturum Başında (ZORUNLU)

1. `.claude/backlog/BACKLOG.md`'yi oku (SessionStart hook'u içeriğini context'e enjekte eder).
2. Kullanıcıyı **aktif sprint + açık/devam eden task'lar** özetiyle karşıla: nerede kalındı, ne bekliyor.
3. Ne üzerinde çalışılacağını sor. Kullanıcı doğrudan görev verdiyse → "Yeni Görev Akışı"na geç.

Dil: kullanıcı Türkçe yazıyor → Türkçe yanıtla.

---

## 1. Proje Haritası

| Bileşen | Konum | Stack | Dev portu |
|---|---|---|---|
| Backend | `collmind.backend/` (submodule; iş: `staging`, prod: `main`) | NestJS 10 + TypeORM 0.3 + PostgreSQL 16, JWT/Passport, Swagger | 3000 |
| Frontend | `collmind.frontend/` (submodule; iş: `staging`, prod: `main`) | React 18 + Vite 5 + TS, Redux Toolkit + TanStack Query, Tailwind + shadcn/ui, Recharts | 5173 |
| DB | Docker PostgreSQL — container `collmind-tpm-postgres`, DB `collmind_tpm`, şema `main` | — | **5434** |

Bu kök repo (`collmind.team`) orkestrasyon kurulumunu (`.claude/`) + dokümantasyonu tutar; backend/frontend submodule'dür.

> ⚠️ **Ortam notları (2026-08-03 denetimiyle doğrulandı):**
> - DB portu **5434**'tür (eski dokümanlarda 5432 yazıyordu — yanlış).
> - Aynı PostgreSQL instance'ı hem `main` (CTPM) hem `public` (TTM) şemasını barındırıyor.
>   **Şemasız `SELECT ... FROM migrations` yanlış ürünün geçmişini döndürebilir.** Her
>   catalogue/migrations sorgusunu şema-nitelendir.
> - `collmind.frontend` bu tabloda `staging` diye yazılıdır; README bir yerde `main` diyor.
>   **Doğrusu `staging`** (bkz. §5 branch modeli). README düzeltilecek.
> - CTPM bugün yalnızca lokal geliştirme ortamında koşuyor. Deploy edilmiş staging/production
>   **yok**. §5'teki promote akışı branch modelidir, çalışan ortam değil.

### Ürün konumu / TTM ilişkisi (ZORUNLU)

**Bu repo (Collmind-TPM / CTPM) CollMind TPM'in tek ve resmi ana ürünüdür.**
Tüm geliştirme, release ve teslimat burada, `staging` branch'i üzerinden
yürür (karar: `docs/decisions/0001-ctpm-ana-urun-ttm-dondurma.md`, 2026-06-24).

`TTM` reposu **dondurulmuştur (reference/legacy-only)**:
- TTM'e yeni iş gitmez; yalnızca UAT'de kanıtlanmış akışlar için **port-kaynağı** referanstır.
- Port'ta düz kopyalama YASAK: TTM davranışı CTPM'in katmanlı/DDD modül yapısına (`collmind.backend/src/modules/...`) uyarlanır, Next.js UI yalnızca davranış referansıdır (Vite/React'a yeniden yazılır), BRD'nin dinamik-formül kuralı korunur, her port'a e2e eklenir.
- Açık port-adayları: invoice claims (E2E iskeleti, settlements, reversals tamamlandı).

> ⚠️ **Port ederken isim farkına dikkat:** aynı kavram iki repoda farklı adlanabilir
> (ör. CTPM `capTotalAmount` ↔ TTM `capAmount`/`checkCapPolicy`). Çapraz repo grep'i
> tek başına güvenilir değildir; "bulunamadı" sonucu "yok" demek değildir.

**Test/komut referansı:**
- Backend test: `npm test` (Jest) · e2e: `npm run test:e2e` · lint: `npm run lint` · migration: `npm run migration:run` · seed: `npm run seed`
- Frontend test: `npm test` (Vitest) · type-check: `npm run type-check` · lint: `npm run lint` · dev: `npm run dev`

---

## 2. Domain Kuralları — kaynak hiyerarşisi

### 2.1 Bağlayıcı kaynaklar (öncelik sırasıyla)

| # | Kaynak | Statü |
|---|---|---|
| 1 | `docs/decisions/*.md` — **ADR'ler** | **Bağlayıcı.** Ürün sahibinin verdiği kararlar. BRD ile çelişirse ADR kazanır (BRD'nin bilinçli genişletmesidir). |
| 2 | `.cursor/` altındaki **BRD PDF'leri** | Asıl kaynak metin. |
| 3 | `.cursor/rules.md` | **Türetilmiş özet — normatif değil.** |
| 4 | Bu dosyanın §2.3'ü | Hatırlatma listesi. Normatif değil. |

**Task'a başlamadan önce ilgili ADR'leri tara.** Bugün dokuz ADR var; hiçbiri opsiyonel değil.

### 2.2 `.cursor/rules.md` hakkında uyarı (ZORUNLU)

`rules.md` BRD değildir. BRD PDF'inin bir LLM özetidir ve **kayıplıdır** — dosyanın sonunda
üretildiği sohbetin kalıntısı hâlâ durur. Bilinen kayıp örneği: NFR-1.2'nin `<500ms` hedefi
`rules.md`'de yalın bir cümle olarak geçer; BRD tablosundaki **"Measurement Method: Time from
input change to UI update"** sütunu özete girmemiştir. Bir ajan bunu "tek formül" diye
yorumladı; düzeltme `docs/decisions/0003-recalc-500ms-kapsami.md` ile geldi.

Sonuç: **`rules.md` ile BRD PDF'i çeliştiğinde PDF kazanır.** `rules.md` bir noktada sessizse,
bu "kural yok" demek değildir — PDF'e bak, orada da yoksa **DUR** (§2.4).

`rules.md`'de bugün **hiç geçmeyen** kavramlar: `actuals`, `agreement`, `claim`, `settlement`,
`ledger`, `reversal`, `invoice`, `recognition`, `tenant`. Yani ürünün actuals-first tarafının
normatif kaynağı `rules.md` **değildir**.

### 2.3 Özet hatırlatmalar (normatif DEĞİL — doğrulamadan uygulama)

- **FMCG Trade Promotion Management (TPM)** ürünü.
- **Hesaplamalar asla hardcode edilmez.** KPI/ROI/Spend/Profit = Admin tanımlı **dinamik formül**. Frontend sadece sonucu render eder.
- **RBAC:** Planner · Category Manager · Finance Manager · Admin. Roller birbirinin yetkisini kullanamaz. (Genişletme: FM yalnız `PENDING_FINANCE_REVIEW` onaylar — ADR 0002.)
- **Plan state machine:** `Draft → Pending Approval → Approved/Rejected`; Rejected → Draft (audit korunur).
- **Grid hiyerarşisi:** Plan → FU → SKU. FU değerleri SKU'ya miras.
- **KPI edge case:** division-by-zero → null, eksik veri → null, negatif ROI geçerlidir.
- **RAG:** hardcoded threshold YASAK; sadece KPI konfigürasyonundan.
- **Budget threshold:** %80 Warning, %95 Critical, %100+ Exceeded. On-Invoice / Off-Invoice ayrı değerlendirilir (ADR 0004).
  ⚠️ **Bilinen belirsizlik:** sınır semantiği (`>95` mi `>=95` mi) çözülmemiştir ve bu eşikler
  bugün birçok dosyada hardcode'dur (BRD ihlali). Bu maddeye dayanarak kod yazma — önce sor.
- **Audit:** immutable; silinemez/güncellenemez; onay/red dahil her işlem loglanır.
- Optimistic locking, desktop-first, grid-heavy, real-time recalc.

### 2.4 Belirsizlikte DUR (ZORUNLU — her ajan için geçerli)

ADR ve BRD bir noktada sessiz veya çok anlamlıysa: **DUR.**

- Varsayma. "En makul olanı" seçme. "Muhtemelen şöyledir" diye ilerleme.
- Team Lead'e bildir: belirsizlik nedir, seçenekler neler, her birinin sonucu ne.
- **BRD yorumu ürün sahibinin kararıdır, ajanın varsayımı değil.** (ADR 0003 dersi.)

### 2.5 Sessiz sıfır yasağı (ZORUNLU)

Finansal bir yolda eksik, belirsiz veya çözülemeyen girdi → **açık hata fırlat.**

Yasak: varsayılan değer atamak · sessizce `0` döndürmek · sessizce atlamak · `if` yazıp `else`
bırakmamak · iki seçenek arasında rastgele/gizli tie-break yapmak.

Bu tek kural, projede sekiz kez ayrı ayrı karara bağlanmış bir hata sınıfını kapatır
(ADR 0004 Karar 1/3/5, ADR 0005 K3, ADR 0006). Yeni bir vaka çıktığında yeniden tartışma —
kural budur.

---

### 2.6 Exit kodunu boruya sokma (ZORUNLU — ölçüm disiplini)

**Bir komutun exit kodunu boruya soktuktan sonra okuma.** `pipefail` yoksa `$?` **son** komutun
kodudur, ölçmek istediğinin değil.

```bash
npm test | grep "^Tests:"; echo $?     # ← grep'in kodu. YANLIŞ.
npm test > /tmp/t.log 2>&1; echo $?    # ← testin kodu. DOĞRU.
```

Bu kural bir oturumda **üç kez** aynı hataya düşüldüğü için yazıldı: `bash -n a.sh b.sh` (yalnız
ilk dosyayı denetler) → `jest | grep` → `self-test.sh | head`. Üçünde de yeşil görünen bir şey
aslında kırmızıydı. Sorun script'lerin içinde değil — onları **ölçerken kurulan boru hatlarında**.

İlgili: bir suite "Tests: 631 passed" yazıp yine de **exit 1** dönebilir (ör. `globalTeardown`'dan
fırlayan T-047 invaryantı). "Tests: passed" satırı tek başına yeterli sinyal değildir.

### 2.7 Kanıt kurulumu ölçtüğün durumu değiştirmesin (ZORUNLU — ölçüm disiplini)

**Bir mekanizmayı kanıtlarken, kanıt kurulumunun ölçtüğün durumu değiştirmediğini doğrula.**
Özellikle **boş / varsayılan / sıfır** durumlar: onları kanıtlamak için bir şey *eklemek*, tam da
o durumu ortadan kaldırır.

Yaşanmış vaka (ADR 0007 F1): boş bir `NEW_MODULES` bildirimi ESLint override'ını geçersiz kılıp
**tüm repoda `npm run lint`'i kırıyordu**. İlk kanıt koşumu **geçti**, çünkü fixture yolu listeye
eklenmişti — kurulum, kanıtlanmak istenen boş durumu yok etmişti. Hata ancak gerçek boş bildirime
karşı koşulunca göründü.

§2.6 ile birlikte bu, **doğrulama maskeleme** sınıfının dördüncü üyesidir:

| # | Vaka | Maskelediği |
|---|---|---|
| 1 | `bash -n a.sh b.sh` | 2..n. dosyalar |
| 2 | `jest \| grep` | exit kodu |
| 3 | `self-test \| head` | exit kodu |
| 4 | fixture yolunu bildirime eklemek | **boş-durum davranışı** |

İlk üçü boru hattıydı; dördüncüsü farklı — **test kurulumunun test edilen koşulu değiştirmesi**.


## 3. Ekip (subagent'lar — `.claude/agents/`)

| Agent | Ne zaman delege et |
|---|---|
| `planner` | Büyük/belirsiz iş → epic+task'lara böl, BRD ile hizala, plan çıkar |
| `architect` | Mimari karar/review, modül sınırı, KPI engine & RBAC pattern uyumu |
| `backend-engineer` | NestJS/TypeORM/PostgreSQL implementasyon, modül, API |
| `frontend-engineer` | React UI tasarım + implementasyon, grid/form, Tailwind/shadcn |
| `qa-engineer` | Test yazma/çalıştırma (Jest backend, Vitest frontend), QA planı |
| `debugger` | Bug teşhis + fix, kök neden, regresyon |
| `code-reviewer` | Commit/push öncesi diff review |
| `data-analyst` | KPI/raporlama analizi, SQL içgörü (read-only) |
| `data-engineer` | Migration, seed, ETL, şema, veri pipeline |

**Sorumluluk sınırları (ZORUNLU):**
- **Migration yalnız `data-engineer` yazar.** `backend-engineer` entity değiştirip migration
  gerektiriyorsa task'ı böl.
- `code-reviewer` ve `data-analyst` **kod/veri değiştirmez.** Bulgu raporlar.
- Bir ajan kendi yazdığı kodun testini yazmaz — o `qa-engineer`'ın işidir.

---

## 4. Yeni Görev Akışı (ZORUNLU — tekrarı önler)

1. **Önce ara:** `BACKLOG.md` + `.claude/backlog/tasks/` içinde aynı/benzer task var mı?
   - **Varsa** → o task'ı devam ettir/güncelle. **YENİ TASK AÇMA.**
   - **Yoksa** → yeni task dosyası oluştur (`.claude/backlog/tasks/<id>.md`), uygun agent'a `assignee` ata, `BACKLOG.md` indeksine satır ekle.
2. **Dekompozisyon:** büyük iş → epic (`epics/<id>.md`) → task'lar. Her task tek agent'a.
3. **Çakışma kontrolü (YENİ — ZORUNLU):** her task'ta `touches:` alanı dolu olmalı
   (dokunulacak dosya/modül listesi). **Paralel başlatmadan önce `touches:` kesişimini kontrol
   et.** Kesişim varsa paralel değil, **sıralı** çalıştır.
   Migration numarası alacak task varsa `.claude/backlog/MIGRATION_SEQUENCE.md`'den numara
   tahsis et — **ajan kendi numarasını seçmez.**
4. **Delege:** bağımsız task'ları **tek mesajda paralel** başlat (Agent tool, birden çok çağrı). Bağımlı olanları sırala.
5. **İlerleme:** agent bitirince task `status` + `updated` alanını güncelle, `BACKLOG.md`'yi senkronla.

Task/epic/sprint dosya formatı: [.claude/backlog/BACKLOG.md](.claude/backlog/BACKLOG.md) başındaki şablona uy.

### 4.1 Delegasyonda bağlam sadakati (ZORUNLU)

Alt-ajana iş verirken **kaynağı referansla ver, özetini değil.**

- ✅ `ADR 0004 Karar 2` · `rules.md §8` · `docs/analysis/0008 §5.7` · `agreement.service.ts:438`
- ❌ "hatırladığım kadarıyla eşik %95'ti" · "sanırım kısmi rezervasyon yasak"

Özet vermen gerekiyorsa **kaynağı da ekle** ki ajan doğrulayabilsin. Finansal bir sistemde
özet-kaybı sessiz yanlış sayı üretir.

### 4.2 "Done" tanımı (ZORUNLU — hepsi sağlanmadan `done` yazılmaz)

- [ ] Testler yeşil (unit + ilgili e2e)
- [ ] `npm run guards` yeşil (backend'e dokunulduysa) — exit 0
- [ ] `bash scripts/guards/money-float.sh --ratchet` exit 0 — **hiçbir** Alan A dosyasının
      bulgu sayısı artmamış olmalı. Azalma beklenen ve iyidir: azaldıysa yeni referansı
      `--baseline > scripts/guards/money-float-baseline.txt` ile ayrı, gözden geçirilebilir
      bir commit'te güncelle (baseline asla kendini yazmaz). **Baseline commit'i, azalmayı
      üreten commit'ten SONRA gelir** — önce gelirse ratchet o aralıkta kör kalır.
      Alan A üyelik testi: bir modül para üretiyor, para kalıcılaştırıyor veya parayı bir
      eşikle karşılaştırıyorsa Alan A'dadır — liste: `scripts/guards/money-float-domain-a.txt`
- [ ] `code-reviewer` onayı
- [ ] **Üretim çağrı yolu var mı?** Bu kodu çağıran HTTP route / zamanlanmış iş / event nedir?
      Yol yoksa status `done` DEĞİL → **`blocked-unreachable`**
- [ ] Bağlayıcı koşullar bir guard'a bağlandı (test / lint / DB constraint / CI).
      Bağlanamıyorsa koşul "tavsiye"ye düşürülür ve öyle işaretlenir.
- [ ] `touches:` alanı gerçekte dokunulan dosyalarla güncel
- [ ] Migration varsa: **catalogue guard'ları şema-nitelendirilmiş** (`nspname`/`schemaname`
      predicate'i olmadan `pg_constraint`/`pg_indexes` sorgulanmaz)

> Üçüncü madde neden var: bu projede "mekanizma var, ona giden yol yok" hatası **sekiz kez**
> tekrarlandı (T-033, T-036, T-039, T-046d, T-048, T-052, T-053, T-062). Her task kendi
> ölçütünde yeşil geçti, ürün etkisi sıfır oldu. Bu madde o sınıfı kapatır.

---

## 5. Git / Bitbucket Workflow

- **Çoklu repo:** backend/frontend ayrı Bitbucket repolarıdır (submodule). Kök repo `collmind.team` kod tutmaz; her submodule'ün **commit pointer'ını** tutar. Bir submodule'de iş bitince: o repoya push → kök repo'da pointer'ı güncelle/commit/push.
- Commit mesajı sonu: `Co-Authored-By: Claude <noreply@anthropic.com>`
  *(Model adı yazma — model değişince her commit yanlış imzalanır.)*
- Commit/push yalnızca kullanıcı isterse.
- `/sync` ile submodule'leri güncel tut.
- **`git checkout` ve `git pull` artık otomatik onaylı değil.** Paylaşılan working tree'de
  paralel ajanlar varken branch değiştirmek, başka bir ajanın altından zemini çeker.

### Doküman yeri (ZORUNLU)

**`docs/` (ölçüm, karar, sözleşme, rapor) meta-repo'da yaşar.** Submodule'lerde yalnız **kodun
okuduğu artefaktlar** bulunur (`scripts/guards/*-baseline.txt` gibi — guard onu okur, kodla
senkron değişmeli).

Gerekçe: ölçüm ve karar dokümanları birbirine referans verir (`0010` → `0013` → ADR 0007 →
`MONEY_FLOAT_BASELINE.md`). Ayrı repolara dağılırlarsa bağlantılar kırılır ve hangi sürümün
hangisine karşılık geldiği izlenemez hâle gelir.

Ölçüldü (2026-08-04): `docs/verification/` altındaki üç rapor da meta'da
(`CTPM_BASELINE_AND_PORT_AUDIT.md`, `GUARD_BASELINE_REPORT.md`, `MONEY_FLOAT_BASELINE.md`) —
kural bugün **ihlalsiz**. `collmind.backend/docs/` altında kalanlar (`safe-prompt-standard-v2.md`,
`safe-prompts/`) ölçüm/karar dokümanı değil, prompt şablonlarıdır; **geriye dönük taşınmıyor**.

### Branch & Release Modeli (ZORUNLU — her üç repoda)

İki kalıcı branch:
- **`staging`** → TÜM geliştirme burada olur. Feature/bugfix branch'leri staging'den açılır, staging'e merge edilir.
- **`main`** → **production/release** branch'i. Yalnızca release promote'u ile güncellenir. **ASLA doğrudan commit/push edilmez.**

**Release akışı (manuel promote, pipeline yok):**
1. `staging` yeşil olmalı (testler geçiyor, code-reviewer onayı).
2. Release tag'i **staging'de** atılır: `vMAJOR.MINOR.PATCH` (semver). Üç repoda da **aynı sürüm**.
3. Promote: `staging → main` merge, `main` push edilir.
4. Production deploy **manuel** yapılır (otomasyon yok).

**Kurallar:**
- Yeni iş → staging'den `feature/<ad>` veya `fix/<ad>` aç → staging'e geri merge.
- `main`'e doğrudan commit/push YASAK.
- Tag yalnızca release anında, staging'den.
- `/release <vX.Y.Z>` bu akışı orkestre eder.

---

## 6. Tipik Orkestrasyon Zincirleri

- **Feature:** `planner → architect (onay) → backend ∥ frontend → qa-engineer → code-reviewer → (kullanıcı onayıyla) commit/push`
- **Bugfix:** `debugger (teşhis+fix) → qa-engineer (regresyon) → code-reviewer`
- **Data işi:** `data-analyst (analiz) → data-engineer (migration/pipeline) → qa-engineer`

Slash command'lar: `/feature`, `/bugfix`, `/sync`, `/qa`, `/standup`, `/release`.

---

## 7. Yeni kod yazmadan önce ara (ZORUNLU)

Bu projede aynı yetenek birden çok kez yazıldı: iki submit yolu, iki lumpsum dağıtım
implementasyonu, iki CSV parser, üç kez yazılmış scope mantığı.

`architect` review'ında ve her implementasyon task'ında cevaplanmalı:

> **"Bu yeteneğin mevcut bir implementasyonu var mı? Arandı mı, nerede, hangi terimlerle?"**

Cevap "yok" ise gerekçesiyle yazılır. Aranmadıysa task eksiktir.
