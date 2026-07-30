# ADR 0003 — BRD NFR-1.2 "<500ms" kapsamı: uçtan uca süre

- **Tarih:** 2026-07-30
- **Durum:** Kabul edildi
- **Karar veren:** Ürün sahibi
- **Kanıt:** `docs/analysis/0006-recalc-performance-brd-scope.md`

## Karar
BRD NFR-1.2'nin `< 500ms` hedefi, **kullanıcının bir hücreye değer girmesinden güncellenmiş
KPI'ları görmesine kadar geçen toplam süre** olarak kabul edilir — tek formül değerlendirmesi
değil.

## Gerekçe (birebir alıntılar, Team Lead PDF'ten doğruladı)
- **NFR-1.2** "KPI calculation time < 500ms" — aynı tablodaki **Measurement Method** sütunu:
  **"Time from input change to UI update"**. (Sütun değerleri tablodan sonra blok halinde
  diziliyor ve sırayla NFR-1.1…1.7'ye karşılık geliyor; ikinci sıra NFR-1.2'dir.)
- **FR-3.1** kabul kriteri: *"Calculation completes within 500ms • All dependent KPIs updated •
  Results displayed with animation • Grand totals panel updated"* — hepsi aynı 500ms listesinde,
  yani ölçüm UI'a kadar.
- **"per formula" / "tek formül" nitelendirmesi hiçbir kaynakta geçmiyor.**
- Karşı kanıt yok; ayrıca NFR-2.5 ("10,000+ KPI calculations per second") ve FormulaParser hedefi
  ("100 formulas in <100ms") tek formülün 500ms olamayacağını gösteriyor.
- `KPI_Details.docx` daha da sıkı: "SKU volume update: <100ms", "FU tactic update: <300ms".

## Reddedilen yorum
[[T-034c]]'yi uygulayan ajan `<500ms`'i "tek formül değerlendirmesi" diye yorumlamıştı.
**Metinsel dayanağı yok.** Team Lead bu yorumu kabul etmedi ve kanıt toplattı; kanıt tek yönlü
çıktı. **Ders: BRD yorumu ürün sahibinin kararıdır, ajanın varsayımı değil.**

## Mevcut durum (ihlal)
| Senaryo | Süre |
|---|---|
| Tek recalc (52 SKU) | ~540-548 ms |
| İki eşzamanlı, farklı planlar | ~650-711 ms |
| İki eşzamanlı, aynı plan (T-034c advisory lock) | ~1035-1148 ms |

Ayrıca **NFR-1.4** ("API response time < 300ms p95") da aşılıyor.
Bu sapma T-034c'den **önce** de vardı (stash'li ölçüm) — yeni regresyon değil.
Bugün hiçbir eşik/telemetri enforce **edilmiyor**; 500ms'e atıf yapan 6 yer yalnızca yorum satırı.

## Sonuçlar
1. **Hemen:** ölçülmüş israfın temizlenmesi → [[T-045]] (~180-200 ms, düşük risk, BRD yorumundan
   bağımsız olarak zaten doğru).
2. **Sonra:** kalan fark ölçülür; gerekirse mimari değişiklik ayrı ele alınır → [[T-046]]
   (tek hücre düzenlemesi HTTP yanıtından önce senkron tam-plan recalc tetikliyor; BRD'nin
   kapsam içi ilan ettiği 500+ SKU'da bu ~10× olur).
3. Performans telemetrisi olmadan uyum iddia edilemez — T-046 kapsamında değerlendirilecek.
