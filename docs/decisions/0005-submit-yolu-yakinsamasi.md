# 0005 — Submit yolu yakınsaması: tipli on/off rezervasyon canlı `/submit`'e taşınır

**Tarih:** 2026-08-02
**Durum:** Kabul edildi (ürün sahibi)
**İlgili:** [[T-056]], [[T-019]], [[T-048]], [[T-053]], [[T-019b]], [[T-052]], [[T-034f]]
**Bağlam:** `docs/decisions/0004-on-off-invoice-zarf-kurallari.md`, `docs/analysis/0008-*`

---

## Bulgu (T-056 hazırlığında ölçüldü, 2026-08-02)

**On/off-invoice ayrımının tamamı, ürün UI'ının hiç çağırmadığı bir uçta yaşıyor.**

| | Canlı UI yolu | On/off makinesinin yolu |
|---|---|---|
| Endpoint | `POST /plans/:id/submit` | `POST /plans/:id/submit-for-approval` |
| Servis | `PlanService#submit` | `ApprovalWorkflowService#submitForApproval` |
| Rezervasyon | **TOTAL kova** — `plan.totalSpend` tek, ayrıştırılmamış tutar | **Tipli** — `ON_INVOICE` + `OFF_INVOICE` ayrı |
| Optimistic locking (T-034f) | **var** (`version` CAS) | **YOK** (imzada `version` parametresi yok) |
| Frontend'de kullanım | `plans.endpoints.ts:300` → `PlanDetailPage.tsx:107` | **hiç geçmiyor** (kaynakta sıfır referans) |

Sonuç: BRD'nin on/off ayrımı bugün **üründen erişilemez**. [[T-019]] Faz 1, [[T-048]], [[T-053]]
ve [[T-019b]] doğru ve gerekli işlerdi — makine UI o yola geçmeden önce zaten doğru olmalıydı —
ama **görünür ürün etkileri henüz sıfır**.

> Bu, oturumun ana temasının en üst seviyedeki tekrarı: *mekanizma var, ona giden yol yok.*
> Alt seviyede yedi kez görüldü ([[T-033]], [[T-036]], [[T-039]], [[T-046d]], [[T-048]],
> [[T-052]], [[T-053]]); bu, aynı desenin mimari ölçekteki hâli.

## Karar

**Tipli on/off rezervasyon, frontend'in zaten çağırdığı `/plans/:id/submit` yoluna taşınır.**
`/submit-for-approval` deprecate edilir. Tek submit yolu kalır.

## Gerekçe

1. **İki kanonik yolun ayrı evrilmesi bu oturumdaki hataların ana kaynağıydı.** [[T-052]]
   (taktikler yalnız bir yolda okunuyordu), [[T-053]] (reject→resubmit yalnız bir yolda
   kapsanıyordu) — ikisi de "iki yol, farklı davranış" sınıfı. Yakınsama bu sınıfı kökten kapatır.
2. **Optimistic locking korunur.** `/submit` T-034f'in `version` CAS'ını zaten yapıyor;
   frontend'i `/submit-for-approval`'a çevirmek onu **sessizce kaybettirirdi**.
3. **Frontend değişikliği gerekmez** — UI'ın çağırdığı uç aynı kalır, davranışı zenginleşir.

## Reddedilenler

- **Frontend `/submit-for-approval`'a geçsin:** o uçta version CAS yok; önce oraya optimistic
  locking eklenmesi, sonra `/submit`'in durum geçişi + audit davranışlarının tek tek eşlendiğinin
  doğrulanması gerekirdi. Daha çok iş, daha çok risk.
- **Yalnız savunmacı split-farkındalığı yapıp yakınsamayı ertelemek:** split üretimde
  kullanılabilir hale gelirdi ama iki submit yolu yaşamaya devam eder, aradaki fark yeni hata
  üretmeye açık kalırdı.

## Uygulama kısıtları (bağlayıcı)

- **Tek türetim noktası:** on/off ayrımı [[T-052]]'nin `SpendCalculationService#buildMechanicValues`
  zincirinden gelir. `shared/budget` bu kararı yeniden uygulamaz (tasarım 0008 §5.7).
- **T-034f `version` CAS'ı korunur** — submit'in mevcut optimistic locking davranışı bozulamaz.
- **ADR 0004 Karar 2 eki geçerli:** değerlendirme planın fiilen harcadığı tipler üzerinden;
  harcanan tiplerden biri aşıyorsa istek tümüyle reddedilir (kısmi rezervasyon YOK).
- **Geriye uyum:** UNSPLIT (bugünkü) boyutta davranış, idempotency key formatları ve mevcut
  ledger satırları bozulmamalı. `RESERVE|PLAN|<id>|<env>` TOTAL key formatının canlı satırları var.
- **[[T-053]] dersi:** teardown (RELEASE) tarafı da kova-farkındalı kalmalı; reject→resubmit
  döngüsü yeni yolda da test edilmeli.

## Bedeli

Canlı UI rotasına dokunuluyor — bu oturumda en riskli değişiklik sınıfı. Adım adım, her adımda
mutasyon kanıtı ve 3 ardışık reset'siz e2e koşumuyla gidilmeli. Önce mimari tasarım
(`docs/analysis/0009-*`), sonra implementasyon.

---

## Ek kararlar (ürün sahibi, 2026-08-02 — tasarım 0009 sonrası)

**K1 — `/submit-for-approval` iki aşamalı deprecate edilir.** T-056'da her iki uç **aynı
rezervasyon motorunu** çağırır (tek para yolu); endpoint yaşamaya devam eder, `Deprecation`
başlığı + log uyarısı alır. `A8c`/`A17` yerinde yeşil kalır, `/submit` üzerine ikizleri eklenir.
Endpoint kaldırma → [[T-058]].
*Gerekçe:* mimar ölçtü — iki uç **eşdeğer değil**; submit-for-approval bir **üst küme ön
doğrulama** koşuyor ve farklı hata sözleşmesi kullanıyor (200+`success:false` vs 400). Kaldırmayı
canlı rotaya dokunan adımla aynı commit'e koymak riski toplardı.

**K2 — `/submit` doğrulama üst kümesini ALMAZ.** Yakınsama yalnız **para yolunu** tekler;
`/submit`'in bugünkü doğrulaması aynen kalır.
*Gerekçe:* kullanıcının bugün submit edebildiği plan yarın da edebilmeli. Ek doğrulama ayrı bir
ürün kararıdır ve UI'da karşılığı hazırlanmadan yapılmamalı.

**K3 — Bayat 0/0 spend kolonları: gürültülü red.** Planın on/off kolonları hesaplanmamış (0/0) ama
`totalSpend > 0` ise submit **açık hata** ile reddedilir; kullanıcıya recalc tetiklemesi söylenir.
*Gerekçe:* sessizce 0 rezerve etmek bütçeyi eksik düşürür — bu oturumda yedi kez kovalanan "sessiz
sıfır" sınıfı. Submit anında yeniden hesaplama reddedildi: T-046a'nın 1746 ms'lik yüzeyini canlı
submit'e taşır ve rezerve edilen tutarı kullanıcının ekranda gördüğünden ayırır.
