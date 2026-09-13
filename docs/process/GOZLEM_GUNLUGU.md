# `GOZLEM_GUNLUGU.md` — TEK-VAKALI GÖZLEMLER
### `ADIM-4` (2026-09-09) · ⛔ **SİLİNMİŞ DEĞİL, TAŞINMIŞ**

> ## ⛔ BU DOSYA BİR ÇÖP KUTUSU DEĞİLDİR
> Buradaki her madde `DISIPLIN.md`'de **başlığı ve tek satırlık özetiyle DURUYOR**,
> ve **karşılıklı atıflıdır** (`F12` / `0006-R` deseni).
> ### ⛔ **İKİNCİ VAKASINDA GERİ TERFİ EDER** — `DISIPLIN`'e döner, `F12` iziyle.

**Taşıma ölçütü (`H2`):** `TEK VAKA` **ve** `türev 0` — yani madde bir sınıf
**tanımlamıyor** (`R1`) ve henüz **atıf almamış**. ⛔ Bir maddenin buraya inmesi
*"yanlış"* demek **değildir**; *"henüz ikinci vakası yok"* demektir.

---

## ENVANTER
```
1  KÖR-NOKTA TÜRLERİ MUTASYON TÜRÜNE GÖRE AYRIŞIR   türev 0   (A)'nın ölçümü
2  Bir YÖNLENDİRME sessiz olamaz                     türev 0   2026-09-08 yazıldı
3  Bir DOSYA YOLU da bir iddiadır — ve BAYATLAR      türev 0   2026-09-08 yazıldı
4  Bir KÜME-pininin gücü, ÜYE KİMLİĞİNE bağlıdır      ⭐ TERFİ ETTİ 2026-09-13 → DISIPLIN F03 (Z111 §30) — ikinci vaka: pin B-2
5  Harness koşum SÜRESİ ardışık vakalarda sıçradı      türev 0   2026-09-13 GÖZLEM (Z111 §29) — sebep ÖLÇÜLMEDİ, F14
```
📌 **`2` ve `3` bu oturumda yazıldı ve AYNI OTURUMDA günlüğe indi.** Bu bir çelişki
değil, ölçütün **kendi yazarını elemesi** — ve `R1`'in çalıştığının kanıtı.

---

### KÖR-NOKTA TÜRLERİ MUTASYON TÜRÜNE GÖRE AYRIŞIR (ZORUNLU — bir daraltma)

`W4a`'nın *"`5/5` hücrede pin kördür"* cümlesi **fazla kabaydı**. `W7` ölçtü:

| mutasyon türü | `5/5` hücrede pin |
|---|---|
| **dekoratör DÜŞMESİ** (`@RequireCapability` kalkar) | **KÖR** — beş rol de hâlâ `403` almıyor |
| **ÜYELİK DARALTMASI** (bir rol hücreden çıkar) | **GÖRÜYOR** — pin'in pozitif yarısı **rol-granüler** (`it.each`) |

> **Bir kör-nokta iddiası, HANGİ MUTASYONA karşı kör olduğunu söylemelidir.**
> *"Pin kördür"* eksik bir cümledir; *"pin **şu** mutasyona karşı kördür"* tam.

### ⇒ VE PİN, HANGİ KAPIYA YASLANDIĞINI DA SÖYLER

*"Pinin ne ölçmediği başlığa yazılır"* kuralının **bağımlılık yönü**:

```
pin  →  yetenek ÜYELİĞİNİ tutar        (global ⇒ örnekleme yeter)
G6   →  rota→hücre ATAMASINI tutar     (45 rotanın HEPSİNDE)
⇒ örnekleme yeterlidir AMA G6'ya KOŞULLU; G6 daralırsa altı controller
  SESSİZCE korumasız kalır
```

📌 Ölçüldü: örneklenmemiş bir controller'da hücre kaydırması → pin **yeşil**,
`G6` rotayı **adıyla** yakaladı.

### TEK-ÜRETİCİ İLKESİNİN SON İSTİSNASI KAPANDI

Bir artefaktın **bir kısmı** üretilip **bir kısmı elle** yazılıyorsa, elle yazılan
kısım **her yeniden üretimde kaybolur** — ve kaybı gören kapı **yoksa** sessizce
tekrarlar.

📌 Vaka (`W7`): TSV'nin dört `#` satırının dördü de elle ekleniyordu; üçü
hatırlandı, **sütun başlığı unutuldu**. Ve `G7` `#` satırlarını **filtrelediği için
bunu yapısal olarak göremiyordu**.

> **Artefakt KENDİNİ TARİF ETMELİDİR.** Başlık üreticiye taşındı ⇒ elle-hatırlama
> sınıfı kapandı.



## Bir YÖNLENDİRME sessiz olamaz — ölçüm, NEYİ ölçtüğünü söylemeli (ZORUNLU)

`§2.5` sessiz varsayılanı yasaklar. Bu onun **ölçüm araçları** tarafındaki hâli:

> ### ⛔ Bir araç, hangi hedefe/DB'ye/zincire baktığını **çıktısında söylemiyorsa**,
> ### o çıktı bir **kanıt değildir** — çünkü neyin kanıtı olduğu bilinmiyor.

Ölçülmüş vaka (2026-09-08, `Z109 §4 KAYIT 2`): bir migration harness'ı
`MIGRATION_VERIFY_RUN_CMD` / `REVERT_CMD` env override'ları taşıyordu. Meşru bir ihtiyaçtan
doğmuşlardı (sentetik bilinen-kırmızı, gerçek zincirin dışında yaşıyor) ama **sessizdiler**:
override aktifken çıktıda **hiçbir iz yoktu**.

```
⇒ etkin komut/hedef HER koşumda basılır
⇒ bir override AKTİFSE ayrıca UYARI basılır ve MEŞRU KULLANIMI yazılır
```

### Kardeşi: **YÜKSEK SESLE EKSİK KALMAK**

Aynı harness'ın en iyi tarafı bir kontrol değildi: `K5`'in bir **sezgi** olduğunu ve
`K6`'nın **hiç inşa edilmediğini** — bir raporda değil, **aracın kendi çıktısında**,
**her koşumda** basıyordu.

> ### ⛔ Sessizce atlayan bir kontrol, **olmayan** bir kontrolden **daha tehlikelidir** —
> ### çünkü **var sanılır.**

📌 `ÖLÇEMEDİM`'in (kapının üçüncü çıktısı) kontrol-düzeyindeki hâli: bir araç, kapsamadığı
şeyi **geçti** saymaz, ve kapsamadığını **söyler**.

---


## Bir DOSYA YOLU da bir iddiadır — ve BAYATLAR (ZORUNLU)

Bir brief'in okuma listesi, bir yorumun atfı, bir `[ÖLÇÜLDÜ:]` etiketinin kaynağı — hepsi
**iddiadır**, ve dosyalar **taşınır**.

Ölçülmüş vaka (2026-09-08, `Z109 §4 KAYIT 3`): bir brief'in okuma listesinde
`collmind.backend/scripts/guards/sigpipe-hygiene.sh` yazıyordu. **O yol yoktu** — dosya
`T-359b` ile meta köküne taşınmıştı. Şerit ölçtü ve bildirdi.

```
⇒ okuma listesindeki HER YOL, brief yazılırken `ls` ile doğrulanır
⇒ [ÖLÇÜLDÜ: ls -l <yol>]  —  yol da bir ölçümdür
```

📌 *"Brief'te her iddia bir etiket taşır"* kuralının **kaynak gösteren her satıra**
genişlemesi: kural yalnız **sayılara** değil, **işaret eden her şeye** uygulanır.
⚠️ Ve aynı sınıf kod yorumlarında da yaşar (`dosya:satır` atıfları) — orada adı
**yorum kirliliği**dir ve zaten kayıtlıdır; bu, onun **brief** tarafındaki yüzü.

---

## Bir KÜME-pininin ayırt etme gücü, ÜYENİN KİMLİK tanımına bağlıdır (ADAY — tek vaka)

> ⭐ **`F12` — TERFİ ETTİ (2026-09-13, `Z111 §30` kayıt 2):** ikinci vaka pin review'unda (B-2: `regexp_match` ilk `:op` →
> `GREATEST(LOCALTIMESTAMP…)` imzası `op0`). Kural artık DISIPLIN `F03`'te **gövdeyle**: *"KİMLİK KÖRLÜĞÜ"*. Bu kayıt **silinmez** —
> vaka 1'in tablosu burada kalır (`GERİ TERFİ NASIL OLUR` §2).

**Durum:** `ADAY` · 2026-09-11 · `Z111 §22.1` N19 · `§23` · türev **0** · DISIPLIN `F03`'te stub'ı var.
⛔ DISIPLIN'den **taşınmadı** — doğrudan günlüğe yazıldı (ürün sahibi: *"günlüğe, aday olarak; DISIPLIN'e ikinci vakada"*).

Ölçülmüş vaka (migration harness volatil maskesinin pini): *"maskelenen ifade türlerinin kümesi"* pinlenecekti.
"Tür"ün kimliği üç biçimde tanımlanabiliyordu, üçü ölçüldü:

| kimlik | bugünkü küme | stable-cast'li sabit `'2020-01-01'::timestamptz` | serial'lı yeni tablo |
|---|---|---|---|
| ifade metni | `nextval('<seq>')` sequence adını taşır | yeni üye | **yeni üye — gürültü** |
| fonksiyon başına | `timestamp` cast'i zaten üye | `{timestamp}` **mevcut üyeye gömülür — pin YEŞİL, kör** | mevcut üye |
| kolon başına imza | dört imza | `{timestamp}` **yeni imza — pin KIRMIZI** | mevcut imza |

> **Bir küme-pini, üyesi kaba tanımlanırsa yeni bir biçimi mevcut bir üyeye gömer ve yeşil kalır.**
> Pinin gücü kümenin **büyüklüğünden** değil, **üye kimliğinin inceliğinden** gelir — ve fazla ince kimlik gürültü üretir.

**Ailesi:** `F03` — PİN ve KÖR NOKTA. En yakın emsal **seviye körlüğü** (aynı kural iki seviyede, pin birinde); bu
**kimlik körlüğü** (küme üyesi kaba tanımlı, pin kör). İkinci vakada ailenin **yedinci** türü.

🔎 **Tetikleyici:** *"bir kümeyi pinliyorum — üyenin kimliği ne?"* ve *"yeni bir biçim, mevcut bir üyeye gömülebilir mi?"*

---

## Harness koşum SÜRESİ ardışık vakalarda sıçradı — sebep ÖLÇÜLMEDİ (GÖZLEM — tek vaka)

**Durum:** `GÖZLEM` · 2026-09-13 · `Z111 §29` · türev **0** · DISIPLIN `F14`'te stub'ı var.
⛔ **Kural adayı DEĞİL** — bir **ölçülmemiş anomalinin kaydı**. Ürün sahibi: *"bugün T-task bile değil, günlük."*

```
[ÖLÇÜLDÜ: tl-verify-r9.sh, SUMMARY — vaka başına süre]
normal vaka               ~ bir dakika
beş ARDIŞIK vaka          on dakikadan bir saate kadar
  (declaration-irr-stale-red · nbd-green · nbd-red · nbd-s0a-red · data-zero)
öncesi ve sonrası          normal · beş vakanın SONUCU beklendiği gibi, DEĞİŞMEDİ
```
⛔ **Sebep yazılmadı** (`DISIPLIN`: *"sayım farkı kaynağı gösterilmeden yorumlanamaz"* · `F14`).
**Aday — ölçülmedi:** aynı saatlerde code-reviewer'ın **eşzamanlı salt-okuma DB sorguları**. Zaman örtüşmesi bir **bağ değildir**.

**İkinci vakada:** `T-353`-emsali **çekişme ölçümü** — aynı vaka listesi **tek başına** ↔ **paralel okuma yükü altında**, süre
dağılımı karşılaştırılır. Fark ölçülürse `F14`'e kural; ölçülmezse aday düşer.

🔎 **Tetikleyici:** *"bir koşum beklenenden çok uzun sürdü — o sırada aynı DB'yi başka kim kullanıyordu?"*

---

## ⛔ GERİ TERFİ NASIL OLUR
```
1  maddenin İKİNCİ vakası ölçülür (tarih + ne olduğu)
2  DISIPLIN.md'deki stub'ı GÖVDEYE dönüşür, buradaki kayıt F12 iziyle KALIR
3  ailesi ve 🔎 tetikleyicisi yazılır
⛔ SİLME YOK — bu dosyadan bir madde ÇIKMAZ, yalnız DISIPLIN'de YENİDEN AÇILIR.
```
