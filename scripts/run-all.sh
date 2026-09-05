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

# T-356 · çapraz-repo ROL ENUM sözleşmesi (backend ↔ frontend ↔ EK_C).
# Bilerek META'da: sözleşmenin iki tarafını (collmind.backend +
# collmind.frontend) BİRLİKTE okuyan tek yer burası. Eskiden
# collmind.frontend/tests/contracts/roleEnumContract.test.ts idi ve
# collmind.backend'in kardeş dizin olmasını şart koşuyordu — bu, frontend
# süitinin izole bir worktree'de TEK BAŞINA koşamamasına yol açıyordu
# (T-356). Kontrol kaybolmadı, buraya taşındı.
run "T-356 · role-enum-contract" node scripts/guards/role-enum-contract.mjs

# [[T-359b]] "KAPILARIN KAPISI" · sigpipe-hygiene BURADA doğuyor, ÇÜNKÜ evreni
# tek repo değil: "pipefail kullanan her .sh", meta kökünden, submodule'ler
# görünür (backend + frontend + scripts + .claude + docs). Eskiden yalnız
# collmind.backend/scripts/guards/'ta yaşıyordu ve frontend'in ÜÇ CANLI
# şekil-1 vakası bu yüzden hiç görülmüyordu (ölçüldü, §0). Kopya bırakılmadı
# — backend zincirinden ÇIKARILDI (lib.sh + run-all.sh).
#
# Doğum şartı (Z83) önce: self-test kırmızıysa bulgu sayıları anlamsızdır.
run "sigpipe-hygiene · self-test" bash scripts/guards/sigpipe-hygiene.sh --self-test

# Kapı: --ratchet. Bugünkü sekiz grandfathered vaka (sigpipe-hygiene-baseline.txt)
# BLOKLAMAZ; baseline'da OLMAYAN yeni bir vaka BLOKLAR (T-212 deseni).
run "sigpipe-hygiene · ratchet" bash scripts/guards/sigpipe-hygiene.sh --ratchet

echo "==================="
if [ "$FAIL" -eq 0 ]; then
  echo "✅ Meta guard zinciri temiz"
else
  echo "⛔ Meta guard zinciri ihlal buldu"
fi
exit "$FAIL"
