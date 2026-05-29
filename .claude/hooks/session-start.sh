#!/usr/bin/env bash
# CollMind SessionStart hook: backlog özetini context'e enjekte eder.
# stdout, oturum context'ine eklenir → Team Lead bununla devreye girer.
set -euo pipefail

BACKLOG="${CLAUDE_PROJECT_DIR:-.}/.claude/backlog/BACKLOG.md"

echo "=== CollMind Team Lead — Oturum Başlangıcı ==="
echo "Sen Team Lead'sin. Aşağıdaki paylaşılan backlog'u oku, aktif sprint + açık/devam eden"
echo "task'ları kullanıcıya özetle ve ne üzerinde çalışılacağını sor."
echo "Yeni görevde ÖNCE bu backlog'da aynı/benzer task'ı ara; varsa yeni AÇMA."
echo ""

if [ -f "$BACKLOG" ]; then
  echo "----- BACKLOG.md (paylaşılan) -----"
  cat "$BACKLOG"
else
  echo "(Backlog bulunamadı: $BACKLOG — henüz oluşturulmamış olabilir.)"
fi
