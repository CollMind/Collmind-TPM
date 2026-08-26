# `B3` Kaza / İstisna Dalgası — brief ÖNERİSİ (onay bekler)

> **Tarih:** 2026-08-26 · **Hazırlayan:** Team Lead · **Statü:** ⏸️ **ONAY BEKLER**
> **Kaynak hüküm:** ürün sahibi, 2026-08-26 — *"kaza-dalgasının yükü büyüdü ve artık
> kendi brief'ini hak ediyor … hepsi satır-satır repro-pinli, tek review yüzeyi."*

Bu dalga **mekanik göç değildir.** Mekanik dalgaların sözleşmesi *"göç davranış
değiştirmez"*dir; buradaki **her kalem davranış değiştirir** ve her biri kendi
gerekçesiyle kayıtlıdır. `B3B1_DEVIR_BRIEF §3`'ün şartı: *"davranış-değiştiren kayıtlı
istisnalar sessizce modül dalgasına KARIŞMAZ."*

---

## 0 · ✅ `LTA` HÜKMÜ — **(b)**, ve önceki hükmün AÇIK GERİ ÇEKİLİŞİ

> **Ürün sahibi, 2026-08-26:** *"`(a)` benim hükmümdü **ama dayanağı öldü**."*

`(a)`'nın gerekçesi *"kardeş emsal"*di. Ölçüm o emsalin **kimlik değiştirdiğini**
gösterdi: `POST /agreements` bir emsal değil, **LTA'nın canlı yazma yolu**. Ve ölçüm
şartının **iki dalı da tetiklenmedi** — üçüncü bir durum çıktı:

```
form VAR ve PLANNER'a AÇIK   ama  POST /agreements'e gidiyor
frontend'in lta-agreements atfı   SIFIR   (poz.kontrol: aynı grep spend-calculation'ı buluyor)
```

⇒ Hizalama artık *"API'yi ekrana yetiştirmek"* değil, **tüketicisiz bir paralel yolu
genişletmek** olurdu — `Z21`-musluğu deseninin **rol hâli**. Ve geri-alma maliyeti:
**genişleme tek yönlü kapıdır, askı değil.**

### Şart 1 — meşruiyet sorusu ROTADAN BÜYÜK: bu bir ÇİFT-MODEL sorusudur

```
agreements(agreementType:LTA)        ↔   lta_agreements + lta_rates
                                          ve W4a/Z36'nın OKUMA rotaları İKİNCİ tabloyu okuyor
```

Yazma yolu sıfır tüketiciliyse **o tablo neyle doluyor?** Cevap *"seed-only"* ise bu bir
**`İlke 3` ihlali adayıdır** (*"verisi düzenlenemeyen kural fiilen koddur"* — mekanik-alanları
dersinin LTA hâli) ve `budget_allocations` deseninin **büyüğü** olabilir: **yarı-ölü paralel
model**.

⇒ Ölçüm turu yalnız *"yazma meşru mu"* değil, **"hangi model KANONİK"** sorusunu cevaplar
(`K-2.2.3` ailesi: aynı kavram, iki çözümleme). Üç kapıdan birine çıkar:

| kapı | ne |
|---|---|
| **kaldırma** | `T-289` deseni |
| **hizalama + kanonikleştirme** | yeni kayıtla |
| **bilinçli çift-model** | ⚠️ bunu seçmek **çok güçlü gerekçe** ister |

### Şart 2 — `K5` DALGADAN ÇIKAR

*"Sonda bekletmek"* yerine **çıkarılır**: kaza-dalgası **beş kalemle** kapanır, LTA ölçüm
turu **ayrı** akar.

> **Bir dalganın kapanışı, ürün-sahibi-bekleyen bir kalemle REHİN kalmaz** — `B3`'ün kendi
> ilkesi.

## 1 · Dalganın kapsamı (ürün sahibi hükmü)

| # | kalem | sınıf | statü |
|---|---|---|---|
| K1 | `Z20` daraltması (`GET /users`) | kayıtlı istisna | hazır |
| K2 | ledger-üçlüsü hizalaması | normalizasyon | hazır |
| K3 | `T-287` — iki ekranda rol-kapısı ↔ rota-kümesi ayrışması (**canlı `403`**) | canlı kusur | hazır |
| K4 | `SHARED_READ`'in dört istisnası — **ÜÇ PARÇAYA ayrıldı** | aşağı bkz. | ✅ hükümlü |
| ~~K5~~ | ~~`LTA` dörtlüsü~~ | — | ⛔ **DALGADAN ÇIKTI** (`§0` Şart 2) |
| K6 | `T-289` — `POST /budget/reserve` **kaldırılması** | uç kaldırma | hazır |

---

## 1.5 · `K4` HÜKMÜ — dört istisna ÜÇ PARÇA, hepsi bu dalgada DEĞİL

| istisna | hüküm |
|---|---|
| `approvals` · `approvals/pending` | **`APPROVAL_QUEUE_READ`** hücresine göçer (`'approval-queue:read'`, ad Team Lead tahsisi — sınıf-adı). Küme `{A,CM,F,RO}` **birebir** ⇒ davranış-koruyucu. `PLANNER`'sızlık artık **cümleli**: onaycı yüzeyi. `W4a-S3`'ün pini **zaten üstünde** ve hücrenin **negatif yarısı var** |
| `spend-calculation/validate-budget/:planId` | **tabana hizalama (`+FINANCE`)**, kayıtlı istisna olarak **bu dalgada**. `FINANCE`-eksikliği bir **kaza** (spend-calculation kardeşlerinin **tamamı** `5/5`), ve cümle **yazılabiliyor**: eşik-üstü onaycının gönderim-öncesi bütçe kontrolünü okuması `K-2.6.4`'ün **kendi işi**. **Repro-pin:** `FINANCE` bugün `403` → sonra `200`, **kardeşler değişmedi** |
| `finance-reporting/budget-variance` | **`SUMMARY_READ` paketine DEVREDİLİR.** `finance-reporting` ailesinin küme-gerekçe taraması hâlâ açıkken tek aile-üyesini ayrı çözmek **yarım muamele** (`İlke 4`). Bu satıra **devir notu** düşülür |

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

### ✅ `K6(b)` KAPISI KOŞTU — sonuç: **SIFIR** (2026-08-26)

> Ürün sahibi güçlendirmesi **(i)**: *"sonuç sıfırsa da rapora yazılır — **'satır yok'
> bir ÖLÇÜMDÜR**, sessiz geçilmez."*

```
budget_transactions             6 satır
tx_type=RESERVE                 4     ·  hepsi source_type=AGREEMENT  ·  YETİM: 0
   poz.kontrol: agreements 5 satır (LEFT JOIN+IS NULL bir YOKLUK testi DEĞİLDİR)

08-19 ×2   4-segment anahtar · 75000 · "…for STA-2026-0002"  → SEED (birebir)
08-24 ×2   3-segment anahtar                                 → reserveForAgreement
           ve o yol KANONİK: agreement.service.ts:750, anlaşma ONAYINDAN çağrılıyor
```

⇒ **`POST /budget/reserve` ile doğmuş satır: SIFIR.** `ADR-0012` devreye girmiyor,
`(c)`'ye geçilir.

📌 **Ve kapı bir şey daha ölçtü:** kanonik motor **canlı ve sağlıklı** — `K-2.2.4`'ün
tetikleyicisi çalışıyor. Bu, *"paralel ikinci yol"* teşhisini **doğruluyor**.

⛔ **Ve bir ZAAF kaydı:** `reserveBudget`'ın `idempotency_key` şekli **seed'inkiyle
BİREBİR AYNI** (`RESERVE|AGREEMENT|{agreementId}|{envelopeId}`). Yani uç kullanılsaydı
satırları **seed satırlarından ayırt edilemezdi**; bu turda ayrım `amount` +
`description` eşleşmesinden geldi, anahtardan değil. Köken imzası **tasarım gereği
ayırt edici olmalı** — kaldırma bu zaafı da kapatıyor.

⚠️ **Ölçüm hatası kaydı:** ilk sorgu `left(idempotency_key,60)` kullanıyordu ve
anahtarları **kesiyordu** — *"seed dört, uç üç segment"* diye **ters bir ayrım** üretti.
Kesmeden ölçünce ayrım **tersine döndü**. `DISIPLIN`: kanıt kurulumunun kendisi
ölçtüğün şeyi bozabilir.

---

## 3 · Dalganın sözleşmesi

- **Satır-satır repro-pin.** Her kalem kendi pinini getirir; *"aynı dalgada oldu"* bir
  gerekçe değildir.
- **Tek review yüzeyi** — altı kalem tek `code-reviewer` turunda.
- ⛔ **`W4a`'nın dersi burada da geçerli:** pin'in ayırt etme gücü hücrenin **negatif
  yarısı** olmasına bağlı. `5/5` kalemlerde dedektör `route-scope.sh` `FILTRESIZ`.
- ⛔ **PİNLER YÖN-AÇIK** (güçlendirme **ii**): bu dalgada **iki ZIT YÖNLÜ** istisna var,
  pinler karışmasın —
  ```
  K1  Z20 daraltması        FINANCE → 403     (DARALTMA görülür)
  K2  ledger-üçlüsü         PLANNER → 200     (GENİŞLEME görülür)
  K4  validate-budget       FINANCE → 200     (GENİŞLEME görülür; kardeşler DEĞİŞMEDİ)
  ```
- **Sabitlik satırı** her kalemde ayrı — bu dalga rota **sayısını da değiştirir**
  (`K6` bir ucu siler), yani `211` sabiti **kırılır** ve yeni sabit **gerekçesiyle**
  doğar (güçlendirme **iii**).

  📌 `211`'in tarihçesi rota-envanteri değişimlerinin kaydı olarak **zaten üç kez**
  işledi (`238 → 223 → 211`); dördüncüsü de **aynı biçimde**.

---

## 4 · Önerilen sıra

```
1  K6(b) defter taraması   ✅ KOŞTU — SIFIR, kapı AÇIK
2  K6(a) repro-pin
3  K3 (canlı 403 — kullanıcı bugün etkileniyor)
4  K1 · K2 (kayıtlı istisna + normalizasyon)
5  K6(c)(d) kaldırma + tek-yol pini
6  K4 (üç parça: göç · hizalama · devir)
```

`K3` öne alındı çünkü **bugün kullanıcı etkileniyor**; `K6(a)(b)` en başta çünkü
sonucu dalganın kapsamını değiştirebilir.


---

## ⛔ DALGANIN BÜYÜMESİ — ve DURMA NOKTASI (ürün sahibi, 2026-08-26)

Bu dalga **planlandığından geniş** akıyor ve bu **kayda geçer**:

```
K3 açıldı        "canlı 403'leri kapat"
K3 kapandı       üç 403 kapandı
                 ⇓ ve reviewer kapsam-dışı bir 500 buldu
T-294 açıldı     "K3'ün KORUDUĞU widget sunucuda kırık"
T-294 kapandı    500 + 400 kapandı (aynı kökten)
                 ⇓ ve reviewer AYNI DOSYADA iki kardeş buldu
T-296 açıldı     iki 400 daha
```

> **Ürün sahibi:** *"Bu zincirin üçüncü halkasındayız — her düzeltme komşusunda yeni
> bir kırık buldu ve 'dalga temiz kapansın' gerekçesi her seferinde bir adım daha
> genişledi. **Meşru bir zincir ama sınırsız değil**; triyaj eşiğimizin tam sınıfı."*

### Durma noktası — ve ÖN-ÖLÇÜMLE KAPATILDI

`T-296`'nın kapsamı **üç uç-özel DTO + pinler**. Review yine kardeş bulursa **task
olur, dalgaya girmez**.

Ve zincirin sınırı **tahmin edilmedi, ölçüldü** (Team Lead, `T-296` brief şartı —
*"senin `§7.1` açığının bu kez BAŞTAN kapanmış hâli"*):

```
finance-reporting.controller.ts
  13 @Query toplam  =  10 DTO'lu (sağlam)  +  2 ÇIPLAK  +  1 yorum
  ÇIPLAK KALAN:  granularity · comparisonType
  üçüncüsü months → T-294'te kapandı
```

⇒ **Envanter ÜÇ. `T-296` sınıfın tamamını kapatıyor ve zincir DOĞAL OLARAK bitiyor.**

### Kapanış tanımı — DÜZELTİLDİ

⛔ Dalganın kapanışı **şu değildir**: *"`finance-reporting`'in bilinen-kırık envanteri
sıfır."*

✅ **Şudur:**
> **`K3`'ün dokunduğu yüzeyde bilinen-kırık SIFIR + kalanı ADRESLİ.**

📌 Fark önemli: birincisi **bitmeyen** bir taahhüt (her tarama yeni bir şey bulur),
ikincisi **ölçülebilir** bir taahhüt.


---

## ⛔ KAPANIŞ RAPORUNUN EK ŞARTI — istisna-atıf taraması

> **Ürün sahibi, 2026-08-26:** *"Bu dalganın kaldırdığı/değiştirdiği **her istisna**
> için, ona **atıf veren** karar/brief satırlarının taraması."*

**Gerekçe — üç vakalık desen:**

| vaka | boşa düşen gerekçe |
|---|---|
| `Z21`-POST | *"e2e göçünce koşul karşılandı"* — **kimse dönüp bakmadı** |
| `Z37`-LTA | *"kardeş emsal"* — emsal ölçümde **kimlik değiştirdi** |
| `T-297` | *"göçürmek `FINANCE`'ı düşürürdü"* — `K1` `FINANCE`'ı **zaten düşürdü** |

⇒ `OPEN_DECISIONS` mekanizmasının **ters yönü**:

```
ileri yön   koşul GERÇEKLEŞİNCE   →  bekleyen iş AÇILIR
geri yön    istisna KALKINCA      →  istisnaya YASLANAN kararlar YENİDEN OKUNUR
```

**Tek `grep` sınıfı iş** — ve `E6`'nın **karar-katmanı** hâli. Bu dalgada kalkan
istisnalar: `Z20` (`K1`) · ledger-üçlüsü kısıtı (`K2`) · `T-289` ucu (`K6`) ·
`SHARED_READ` istisnaları (`K4`).
