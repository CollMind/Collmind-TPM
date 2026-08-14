#!/usr/bin/env bash
#
# push-order-self-test.sh — push-order.sh'ın kendi doğruluğunu kanıtlar (S3, T-212)
#
# NEDEN VAR: push-order.sh başlığı "test edilebilirlik için" env değişkenleri
# tanımlıyordu ama onları kullanan bir self-test YOKTU — cümle şimdiki zamanda
# yazılmış bir iddiaydı, ölçülmemiş. Bu script o iddiayı gerçek kılar.
#
# TAMAMEN LOKAL: gerçek GitHub'a hiç dokunmaz. Her senaryo kendi bare-repo
# üçlüsünü (backend/frontend/meta) kurar, push-order.sh'ı env override'larıyla
# ona yöneltir, sonucu (exit kodu + origin'in GERÇEKTEN değişip değişmediğini)
# ölçer. "Push edildi" iddiası her yerde `git --git-dir=<bare> rev-parse` ile
# doğrulanır — komutun exit kodu değil, origin'in İÇERİĞİ.
#
# exit 0 = tüm senaryolar beklendiği gibi · exit 1 = en az biri sapıyor
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$DIR/push-order.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

FAIL=0

# build_harness <dizin> — üç bare repo + bir work clone kurar, staging'e
# tek bir başlangıç commit'i koyar. Her senaryo KENDİ izole harness'ini kurar
# (bir öncekinin durumu sızmasın diye — §2.7 "kanıt kurulumu ölçtüğün durumu
# değiştirmesin" ailesinin tersi: burada asıl risk senaryolar ARASI sızıntı).
build_harness() {
  local h="$1"
  mkdir -p "$h"
  git init --bare -q "$h/ob.git"
  git init --bare -q "$h/of.git"
  git init --bare -q "$h/om.git"

  mkdir "$h/b" && (cd "$h/b" && git init -q -b staging \
    && git -c user.email=a@a -c user.name=a commit --allow-empty -q -m i \
    && git remote add origin "$h/ob.git" && git push -q origin staging)
  mkdir "$h/f" && (cd "$h/f" && git init -q -b staging \
    && git -c user.email=a@a -c user.name=a commit --allow-empty -q -m i \
    && git remote add origin "$h/of.git" && git push -q origin staging)

  mkdir "$h/m" && (cd "$h/m" && git init -q -b staging \
    && git -c protocol.file.allow=always submodule add -q --branch staging "$h/ob.git" collmind.backend \
    && git -c protocol.file.allow=always submodule add -q --branch staging "$h/of.git" collmind.frontend \
    && git -c user.email=a@a -c user.name=a commit -q -m init \
    && git remote add origin "$h/om.git" && git push -q origin staging)

  git clone -q --branch staging "$h/om.git" "$h/work"
  (cd "$h/work" \
    && git -c protocol.file.allow=always submodule update --init --recursive -q \
    && git -C collmind.backend switch -C staging origin/staging -q \
    && git -C collmind.frontend switch -C staging origin/staging -q)
}

# expect_exit <etiket> <beklenen-exit> -- <env=val>... -- <komut açıklaması>
run_case() { # <etiket> <beklenen-exit> <work-dizini> [env=val ...]
  local label="$1" want="$2" work="$3"; shift 3
  local out rc
  out="$(env "$@" PUSH_ORDER_ROOT="$work" bash "$SCRIPT" 2>&1)"
  rc=$?
  if [ "$rc" != "$want" ]; then
    echo "!! self-test BAŞARISIZ: $label → beklenen exit $want, bulunan $rc" >&2
    printf '%s\n' "$out" | sed 's/^/     /' >&2
    FAIL=1
    return 1
  fi
  printf '%s\n' "$out"
  return 0
}

# ------------------------------------------------------------ VAKA 1: temiz
H1="$TMP/h1"; build_harness "$H1"
run_case "temiz ağaç" 0 "$H1/work" >/dev/null

# ---------------------------------------------------- VAKA 2: gerçek akış
H2="$TMP/h2"; build_harness "$H2"
echo x >> "$H2/work/collmind.backend/f.txt"
git -C "$H2/work/collmind.backend" add -A
git -C "$H2/work/collmind.backend" -c user.email=a@a -c user.name=a commit -q -m "backend iş"
git -C "$H2/work" add collmind.backend
git -C "$H2/work" -c user.email=a@a -c user.name=a commit -q -m "meta pointer bump"
run_case "gerçek akış (commit+bump, hiçbiri push edilmemiş)" 0 "$H2/work" >/dev/null
BACKEND_SHA="$(git -C "$H2/work/collmind.backend" rev-parse HEAD)"
ORIGIN_BACKEND_SHA="$(git --git-dir="$H2/ob.git" rev-parse staging)"
if [ "$BACKEND_SHA" != "$ORIGIN_BACKEND_SHA" ]; then
  echo "!! self-test BAŞARISIZ: gerçek akış → backend origin'e GERÇEKTEN yazılmadı" >&2
  FAIL=1
fi

# --------------------------------------------- VAKA 3: dirty ağaç → DUR
H3="$TMP/h3"; build_harness "$H3"
echo x >> "$H3/work/collmind.backend/dirty.txt"
BEFORE="$(git --git-dir="$H3/ob.git" rev-parse staging)"
run_case "dirty ağaç (varsayılan: DUR)" 2 "$H3/work" >/dev/null
AFTER="$(git --git-dir="$H3/ob.git" rev-parse staging)"
if [ "$BEFORE" != "$AFTER" ]; then
  echo "!! self-test BAŞARISIZ: dirty ağaç → origin DEĞİŞMEMELİYDİ, değişti" >&2
  FAIL=1
fi

# ------------------------------- VAKA 4: meta pointer submodule'den eski
H4="$TMP/h4"; build_harness "$H4"
echo x >> "$H4/work/collmind.backend/f.txt"
git -C "$H4/work/collmind.backend" add -A
git -C "$H4/work/collmind.backend" -c user.email=a@a -c user.name=a commit -q -m "backend iş (meta hiç bilmiyor)"
BEFORE_META="$(git --git-dir="$H4/om.git" rev-parse staging)"
run_case "meta pointer eski (pointer bump YAPILMADI)" 2 "$H4/work" >/dev/null
AFTER_META="$(git --git-dir="$H4/om.git" rev-parse staging)"
if [ "$BEFORE_META" != "$AFTER_META" ]; then
  echo "!! self-test BAŞARISIZ: pointer uyuşmazlığı → meta origin DEĞİŞMEMELİYDİ, değişti" >&2
  FAIL=1
fi

# ------------------------- VAKA 5 (S1): kapsam dışı submodule kirliliği
H5="$TMP/h5"; build_harness "$H5"
echo x >> "$H5/work/collmind.frontend/dirty.txt"
run_case "frontend kirli + kapsam dışı (S1: meta yine de push edilmeli)" 0 "$H5/work" \
  PUSH_ORDER_SUBMODULES="collmind.backend" >/dev/null

# --------------------------- VAKA 6 (B2): geçersiz bool bayrağı → exit 2
H6="$TMP/h6"; build_harness "$H6"
echo x >> "$H6/work/collmind.backend/dirty.txt"
BEFORE6="$(git --git-dir="$H6/ob.git" rev-parse staging)"
run_case "PUSH_ORDER_ABORT_ON_DIRTY=true (geçersiz yazım)" 2 "$H6/work" \
  PUSH_ORDER_ABORT_ON_DIRTY=true >/dev/null
AFTER6="$(git --git-dir="$H6/ob.git" rev-parse staging)"
if [ "$BEFORE6" != "$AFTER6" ]; then
  echo "!! self-test BAŞARISIZ: geçersiz bayrak → origin DEĞİŞMEMELİYDİ, değişti" >&2
  FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  echo "!! push-order self-test BAŞARISIZ — push-order.sh'a güvenilmiyor" >&2
  exit 1
fi
echo "-- push-order self-test: 6 senaryo tutuyor"
exit 0
