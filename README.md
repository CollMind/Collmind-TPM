# collmind.team

CollMind TPM projesinin **Claude Code geliştirme ekibi (multi-agent orkestrasyon)** meta-repo'su.
Bu repo orkestrasyon kurulumunu (`.claude/`), paylaşılan backlog'u ve dokümantasyonu tutar; uygulama kodu submodule'lerdedir.

## Yapı

```
collmind/  (collmind.team meta-repo)
├── CLAUDE.md                  # Team Lead orkestrasyon talimatları + domain kuralları
├── .claude/
│   ├── agents/                # 9 uzman subagent
│   ├── commands/              # /feature /bugfix /sync /qa /standup
│   ├── backlog/               # Paylaşılan Sprint/Epic/Task defteri (git-tracked)
│   ├── hooks/session-start.sh # Oturum başında backlog'u Team Lead'e enjekte eder
│   └── settings.json          # İzinler + SessionStart hook (paylaşılan)
├── collmind.backend/          # git submodule — NestJS (branch: staging)
├── collmind.frontend/         # git submodule — React/Vite (branch: main)
└── .cursor/rules.md           # BRD domain kuralları (tek doğruluk kaynağı)
```

## Ekip (subagent'lar)

| Agent | Rol |
|---|---|
| planner | İşi epic/task'a böler, BRD ile hizalar |
| architect | Mimari karar + review |
| backend-engineer | NestJS/TypeORM implementasyon |
| frontend-engineer | React UI tasarım + implementasyon |
| qa-engineer | Test yazma/çalıştırma, QA planı |
| debugger | Bug teşhis + fix |
| code-reviewer | Commit öncesi diff review |
| data-analyst | KPI/raporlama analizi (read-only) |
| data-engineer | Migration/seed/şema/pipeline |

**Team Lead = ana Claude oturumu** — taskları dağıtır, paralel çalıştırır, backlog'u günceller.

## Kurulum (yeni ekip üyesi — 3 kişilik ekip)

```bash
# 1. Repo'yu submodule'leriyle birlikte klonla
git clone --recurse-submodules <collmind.team-bitbucket-url> collmind
cd collmind

# (zaten klonladıysan)
git submodule update --init --recursive

# 2. Bağımlılıklar
( cd collmind.backend && npm install )
( cd collmind.frontend && npm install )

# 3. Claude Code'u başlat — Team Lead oturum başında backlog'la karşılar
claude
```

> Kişiye özel ayarların `.claude/settings.local.json`'a (git-ignored). Bitbucket erişimi mevcut token'lı git remote'larıyla.

## Günlük kullanım

- `/standup` — durum özeti (backlog + repo)
- `/feature <açıklama>` — feature'ı uçtan uca orkestre et
- `/bugfix <açıklama>` — bug teşhis → fix → test → review
- `/qa` — tüm test suite'lerini çalıştır
- `/sync` — submodule'leri Bitbucket'tan güncelle

## Paylaşılan Backlog

`.claude/backlog/` git'e commit'lenir → tüm ekip + agentlar aynı task durumunu paylaşır.
Team Lead yeni görevte önce burayı kontrol eder; **aynı task'ı tekrar açmaz**.
Şablonlar için [.claude/backlog/BACKLOG.md](.claude/backlog/BACKLOG.md).
