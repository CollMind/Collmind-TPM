#!/usr/bin/env bash
# CollMind agent-teams kalite kapısı: task yaşam döngüsünde git-tracked backlog'u
# (.claude/backlog/) senkron tutmayı hatırlatır. NON-BLOCKING (exit 0).
#
# Kullanım: backlog-sync.sh <created|completed>
# stdin: hook JSON payload'ı (task bilgisi). Sadece hatırlatma üretir, aksiyonu engellemez.
set -euo pipefail

PHASE="${1:-unknown}"

case "$PHASE" in
  created)
    echo "[backlog] Yeni task oluşturuldu. HATIRLATMA: .claude/backlog/ içinde aynı/benzer task var mı kontrol et (dedup); yoksa .claude/backlog/tasks/<id>.md aç ve BACKLOG.md indeksine ekle. Bu agent-teams task listesi geçicidir; kalıcı kayıt git-tracked backlog'dadır."
    ;;
  completed)
    echo "[backlog] Task tamamlandı. HATIRLATMA: ilgili .claude/backlog/tasks/<id>.md dosyasında status=done + updated alanını güncelle ve BACKLOG.md indeksini senkronla. Gerekirse commit et."
    ;;
  *)
    echo "[backlog] Bilinmeyen faz: $PHASE"
    ;;
esac

exit 0
