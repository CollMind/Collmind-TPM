# `T-375` — e2e HİZALAMA (`R2`/`R3` sınıfı + kayıp ÜRETİCİ)

> Şerit: `qa-engineer` · Repo: `collmind.backend`
> ⛔ Bunlar **eski modeli ANLAMCA pinleyen** testlerdir. Model **hükümle** değişti
> (`Z102`, ürün sahibi 2026-09-07) — testler o hükme **hizalanır**, hüküm testlere değil.

## 0. Bağlam (⛔ önce oku)
`docs/brd-v2/04_KARAR_KAYDI.md` → **`Z102`** · `L2_01_*.md` → `K-2.2.1` · `K-2.2.3a` ·
`K-2.2.3b` · `.claude/backlog/tasks/T-375.md` · `CLAUDE.md` · `docs/DISIPLIN.md`

Ne değişti:
```
zarflar     8 kategori zarfı ACTIVE · channel NULL (tanımlı-wildcard) · period 2026-04
            eski ENV-2026-NKA-Q1/Q2 → CLOSED · TRAD/ECOM → silindi
CM-scope    category.manager2 → CAT-SAC-BOYASI (TEK)
            category.manager  → CAT-SET-BOYA · CAT-SEKILLENDIRICI · HAIR_CARE · CAT-KOPUK
            manager           → CAT-PEROKSIT · CAT-KARMA-KOLI · CAT-DIGER
            ⛔ eski çift-atama KALKTI (is_active=false)
anlaşma     categoryId ZORUNLU + FU↔kategori çapraz doğrulaması
```

Taban: `tsc 0 · guards 0 · unit 87 suite / 1537 test · e2e 7 suite / 32 test KIRMIZI`.
⛔ Ağaçtaki commit edilmemiş dosyalar **senin tabanın** — geri alma.

## 1 · `R3` — CM YENİDEN ATAMASI (en geniş kalem)

Kök neden **ölçüldü**: `category.manager@wella.com` ve `manager@wella.com`'un
`CAT-SAC-BOYASI` scope satırları artık `is_active = false`; o kategoriyi
`category.manager2@wella.com` kazandı.

Etkilenen (önceki elin ölçtüğü, ⛔ **YENİDEN ÖLÇ** — liste bayatlamış olabilir):
```
role-journey.e2e-spec.ts          A9c · A10 · A12 · A14-A19 · N3 · N3b · N4 · POZİTİF · G1-G5
optimistic-locking.e2e-spec.ts    2 alt-test
plan-escalate-to-finance.e2e-spec.ts
plan-review-decision.e2e-spec.ts
```
⚠️ Kapsam brief'in ilk tahmininden **geniş** çıktı (yalnız `E`/`E2` değil, `A` bölümü de).

**Nasıl hizalanır:** test **hangi kategoriyi kullanıyorsa O kategorinin CM'iyle** koşar.
⛔ **Testin İDDİASINI değiştirme** — yalnız *"bu kategoriye hangi CM bakıyor"* eşlemesini.
Bir testin iddiası gerçekten geçersizleştiyse **DUR ve bildir**, sessizce zayıflatma.

## 2 · `R2` — `budget-variance.e2e-spec.ts`

İki ayrı sebep, **ayırt et**:
```
(a) CM testi   başlığı bile eski dünyayı yazıyor: "seed envelope categoryId=NULL"
               ⇒ CM artık kendi kategorisindeki zarfı GÖRÜYOR (beklenen [], gelen 1)
(b) ADMIN → 200 / "Sayısal doğruluk"
               ENV-2026-NKA-Q1 artık CLOSED ⇒ getBudgetVariance'ın ACTIVE-only filtresinden düşüyor
```
`(a)`: fail-closed scope'un **hâlâ** çalıştığını gösteren yeni bir kurulum gerekir —
CM'in **sahip OLMADIĞI** bir kategorinin zarfı. ⛔ Boş bir beklentiyi *"artık dolu"* diye
güncellemek `§2.7 #4`'tür: kanıt kurulumu, kanıtlanmak istenen boş durumu yok eder.
`(b)`: canlı bir zarfla değiştir; ⛔ tutarları **ölçerek** yaz.

## 3 · ⛔ `on-invoice-ledger-invariants` — TEAM LEAD TEŞHİSİ DÜZELTTİ

Önceki el bunu *"kaskadın gerçek davranış değişikliği, `INV-R-001`'e dokunan finansal bulgu"*
diye raporladı. **Ölçüm başka bir şey söylüyor** ve fark önemli:

```
testin ayırt ediciliği:  "envelope'u OLMAYAN bir KANAL" (DISTRIBUTOR) → ERROR dalı
yeni model:              kanal TANIMLI-WILDCARD ⇒ envelope'suz KANAL diye bir şey YOK
⇒ kusur kaskatta DEĞİL — INV-R-001'in İKİNCİ ÜYESİNİN ÜRETİCİSİ ÖLDÜ
```

> ### Bu, `Z91` sınıfıdır: **üye var, üretici yok.** Ve `§2.7 #6`: iki satır da `POSTED`
> ### çıkıyorsa test artık **ayırt etmiyor** — yeşile çevirmek onu KÖR yapar.

⛔ **Üreticiyi YENİDEN KUR, testi zayıflatma.** Aday (ölç ve doğrula): `ERROR` satırını
**2026 DIŞI** bir döneme al (ör. `2027-06`) — hiçbir zarf `2027%`'ye uymaz. Testin dosya
başındaki *"ayırt etme gücü"* bloğunu `F12` ile güncelle: eski gerekçe **silinmez**, yeni
üretici ve **neden değiştiği** yazılır.
⛔ **Reprodüksiyon-önce:** yeni üreticiyle `ERROR` dalının **gerçekten** koştuğunu gör
(satır `ERROR` **ve** `validation_errors` BOŞ DEĞİL) — yoksa dal yine ölçülmemiş olur.

📌 İlgili ama **senin işin değil**: `T-380` (yıl-LIKE fallback'in sessiz tie riski).

## 4 · `budget-envelope-split.e2e-spec.ts` `SP-E2E-09` — ÖNCÜLÜ GEÇERSİZ

*"kategori opsiyonel → hiç filtrelenmiyor"* testi: `GET /budget/status`'un `categoryId`'si
artık **zorunlu** ⇒ senaryo yapısal olarak **imkânsız**. Önceki el dokunmadı, koda yorum
düştü — **doğru yaptı**.

⛔ Testi **zorla yeşile çevirme** (`categoryId` eklemek iddiayı **değiştirir**). İki meşru yol:
```
(a) test SİLİNİR — ama ancak "bu yetenek artık YOK" KARARIYLA, ve gerekçesi dosyada kalır
(b) test DÖNÜŞTÜRÜLÜR — yeni sözleşmeyi pinler: categoryId eksikse AÇIK 400 (§2.5)
```
⛔ **TL görüşü `(b)`** — bir yetenek kaybolmuyor, bir sözleşme **sıkılaşıyor**; sıkılaşma
pinlenmezse geri gevşer. Ama seçim gerekçeli olmalı; `(a)` istiyorsan **DUR ve bildir**.

📌 ⛔ Ve bu testin çevresinde bir **canlı kusur** var, `T-379`: frontend
`GET /budget/status`'a **UUID** gönderiyor, backend **KOD** bekliyor. **Kapsamın dışı** —
ama yazacağın pin bu kusuru **yanlışlıkla meşrulaştırmasın**: pin, parametrenin *hangi
temsili* taşıdığını **açıkça** yazsın.

## 5 · ⛔ DUR / KURALLAR

- Üretim kodu **DEĞİŞTİRME**. Bir testin kırmızısı bir **üretim kusuruna** işaret ediyorsa
  **DUR ve bildir** — düzeltme.
- Bir testi yeşile çevirmenin **ayırt etme gücünü** yok edip etmediğini her seferinde sor
  (`§2.7 #6`). *"Yeşil"* bir hedef değil, bir **sonuç**tur.
- `mode-split`: `src/modules/modes/` altına **yeni dosya YOK**; `test/` altına konan yeni bir
  dosya `modes/`'a import ederse **YENİ REFERANS ihlali** doğar (ölçüldü, `Z102 §7`).
- İlk komut: `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**.
- Ölçüm **borusuz**: `cmd > log 2>&1; echo $?`.
- `docs/brd-v2/**` **YAZMA**. `git commit` / `git push` **YOK**.
- ⛔ **Rapor: SAYI değil, LİSTE** — hangi dosya, hangi alt-test, hangi sebep, ne yapıldı.

## 6 · Doğrulama
`npx tsc --noEmit` 0 · `npm test` 0 · `npm run test:e2e` **0** · `npm run guards` 0 ·
`[T-047 invariant]` satırı **birebir** raporda.
