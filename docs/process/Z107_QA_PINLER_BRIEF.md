# `Z107` — **PİNLER**: bu dalganın iddialarını guard'a bağla

> Şerit: `qa-engineer` · Repo: `collmind.backend`
> ⛔ Review'ın push için istediği **son** madde: *"bu turun HİÇBİR yeni davranışının testi yok —
> reprodüksiyon iddialarının koddaki karşılığı YOK."*

## 0 · ⛔ Neden bu tur var
```
grep -rn "METADATA_DIMENSION_FORBIDDEN|OVERCOMMITTED|CONTRACT_VIOLATION|ENVELOPE_NOT_FOUND|period_from" test/
  → yalnız bir YORUM satırı + bir fixture sorgusu.  BAŞKA HİÇBİR EŞLEŞME.
```
Yani `1547` unit + `877` e2e **yeşil**, ama bu dalganın **hiçbir** iddiasını ölçmüyor.
⛔ Ve blocker-2 **tam bu boşluktan geçti**: bir kapı konuldu, canlı bir üretim yolunu `400`'e
çeviriyordu, ve **hiçbir test görmedi** (tek unit testi `createEnvelope`'u **mock'luyor**,
e2e kapsamı **sıfır**).
📌 `DISIPLIN`: *bağlayıcı koşul bir guard'a bağlanır; bağlanamıyorsa "tavsiye"ye düşer.*

## 1 · Devraldığın durum
Ağaçta dalganın **commit edilmemiş** diff'i — **TABANIN**, geri alma.
Team Lead ölçtü: `tsc 0 · guards 0 · unit 87/1547 · e2e 64/877 EXIT 0 · T-047 PASS`.
⇒ **Her şey yeşil; kırdığın her şey senin.**

## 2 · DÖRT PİN — her biri ⛔ **AYIRT EDİCİ** olmalı

```
P1  autoCreateBudget = true          ⛔ BUGÜN SIFIR e2e KAPSAMI — canlı rota, hiç test yok
    POST /plans/:id/approve { autoCreateBudget: true }  → zarf YARATILIR ve onay GEÇER
    ⛔ ve yaratılan zarfın `channel` ADANMIŞ KOLONDA olduğu doğrulanır (metadata'da DEĞİL)
       — blocker-2 tam bu asimetriyi kapattı, pin onu KORUR
P2  metadata-boyut reddi              POST /budget/envelopes { metadata: { channel: 'X' } }
                                      → 400 BUDGET_ENVELOPE_METADATA_DIMENSION_FORBIDDEN
    ⛔ pozitif kontrol: metadata { autoCreated: true } (BOYUT DEĞİL) → KABUL
       (yoksa pin "metadata'yı tamamen yasakladık" der ve YANLIŞ olur)
P3  kesişme reddi (K-2.2.1b)          aynı kategori+kanal+tip, KESİŞEN aralık → REDDEDİLİR
    ⛔ pozitif kontrol: KESİŞMEYEN aralık → KABUL · ve K-2.2.2 ON/OFF İKİZİ → KABUL
       (ikincisi bir GERİLEME kapısı: önceki turda 21 test kırılmıştı)
P4  "zarf yok" politikası             GET /budget/status (zarfsız dönem/kategori)
                                      → 200 + status ENVELOPE_NOT_FOUND + sayılar null
    ⛔ ve pin GREEN dönerse KIRMIZI vermeli (§2.7 #6)
```

⛔ **Her pin için mutasyon:** korumayı kapat → pin **kırmızı** olmalı, ve kırmızı bir
**assertion** olmalı (derleme/çalıştırma hatası **başarısız bir deneydir**).
Mutasyon: kopya → uygula → **değiştirilen satırı `sed -n '<n>p'` ile BAS** → ölç → kopyadan
geri yükle → `shasum -a 256 -c`. ⛔ `git checkout` **YASAK**.

## 3 · ⛔ DUR / KURALLAR
- **Üretim kodu DEĞİŞTİRME** (mutasyon hariç, ve o geri alınır). Kırmızı bir üretim kusuruna
  işaret ediyorsa **DUR ve bildir**.
- `mode-split`: `src/modules/modes/` altına **yeni dosya YOK**; `test/`'ten `modes/`'a **yeni
  referans** da ihlaldir (`Z102 §7`, ampirik) ⇒ `test/` altında **HTTP rotası** üzerinden çalış,
  mevcut kardeş dosyalara ekleme tercih edilir.
- ⛔ **`T-047` sızıntısı:** kurduğun her satır **temizlenir**; teardown'ın `E2E-FIX-%` deseni
  var, ⛔ **ona güvenme — kendi fixture'ının kaderini ÖLÇ** (`budget_envelopes` önce/sonra).
- ⛔ **Ölçüm izolasyonu:** `migration:revert`/`run` ile `test:e2e`'yi **AYNI ANDA koşturma**
  (paylaşılan DB — bir tur bu yüzden `18 suite/89 test` **sahte kırmızı** ölçtü).
- `docs/brd-v2/**` **YAZMA** · `collmind.frontend`'e **DOKUNMA** · yeni task **AÇMA** ·
  `git commit`/`push` **YOK** · ölçüm **borusuz** · ilk komut hayalet-konteyner kontrolü.
- ⛔ Hedef: `tsc 0 · guards 0 · npm test 0 · npm run test:e2e 0` — ⛔ **ve toplam test sayısı
  ARTMIŞ olmalı** (dört yeni pin); artmadıysa pinler koşmuyor demektir.
- ⛔ **Rapor SAYI değil LİSTE**: her pin → ne ölçtüğü, mutasyon kanıtı (basılmış satır +
  assertion mesajı + geri yükleme `shasum`'ı).
