#!/usr/bin/env bash
#
# push-order.sh — submodule'ler ÖNCE, meta pointer EN SON (T-212 Kalem 3)
#
# NEDEN VAR
# Team Lead push sırasını İKİ KEZ ters yaptı (meta → submodule). Meta pointer
# submodule'lerin henüz origin'de görünmeyen commit'lerine işaret etti — bir
# başkası (ya da CI) meta'yı checkout ettiğinde submodule pointer'ı ÇÖZÜLEMEZ.
# "Bir daha dikkat ederim" iki kez söylendi, iki kez tutmadı:
# "niyet mekanizmanın yerini tutmaz." Kural artık bir SCRIPT.
#
# SIRA
#   1. Her submodule'ü push et (backend, frontend — bu script'in çağrıldığı
#      sıra bağlayıcıdır, listede ne yazılıysa o sırayla gider)
#   2. Her push'tan SONRA `merge-base --is-ancestor` ile commit'in origin'de
#      GERÇEKTEN GÖRÜLDÜĞÜNÜ doğrula — "push edildi" (komutun exit 0 dönmesi)
#      yetmez, ağ/timeout/partial-push senaryolarında yanıltıcı olabilir.
#   3. Meta pointer'ın işaret ettiği submodule commit'i, az önce doğrulanan
#      commit'le eşleşiyor mu diye sanity-check yap.
#   4. ANCAK SONRA meta'yı push et — ve onu da aynı merge-base doğrulamasından
#      geçir.
#
# Bir adım başarısız/doğrulanamaz olursa script DURUR ve sonraki adıma
# GEÇMEZ — özellikle meta pointer, doğrulanmamış bir submodule commit'i
# üstüne ASLA push edilmez.
#
# ⛔ AÇIK KARAR — Team Lead'e soruldu, bu script'te KONSERVATİF VARSAYILANLA
# uygulandı (CLAUDE.md §2.4 "Belirsizlikte DUR"):
#   Bir submodule'de COMMIT EDİLMEMİŞ değişiklik bulunursa script DURUR
#   (exit 2) ve HİÇBİR ŞEY push ETMEZ — uyarıp devam etmez. Gerekçe: push
#   sırası zaten meta pointer'ın submodule'ün push edilen HALİYLE eşleşmesini
#   garanti etmeye çalışıyor; commit edilmemiş bir değişiklik o garantiyi
#   baştan anlamsız kılar (hangi hâl push edildi, hangi hâl kaldı belirsiz).
#   Bu varsayım DOĞRULANMADI — Team Lead onayı bekliyor. Onaylanmazsa
#   (ör. "yalnız UYAR, devam et" isteniyorsa) `ABORT_ON_DIRTY` bayrağı bunun
#   için hazır: `PUSH_ORDER_ABORT_ON_DIRTY=0` ile gevşetilebilir, varsayılan
#   1 (dur).
#
# KULLANIM
#   bash scripts/push-order.sh
#
# ÇEVRE DEĞİŞKENLERİ (test edilebilirlik için — self-test bunları kullanır)
#   PUSH_ORDER_ROOT              varsayılan: bu script'in üst üst dizini
#   PUSH_ORDER_SUBMODULES        varsayılan: "collmind.backend collmind.frontend"
#                                 (SIRA BAĞLAYICI — backend önce, frontend sonra)
#   PUSH_ORDER_REMOTE            varsayılan: origin
#   PUSH_ORDER_ABORT_ON_DIRTY    varsayılan: 1 (yukarıdaki açık karara bkz.)
#   PUSH_ORDER_SKIP_META         varsayılan: 0 — 1 ise yalnız submodule'leri
#                                 push eder, meta'ya dokunmaz (self-test bunu
#                                 kullanır: meta pointer sanity-check'i ayrı
#                                 test eder)
#
# ÇIKIŞ KODLARI
#   0  hepsi push edildi ve origin'de doğrulandı (meta dahil, atlanmadıysa)
#   1  bir push ya da doğrulama BAŞARISIZ oldu — sıra durdu
#   2  KURULUM/GİRDİ hatası: commit edilmemiş değişiklik (DUR) · detached HEAD ·
#      meta pointer submodule'ün doğrulanan commit'iyle uyuşmuyor
set -uo pipefail

ROOT="${PUSH_ORDER_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SUBMODULES="${PUSH_ORDER_SUBMODULES:-collmind.backend collmind.frontend}"
REMOTE="${PUSH_ORDER_REMOTE:-origin}"
ABORT_ON_DIRTY="${PUSH_ORDER_ABORT_ON_DIRTY:-1}"
SKIP_META="${PUSH_ORDER_SKIP_META:-0}"

# push_and_verify <etiket> <yol>
# Döner: 0 = push edildi (ya da zaten güncel) VE origin'de doğrulandı
#        1 = push ya da doğrulama başarısız
#        2 = kurulum/girdi hatası (dirty ağaç, detached HEAD)
push_and_verify() {
  local label="$1" path="$2"

  if [ ! -d "$path/.git" ] && [ ! -f "$path/.git" ]; then
    echo "!! [$label] ($path) bir git deposu değil — DUR" >&2
    return 2
  fi

  # -uall: untracked dosyalar da sayılır. "push edildi" iddiası, çalışma
  # ağacının commit edilmiş hâliyle eşleştiği varsayımına dayanır; dirty bir
  # ağaçta bu varsayım baştan çürük.
  local dirty
  dirty="$(git -C "$path" status --porcelain -uall)"
  if [ -n "$dirty" ]; then
    echo "!! [$label] commit edilmemiş değişiklik var:" >&2
    printf '%s\n' "$dirty" | sed 's/^/     /' >&2
    if [ "$ABORT_ON_DIRTY" -eq 1 ]; then
      echo "!! [$label] DUR (varsayılan davranış — üstteki 'AÇIK KARAR' notuna bkz, Team Lead onayı bekliyor)" >&2
      return 2
    else
      echo "-- [$label] UYARILDI, PUSH_ORDER_ABORT_ON_DIRTY=0 ile devam ediliyor (riskli)" >&2
    fi
  fi

  local branch
  branch="$(git -C "$path" branch --show-current)"
  if [ -z "$branch" ]; then
    echo "!! [$label] detached HEAD — hangi branch push edilecek belirsiz, DUR" >&2
    return 2
  fi

  local local_sha
  local_sha="$(git -C "$path" rev-parse HEAD)"

  if ! git -C "$path" fetch "$REMOTE" "$branch" >/dev/null 2>&1; then
    echo "!! [$label] fetch $REMOTE/$branch başarısız" >&2
    return 1
  fi
  local remote_sha
  remote_sha="$(git -C "$path" rev-parse "$REMOTE/$branch" 2>/dev/null || echo '')"

  if [ "$remote_sha" = "$local_sha" ]; then
    echo "-- [$label] zaten güncel: $REMOTE/$branch == ${local_sha:0:12}, push ATLANIYOR"
  else
    echo "-- [$label] push ediliyor: ${local_sha:0:12} -> $REMOTE/$branch"
    if ! git -C "$path" push "$REMOTE" "HEAD:$branch"; then
      echo "!! [$label] push BAŞARISIZ" >&2
      return 1
    fi
  fi

  # "push edildi" (komut exit 0) yetmez — origin'de GÖRÜLDÜĞÜNÜ ayrıca ölç.
  git -C "$path" fetch "$REMOTE" "$branch" >/dev/null 2>&1
  if ! git -C "$path" merge-base --is-ancestor "$local_sha" "$REMOTE/$branch" 2>/dev/null; then
    echo "!! [$label] push edildi ama ${local_sha:0:12} $REMOTE/$branch'te GÖRÜLMÜYOR — doğrulama başarısız" >&2
    return 1
  fi
  echo "-- [$label] doğrulandı: ${local_sha:0:12} $REMOTE/$branch'te görülüyor"
  return 0
}

echo "=== push-order: $SUBMODULES (sırayla), sonra meta ==="
echo

for sm in $SUBMODULES; do
  echo "--- $sm ---"
  push_and_verify "$sm" "$ROOT/$sm"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    echo
    echo "!! push sırası DURDU: $sm adımında (exit $rc) — meta pointer PUSH EDİLMEDİ" >&2
    exit "$rc"
  fi

  # Sanity: meta'nın ŞU AN commit edilmiş HEAD'inin işaret ettiği submodule
  # pointer'ı, az önce origin'de doğrulanan commit'le eşleşiyor mu? Eşleşmezse
  # meta zaten yanlış (ya da eski) bir pointer taşıyor demektir — onu push
  # etmek origin'i submodule ile TUTARSIZ bırakır.
  meta_pointer_sha="$(git -C "$ROOT" rev-parse "HEAD:$sm" 2>/dev/null || echo '')"
  local_sha="$(git -C "$ROOT/$sm" rev-parse HEAD)"
  if [ -z "$meta_pointer_sha" ]; then
    echo "!! [$sm] meta HEAD'inde bu yol için bir gitlink bulunamadı (.gitmodules kontrol et)" >&2
    exit 2
  fi
  if [ "$meta_pointer_sha" != "$local_sha" ]; then
    echo "!! [$sm] meta'nın HEAD'i bu submodule için ${meta_pointer_sha:0:12} işaret ediyor," >&2
    echo "!! ama submodule'ün şu anki (doğrulanan) commit'i ${local_sha:0:12} — UYUŞMUYOR." >&2
    echo "!! meta commit'i muhtemelen submodule pointer bump'ından ÖNCE alınmış. DUR." >&2
    exit 2
  fi
  echo "-- [$sm] meta pointer eşleşiyor: ${local_sha:0:12}"
  echo
done

if [ "$SKIP_META" -eq 1 ]; then
  echo "-- [meta] PUSH_ORDER_SKIP_META=1 — meta push atlandı (yalnız submodule'ler doğrulandı)"
  exit 0
fi

echo "--- meta (pointer en son) ---"
push_and_verify "meta" "$ROOT"
exit $?
