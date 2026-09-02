#!/usr/bin/env bash
# gate.sh — bir kapıyı DOĞRU DİZİNDE koşar ve çıktının başına `pwd` basar.
#
# ⛔ NEDEN VAR (ölçülmüş, 2026-09-02/03): Team Lead elle kapı koşumlarında `cwd`
# kaymasıyla ÜÇ KEZ yanıldı — sonuncusunda dört kapı birden "kırmızı" göründü,
# çünkü `npx tsc` meta reposundan koşulmuştu (`tsc` orada YOK).
# Üçünde de yanlış sonuç "HER ŞEY BOZUK" yönündeydi ⇒ SAHTE ALARM,
# `§2.7`'nin TERS yönü. Zararı zaman; üçüncüde ARAÇ.
# `DISIPLIN`: "üçüncü ihlal YERLEŞİM KUSURUDUR — hatırlatmanın yerini ARAÇ alır."
#
# ⚠️ Bu, `push-order.sh`'ın kapı zincirinin YERİNE GEÇMEZ: orası beyanı ÜRETEN
# yerdir ve zaten doğru dizinde koşar. Bu wrapper ARA DOĞRULAMA içindir.
#
# Kullanım:  bash scripts/gate.sh <be|fe|meta> <komut...>
#   bash scripts/gate.sh be npm run guards
#   bash scripts/gate.sh fe npx vitest run
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "${1:-}" in
  be|backend)   DIR="$ROOT/collmind.backend" ;;
  fe|frontend)  DIR="$ROOT/collmind.frontend" ;;
  meta|root)    DIR="$ROOT" ;;
  *)
    echo "kullanım: bash scripts/gate.sh <be|fe|meta> <komut...>" >&2
    exit 2 ;;
esac
shift

if [ $# -eq 0 ]; then
  echo "!! komut verilmedi" >&2
  exit 2
fi

if [ ! -d "$DIR" ]; then
  echo "!! dizin YOK: $DIR (kurulum hatası — ölçüm YAPILMADI)" >&2
  exit 2
fi

echo "-- [gate] pwd: $DIR"
echo "-- [gate] komut: $*"
cd "$DIR" || { echo "!! cd başarısız: $DIR" >&2; exit 2; }
"$@"
RC=$?
echo "-- [gate] exit: $RC  (pwd: $DIR)"
exit $RC
