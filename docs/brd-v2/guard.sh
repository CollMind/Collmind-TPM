#!/usr/bin/env bash
# BRD v2 · belge guard'ı — E6
#
# Dört kontrol:
#   1. Kural sayımı            (F8: elle tutulan sayı bayatlar)
#   2. Kimlik tekilliği        (F2: aynı numara iki kurala verilmişti)
#   3. Sarkan atıf             (var olmayan bir K-numarasına referans)
#   4. BACKLOG bayat link      (F2'nin task tarafı — link YANLIŞ hedefe gidiyor)
#
# NOT — "beşinci kontrol" bu dosyada 4 numarayı taşır. 2a (hayalet tanım) ayrı
# bir kontroldür ama 2'nin altında yaşar; sayarken beş, numaralarken dört
# çıkıyor. Guard'ın kendi dersi burada da geçerli: numara değil, LİSTE kanonik.
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
#   f) `D-*` etiket tekilliği — 2026-08-14: `D1`/`D2` İKİ ŞEYE verilmişti
#      (`T-189` = `analysis/0058`'in Playwright denetimi · gri→yeşil sızıntısı +
#      kapsama oranı). `F2`'nin üçüncü vakası ama BAŞKA BİR UZAYDA: `K-*` ve `T-*`
#      guard'lı, `D-*` değil. ⚠️ Ve daha basit bir çözüm var: `D-*` serisi geçici
#      bir etiket olarak doğdu ve iki kez çakıştı — KULLANIMDAN KALDIRILMASI
#      guard yazmaktan ucuz. Karar verilmedi.
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

# BACKLOG paketin DIŞINDA yaşıyor, yani $PKG'den türetilemez — script'in kendi
# konumundan türetiliyor. (Çağıranın cwd'sinden değil: guard hem depo kökünden
# hem paket içinden çağrılıyor, ve bir kontrolün kapsamı çağırana göre
# değişmemeli.)
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BACKLOG_FILE="${BACKLOG_FILE:-$SCRIPT_DIR/../../.claude/backlog/BACKLOG.md}"
TASKS_DIR="${TASKS_DIR:-$SCRIPT_DIR/../../.claude/backlog/tasks}"

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

TAB=$(printf '\t')

# BACKLOG tablo satırlarından "T-nnn<TAB>açıklama" üretir.
#   | [[T-113]] | grid e2e fixture'ı: … | P1 | debugger | review |
# Yalnız TABLO satırları: kapanmış task'ların madde-imli listesi başka biçimde
# ve başka bir amaca hizmet ediyor (arşiv), açıklaması güncel tutulmuyor.
extract_backlog_links() {
  sed -n "s/^| \[\[\(T-[0-9][0-9]*[a-z]*\)\]\] *| *\([^|]*[^| ]\) *|.*/\1${TAB}\2/p"
}

# task dosyasının frontmatter başlığını çıkarır (tırnaklı ya da tırnaksız)
extract_task_title() {
  sed -n 's/^title:[[:space:]]*//p' | sed -n '1p' | sed 's/^"//; s/"$//'
}

# ── Bayat link motoru — TEK uygulama (pozitif kontrol de üretim yolu da burada)
#
# SORULAN SORU şu DEĞİL: "açıklama başlıkla uyuşuyor mu?" Ölçüldü (2026-08-13,
# 167 satır): BACKLOG açıklamaları teşhis ilerledikçe güncelleniyor, başlık
# ilk günden kalıyor — sıfır kesişimli ON satır var ve HEPSİ doğru. Uyum
# aramak on yanlış pozitif üretirdi, ve gürültülü bir guard kapatılır.
#
# SORULAN SORU: "BAŞKA bir task dosyası bu açıklamaya belirgin biçimde daha mı
# iyi uyuyor?" Bu, tam olarak aranan tehlikenin şeklidir — link kırılmadı,
# BAŞKA YERE gitti. Doğru bir linkte hedef zaten en iyi eşleşmedir.
#
#   girdi : $1 = linkler  (id<TAB>açıklama)   ·  $2 = başlıklar (id<TAB>başlık)
#   çıktı : id<TAB>SAPMA<TAB>daha-iyi-hedef<TAB>bağlı-skor<TAB>en-iyi-skor<TAB>açıklama
#           id<TAB>YOK<TAB>-<TAB>-<TAB>-<TAB>açıklama          (hedef dosya yok)
#
# Açıklama çıktıya BİLE BİLE taşınıyor, sonradan BACKLOG'dan aranmıyor: aynı id
# birden çok satırda geçebilir ve `grep -m1` BAŞKA bir satırı basar. Ölçüldü
# (2026-08-13, enjeksiyon turu): teşhis satırı, bulguyu ÜRETEN satır yerine
# gerçek T-200 satırını gösterdi — skorla çelişen bir kanıt. Kanıt, ölçülen
# şeyin kendisi olmalı; ikinci bir aramayla yeniden bulunanı değil.
#
# LINK_MARGIN ölçülerek seçildi — TAHMİNLE değil, BU uygulamayla. (İlk kalibrasyon
# ayrı bir python taslağıyla yapılmıştı ve +2'yi işaret ediyordu; awk'ın bayt-güvenli
# sözcükleyicisi Türkçe kelimeleri daha kısa parçalara böldüğü için gürültü seviyesi
# farklı çıktı. Bir eşik, onu kullanacak KODLA kalibre edilir.)
#
# Ölçüm (2026-08-13 · gerçek BACKLOG 167 satır · her satırın hedefi rastgele başka
# bir task'a saptırılmış ikinci bir BACKLOG'a karşı):
#
#     eşik   temiz→yanlış pozitif   saptırılmış→yakalanan
#     +2            1                  147/167  (%88)
#     +3            0                  127/167  (%76)   ← seçilen
#
# +2'nin tek yanlış pozitifi (T-098 → T-085) yalnız jenerik parçalarda kesişiyordu
# ("canl", "rota"). Nadir token filtresi (IDF) denendi: yanlış pozitifi ancak
# kesme 4'e inince düşürdü, ve o noktada yakalama da 127'ye indi — yani +3 ile
# AYNI sonuç, fazladan bir düğmeyle. Düğme kaldırıldı.
#
# Temiz backlog'da kırmızı veren bir guard kapatılır (§2.7 #9: sinyal sabitse,
# sinyal değildir). 12 puan duyarlılık, yaşayan bir guard'ın bedeli.
#
# ⚠️ Eşik, pozitif kontrolün fixture farkından (4) KÜÇÜK kalmalı. Büyütülürse
# fixture'daki bilinen bayat link yakalanmaz ve guard `exit 2` verir — yani
# körleşmez, ÇALIŞMAYI REDDEDER. Bu bilinçli: eşiği yükselten kişi sessiz bir
# körlük değil, gürültülü bir hata görür.
LINK_MARGIN=3

audit_link_targets() {
  awk -F"$TAB" -v margin="$LINK_MARGIN" '
    # Bayt-güvenli sözcükleyici: Türkçe karakterler çok baytlıdır ve burada
    # AYRIŞTIRICI gibi davranırlar ("şema" → "ema"). Kayıplı ama SİMETRİK —
    # aynı sözcük iki tarafta da aynı biçimde bölünür, kesişim korunur.
    # Locale bağımsızlığı bilinçli: guard iki farklı ortamda aynı sonucu
    # vermek zorunda.
    function tokenize(s, arr,   n, i, parts) {
      delete arr
      s = tolower(s)
      gsub(/[^0-9a-z-]+/, " ", s)
      n = split(s, parts, " ")
      for (i = 1; i <= n; i++)
        if (length(parts[i]) >= 3) arr[parts[i]] = 1
    }
    NR == FNR {                      # başlıklar → ters indeks
      known[$1] = 1
      tokenize($2, t)
      for (w in t) inv[w] = inv[w] " " $1
      next
    }
    {                                # linkler
      link = $1
      if (!(link in known)) { print link "\tYOK\t-\t-\t-\t" $2; next }
      tokenize($2, d)
      delete score
      for (w in d) {
        n = split(inv[w], lst, " ")
        for (i = 1; i <= n; i++) if (lst[i] != "") score[lst[i]]++
      }
      linked = score[link] + 0
      # Belirlenimci eşitlik bozma: awk için `for (k in …)` sırası tanımsızdır,
      # ve sırası değişen bir guard iki koşumda iki cevap verir.
      bestid = ""; best = -1
      for (k in score)
        if (score[k] > best || (score[k] == best && k < bestid)) {
          best = score[k]; bestid = k
        }
      if (bestid != link && best > linked + margin)
        print link "\tSAPMA\t" bestid "\t" linked "\t" best "\t" $2
    }
  ' "$2" "$1"
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

  # (5) BACKLOG link çıkarıcı: bir tablo satırı + iki tuzak
  #     (madde-imli arşiv satırı ve gövde içindeki bir [[T-nnn]] atfı SAYILMAZ)
  want="T-113${TAB}grid e2e fixture'ı: 500 bayat süreçmiş"
  got=$(printf '%s\n' \
        "| [[T-113]] | grid e2e fixture'ı: 500 bayat süreçmiş | P1 | debugger | review |" \
        '- [[T-019b]] arşiv satırı — tablo değil' \
        'gövdede geçen bir [[T-042]] atfı' | extract_backlog_links)
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: extract_backlog_links" >&2
                            echo "   beklenen: [$want]  bulunan: [$got]" >&2; fail=1; }

  # (6) başlık çıkarıcı: tırnaklı biçim + ilk satır kuralı
  want="POST /plans/:id/fus 500 dönüyor — grid e2e'leri hiç koşamıyor"
  got=$(printf '%s\n' 'id: T-113' \
        'title: "POST /plans/:id/fus 500 dönüyor — grid e2e'\''leri hiç koşamıyor"' \
        'title: gövdede geçen ikinci bir title satırı' | extract_task_title)
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: extract_task_title" >&2
                            echo "   beklenen: [$want]  bulunan: [$got]" >&2; fail=1; }

  # (7) BAYAT LİNK MOTORU — bu turun asıl kontrolü.
  #
  # Fixture üç durumu BİRDEN taşır ve üçü de kanıtlanmak zorunda:
  #   · doğru link       → bulgu ÜRETMEMELİ  (yanlış pozitif yokluğu)
  #   · saptırılmış link → SAPMA + doğru hedefi göstermeli
  #   · hedefsiz link    → YOK
  #
  # İkincisi olmadan guard'ın yakaladığı bilinmez; BİRİNCİSİ olmadan guard'ın
  # sustuğu bilinmez. "Her koşuda bilinen bir bayat link enjekte edilip
  # yakalandığı gösterilmeli" — ve sessiz kaldığı da.
  local lf tf
  lf=$(mktemp); tf=$(mktemp)
  printf '%s\n' \
    "T-900${TAB}Şema guard'ı yok — INV-L-001 hâlâ HOLDS yazıyor" \
    "T-901${TAB}Super Admin altıncı rol olarak tanımlanmalı" > "$tf"
  printf '%s\n' \
    "T-900${TAB}şema guard'ı inmedi — INV-L-001 hâlâ HOLDS" \
    "T-901${TAB}şema guard'ı inmedi — INV-L-001 hâlâ HOLDS" \
    "T-902${TAB}hedefi olmayan bir link" > "$lf"

  want="T-901${TAB}SAPMA${TAB}T-900${TAB}0${TAB}4${TAB}şema guard'ı inmedi — INV-L-001 hâlâ HOLDS
T-902${TAB}YOK${TAB}-${TAB}-${TAB}-${TAB}hedefi olmayan bir link"
  got=$(audit_link_targets "$lf" "$tf")
  rm -f "$lf" "$tf"
  [ "$got" = "$want" ] || { echo "!! pozitif kontrol DÜŞTÜ: audit_link_targets" >&2
                            echo "   beklenen: [$want]" >&2
                            echo "   bulunan : [$got]" >&2; fail=1; }

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

# ------------------------------------------------- 4 · BACKLOG bayat link
# F2'nin task tarafı. Kırık bir link fark edilir; YANLIŞ HEDEFE giden bir link
# doğru görünür — ve bu sınıf bu depoda altı kez ölçüldü (F2 · T-nnn çakışması
# · K-2.12.* sarkan atıfları · ve BACKLOG).
echo "4 · BACKLOG bayat link"

if [ ! -f "$BACKLOG_FILE" ]; then
  # SESSİZ ATLAMA YASAK. Bir dosyanın bulunamaması kontrolü kaldırmaz; kontrolü
  # kaldıran şey "bulunamadı → yeşil" davranışıdır. (CLAUDE.md · port kuralı:
  # "SKIPPED bir geçiş değildir" — ve onu geçiş olmaktan çıkaran şey burada
  # exit 2'dir, dışarıdaki bir grep değil.)
  echo "   ⛔ KURULUM HATASI: BACKLOG bulunamadı ($BACKLOG_FILE)"
  exit 2
fi
if [ ! -d "$TASKS_DIR" ]; then
  echo "   ⛔ KURULUM HATASI: task dizini bulunamadı ($TASKS_DIR)"
  exit 2
fi

LINKS=$(mktemp)
TITLES=$(mktemp)
trap 'rm -f "$DEFINED" "$REFERENCED" "$LINKS" "$TITLES"' EXIT

extract_backlog_links < "$BACKLOG_FILE" > "$LINKS"
for f in "$TASKS_DIR"/T-*.md; do
  [ -f "$f" ] || continue
  ttl=$(extract_task_title < "$f")
  [ -n "$ttl" ] || continue
  printf '%s%s%s\n' "$(basename "$f" .md)" "$TAB" "$ttl" >> "$TITLES"
done

# Boş küme = çıkarıcı çalışmıyor. Ve bu motorda boşluk SESSİZ DEĞİL, TERS
# çalışır: başlık dosyası boşsa awk'ın `NR == FNR` koşulu link dosyasını
# başlık sanır ve her satır "kendi kendine uyuyor" çıkar — yani tam yeşil.
if [ ! -s "$LINKS" ]; then
  echo "   ⛔ KURULUM HATASI: BACKLOG'dan link çıkmadı — çıkarıcı çalışmıyor"
  exit 2
fi
if [ ! -s "$TITLES" ]; then
  echo "   ⛔ KURULUM HATASI: task başlığı çıkmadı — çıkarıcı çalışmıyor"
  exit 2
fi

echo "   link  : $(wc -l < "$LINKS" | tr -d ' ')"
echo "   başlık: $(wc -l < "$TITLES" | tr -d ' ')"

STALE=$(audit_link_targets "$LINKS" "$TITLES")

if [ -n "$STALE" ]; then
  echo "$STALE" | while IFS="$TAB" read -r id verdict better ls bs desc; do
    [ -z "$id" ] && continue
    if [ "$verdict" = "YOK" ]; then
      echo "   ⛔ İHLAL: $id — BACKLOG'da link var, task dosyası YOK"
    else
      echo "   ⛔ İHLAL: $id — açıklama $better'a belirgin daha iyi uyuyor"
      echo "        anahtar kesişimi:  $id=$ls   $better=$bs"
      # Kısaltma KELİME sınırında: `cut -c` bayt-bazlıdır ve çok baytlı bir
      # Türkçe karakteri ortadan böler. Ölçüldü 2026-08-13: guard'ın kendi
      # çıktısı geçersiz UTF-8'e dönüştü ve ugrep o dosyada HİÇBİR ŞEY
      # bulamadı (BSD grep 147 bulgu sayarken ugrep 0). Yani guard'ın
      # çıktısını sayan her araç sessizce sıfır görüyordu — §2.7'nin
      # "ölçüm aracının kendisi bozuk" hâli, guard'ın kendi turunda.
      echo "        BACKLOG : $(printf '%s' "$desc" | cut -d' ' -f1-16)"
      echo "        $id başlığı: $(grep "^$id$TAB" "$TITLES" | cut -f2-)"
      echo "        $better başlığı: $(grep "^$better$TAB" "$TITLES" | cut -f2-)"
    fi
  done
  echo
  echo "      Link YANLIŞ HEDEFE gidiyor olabilir. Kırık link fark edilir;"
  echo "      yanlış hedefe giden link DOĞRU GÖRÜNÜR."
  FAIL=1
else
  echo "   ✅ bayat link yok"
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
