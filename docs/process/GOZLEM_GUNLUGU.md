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

---

## ⛔ GERİ TERFİ NASIL OLUR
```
1  maddenin İKİNCİ vakası ölçülür (tarih + ne olduğu)
2  DISIPLIN.md'deki stub'ı GÖVDEYE dönüşür, buradaki kayıt F12 iziyle KALIR
3  ailesi ve 🔎 tetikleyicisi yazılır
⛔ SİLME YOK — bu dosyadan bir madde ÇIKMAZ, yalnız DISIPLIN'de YENİDEN AÇILIR.
```
