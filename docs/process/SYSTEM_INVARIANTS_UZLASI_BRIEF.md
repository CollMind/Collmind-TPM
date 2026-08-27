# `SYSTEM_INVARIANTS` — UZLAŞI TURU · BRIEF

**Tarih:** 2026-08-27 · **Tetikleyici:** `ADIM 5` (`RLS`) planlamasının açılışı
**Dayanak:** karantina damgası `2026-08-24` (ürün sahibi onaylı), **yol maddesi 2**

> ## Bu tur, bir sorunun kapanışıdır
>
> Oturum şu soruyla açılmıştı: ***"`contracts` altında bir dosyamız var, güncel mi?"***
> Cevap: **bayattı, damgalandı, bekledi.** Bugün `RLS` turunun **girdi envanteri**
> olarak işe dönüyor ve uzlaşıyla **kanonik statüye terfi ediyor.**
>
> 📌 **Belge silinseydi, bu tur onu SIFIRDAN İCAT EDECEKTİ.** *(`DISIPLIN`: "testler
> bir ŞARTNAMEDİR — kod silinse bile" — bunun **belge** tarafı.)*

---

## ⛔ ÖNCELİK: `INV-T` / YETKİ-KAPSAM AİLESİ **ÖNCE** — çünkü `RLS` paketinin GİRDİSİ

> **`RLS` karar paketi, bu bölüm bitmeden ürün sahibine GELMEZ.**

Damganın kendi tespiti: *"`INV-T` ailesi `ADIM-3` yetki katmanını (`K-2.6.13` DB
rolleri · kapsam zorlaması · capability modeli) **HİÇ TAŞIMIYOR**."*

### Eklenecek aile — üç invariant, üçü de **ölçülüp bağlanacak**

| invariant | bugünkü kanıt yüzeyi |
|---|---|
| **boş kapsam = erişim yok** | ⛔ **`A′`'nın KOD-KANITI VAR**: `CapabilityGuard` **default-deny**. *Yazılacak değil, **ÖLÇÜLÜP BAĞLANACAK**.* |
| **`SUMMARY_READ` kapsamsız doğamaz** | `Z32` üyelik ölçütü · `SUMMARY ∧ A1 = 10` (bugün **açık borç**, `T-304 DİLİM-1`) |
| **negatif kullanılabilirlik** | ⛔ **test YOK**, `budget_envelopes`'ta CHECK **YOK** (`ADIM3 §3.5`, poz. kontrollü) |

⇒ Üçü de **statü satırı DEĞİL, KANIT YÜZEYİ** ile yazılır: *"guard mı, test mi, DB
constraint mi, hiçbiri mi"* — ve **hiçbiri**yse **o da bir statüdür**.

---

## Turun geri kalanı — `RLS`'i **BLOKLAMAZ**, kendi hızında iner

1. **Tüm `Status:` satırlarının bugünkü gerçekle çakıştırılması.** Damga bilinen
   bayatları **örnekleme** olarak sayıyor — **tam liste değil**. ⛔ Her satır **tek
   tek** ölçülür; *"örnekleme"* kelimesi bir **uyarıdır**, bir kapsam değil.
2. `INV-C` ↔ **ilk-deploy ön koşulları** çapraz referansı
   *(o listeye `2026-08-27`'de bir satır daha girdi: **guard-tanıma yükleminin
   minification-dayanıklılığı** — `FAZ1_PLAN §0.2`)*
3. `§12` **Adoption** koşullarının yeniden değerlendirilmesi
   *(⚠️ `§12` registry notu bayat: karar defteri **bu repoda**, `TTM`'de değil)*

## ⛔ KALICI MEKANİZMA — damganın yol maddesi 3, bu turda KARARLAŞTIRILIR

```
GUARD SCRIPT'li statüler  →  GUARD ÇIKTISINDAN TÜRETİLİR
elle kalanlar             →  Z-kaydının "etkilenen türev belgeler" alanına BAĞLANIR
```

> 📌 Bu, `DISIPLIN`'in **evren-kaynağı hiyerarşisinin** (`türetilmiş > taranmış >
> yazılmış`) **belge tarafıdır**. Bir statü elle yazıldığı sürece **bayatlar** — bu
> repoda ölçülmüş oran **dokuzda dokuz**.
>
> ⛔ Ve `ADIM 3`'ün mühür yasası burada da geçerli: **bir statünün üç meşru değeri
> vardır — `sağlanıyor` · `sağlanmıyor` · `ÖLÇÜLMEDİ`.** *"Bilinmiyor"u
> `sağlanıyor`a yuvarlamak, sessiz-yeşilin belge hâlidir.*

---

# ⛔ DOĞRULAMA İZOLASYONU BEYANI (`T-269 ∥ T-270` usulü)

```
YÖN TEK:  bu tur SYSTEM_INVARIANTS'a YAZAR · RLS turu ORADAN OKUR
⇒ RLS turu bu dosyaya DOKUNMAZ; bu tur RLS turunun ölçüm dosyalarına DOKUNMAZ

Doğrulama izole bir git worktree'de; paylaşılan ağaçta --fix / mutasyon /
git checkout YOK.
```

⚠️ Ve `F12`: **hiçbir bayat satır SİLİNMEZ** — üstüne *"revize edildi (tarih, gerekçe,
çürüten ölçüm)"* yazılır. Damga da **silinmez**; uzlaşı kapanınca **statüsü değişir**.
