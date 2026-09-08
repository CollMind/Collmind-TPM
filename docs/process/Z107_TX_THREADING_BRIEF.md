# `Z107` — `findEnvelopeByDimensions` **TRANSACTION'A GİRMİYOR** (`P1` pininin bulduğu kusur)

> Şerit: `backend-engineer` · Repo: `collmind.backend` · ⛔ Push'tan önceki **son** blocker.

## 0 · Kusur — ve kanıtı kendi dosyasında

```
budget.repository.ts — `manager?: EntityManager` kabul eden metot:   SEKİZ
                       (:87 · :111 · :423 · :437 · :503 · :525 · :542 · :561)
findEnvelopeByDimensions  (MERKEZİ ÇÖZÜMLEYİCİ, :159)                 YOK   ⛔
```
⇒ Transaction-threading konvansiyonu **dosyanın her yerinde var**; **tek istisna
çözümleyicinin kendisi**.

**Zincir (`qa` izledi, Team Lead doğruladı):**
```
plan.service.ts  approve + autoCreateBudget=true (UNSPLIT dal)
  → budgetService.createEnvelope(..., queryRunner.manager)     ✓ transaction İÇİNDE yazar
  → commitAllReservedForPlan(..., manager)
     sıfır-spend plan ⇒ hiç RESERVE yok ⇒ candidateBucketKeys.size === 0
  → commitReservedForPlan(fallbackAmount=0, ..., 'TOTAL', manager)
  → budget.service.ts:942  findEnvelopeByDimensions(...)        ⛔ manager VERİLMEDEN
  → repository varsayılan (transaction-DIŞI) bağlantı ⇒ commit edilmemiş satırı GÖREMEZ
  → null ⇒ "No active budget envelope found" ⇒ ROLLBACK ⇒ zarf da silinir ⇒ 400
```

> ### ⛔ Ve bu kusuru **TESTİN YOKLUĞU** örtüyordu: `autoCreateBudget`'ın e2e kapsamı **sıfırdı**,
> ### tek unit testi `createEnvelope`'u **mock'luyordu**. Kapsam açılır açılmaz kusur çıktı.

## 1 · İŞ — `manager` threading'i, ⛔ **KARDEŞ YOLLAR SAYILARAK**

1. `findEnvelopeByDimensions`'a `manager?: EntityManager` — **kardeş sekiz metodun
   imzasıyla AYNI konumda ve AYNI adla** (`§2.7 #8`: ikinci bir konvansiyon yaratma).
   ⛔ `resolveEnvelopeForChannelStage` / `buildDimensionQuery` zincirine **sonuna kadar** geç.
   ⛔ `findEnvelopeByDimensionsStrict` de **aynı** zincirden geçiyor — o da almalı.
2. ⛔ **`§7.1` — LİSTE:** `findEnvelopeByDimensions`/`...Strict`'in **transaction İÇİNDE**
   koşan **her** çağrı yerini **ölç ve say**. `commitReservedForPlan`'ın fallback'i **bir**
   tanesi; *"aynı transaction'da yaratıp hemen okuyan"* başka yol var mı?
   Her çağrı yeri için: **transaction içinde mi** · **manager geçiyor mu** · **geçmiyorsa NEDEN
   meşru** (gerekçesi ölçümle).
   ⛔ *"Kardeş yol etkilenmiyor"* iddiası **ölçülmeden yazılamaz** — bu dalga o kuralı **yedi kez**
   ihlal etti.
3. `budget.service.ts:942` fallback'i `manager`'ı **geçer**.

## 2 · ⛔ REPRODÜKSİYON-ÖNCE (yönsüz)
Kırmızı pin **zaten var**: `test/plan-review-decision.e2e-spec.ts` → `AYIRT EDİCİ 4 (Z107 P1)`
pozitif testi. ⛔ **Önce onu koş ve KIRMIZI GÖR**, sonra düzelt, sonra **YEŞİL GÖR**.
⛔ Testi **değiştirme** — o `qa`'nın ve **doğru davranışı** iddia ediyor.

## 3 · 🟡 Aynı turda, ucuz
`P3`'ün HTTP şekli **`500`**: Postgres `23P01` (kesişme trigger'ı) hiçbir yerde `4xx`'e
çevrilmiyor (`grep -rn "23P01" src/` → yalnız migration). ⇒ Kısıt ihlali kullanıcıya
**sunucu hatası** gibi görünüyor. ⛔ Bir `4xx` + **kod** ile şekillendir (`K-2.2.14`'ün
*"bildirilmiş politika"* dili) — ⛔ ve **yalnız bu kısıt** için, genel bir `QueryFailedError`
yakalayıcısı **yazma** (sessiz yutma riski).

## 4 · ⛔ DUR / KURALLAR
- **Test dosyalarına DOKUNMA** (`P1` pini `qa`'nın; kırmızı olması **beklenen**).
- `collmind.frontend`'e **DOKUNMA** · `docs/brd-v2/**` **YAZMA** · yeni task **AÇMA**.
- ⛔ **Migration numarası ALMA** — **DUR ve iste**.
- Mutasyonda kopya + satır **BAS** + `shasum` (⛔ `git checkout` yasak) · ölçüm **borusuz** ·
  ilk komut hayalet-konteyner kontrolü · ⛔ `migration:revert`/`run` ile `test:e2e`'yi
  **aynı anda koşturma** · `git commit`/`push` **YOK** · belirsizlikte **DUR**.
- ⛔ Hedef: `tsc 0 · guards 0 · npm test 0 · npm run test:e2e 0` — **887/887**
  (bugün `886/887`, tek kırmızı yukarıdaki `P1`).
- ⛔ **Rapor SAYI değil LİSTE.**
