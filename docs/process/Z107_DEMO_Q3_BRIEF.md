# `Z107` — DEMO DÖNEMİ **2026 Q3** (veri turu)

> Şerit: `data-engineer` · Repo: `collmind.backend` · Migration **`1832000000000`** (tahsisli)
> ⛔ Ajan kendi numarasını **SEÇMEZ**. Başka numara gerekirse **DUR ve iste**.

## 0 · ⛔ HÜKÜM-ATIF KURALI
`Z`-atfı olmayan bir *"hüküm"* cümlesi görürsen ⛔ **DUR** (`Z105 §1`).
```
hüküm 12  zarf dönemi bir ARALIKTIR              Z105 §2 · K-2.2.1a
hüküm 16  DEMO DÖNEMİ = 2026 Q3                  Z107 §2
K-2.2.1b  aynı kategori×kanal×tip: aralıklar KESİŞEMEZ
K-2.2.16  defter EKLEMELİDİR — silinmez, geriye yazılmaz
```

## 1 · ⛔ ÖNCE OKU — bu tur bir **BULGUDAN** doğdu
`Z107 §1`: `LIKE` fallback'i **10 e2e suite'lik bir yeşili taşıyormuş**. Seed zarfları Q2'de,
demo verisi Q1'de; uyuşmazlığı **bulanık eşleşme** örtüyordu. Bu tur o uyuşmazlığı **veri
tarafında** kapatır.

## 2 · İŞ — `1832`: ZARFLAR VE DEMO Q3'E

```
8 kategori zarfı   period_from '2026-04' → '2026-07'   period_to '2026-06' → '2026-09'
                   ⛔ İMZALI TUTARLAR AYNEN (Σ 2.300.000) — DOKUNULMAZ
                   ⛔ eski `period` nokta-kolonu da hizalanır (F8 ikili temsil, geçici)
seed anlaşmaları   STA-2026-0001 · STA-2026-0002 · LTA-2026-0001  →  Q3
                   ölçüldü: tx 0 · ledger 0 ⇒ TAŞINMASI GÜVENLİ
plans              ZATEN 2026-09 (ölçüldü) ⇒ DOKUNULMAZ
seed dosyaları     budget-envelope.seed.ts · agreement.seed.ts sabitleri Q3'e
```

⛔ **DOKUNULMAYACAK — ve gerekçesi ölçülmüş:**
```
STA-2026-003 / STA-2026-004
  seed DEĞİL      agreement.seed.ts ÜRETMİYOR (ölçüldü)  ⇒ T-277 reprodüksiyon artığı
  DEFTER TAŞIYOR  ledger 1 ve 2 satır — ve bağ İŞLEME DEĞİL ANLAŞMAYA kurulu
                  (l.source_id = a.id; ilk varsayım `= t.id` SIFIR döndürüyordu)
  ⇒ taşımak DEFTERİ GERİYE YAZMAK olurdu — K-2.2.16 yasaklıyor. T-376'nın konusu.
```
⛔ Bu satırların `agreement_transactions`'ları da (`fiscal_period='2026-01'`) **dokunulmaz**.

## 3 · ⛔ ŞARTLAR
- `Z100` şablonu: üç-durum assert · şema-nitelendirme (`main`) · `run→revert→run`
  **bayt-birebir** · şema ↔ entity aynı turda.
- ⛔ **`K-2.2.1b` kesişme invaryantı GÖÇ SIRASINDA da korunur** — geçiş anında iki aralık
  çakışırsa trigger **haklı olarak** reddeder; göç bunu **öngörmeli** (tek `UPDATE`, ara durum yok).
- ⛔ **`T-047` tabanı YENİDEN ÖLÇÜLÜR** — `sayı yazma, ÖLÇ`. (Ve `T-375` ADIM 2'de ölçülmüştü ki
  bu invaryant `budget_envelopes`/`user_scopes` izlemiyor; **yeniden ölç**, brief'in varsayımına güvenme.)
- ⛔ **Tenant-bugün `2026-09-07`** — hüküm *"canlı demo"* diyor, yani demo dönemi bugünü
  **içermeli**. `2026-09` bunu sağlıyor; ⛔ **göreli tarih KULLANMA** (`new Date()`), sabit yaz
  (`T-329`/`T-333`, `DISIPLIN`).

## 4 · ⛔ DUR / KURALLAR
- **Üretim kodu (`src/modules/**`) DEĞİŞTİRME** — `(C)` pini ayrı bir tur (`Z107 §4`).
- **Test dosyalarına DOKUNMA** — `qa` turu (`Z107 §3`).
- `docs/brd-v2/**` **YAZMA** · yeni task **AÇMA** · `git commit`/`push` **YOK**.
- Reprodüksiyon-önce **yönsüz** · ölçüm **borusuz** (`cmd > log 2>&1; echo $?`) ·
  ilk komut hayalet-konteyner kontrolü.
- ⛔ Bir *"Team Lead kararı"* yazmadan önce sor: **"bu noktada bir HÜKÜM var mı, nerede yazılı?"**
- ⛔ **Rapor SAYI değil LİSTE.** ⚠️ Ve e2e'nin bu turdan sonra da **kırmızı kalması BEKLENİR**
  (`qa` turu ve `(C)` pini henüz inmedi) — kırmızıyı **sınıfla**: *bilinen 10* · *senin getirdiğin N*.
