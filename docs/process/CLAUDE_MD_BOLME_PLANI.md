# `CLAUDE.md` BÖLME PLANI — **ÖNERİ** (onay bekliyor)

**Tarih:** 2026-08-25 · **Hazırlayan:** Team Lead · **Şema ilkeleri:** ürün sahibi
**Statü:** ⏳ onaylanmadan bölme commit'i atılmaz

---

## 0 · TABAN ÖLÇÜMÜ (bölme ÖNCESİ — kayıpsızlık kanıtının referansı)

```
CLAUDE.md            3045 satır · 89 başlık  (1 '#' · 9 '##' · 79 '###')
§2.7 ailesi          1995 satır   %65
§7.1 ailesi           489 satır   %16
çekirdek adayları     561 satır   %18   (§0–§2.6: 321 · §3–§7: 240)
```

## 1 · ⛔ EN BÜYÜK RİSK ÖLÇÜLDÜ — ve beklediğimden farklı çıktı

`docs/` + `.claude/` genelinde **numaralı `§` atıfları**:

| atıf | adet |
|---|---|
| `§7.1` | **229** |
| `§2.5` | 163 · `§2.7` 147 · `§2.3` 145 · `§2.4` 80 |
| `§2.7 #N` | **80** (`#9`→33 · `#6`→26 · `#4`→8 · `#8`→7 · `#5`→3 · `#7`→2 · `#10`→1) |
| `§4.2` 60 · `§2.1` 56 · `§2.6` 54 · `§2.1.2` 43 · `§2.2` 37 · `§2.1.1` 24 · `§4.1` 12 |

> ### ⛔ VE BİR MEVCUT TEHLİKE ORTAYA ÇIKTI — bölme onu KÖTÜLEŞTİRMEMELİ
>
> **Çıplak `§2.N` bugün BELİRSİZ.** Aynı biçim hem `CLAUDE.md`'yi hem **BRD**'yi
> gösteriyor. Örneklendi:
>
> ```
> "…ulaşılamazsa `CLAUDE.md §2.3`'ün BudgetAlertConfigur…"   → CLAUDE.md
> "…bir hâli yok (§2.3). Mevcut davranışı **spe…"            → BRD
> "…`numeric(18,3)` taşıyor** (§2.2). D-06'nın…"             → BRD
> ```
>
> ⇒ `§3.3` · `§5.2` · `§10.1` · `§9.x` · `§11.x` gibi yüksek sayılar **BRD'nin**,
> `CLAUDE.md`'nin değil. `CLAUDE.md`-sahipli atıf **≈1130**.
>
> 📌 **Bu bölmenin yarattığı bir sorun DEĞİL, bulduğu bir sorun.** Plan onu
> çözmüyor (kapsam dışı), ama **kötüleştirmiyor**: numaralı iskelet
> `CLAUDE.md`'de **aynen kalıyor**.

## 2 · ŞEMA — iki katman, disiplin TEK dosya

```
CLAUDE.md              ÇEKİRDEK — her turun başında okunan
                       §0–§7 numaralı iskelet AYNEN KALIR
                       + taşınan her kural için TEK SATIR indeks

docs/DISIPLIN.md       DİSİPLİN — tetiklenince başvurulan
                       aile başlıklarıyla, başlık metinleri BİREBİR
```

**Ad tahsisi (Team Lead):** `docs/DISIPLIN.md`. Gerekçe: `§5 Doküman yeri` kuralı
*"`docs/` (ölçüm, karar, **sözleşme**, rapor) meta-repo'da yaşar"* diyor — bu bir
sözleşmedir. Alt-dizin **yok** (tek dosya kararı).

### ⛔ ATIF SÖZLEŞMESİ DEĞİŞMEZ — bölmenin birinci şartı

- **Numaralı iskelet `CLAUDE.md`'de kalır.** `§2.7`, `§7.1`, `§4.2`, `§2.6`…
  hepsi **aynı numarayla** aynı dosyada.
- **`§2.7`'nin ON SATIRLIK TABLOSU çekirdekte kalır** — `§2.7 #N`'in atıf yüzeyi
  odur (**80** atıf). Tablonun **uzun düzyazı açıklamaları** disipline taşınır.
- Taşınan her kural çekirdekte **tek satır**: `ad → docs/DISIPLIN.md#çapa`.
- **Başlık metinleri BİREBİR taşınır** — çapa (`#anchor`) başlıktan türediği için
  metin değişirse çapa değişir, yani bu bir **atıf koruma** şartıdır.

## 3 · SINIFLANDIRMA — 88 başlık, tam liste

Turnusol (ürün sahibi): *"Bu satırı okumayan bir ajan, **ilk mesajında** yanlış
davranır mı?"* → Evet: çekirdek · Hayır: disiplin. **Sınırdakiler disipline.**

```
ÇEKİRDEK   26 başlık      DİSİPLİN   63 başlık
```

> ⛔ **PLANDAKİ `19/69` YANLIŞTI — gerçek `26/63`** (`F12` izi).
> Sebep: plan *"numaralı başlık = atıf iskeleti = çekirdek"* kuralını yürütmede
> netleştirdi; `§2.1.1` · `§2.1.2` · `§2.2` · `§2.6` · `§2.7` · `§7.1` çekirdeğe
> döndü. İlk denemede taşınmışlardı ve **planın birinci şartını ihlal
> ediyorlardı** — `§2.6` tek başına `54` dış atıf taşıyor.

Tam liste ekte: [`CLAUDE_MD_BOLME_SINIFLANDIRMA.md`](CLAUDE_MD_BOLME_SINIFLANDIRMA.md)

### Çekirdekte kalanlar — ve neden

| bölüm | neden ilk mesajda gerekli |
|---|---|
| `§0` oturum başı · `§1` proje haritası + TTM | yanlış repo/port/DB'ye gider |
| `§2.1` kaynak hiyerarşisi · **BRD dondurma** | dondurulmuş belgeye kayıtsız yazar |
| `§2.3` özet hatırlatmalar · `§2.4` **DUR** · `§2.5` **sessiz sıfır** | varsayarak ilerler, boşluk uydurur |
| `§3` ekip + **sorumluluk sınırları** | migration'ı yanlış ajana yazdırır |
| `§4` görev akışı · `touches` · `§4.1` · **`§4.2` Done** | `done` yazar, çakışan tur açar |
| `§5` git + **push-order** + doküman yeri | push sırasını ters yapar |
| `§6` zincirler · `§7` önce ara | yeniden yazar |

### Disipline taşınan aileler

| aile | ne toplar |
|---|---|
| **ARAMA UZAYI ve NEGATİF KANIT** | poz.kontrol · evren seçimi · yüzey dili · enjeksiyon≠kullanım · sayı örnekleme |
| **KAPI ve GUARD YAZIMI** | kapı=durdurma · `Z29` üç+dördüncü soru · dosya-sınırı state · self-test zinciri |
| **GİZLENEN KUSUR SINIFLARI** | bileşimsel fail-open · `500` örtüsü · yorum kirliliği · *"ulaşılamaz"* |
| **ŞART · SINIR · KAYIT** | ayrılabilirlik · `DUR`/kabul listeleri · sağlayıcı-kilit · türev belge |
| **SAYI · LİSTE · KANIT** | toplam≠sınıf · eşitlik≠varlık · rengin sebebi · bağımsız çakıştırma |
| **DÜZELTME · PORT · BAYATLIK** | düzeltme=iddia · bağlam taşınmaz · bayat süreç/ölçüm · fixture ayırt ediciliği |

## 4 · ARAÇLAŞMIŞ KURALLAR — *"araç uygular"* satırı

Tam metin **disiplinde kalır**; çekirdekte **yalnız araç adı**. Bugün `CLAUDE.md`'de
adı geçen araçlar ölçüldü — **dört**:

```
scripts/guards/money-float.sh · money-float-domain-a.txt · money-float-baseline.txt
scripts/guards/find-importers.sh
```

⚠️ **Ama araçlaşma bundan geniş** — bu oturumda doğan/genişleyenler dahil:
`route-scope.sh` · `route-scope.awk` · `single-mechanism.sh` · `scope-ratchet.sh` ·
`lint-ratchet.sh` · `route-cell-map.py` · `push-order.sh` · `guard.sh`.

⇒ Bölme turunda **her kuralın karşısına araç satırı EKLENMEZ** (o bir metin
değişikliğidir, bkz. `§5`). Bunun yerine: **envanter çıkarılır ve ayrı tura
bırakılır.** Bölme turu **salt taşımadır**.

## 5 · ⛔ COMMIT ŞEKLİ — TEK commit, SALT TAŞIMA, SIFIR metin değişikliği

```
✅  satır taşınır          ✅  indeks satırı eklenir (YENİ metin, taşıma değil)
⛔  hiçbir kural DÜZELTİLMEZ    ⛔  hiçbir başlık YENİDEN YAZILMAZ
⛔  hiçbir araç satırı EKLENMEZ ⛔  hiçbir bayat metin GÜNCELLENMEZ
```

> **Bayat bir kural bulursan İŞARETLE, ayrı tura.** Taşıma ile düzeltme aynı
> commit'te yaşarsa diff **gözden geçirilemez** olur — *cerrahi baseline* dersinin
> doküman hâli (`19` satırlık toptan düşüş yerine kendi turunun `2` satırı).

⚠️ **İndeks satırları bir istisnadır ve bilinçli:** onlar taşınan metnin değil,
**bölmenin kendisinin** ürünü. Diff'te tek blok hâlinde görünürler.

## 6 · KAYIPSIZLIK — ÜÇ ÖLÇÜT (ürün sahibi)

### Ölçüt 1 · Başlık listesi BİREBİR
```bash
# ÖNCE (bu commit'ten önce, HEAD'den):
git show HEAD:CLAUDE.md | grep '^#\{1,4\} ' | sed 's/^#* //' | sort > /tmp/once.txt
# SONRA:
cat CLAUDE.md docs/DISIPLIN.md | grep '^#\{1,4\} ' | sed 's/^#* //' | sort > /tmp/sonra.txt
```
⛔ **POZ.KONTROL DIFF'TEN ÖNCE:** iki dosyanın da **boş olmadığı** ve satır
sayılarının beklenen olduğu ayrıca kanıtlanır — *iki boş dosyanın `diff`'i `rc=0`
verir.* Sonra `diff` **boş** olmalı (indeks satırları başlık DEĞİL, `-` ile başlar).

### Ölçüt 2 · Sarkan atıf taraması — **İKİ YÖNDE**
```
ileri  : CLAUDE.md'deki her `docs/DISIPLIN.md#çapa` GERÇEKTEN var mı
geri   : DISIPLIN.md'deki her `CLAUDE.md §N` atfı hâlâ ÇÖZÜLÜYOR mu
```
Ve **`§2.7 #1..#10`** ile **`§7.1`** ayrıca sınanır — en çok atıf alan iki yüzey.

### Ölçüt 3 · ÖRNEKLEM-BRIEF atıf çözümü
`docs/process/B3B1_DEVIR_BRIEF.md`'nin **`§4 DUR listesi`** alınır; içindeki her
`CLAUDE.md` atfının **yeni yapıda hedefine vardığı** tek tek gösterilir.

> 📌 Üçü birlikte: **liste kayıpsız · bağlar sağlam · gerçek bir okuyucu yolunu
> buluyor.** Üçüncüsü olmadan ilk ikisi *"dosya bütün"* der, *"kullanılabilir"*
> demez.

## 7 · SIRA

```
1  bölme commit'i (salt taşıma) + üç ölçüt raporu     ← ONAY sonrası
2  W2 açılır — 2.784 satır yerine ~560 satırlık zeminle
3  bayat-kural envanteri ve araç-satırı turu AYRI, aciliyetsiz
```

⚠️ **Bölme turu `code-reviewer` ZORUNLU** — muafiyetin daraltılmış hâli gereği
(kural metni taşıyan tur), ve burada özellikle: **taşımanın gerçekten SALT taşıma
olduğunu** üçüncü bir göz doğrulamalı.
