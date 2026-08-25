# `B3` Kaza / İstisna Dalgası — brief ÖNERİSİ (onay bekler)

> **Tarih:** 2026-08-26 · **Hazırlayan:** Team Lead · **Statü:** ⏸️ **ONAY BEKLER**
> **Kaynak hüküm:** ürün sahibi, 2026-08-26 — *"kaza-dalgasının yükü büyüdü ve artık
> kendi brief'ini hak ediyor … hepsi satır-satır repro-pinli, tek review yüzeyi."*

Bu dalga **mekanik göç değildir.** Mekanik dalgaların sözleşmesi *"göç davranış
değiştirmez"*dir; buradaki **her kalem davranış değiştirir** ve her biri kendi
gerekçesiyle kayıtlıdır. `B3B1_DEVIR_BRIEF §3`'ün şartı: *"davranış-değiştiren kayıtlı
istisnalar sessizce modül dalgasına KARIŞMAZ."*

---

## 0 · ⛔ ÖNCE: bir hükmün DAYANAĞI ölçümle değişti — `LTA`

Ürün sahibi `LTA` dörtlüsü için hizalamayı (`{ADMIN}` → `{ADMIN,PLANNER}`) **bir ölçüm
şartına** bağladı:

> *"UI `PLANNER`'a LTA formu sunuyorsa hizalama `T-277`'nin ters yönlü kapanışıdır
> (API ekrana yetişir); sunmuyorsa genişleme ekransız iner."*

**Ölçüm iki dalın hiçbirini vermedi — üçüncü bir durum çıktı.**

```
LTA FORMU VAR ve PLANNER'A AÇIK        LTAAgreementForm.tsx
                                       AgreementsPage.tsx:280 (montaj)
                                       /agreements ekranı: ADMIN,PLANNER,CM,…

AMA FORM BU ROTALARA GİTMİYOR          onSubmit → handleCreate → useCreateAgreement
                                       → agreements.endpoints.ts:23
                                       → POST /agreements     ← lta-agreements DEĞİL

FRONTEND'İN lta-agreements ATFI        SIFIR
POZ.KONTROL                            aynı grep spend-calculation'ı buluyor (8 atıf)
```

### Ve altından ikinci bir şey çıktı: **İKİ AYRI LTA YAZMA YOLU, İKİ AYRI TABLO**

| yol | küme | yazdığı | frontend |
|---|---|---|---|
| `POST /agreements` | `{ADMIN,PLANNER}` | `agreements` (`agreementType: LTA`, *"LTA > 30 gün"* doğrulaması) | **CANLI** |
| `POST /lta-agreements` | `{ADMIN}` | `lta_agreements` + `lta_rates` | **atıf yok** |

📌 `CLAUDE.md §7`'nin adıyla saydığı desen: *"bu projede aynı yetenek birden çok kez
yazıldı: **iki submit yolu**, iki lumpsum dağıtım implementasyonu, iki CSV parser…"*

⚠️ **Ama bu `T-289` ile AYNI SINIF DEĞİL** — ve fark önemli:

```
T-289          paralel yazma yolu,  CANLI ekrandan tetiklenebilir,  denetimsiz musluk
LTA dörtlüsü   yazma yolu,          hiçbir ekrandan tetiklenmiyor,  "mekanizma var, yol yok"
```

Ve `lta_agreements` **ölü değil**: `W4a`'da göçen üç `GET` ve `Z36 §5`'in üç
hesap-okuma rotası o tabloyu **okuyor**.

### ⇒ Ürün sahibine giden soru (bu dalga başlamadan)

Hizalama hükmünün gerekçesi *"kardeş emsal + `K-2.6.4`'ün anlaşma-girişi okuması"*ydı —
ve kardeş emsal (`POST /agreements` `{A,P}`) artık **yalnız bir emsal değil, LTA'nın
CANLI yazma yolu** olarak ölçüldü. Üç seçenek:

| | ne | sonuç |
|---|---|---|
| **(a)** | hizalama **aynen** iner (`{A,P}`), ekransız | dörtlü genişler; ikinci yol **yaşamaya devam eder** ve genişlemiş olur |
| **(b)** | hizalama **askıya alınır**, önce *"`lta_agreements` yazma tarafı meşru mu?"* sorusu | `T-289`'un disiplinini bu dörtlüye de uygular (İlke 1: *"gerçek ihtiyaçsa kanıtıyla gelir"*) |
| **(c)** | `{ADMIN}` **korunur**, ama `Z18` gereği cümlesi yazılır | ölçüm cümlenin yazılamadığını söylüyordu (*"ticari sözleşme ≠ sistem tanımı"*) — bu yol **kapalı** görünüyor |

**Team Lead önerisi: (b).** Gerekçe — hizalama bir **genişlemedir**, ve tüketicisi
olmayan bir yazma yolunu genişletmek `§4.2`'nin *"üretim çağrı yolu var mı?"* maddesine
ters yönde bir hareket. `(a)` yanlış değil ama **geri alması `(b)`'den pahalı**: bir
kez `{A,P}` olduktan sonra daraltma davranış-değiştiren yeni bir kayıt ister.

---

## 1 · Dalganın kapsamı (ürün sahibi hükmü)

| # | kalem | sınıf | statü |
|---|---|---|---|
| K1 | `Z20` daraltması (`GET /users`) | kayıtlı istisna | hazır |
| K2 | ledger-üçlüsü hizalaması | normalizasyon | hazır |
| K3 | `T-287` — iki ekranda rol-kapısı ↔ rota-kümesi ayrışması (**canlı `403`**) | canlı kusur | hazır |
| K4 | `SHARED_READ`'in **dört istisnası** — çözüm | karar-bekler kalıntısı | ⏸️ küme kararı ister |
| K5 | `LTA` dörtlüsü hizalaması | genişleme | ⛔ **§0'a bağlı** |
| K6 | `T-289` — `POST /budget/reserve` **kaldırılması** | uç kaldırma | hazır |

---

## 2 · `K6` — `T-289` kaldırma disiplini (ürün sahibi sırası, DEĞİŞTİRİLMEZ)

> Hüküm: *"uç meşru değil — kaldırılır; bu bir rol kararı değil, `K-2.2.4`'ün savunması."*

```
(a) ÖNCE REPRO-PİN     uydurma agreementId ile POSTED satır üretilebildiği GÖRÜLÜR
                       ⛔ T-273: kusur ÖNCE görülmeli — "kusur var" da bir İDDİADIR
(b) DEFTER TARAMASI    bu yolla doğmuş satır VAR MI
                       varsa ADR-0012 geçerli: FİZİKSEL SİLME YOK, ele alınışı AYRI karar
(c) İKİ REPO TEK KAPANIŞ  uç + ReserveBudgetDialog BİRLİKTE ölür (T-277 deseni)
                       /budget ekranının kalanı requiredRole alır (T-287 ailesiyle)
(d) TEK YOL PİNİ       kanonik motorun (reserveTypedForPlan) tek yol kaldığı pinlenir
```

⚠️ `(b)` bir **kapıdır**, bir adım değil: satır bulunursa `(c)`'ye geçilmez, ürün
sahibine dönülür.

---

## 3 · Dalganın sözleşmesi

- **Satır-satır repro-pin.** Her kalem kendi pinini getirir; *"aynı dalgada oldu"* bir
  gerekçe değildir.
- **Tek review yüzeyi** — altı kalem tek `code-reviewer` turunda.
- ⛔ **`W4a`'nın dersi burada da geçerli:** pin'in ayırt etme gücü hücrenin **negatif
  yarısı** olmasına bağlı. `5/5` kalemlerde dedektör `route-scope.sh` `FILTRESIZ`.
- **Sabitlik satırı** her kalemde ayrı — bu dalga rota **sayısını da değiştirir**
  (`K6` bir ucu siler), yani `211` sabiti **kırılır** ve yeni sabit **gerekçesiyle**
  yazılır.

---

## 4 · Önerilen sıra

```
1  K6(a) repro-pin + K6(b) defter taraması   ← KAPI: satır varsa ürün sahibine
2  K3 (canlı 403 — kullanıcı bugün etkileniyor)
3  K1 · K2 (kayıtlı istisna + normalizasyon)
4  K6(c)(d) kaldırma + tek-yol pini
5  K4 · K5   ← ikisi de ürün sahibi kararı bekliyor, dalganın SONUNDA
```

`K3` öne alındı çünkü **bugün kullanıcı etkileniyor**; `K6(a)(b)` en başta çünkü
sonucu dalganın kapsamını değiştirebilir.
