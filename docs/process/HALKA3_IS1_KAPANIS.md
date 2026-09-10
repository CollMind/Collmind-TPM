# `HALKA-3` İŞ-1 KAPANIŞI — actuals-sözleşmesi: **TÜREV DÜŞTÜ, ÖLÜM KOŞULLU**
### Team Lead · 2026-09-10 · şerit: `architect` (salt-okunur) · brief: `docs/process/HALKA3_ACTUALS_SOZLESMESI_BRIEF.md`

> ## ⛔ BU BELGE BİR HÜKÜM DEĞİLDİR
> Şeridin ölçümü + Team Lead'in bağımsız doğrulaması + ürün sahibinden gereken kararların
> **listesi**. Hüküm `Z111`'in sahibindedir (`DISIPLIN F00`: *"ölçen taraf düzeltmesini
> hükme kendisi yazmaz"*).

---

## 1 · MANŞET

```
TÜREV   bugünkü şemayla AYAKTA DEĞİL — on_invoice_entries'in 8 NOT NULL kolonu
        (invoice_no · invoice_date · customer_id · sku_id · quantity · list_price ·
         actual_price · discount_type) uydurma ya da DAĞITIM olmadan dolamaz
ÖLÜM    DEFTER İHTİYACI açısından ayakta (amount · period · envelope · cpl · fu var;
        posting_date YOK) — ama DÖRT ürün kararına bağlı
⛔ EN AĞIR BULGU  Z-K3'ün "indirim actuals satırıyla gelir" hükmü KAYITSIZ bir sapma:
        K-2.13.14h6 "satış tablosunun indirim alanından DEĞİL" · INV-R-005 · T-209
```

---

## 2 · TEAM LEAD BAĞIMSIZ DOĞRULAMASI — karar üreten iddialar

| şerit iddiası | doğrulama | sonuç |
|---|---|---|
| `K-2.13.14h6` satış tablosunun indirim alanını **reddediyor** | `[ÖLÇÜLDÜ: sed -n '314,330p' L2_04_hakedis_ai_kurulum.md]` | ✅ TUTTU — *"gözlenen harcama kayıtlarından toplanır — satış tablosunun indirim alanından değil"* |
| bu sapma karar kaydında **yok** | `[ÖLÇÜLDÜ: grep -c -F "K-2.13.14h6" 04_KARAR_KAYDI.md → 0]` · pozitif kontrol `K-2.13.14` → 3 | ✅ TUTTU |
| `INV-R-005` açıkça devrilmeli | `[ÖLÇÜLDÜ: SYSTEM_INVARIANTS.md:725-730]` *"must explicitly overturn or reconcile"* | ✅ TUTTU |
| T-208 · T-209 açık | `[ÖLÇÜLDÜ: grep ^status: T-208.md T-209.md]` → `todo` · `todo` | ✅ TUTTU |
| on_invoice_entries NOT NULL kolonları | `[ÖLÇÜLDÜ: information_schema.columns … is_nullable='NO']` | ✅ TUTTU (+ `customer_code`/`sku_code` denormalize, türetilebilir) |
| kalıntı `gross−net−discount` Σ 63.000, 3/3 | `[ÖLÇÜLDÜ: SELECT gross_amount-net_amount-discount_amount FROM main.sales_actuals]` → 25000 · 20000 · 18000 | ✅ TUTTU — `K-2.13.14h6`'nın düzeltme notuyla **birebir** (`L2_04:322-325`) |
| anlaşma çakışması, biri APPROVED×APPROVED | `[ÖLÇÜLDÜ: agreements self-join, aynı tenant+CPL+FU, daterange &&]` | ✅ TUTTU — 3 çift; `STA-2026-003 × STA-2026-004` APPROVED×APPROVED (T-277 artığı, T-376) |
| ON_INVOICE anlaşma 0 | `[ÖLÇÜLDÜ: SELECT spend_type,count(*) FROM main.agreements]` → `OFF_INVOICE 5` | ✅ TUTTU |
| aktif müşterinin 2/29'u CPL'siz ⇒ ledger `cpl_id` sessiz NULL | `[ÖLÇÜLDÜ: customers ACTIVE ∧ deleted_at IS NULL, Wella Turkey]` → 29 · 2 · `[ÖLÇÜLDÜ: create-ledger-entry.dto.ts:68-75]` `cplId?`/`fuId?` | ✅ TUTTU — ⚠️ ilk sorgum `93\|66` verdi: **silinmiş 64 satırı sayıyordu** (araç: `\echo` içinde `'` psql'i bozdu) |
| red sözlüğünün tüketicisi yok | `[ÖLÇÜLDÜ: grep -rn -F SALES_ACTUALS_ROW_REJECTION_REASON src test]` → yalnız tanım `:107` | ✅ TUTTU |
| iade probe'u (R0–R8) | `[ÖLÇÜLDÜ: şeridin probe-return.ts'i yeniden koşuldu, NODE_PATH + ts-node transpile-only → exit 0]` | ✅ BİREBİR — R5 (net −) · R5b · R6 (discount −) · R7 (volume −) **sessiz kabul** |

⛔ **Doğrulanmayan:** `REPLACE → türetilmiş defter satırı çift sayım` (henüz kod yok — senaryo
çıkarımı, `[ÖLÇÜLMEDİ]`) · frontend (ii) widget'larının veri kaynağı · ham SQL yazar taraması
(tırnaklı tablo adı biçimi).

---

## 3 · ÜRÜN SAHİBİNDEN GEREKEN KARARLAR (şeridin K1–K6'sı, Team Lead sınıflamasıyla)

```
K1  ⛔ ENGELLEYİCİ — İNDİRİM KAYNAĞININ ANLAMI
    Z-K3 ↔ K-2.13.14h6 + INV-R-005 + T-209. discount_amount "ticari harcama DEĞİL" diye
    2026-08-13'te ÖLÇÜLDÜ ve BRD'ye yazıldı. Z111 bu kaydı ANMIYOR.
    ⇒ ya Z-K3 F12 (indirim ayrı bir kaynaktan — hangisi?)
       ya K-2.13.14h6 + INV-R-005 açıkça devrilir (gerekçesiyle, T-003/T-017 çift sayım tarihiyle)
    ⇒ K1 çözülmeden İŞ-2 (resolver hangi satırı okur) YAZILAMAZ
K2  ANLAŞMA BAĞI — actuals satırında taktik/anlaşma referansı YOK; anlaşma tekilliği YOK
    (a) Z-K1 tekilliği ON_INVOICE/BOTH anlaşmalara da  ·  (b) actuals'a agreement_code/taktik
    + gün-seviyeli anlaşma ↔ aylık actuals uyuşmazlığı
K3  posting_date — actuals'ta tarih yok, ledger'da NOT NULL
K4  ZARF BULUNAMAZSA — INV-R-001'in ERROR üyesi actuals'ta kalıcılaşacak yer yok (+ INV-B-006)
K5  REPLACE → türetilmiş defter satırlarının reversal'ı (INV-R-003/004)
K6  İADE — Z111 §11 Ö1 hükmü VAR (NEGATIVE_AMOUNT); ek bulgu aşağıda §4
```

---

## 4 · `§3.6` YORUMU — `Z111 §11 Ö1` + ürün sahibi notu (1)'e göre

```
gross < 0   R1 → INVALID_GROSS_AMOUNT (bugün)          ⇒ hüküm: NEGATIVE_AMOUNT (yeni kod, üreticisiyle)
okunamadı   R3/R4 → INVALID_GROSS_AMOUNT, DİNAMİK mesaj  ⇒ hüküm: yalnız "okunamadı" — bugün zaten ayrışıyor
gross = 0   R2 → INVALID_GROSS_AMOUNT
  İLK SORU  [ÖLÇÜLDÜ: SELECT count(*) FILTER (WHERE gross_amount=0) FROM main.sales_actuals] → 0/3
            [ÖLÇÜLDÜ: awk gross sütunu, seeds/data/actuals_2026-01.csv + -02.csv] → 0/3 (negatif de 0)
  ⇒ YOK ⇒ "kusur mu meşru mu" BUGÜN CEVAPSIZ ⇒ <= 0 reddi KORUMACI VARSAYIMLA DURUR
    (yanlışsa fazladan red, sessiz kabul değil) — hüküm ölçümden sonra
```
⚠️ **Mesajı nereye yazacağın önemli** (şerit ölçtü, doğrulandı):
```
statik sözlük (:107)     tüketicisi YOK ⇒ "kapsam dışı" yazılırsa abc/1.234/boş da "iade" olur — bugün GİZLİ
fallback dalı (:406-407) R1'i doğru yakalar ama R2'yi (gross 0) de "iade" diye etiketler
⇒ NEGATIVE_AMOUNT hükmü bu yüzden DOĞRU ŞEKİL: < 0 ile == 0 ayrı dala düşer
```
⛔ **Ek bulgu — hükmün kapsamadığı sessiz kabuller** (`§2.5`):
```
R5  gross +, net −50                 KABUL, uyarı yok      kaydedilen net = −50
R5b gross +, net −50, discount 150   KABUL, uyarı yok
R6  gross +, discount −10            KABUL, yalnız AMOUNT_RECONCILIATION uyarısı
R7  volume −5                        KABUL — volume HİÇ OKUNMUYOR, rawRow'da kalıyor
⇒ Z-K2 "iade satırı AÇIK RED" bugün yalnız gross'ta karşılanıyor
⇒ T-208 bu sınıfı kapsıyor ama BAYAT (2026-08-13 — o gün gross'ta da kontrol yoktu)
```

---

## 5 · ŞERİDİN AYRI §2.5 BULGUSU

```
on-invoice yolu: customer.cplId nullable · ledger DTO cplId?/fuId? opsiyonel
⇒ CPL'siz müşteriye (2/29 aktif) yazılan on-invoice satırı ledger'a cpl_id = NULL SESSİZCE düşer
⇒ bacak ÖLSE de TÜREV olsa da, yolun hangi hâli kalırsa kalsın açık hataya çevrilmeli
```

---

## 6 · BRIEF KUSURLARI — `F12` brief `§11`'de
`B1` etiketsiz/eksik grain satırı · `B2` 12-dosya listesi eksik (sembol ≠ yetenek, uyarının
**altında**) · `B3` invaryant evreni iki üyeyle sınırlıydı.

## 7 · ÜÇ METRİK
```
tur süresi   ~7 dk duvar saati (şerit `date` ölçümü) · ~14 dk ajan süresi (bildirim)
review-tur   0
DUR          turu durduran 0 · rapora çıkan karar noktası 6 · brief kusuru 3 (B1'de DUR yerine devam, kayıtlı)
```

## 8 · ⛔ NE ÖLÇÜLEMEDİ
```
· on-invoice anlaşma bağının CANLI davranışı — ON_INVOICE/BOTH anlaşma 0, LTA 0
· ham INSERT/UPDATE yazar taraması — tırnaklı "main"."on_invoice_entries" biçimi aranmadı
· frontend (ii) widget'larının bacaktan beslenip beslenmediği (ledger ON_INVOICE toplamları)
· EK_E / L1'de on-invoice yükleme YETENEĞİNİN satırı — ÖLÜM bir yeteneği haritadan düşürebilir
· ERROR üreticisinin (2027-06) actuals yüklemesinden geçip geçmediği
· REPLACE → çift sayım (senaryo çıkarımı, kod yok)
```
