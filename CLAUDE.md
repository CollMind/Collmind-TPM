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
| DB | Docker PostgreSQL | — | 5432 |

Bu kök repo (`collmind.team`) orkestrasyon kurulumunu (`.claude/`) + dokümantasyonu tutar; backend/frontend submodule'dür.

**Test/komut referansı:**
- Backend test: `npm test` (Jest) · e2e: `npm run test:e2e` · lint: `npm run lint` · migration: `npm run migration:run` · seed: `npm run seed`
- Frontend test: `npm test` (Vitest) · type-check: `npm run type-check` · lint: `npm run lint` · dev: `npm run dev`

---

## 2. Domain Kuralları (BRD — DEĞİŞTİRİLEMEZ)

Tek doğruluk kaynağı: [.cursor/rules.md](.cursor/rules.md) + `.cursor/` altındaki BRD PDF'leri. Özet:

- **FMCG Trade Promotion Management (TPM)** ürünü. Tüm geliştirmeler BRD ile uyumlu olmalı; varsayım yapma.
- **Hesaplamalar asla hardcode edilmez.** KPI/ROI/Spend/Profit = Admin tanımlı **dinamik formül**. Frontend sadece sonucu render eder. Hesap < 500ms.
- **RBAC (sabit):** Planner (sadece yetkili CPL+Category, plan onaylayamaz) · Category Manager (atanmış kategoriyi onaylar, plan düzenleyemez) · Finance Manager (okuma + bütçe) · Admin (tam). Roller birbirinin yetkisini kullanamaz.
- **Plan state machine:** `Draft → Pending Approval → Approved/Rejected`; Rejected → Draft (audit korunur). Pending'de plan değiştirilemez; Approved bütçeden düşer.
- **Grid hiyerarşisi:** Plan → FU → SKU. SKU'da Planned Volume, FU'da Tactic girilir; FU değerleri SKU'ya miras; SKU'da tactic değiştirilemez.
- **KPI edge case:** division-by-zero → null, eksik veri → null, negatif ROI geçerlidir.
- **RAG:** hardcoded threshold YASAK; sadece KPI konfigürasyonundan. SKU Red→FU Red, karışık→Amber, hepsi Green→Green.
- **Budget threshold:** %80 Warning, %95 Critical, %100+ Exceeded (block). On-Invoice / Off-Invoice ayrı.
- **Audit:** immutable; silinemez/güncellenemez; onay/red dahil her işlem loglanır.
- Optimistic locking (eş zamanlı düzenleme), desktop-first, grid-heavy, real-time recalc.

---

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

---

## 4. Yeni Görev Akışı (ZORUNLU — tekrarı önler)

1. **Önce ara:** `BACKLOG.md` + `.claude/backlog/tasks/` içinde aynı/benzer task var mı?
   - **Varsa** → o task'ı devam ettir/güncelle. **YENİ TASK AÇMA.**
   - **Yoksa** → yeni task dosyası oluştur (`.claude/backlog/tasks/<id>.md`), uygun agent'a `assignee` ata, `BACKLOG.md` indeksine satır ekle.
2. **Dekompozisyon:** büyük iş → epic (`epics/<id>.md`) → task'lar. Her task tek agent'a.
3. **Delege:** bağımsız task'ları **tek mesajda paralel** başlat (Agent tool, birden çok çağrı). Bağımlı olanları sırala.
4. **İlerleme:** agent bitirince task `status` (`todo→in-progress→review→done`) + `updated` alanını güncelle, `BACKLOG.md`'yi senkronla.

Task/epic/sprint dosya formatı: [.claude/backlog/BACKLOG.md](.claude/backlog/BACKLOG.md) başındaki şablona uy.

---

## 5. Git / Bitbucket Workflow

- **Çoklu repo:** backend/frontend ayrı Bitbucket repolarıdır (submodule). Kök repo `collmind.team` kod tutmaz; her submodule'ün **commit pointer'ını** tutar (hangi backend+frontend sürümü birlikte). Bir submodule'de iş bitince: o repoya push → kök repo'da pointer'ı güncelle/commit/push.
- Commit mesajı sonu: `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`
- Commit/push yalnızca kullanıcı isterse.
- `/sync` ile submodule'leri güncel tut.

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
- `main`'e doğrudan commit/push YASAK; `main` yalnızca staging'den promote alır.
- Tag yalnızca release anında, staging'den. Meta-repo tag'i o anki submodule sürüm kombinasyonunu işaretler (önce backend/frontend release'lenir, pointer güncellenir, sonra meta tag'lenir).
- `/release <vX.Y.Z>` bu akışı orkestre eder.

---

## 6. Tipik Orkestrasyon Zincirleri

- **Feature:** `planner → architect (onay) → backend ∥ frontend → qa-engineer → code-reviewer → (kullanıcı onayıyla) commit/push`
- **Bugfix:** `debugger (teşhis+fix) → qa-engineer (regresyon) → code-reviewer`
- **Data işi:** `data-analyst (analiz) → data-engineer (migration/pipeline) → qa-engineer`

Slash command'lar: `/feature`, `/bugfix`, `/sync`, `/qa`, `/standup`.
