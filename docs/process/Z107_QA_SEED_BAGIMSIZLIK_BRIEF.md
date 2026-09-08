# `Z107 §3` — e2e: **SEED'DEN BAĞIMSIZLIK** (10 suite, hüküm 17)

> Şerit: `qa-engineer` · Repo: `collmind.backend`
> ⛔ Bu, dalgayı **yeşile döndüren** turdur. Hedef: `npm run test:e2e` **exit 0**.

## 0 · ⛔ HÜKÜM-ATIF KURALI
`Z`-atfı olmayan bir *"hüküm"* cümlesi görürsen ⛔ **DUR** (`Z105 §1`).
```
hüküm 16  DEMO DÖNEMİ = 2026 Q3                Z107 §2
hüküm 17  e2e SEED'DEN BAĞIMSIZ · göreli tarih YASAK   Z107 §3
hüküm 18  (C) pini — sessiz DRAFT öldü          Z107 §4   (İNDİ)
K-2.2.1a/b  aralık modeli + kesişme invaryantı
```

## 1 · Devraldığın durum (Team Lead bağımsız ölçtü)
```
tsc 0 · guards 0 · unit 87 suite/1547 test · T-047 PASS
e2e  10 suite / 59 test KIRMIZI — TEK kök neden Z107 §1
     (C) pini indi ve ÜSTÜNE SIFIR yeni kırmızı ekledi (ölçüldü, birebir aynı liste)
zarflar   2026-07 … 2026-09   ·   seed anlaşmaları Q3   ·   plans zaten 2026-09
```
Ağaçta `DALGA-B` + `Z107` veri turu + `(C)` pininin **commit edilmemiş** diff'i — **TABANIN**.

## 2 · İŞ — 10 SUITE, ⛔ **LİSTE** OLARAK SINIFLANIR

```
(i)  DÖNEM-SABİTİ olan          → sabit değişir (Q3'e)
(ii) SEED ZARFINA bağımlı olan  → ⛔ KENDİ ZARFINI KURAR, SABİT tarih, seed'den BAĞIMSIZ
```
Kırmızı suite'ler (⛔ **yeniden ölç**, liste bayatlamış olabilir):
```
optimistic-locking · role-journey · plan-escalate-to-finance · plan-review-decision
lta-parent-lifecycle-status-gate · q20-untouched-vs-partial-row-gate
settlement-budget-release · settlement · ledger-read-surface · reversal
```

⛔ **Her suite için sınıfını ve gerekçesini YAZ** — *"düzelttim"* yetmez; **hangi sınıf, neden**.

## 3 · ⛔ İKİ MUTLAK YASAK

```
1  GÖRELİ TARİH YASAK   new Date() · "bugün + N" · Date.now()          T-329 / T-333
   ⇒ fixture SABİT tarih taşır; testin sonucu KOŞTUĞU GÜNE bağlı olamaz
2  SEED'İN VERİ KARARINA BAĞLANMA
   ⇒ bir e2e, seed'in DÖNEM/TUTAR seçimine bağımlıysa bir DAVRANIŞI değil bir
     VERİ KARARINI pinliyordur — ve veri kararı değiştiği gün KOD DOĞRUYKEN kırmızı yanar
     (DISIPLIN: "SEED bir DEMO'dur, FIXTURE bir SÖZLEŞMEDİR")
```

## 4 · ⛔ VE BU TURUN YENİ KONTROLÜ: **İDDİA MI, GÖZLEM Mİ?**

Ölçülmüş vaka (`role-journey.e2e-spec.ts:1203-1204`, `A13`/`A13b`):
```ts
expect(res.status).not.toBe(403);   // ← testin GERÇEK niyeti: rol kontrolü
expect(res.status).toBe(404);       // ← ve buraya "şu an ne dönüyorsa" YAZILMIŞ
```
O `404`, nokta-sütunu aralıkmış gibi sorgulayan **kusurun SEMPTOMUYDU**. Kusur onarılınca
doğru davranış (`200`) **kırmızı** yandı.

> ### ⛔ **HER ASSERTION İÇİN SOR: bu bir İDDİA mı, yoksa bir GÖZLEM mi?**
> ### Bir gözlemi assertion'a yazmak, o **anı** bir **kurala** çevirir.

`A13`/`A13b`'de testin niyeti `not.toBe(403)`'tür. ⛔ Onu **koru**; durum kodunu artık
**gerçeğe** göre yaz ve **neden** değiştiğini yorumla belirt (`F12`: eski satırı silme, üstünü çiz).

## 5 · `SP-E2E-10` — Team Lead'in tahmini **ÖLÇÜMLE ÇÜRÜTÜLDÜ**

Brief'lerim *"`(C)` pini inince `SP-E2E-10` kırmızıya döner"* diyordu. `(C)` turu **ölçtü**:
**dönmedi** — `HTTP` hâlâ `200`, test yalnız `res.body.code`'a bakıyor ve o alan zaten yok.
18/18 geçiyor.
⛔ Ama `qa` turu ölçtü ki bu test **mekanizma olarak boşa koşuyor** (senaryosu yıl-`LIKE`
fallback'ine dayanıyordu, `LIKE` öldü). **Değerlendir ve karar ver:** adı/senaryosu bugünkü
davranışa göre **gözden geçirilsin mi**, yoksa **silinip** yerine `(C)` pininin kendi testi mi
konsun? ⛔ Ne yaparsan **gerekçesini yaz** — ve `§2.7 #6`: *yeşil olması, ayırt ettiği anlamına gelmez.*

## 6 · ⛔ DUR / KURALLAR
- **Üretim kodu DEĞİŞTİRME.** Bir kırmızı üretim kusuruna işaret ediyorsa **DUR ve bildir**.
- ⛔ Testi yeşile çevirmek için **hükmü gevşetme** — `K-2.2.1b` kesişmeyi yasaklıyor; test **uyar**.
- ⛔ **`collmind.frontend`'e DOKUNMA** — orada bilinen bir kusur var (`T-384`: `null` → `₺0`),
  **senin işin değil**, ama e2e'de karşına çıkarsa **adıyla an**.
- `mode-split`: `src/modules/modes/` altına **yeni dosya YOK**; `test/`'ten `modes/`'a **yeni
  referans** da ihlaldir (`Z102 §7`, ampirik).
- `docs/brd-v2/**` **YAZMA** · yeni task **AÇMA** · `git commit`/`push` **YOK**.
- Reprodüksiyon-önce · ölçüm **borusuz** (`cmd > log 2>&1; echo $?`) · ilk komut
  hayalet-konteyner kontrolü · belirsizlikte **DUR**.
- ⛔ **Rapor SAYI değil LİSTE**: her suite → **sınıfı**, **ne yaptığın**, **ayırt etme gücü
  korundu mu**.

## 7 · Hedef
`tsc 0` · `guards 0` · `npm test 0` · **`npm run test:e2e` exit 0 · 877/877** ·
`[T-047 invariant]` satırı **birebir**.
