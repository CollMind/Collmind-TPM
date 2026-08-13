#!/usr/bin/env bash
# BRD v2 · belge guard'ı — E6
#
# Üç kontrol:
#   1. Kural sayımı            (F8: elle tutulan sayı bayatlar)
#   2. Kimlik tekilliği        (F2: aynı numara iki kurala verilmişti)
#   3. Sarkan atıf             (var olmayan bir K-numarasına referans)
#
# CLAUDE.md §2.7'nin belge hâli: bir kurala uymak ile o kuralın kendi çıktına
# uygulandığını doğrulamak ayrı işlerdir.
#
# ══════════════════════════════════════════════════════════════════════════
# NEDEN POSIX — ölçülmüş bir körlük (2026-08-13)
#
# Bu guard'ın önceki sürümü DÖRT yerde `grep -oP` kullanıyordu. `-P` bir GNU
# eklentisidir; macOS'un BSD grep'i onu tanımaz. Ölçüldü (BSD grep şimi ile):
#
#   1 · Kural sayımı      indeks karşılaştırması SESSİZCE ATLANDI
#                         (IDX_COUNT boş → `[ -n ... ]` yanlış → hiçbir satır)
#   2 · Kimlik tekilliği  DUPES boş → "✅ çakışma yok"
#   3 · Sarkan atıf       DEFINED/REFERENCED boş → "✅ sarkan atıf yok"
#
#   çıktı:  "✅ Temiz — 363 kural, 2 açık"      exit 0
#
# Yani ürün sahibinin Mac'inde guard AYLARDIR üç kontrolü de yapmadan yeşil
# veriyordu. Tek görünür iz, çıktıdan EKSİLEN bir satırdı ("✅ indeks
# sayımıyla uyumlu") — bir yokluk, ve yoklukları kimse fark etmez.
#
# CLAUDE.md §2.7 #5'in tam örneği: "desen yazıldı, uygulandı görünüyor, sıfır
# şey yapıyor." Ve §2.7 #9'un: "sinyal sabitse, sinyal değildir."
#
# İKİ DÜZELTME:
#   (1) Tüm çıkarımlar POSIX `sed`/`grep` ile — GNU eklentisi yok.
#   (2) POZİTİF KONTROL: guard, ölçmeye başlamadan ÖNCE kendi çıkarıcılarını
#       bilinen fixture'lara karşı koşturur. Bir çıkarıcı beklenen sonucu
#       vermezse guard "temiz" DEMEZ — `exit 2` (kurulum hatası) verir.
#       Beklenen değerler AŞAĞIDA, ölçümden önce yazılıdır.
#
#   > Bir taramanın negatif sonucu, pozitif kontrolü olmadan raporlanamaz.
#     (CLAUDE.md · "Negatif sonuçlu tarama POZİTİF KONTROLSÜZ rapor edilemez")
# ══════════════════════════════════════════════════════════════════════════
#
# KONTROL ADAYLARI — henüz yazılmadı, ve bugün elle tutuluyor demektir.
# (Sıra numarası yok: 00_PAKET_INDEKSI'nin "dördüncü kontrol adayı" cümlesi
#  dosya adı atıflarını, 2026-08-13 turu bayat adresi "dördüncü" diye
#  adlandırdı. Numara değil, liste kanonik.)
#
#   a) Dosya adı atıfları  — üç kontrol de K-numarasına bakıyor; bayat bir
#      dosya adı (`01_YETENEK`) yakalanmadı
#   b) Açık (⛔) sayısı     — sayılıyor ve BASILIYOR, ama indeksle
#      KARŞILAŞTIRILMIYOR. Yalnız toplam karşılaştırılıyor.
#      ⏸️ Açık sayısı 0'a inince ucuzlar: ">0 ve indekste gerekçesi yok → kırmızı"
#   c) Bölüm dağılımı      — aynı: basılıyor, karşılaştırılmıyor. İndeksin
#      dağılım satırı bir kez bayat yakalandı (89 ↔ 88)
#   d) Bayat adres         — kapanmış bir dalgaya/task'a referans veren ❌
#      (L2 §Bu katmanın kuralları md.5: her ❌ bir adres taşır)
#   e) L2'ye tek kanal      — L2_* dosyasına Team Lead dışı bir commit
#      (CLAUDE.md §3). ⚠️ Guard bunu ancak commit GELDİKTEN sonra yakalar,
#      önlemez — kanalı koruyan şey dosya başlıklarındaki uyarı.
#
# Kullanım:  ./guard.sh [paket_dizini]
# Çıkış:     0 temiz · 1 ihlal · 2 kurulum hatası (pozitif kontrol düştü)

set -uo pipefail
PKG="${1:-.}"
RULES_DIR="$PKG/03_IS_KURALLARI"
FAIL=0

# ═════════════════════════════════════════════ çıkarıcılar — TEK uygulama
# Hem pozitif kontrol hem üretim yolu BU fonksiyonlardan geçer. Bir kontrolü
# sınayan test, o kontrolün kopyasını çalıştırmamalıdır (ADR 0007 E16).

# stdin'deki kural TANIMI satırlarından kimlikleri çıkarır: `**K-2.1.3a**` → `K-2.1.3a`
extract_rule_ids() {
  sed -n 's/^\*\*\(K-[0-9][0-9.a-z]*\)\*\*.*/\1/p'
}

# stdin'deki metinden kural ATIFLARINI çıkarır: `` `K-2.1.3a` `` → `K-2.1.3a`
#   "eski `K-x`" biçimindeki TARİHSEL notlar atıf sayılmaz — bir kuralın
#   taşındığını kaydeden bir izdir, ona yapılan bir referans değil.
#   (GNU lookbehind yerine: önce o kalıbı metinden düşür, sonra çıkar.)
extract_rule_refs() {
  sed 's/eski `K-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*[a-z0-9]*`//g' \
    | grep -o '`K-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*[a-z0-9]*`' \
    | tr -d '`'
}

# indeksteki "L2 kural tanımı" sayısını çıkarır
extract_index_count() {
  sed -n 's/^| `L2` kural tanımı | \*\*\([0-9][0-9]*\)\*\*.*/\1/p'
}

# indeksteki "Açık (⛔) kural" sayısını çıkarır
extract_index_open() {
  sed -n 's/^| Açık (⛔) kural | \*\*\([0-9][0-9]*\)\*\*.*/\1/p'
}

# ═══════════════════════════════════════════════════════ POZİTİF KONTROL
# Beklenen değerler ölçümden ÖNCE yazılıdır — çıkan sonuca bakıp "makul" demek,
# kontrolü kontrol olmaktan çıkarır.

self_check() {
  local got want fail=0

  # (1) tanım çıkarıcı: iki tanım satırı + bir tuzak (atıf, tanım değil)
  want='K-2.1.3a
K-2.13.14h6'
  got=$(printf '%s\n' \
        '**K-2.1.3a** — bir kural' \
        'Bu satır `K-9.9.9` diye ATIF veriyor, tanım değil' \
        '**K-2.13.14h6** — başka bir kural' | extract_rule_ids)
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: extract_rule_ids" >&2
                            echo "   beklenen: [$want]  bulunan: [$got]" >&2; fail=1; }

  # (2) atıf çıkarıcı: iki atıf + "eski" istisnası düşmeli
  want='K-2.1.3a
K-2.4.22'
  got=$(printf '%s\n' \
        'şuna bak: `K-2.1.3a` ve `K-2.4.22`' \
        'ama eski `K-2.12.1` bir iz, atıf değil' | extract_rule_refs)
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: extract_rule_refs" >&2
                            echo "   beklenen: [$want]  bulunan: [$got]" >&2; fail=1; }

  # (3) indeks sayısı
  want='363'
  got=$(printf '%s\n' '| `L2` kural tanımı | **363** |' | extract_index_count)
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: extract_index_count" >&2
                            echo "   beklenen: [$want]  bulunan: [$got]" >&2; fail=1; }

  # (4) indeks açık sayısı
  want='0'
  got=$(printf '%s\n' '| Açık (⛔) kural | **0** ✅ — kalmadı |' | extract_index_open)
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: extract_index_open" >&2
                            echo "   beklenen: [$want]  bulunan: [$got]" >&2; fail=1; }

  return $fail
}

if [ ! -d "$RULES_DIR" ]; then
  echo "HATA: $RULES_DIR bulunamadı" >&2
  exit 2
fi

if ! self_check; then
  {
    echo "!!"
    echo "!! Guard kendi çıkarıcılarını doğrulayamadı — ÖLÇÜM YAPILMADI."
    echo "!! 'Temiz' çıktısı bu durumda anlamsız olurdu: bir çıkarıcı boş"
    echo "!! döndüğünde her kontrol sessizce ✅ verir (2026-08-13'te bu tam"
    echo "!! olarak yaşandı — grep -oP macOS'ta yok)."
  } >&2
  exit 2
fi

echo "BRD v2 · belge guard'ı"
echo "======================"
echo

# ---------------------------------------------------------------- 1 · sayım
echo "1 · Kural sayımı"

TOTAL=$(grep -h '^\*\*K-' "$RULES_DIR"/*.md | wc -l | tr -d ' ')
OPEN=$(grep -h '⛔ \*\*açık' "$RULES_DIR"/*.md | wc -l | tr -d ' ')

echo "   tanım : $TOTAL"
echo "   açık  : $OPEN"
echo
echo "   bölüm başına:"
for f in "$RULES_DIR"/*.md; do
  printf "     %-52s %s\n" "$(basename "$f")" "$(grep -c '^\*\*K-' "$f")"
done
echo

# İndeksteki sayı ile karşılaştır — F8 sınıfı
IDX="$PKG/00_PAKET_INDEKSI.md"
if [ ! -f "$IDX" ]; then
  echo "   ⛔ İHLAL: indeks dosyası yok ($IDX) — sayım karşılaştırılamıyor"
  FAIL=1
else
  IDX_COUNT=$(extract_index_count < "$IDX")
  if [ -z "$IDX_COUNT" ]; then
    # SESSİZ ATLAMA YASAK: indeks var ama satır okunamıyorsa bu bir ihlaldir,
    # bir "kontrol edilemedi" değil. Önceki sürüm burada sessizce geçiyordu.
    echo "   ⛔ İHLAL: indekste 'L2 kural tanımı' satırı okunamadı"
    echo "      (biçim değişmiş olabilir — kontrol körleşmesin diye kırmızı)"
    FAIL=1
  elif [ "$IDX_COUNT" != "$TOTAL" ]; then
    echo "   ⛔ İHLAL: indeks $IDX_COUNT diyor, gerçek $TOTAL"
    echo "      (F8 sınıfı — elle tutulan sayı bayatladı)"
    FAIL=1
  else
    echo "   ✅ indeks sayımıyla uyumlu"
  fi

  # Kontrol adayı (b) — AÇIK SAYISI. 2026-08-13'te ucuzladı: açık kural 0'a indi,
  # yani bu satır artık bir EŞİĞİ koruyor, bir durumu değil. Bir kural sessizce
  # ⛔ açık'a dönerse indeks bayatlar ve eşik kaybedilir.
  IDX_OPEN=$(extract_index_open < "$IDX")
  if [ -z "$IDX_OPEN" ]; then
    echo "   ⛔ İHLAL: indekste 'Açık (⛔) kural' satırı okunamadı"
    FAIL=1
  elif [ "$IDX_OPEN" != "$OPEN" ]; then
    echo "   ⛔ İHLAL: indeks $IDX_OPEN açık diyor, gerçek $OPEN"
    FAIL=1
  elif [ "$OPEN" -eq 0 ]; then
    echo "   ✅ açık kural yok — L2'de dayanaksız yürürlükte madde kalmadı"
  else
    echo "   ✅ açık sayısı indeksle uyumlu"
  fi
fi
echo

# ------------------------------------------------------- 2 · kimlik tekilliği
echo "2 · Kimlik tekilliği"

# ── 2a · HAYALET TANIM: RULES_DIR DIŞINDA kural tanımı taşıyan dosya
# Kör noktanın kendisi buydu: tekillik kontrolü yalnız RULES_DIR'a bakıyordu,
# yani eski bir paketin kalıntısı (aynı kuralları düz dosyalarda taşıyan
# dosyalar) çift tanım üretse bile "çakışma yok" çıkıyordu.
# Ölçüldü 2026-08-13: staging'in dört düz dosyası 333 tanım taşıyor.
GHOSTS=$(find "$PKG" -name '*.md' -not -path "*03_IS_KURALLARI*" -exec grep -l '^\*\*K-' {} \; 2>/dev/null | sort)

if [ -n "$GHOSTS" ]; then
  echo "   ⛔ İHLAL: kural tanımı RULES_DIR DIŞINDA — hayalet dosya"
  printf '%s\n' "$GHOSTS" | while read -r g; do
    [ -z "$g" ] && continue
    echo "      $g  ($(grep -c '^\*\*K-' "$g") tanım)"
  done
  echo "      Eski bir paketin kalıntısı olabilir. Çift tanım tekillik"
  echo "      kontrolüne GÖRÜNMEZ — kapsam RULES_DIR ile sınırlı."
  FAIL=1
fi

DUPES=$(grep -h '^\*\*K-' "$RULES_DIR"/*.md | extract_rule_ids | sort | uniq -d)

if [ -n "$DUPES" ]; then
  echo "   ⛔ İHLAL: aynı numara birden çok kurala verilmiş"
  echo "$DUPES" | while read -r id; do
    echo "      $id"
    grep -Hn "^\*\*$id\*\*" "$RULES_DIR"/*.md | sed 's/^/        /'
  done
  echo
  echo "      Bu, sessiz geçersiz kılmanın en tehlikeli formudur:"
  echo "      atıf çözümlemesi okuyana göre değişir. (F2)"
  FAIL=1
else
  echo "   ✅ çakışma yok"
fi
echo

# ----------------------------------------------------------- 3 · sarkan atıf
echo "3 · Sarkan atıf"

DEFINED=$(mktemp)
REFERENCED=$(mktemp)
trap 'rm -f "$DEFINED" "$REFERENCED"' EXIT

grep -h '^\*\*K-' "$RULES_DIR"/*.md | extract_rule_ids | sort -u > "$DEFINED"
grep -rh '`K-' "$PKG" --include='*.md' | extract_rule_refs | sort -u > "$REFERENCED"

# Kendi kendini denetleyen bir ölçüm: tanım kümesi boşsa çıkarıcı çalışmıyor
# demektir, ve o durumda "sarkan atıf yok" bir yalan olur.
if [ ! -s "$DEFINED" ]; then
  echo "   ⛔ KURULUM HATASI: tanım kümesi boş — çıkarıcı çalışmıyor"
  exit 2
fi

DANGLING=$(comm -13 "$DEFINED" "$REFERENCED")

if [ -n "$DANGLING" ]; then
  echo "   ⛔ İHLAL: var olmayan kurala atıf"
  echo "$DANGLING" | while read -r id; do
    [ -z "$id" ] && continue
    echo "      $id  ←"
    grep -rln "\`$id\`" "$PKG" --include='*.md' | sed 's/^/        /'
  done
  FAIL=1
else
  echo "   ✅ sarkan atıf yok"
fi
echo

# ---------------------------------------------------------------------- özet
echo "======================"
if [ "$FAIL" -eq 0 ]; then
  echo "✅ Temiz — $TOTAL kural, $OPEN açık"
else
  echo "⛔ İhlal var — yukarıya bak"
fi

exit "$FAIL"
