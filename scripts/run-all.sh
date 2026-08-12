#!/usr/bin/env bash
# Meta repo guard zinciri.
#
# Neden meta'da: buradaki guard'lar META'daki BELGELERİ koruyor. Submodule'e
# taşımak, guard'ı koruduğu şeyden ayırır — `F1`'in deseni.
#
# Kullanım:  bash scripts/run-all.sh
# Çıkış:     0 hepsi temiz · 1 en az bir guard ihlal buldu

set -uo pipefail
cd "$(dirname "$0")/.."

FAIL=0
run() {
  local ad="$1"; shift
  echo "▶ $ad"
  if "$@"; then
    echo "  ✅ $ad"
  else
    echo "  ⛔ $ad — exit $?"
    FAIL=1
  fi
  echo
}

# E6 · BRD v2 belge guard'ı (kural sayımı · kimlik tekilliği · sarkan atıf)
run "E6 · brd-v2" bash docs/brd-v2/guard.sh docs/brd-v2

echo "==================="
if [ "$FAIL" -eq 0 ]; then
  echo "✅ Meta guard zinciri temiz"
else
  echo "⛔ Meta guard zinciri ihlal buldu"
fi
exit "$FAIL"
