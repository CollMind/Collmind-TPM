# OPEN_DECISIONS.md — açık kararların **indeksi**

> **Bu bir indekstir, bir kopya değil.** Hiçbir kararın içeriği burada yaşamaz; her satır
> kararın **tanımlı olduğu yeri** gösterir. Bir kararın gerekçesini, seçeneklerini ve
> ölçümünü okumak için **"Nerede tanımlı"** sütunundaki belgeye git.
>
> Kopyalanan her karar bir **ikinci doğruluk kaynağı** olur — `CLAUDE.md §7`'nin bu projede
> sekiz kez ölçülmüş sınıfı. Bu dosya o sınıfı **çözmek** için var, ona bir üye eklemek
> için değil.

- **Açıldı:** 2026-08-11
- **Kapsam:** ürün sahibi · hukuk · danışman · teknik ölçüm bekleyen **tüm** açık kararlar

---

## Neden açıldı — ölçülmüş iki gerekçe

### 1. Aynı karar iki yerde, birbirinden habersiz

`D-01` (*CAP exceedance behaviour*, `SYSTEM_INVARIANTS §10`) ile [[T-176]]'nın CAP maddesi
**aynı karardır**. İkisi ayrı turlarda, birbirine referans vermeden yazıldı.

> Bugün bir çakışma; yarın **ikisi ayrı cevaplanır ve ikisi de "verilmiş karar" sayılır.**

Bu oturumda o sınıfın sekiz vakası bulundu — **hepsi kodda**. Bu, **karar kayıtlarındaki**
ilki.

### 2. Kayıt yeri sessizce kaydı ve kimse fark etmedi

*"Danışman kuyruğu"* turu 1–19 arasında sekiz analiz belgesinde tutuldu. Sonra durdu:

```
tur 19'dan sonraki 19 belgede "danışman" → 0 geçiş
```

Tur 20+ kararları **task dosyalarına** dağıldı. Kimse bir şeyi silmedi; **tek bir yer
olmadığı için** kayıt yeri kaydı, ve bugün onları toplamak bir arama işi.

> **Kural:** yeni bir açık karar doğduğunda **buraya bir satır eklenir** — içeriği nerede
> yaşarsa yaşasın.

---

## `D-*` serisiyle ilişkisi — indeks onu **yutmaz**, işaret eder

`SYSTEM_INVARIANTS.md §10`'un başlığı kapsamını tanımlıyor: **"Open decisions blocking
invariants"** — yani yalnız cevabı bir **sözleşme cümlesini** açan kararlar.

**Bu darlık doğrudur ve korunmalıdır.** İkisi farklı işlevde:

| | işlevi |
|---|---|
| `D-*` (`SYSTEM_INVARIANTS §10`) | **sözleşme katmanının kendi kapı listesi** — hangi invariant hangi karara bloklu |
| **bu indeks** | **tüm** açık kararların haritası — invariantı olsun olmasın |

Bir domain sorusunun invariantı yoksa `D-*`'a girmez; buraya girer.

---

## ⚠️ ID uzayı — dört ayrı seri var, biri **çakışıyor**

Bu indeks **yeni ID üretmez**; her kararın kendi yerel ID'sini kullanır. Ama seriler
çakışabiliyor:

| seri | nerede | not |
|---|---|---|
| `D-01`…`D-17` | `SYSTEM_INVARIANTS §10` | tek uzay |
| `T-nnn` | `.claude/backlog/tasks/` | tek uzay |
| **`K1`…`K10`** | `docs/analysis/0056` | ⛔ **çakışıyor** — TTM'in `DECISION_REGISTRY` de `K1`–`K45` kullanıyor (`docs/analysis/0055`) |
| tur kuyruğu `#1`…`#9` | `docs/analysis/0019` vb. | belge-yerel numaralar, global değil |

> **Bu tabloda `0056-K1` yazılır, `K1` değil.** Ve TTM'inkiler `TTM-K43-R` gibi
> nitelendirilir. Aynı etiketin iki anlamı olması, bu dosyanın çözmeye çalıştığı sorunun
> ta kendisidir.

---

# İndeks

## 📦 BRD v2.0 paketi — bu indeksin ikinci evi (2026-08-12)

`docs/brd-v2/` indi ve **birincil belge** oldu (`CLAUDE.md §2.1`). İki dosya bu indeksle
doğrudan ilişkili:

| dosya | bu indeksle ilişkisi |
|---|---|
| **`00_PAKET_INDEKSI.md`** | *"Açık kalanlar"* bölümünde **altı maddeyi** türleriyle listeliyor (2 karar · 2 **hukuk** · 2 teknik ölçüm) ve *"`OPEN_DECISIONS.md` bunları indeksler"* diyor |
| **`04_KARAR_KAYDI.md`** | **21 kararın** tamamı — soru · karar · gerekçe · açtığı `K-*` kuralları. Aşağıdaki satırların çoğunun **cevabı burada** |

⚠️ **Bu indeks henüz o kararlara göre GÜNCELLENMEDİ.** Satırların statü sütunu
`04_KARAR_KAYDI.md` işlenmeden **bayattır** — `açık` görünen bir madde 2026-08-12'de
kapanmış olabilir. Güncelleme ayrı bir turda yapılacak (kapananlar `✅` olur, **silinmez**).

📌 Ve iki kayıt yeri **çelişmemeli**: paket indeksi altı maddeyi **özetler**, bu dosya
onları **işaret eder**. İçerik ikisinde de yaşamaz — `04_KARAR_KAYDI.md`'de yaşar.

---


**Durum:** `açık` · `karar verildi` · `ölçüm bekliyor` (soru sorulabilmesi için önce bir
teknik ölçüm gerekiyor) · `bayat?` (kaydedildiğinden beri doğrulanmadı)

## A. Ürün sahibi kararı

| ID | Soru | Nerede tanımlı | Neyi blokluyor | Durum |
|---|---|---|---|---|
| `D-01` | CAP aşımında ne olur: skip · clamp · reject? | `SYSTEM_INVARIANTS §10` · [[T-176]] | `INV-B-002` · `INV-B-005` · claim portu | **açık** ⛔ *iki yerde tanımlı* |
| `D-02` | CAP'in doğruluk kaynağı nedir? | `SYSTEM_INVARIANTS §10` | `INV-B-004` | açık |
| `D-03` | CAP zorunlu mu, kapsamı ne? | `SYSTEM_INVARIANTS §10` | `INV-B-002` | açık |
| `D-04` | Append-only hangi seviyede zorlanır (kolon mu, trigger mı)? | **`ADR 0012`** (birleşti) · `SYSTEM_INVARIANTS §10` · `§3` | `INV-L-001` · `INV-L-003` | **öneri hazır** — [[T-188]] ölçümü + kaynak üç yerde yazıyor |
| `D-06` | Settlement tabanı nedir? | `SYSTEM_INVARIANTS §10` | `INV-R-007` | açık |
| `D-07` | Recognition dağıtım kuralı? | `SYSTEM_INVARIANTS §10` | `INV-R-007` · `INV-R-008` | açık |
| `D-08` | Envelope bulunamazsa: reddet mi, otomatik yarat mı? | `SYSTEM_INVARIANTS §10` · `0020 §6 #7` | `INV-B-006` (+1) | **açık** ⛔ *iki yerde* |
| `D-09` | Envelope çözümleme boyutları? | `SYSTEM_INVARIANTS §10` | `INV-B-007` | açık |
| `D-10` | Claim modeli CTPM'e girecek mi, hangi şekilde? | `SYSTEM_INVARIANTS §10` · [[T-176]] · `0055` | claim portu | açık |
| `D-14` | Actuals replace semantiği bir **tenant politikası** mı? | `SYSTEM_INVARIANTS §10` | `INV-R-003` | açık |
| `D-15` | Hesaplanan **sıfır** KPI ile *"KPI yok"* aynı şey mi? | `SYSTEM_INVARIANTS §10` · `0057` | **`INV-N-002`'nin transformer fazı** (tüm `INV-N-*` değil) | **açık** ✅ *ADR 0008 farklı eksen — doğrulandı, `SYSTEM_INVARIANTS:681` zaten yazıyor* |
| [[T-144]] | Bütçe eşiği orta kademesi **90** mı **95** mi, ve sınır `>` mi `>=` mi? | `.claude/backlog/tasks/T-144.md` · `0049 §2b` · **`0059 §2.3`** | RAG gösterimi · onay kapısı | **açık** ⚠️ *tanık sayısı 3→5: `Section_10:72` ve `Section_08:164-166` **95** diyor, ikincisi 95'e **kapı** koyuyor — önceki "çözüldü" okuması eksik enumerasyona dayanıyordu* |
| [[T-156]] | Konfigürasyon katmanı (altı tablo) hangi şekilde yazılacak? | `.claude/backlog/tasks/T-156.md` | Phase 2'nin tamamı | **açık** — ⚠️ port referansı **yok**, sıfırdan tasarım |
| [[T-176]] | LTA'nın uygulanabilirliği **dönem etiketinden** mi **tarih aralığından** mı gelir? | `.claude/backlog/tasks/T-176.md` · `0055 §1.2` | claim portu | açık — TTM'de de cevaplanmamış |
| [[T-177]] | Oran KPI'ları üst seviyede nasıl toplanır, ve **kısmi null** bir plan ne gösterir? | `.claude/backlog/tasks/T-177.md` | Gate 3 (*"%70 yeşil"*) ölçülebilirliği | açık |
| [[T-174]] | Çok-birim (UOM) gerekiyor mu, yoksa tek kanonik birim mi? | `.claude/backlog/tasks/T-174.md` · `0052 §3` | fatura ↔ plan hacim karşılaştırması | açık |
| `0056-K1` | Deprecated enum etiketleri (`MANAGER`·`FINANCE`·`APPROVER`) ne olacak? | `0056 §C` | [[T-165]] | açık — ⚠️ enum kaldırma, veri taşıyan ortamda pahalı |
| `0056-K2` | Çok-rol gerekiyor mu (junction ↔ enum)? | `0056 §C` | [[T-165]] | açık |
| `0056-K3` | Yetenek granularitesi: `§7.2`'nin 20 yeteneği mi, daha kaba mı? | `0056 §C` | [[T-167]] · [[T-156]] | açık |
| `0056-K4` | `user_permission_overrides` gelecek mi? | `0056 §C` | [[T-165]] | açık — kaynak bile *"use sparingly"* diyor |
| `0056-K5` | Kapsam eksenleri: `category` kalsın mı, `region` eklensin mi? | `0056 §C` · `0052 §1` | [[T-165]] | açık |
| `0056-K6` | `SCOPE_ENFORCEMENT_ENABLED` ne zaman açılacak? | `0056 §C` | planner kapsam izolasyonu | açık — **bugün kapalı** |
| `0056-K7` | `RolesGuard` fail-open kalacak mı? | `0056 §C` · [[T-181]] | 77 route | açık |
| `0056-K8` | Yetki **veri** mi olacak (üretimden konfigüre edilebilir mi)? | `0056 §C` · [[T-108]] | [[T-156]] | açık |
| `0056-K9` | Dört ölü tenant/admin mekanizması: sil mi, bağla mı? | `0056 §C` · [[T-180]] | — | açık — **öneri: sil** |
| `0056-K10` | Login'in tenant çözümü çok-tenant'ta ne yapacak? | `0056 §C` | çok-tenant login | açık |
| `0019 #1` | Mod seçimi bağlamla mı çözülür (üç katmanlı yığın)? | `docs/analysis/0019 §kuyruk` · `0037` | [[T-148]] · [[T-156]] | açık — soru **değişti**: *"doğru mu"* değil, *"tablo neden yok"* (`0021:108`) |
| `0019 #2` | Tactic FU seviyesinde, hacim SKU seviyesinde — doğru mu? | `0019 §kuyruk` · **`0057` (ölçüldü 2026-08-11)** | grid · veri modeli · miras | **açık** — yazma yolunda ✅ ve BRD'den **katı**; kullanıcı yüzeyinde ❌ ([[T-187]]) |
| `0020 #6` | %90'da *"Finance onayı gerekir"* katmanı — üç kademeli bütçe kapısı | `docs/analysis/0020 §6` | [[T-144]] | açık |
| `0020 #8` | STA ≤30 gün / LTA >30 gün ayrımı | `docs/analysis/0020 §6` | — | 🟡 açık |
| `§3.1 ↔ §5` | Hacim **FU** seviyesinde mi tahmin edilir, **SKU** seviyesinde mi? Kaynak kendi içinde çelişiyor (`Section_03:112` *"FU → SKU volumes (optional detail)"* ↔ `Section_05:169` *"Volume planning occurs at SKU level"*) | `0057 §1` | grid mimarisi | **açık** ⛔ kod `Section_05`'i uyguluyor **ve** *"optional"*ı kapatıyor |
| `0023` | `spend_type = ACCRUAL` — tahakkuk ne zaman yazılır, nasıl kapanır? | `docs/analysis/0023 §3` | ledger tahakkuk yolu | **açık** — mekanizma **hiç yok**, LTA'ların çoğu gerektiriyor |
| `§7.2 ↔ backend` | `import.invoice`: BRD *"Typical Roles: **Planner**, Finance"* diyor, backend `PLANNER`'ı **dışlıyor** — hangisi doğru? | `.claude/backlog/tasks/T-179.md` · `agreement-transaction.controller.ts:288` | fatura yükleme yetkisi | **açık** — [[T-179]] backend'e uydu, çelişki karara bağlanmadı |
| `ADR 0002 ↔ §7.1` | Finance Manager yalnız `PENDING_FINANCE_REVIEW`'u mu onaylar, yoksa genel Level-2 mi? | `0056 §F.1` · `docs/decisions/0002` | onay akışı | **açık** ⛔ ADR'nin dayanağı **süperseded** (`.cursor/rules.md`) |
| `0064-ROI` | GP ROI RAG ölçeği: `≥20%` mi `150%+` mı? | `0064 §1` · `Section_05:432` (formül) ↔ `Section_02:561` · `Section_01:163` | yeni BRD'nin örnekleri · Gate 3 (*"%70 yeşil"*) | **açık** — ölçüldü: **7 tanık `≥20`**, 2 tanık `150%` ve **ikisi de anlatı örneği**; öneri: örnekleri düzelt |
| `0064-TENANT` | Çok-kiracılık Phase 1'de **var** mı, yol haritası mı? | `0064 §2` · **`0066 §3`** | RLS · `0056-K10` · [[T-179]] | **açık** ⛔ — `0063-SSO`'nun sözleşmesi burada **işlemiyor** (yön ters: faz bölümü *var*, yetenek bölümü *roadmap* diyor). `§9.2` faz etiketli + sayısal + mekanizma seviyesinde (RLS, pgBouncer); `§2.5` tek cümlelik not |
| `0064-SCALE` | Performans testi **kapasite tavanını** mı (10.000 SKU / 100 kullanıcı) yoksa **Yıl-1 projeksiyonunu** mu (5.000 / 50) hedefler? | `0064 §3` · **`0066 §2` (çerçeve düzeltildi)** | performans testi hedefleri · [[T-154]] | **açık ama daraldı** — sayılar çelişmiyor: `§2.5` **kapasite**, `§9.2` **projeksiyon**, `§1.3` **örnek**. Soru artık "hangi sayı doğru" değil, "test neyi hedefler" |
| `0067-LUMPSUM` | Lumpsum dağıtım tabanı **base** mi **planned** hacim mi — ve `null base` SKU pay alır mı? | `0067 §1-2` · [[T-202]] · `ADR 0006` (öncülü yanlışlandı) | yeni ürün lansmanlarında SKU kârlılığı · bütçe rezervasyonu | **açık** ⛔ **üç sinyal**: `§5.2` metni *planned* · `§5.2` örneği *ikisi de değil* · `ADR 0006` + `0001` *base* |
| `0063-SSO` | SSO Phase 1'de var mı? | `0063 §2` · **`0066 §1` (tam enumerasyon)** | Phase 1 güvenlik kapsamı | **çözüldü sayılabilir** ✅ — **4 faz-tanığı** *Phase 2* (`§7.7`·`§9.4`·`§9.8`·`§10.1`); "var" diyen 5 tanığın 4'ü `Section_03`'ün *"Target State vs Phasing"* sözleşmesiyle açıklanıyor. Geriye **tek aykırı ifade**: `§2.1.4:214` `(Day 1)` → yazım hatası önerisi |
| `0060-EA001` | **Super Admin**: altıncı rol mü, Admin'in bölünmesi mi, yoksa bir **yetenek** mi? | `0060 §5` · [[T-200]] — karar [[T-165]] ile birlikte | rol modeli · `0056-K1`/`K2`/`K3` | açık — ⚠️ kaynak **imzalanmamış Sprint-0 taslağı** |
| `0060-AI001` | `AI-001`'in kalan dört maddesi uygulanacak mı: hata raporu **CSV**, başarı ekranı + re-import, boş/tümü-geçersiz dosya mesajları, **duplike → skip with warning**? | `0060 §2` · [[T-126]] (kapalı) · [[T-130]] | import hata yüzeyi e2e'si | açık — ⚠️ satır-bazlı ret **zaten uygulandı**, soru üstündeki yüzey |
| `0060-MC001` | Phase 1 eşzamanlılık kabul ölçütü **`H2`'nin 10×1.500'ü** mü, **`MC-001`'in 5×2.500'ü** mü? | `0060 §3` · [[T-154]] | bütçe eşzamanlılık testi | açık — ⚠️ çelişki **iddia edilmiyor**: gevşetme önerisi olabilir, ölçülmedi |
| [[T-169]] | Phase 1 tabanı mı, Phase 2 devamı mı? | `.claude/backlog/tasks/T-169.md` | sıralama | ✅ **karar verildi** 2026-08-10 |
| [[T-163]] | `GP_ROI_PCT` paydası? | `docs/decisions/0011` | dört eşik | ✅ **karar verildi** — ADR 0011 |
| `D-05` | Sayısal sözleşme | `docs/decisions/0007` | `INV-N-*` | ✅ **karar verildi** — ADR 0007 |

## B. Hukuk kararı

| ID | Soru | Nerede tanımlı | Neyi blokluyor | Durum |
|---|---|---|---|---|
| [[T-170]] | Vergi Usul · KVKK · E-Fatura bu üründe **hangi kayıtlara**, hangi biçimde uygulanır? | `.claude/backlog/tasks/T-170.md` · `0050` | `INV-C-001`…`INV-C-004` | **ölçüm bekliyor** — üç teknik ölçüm önce |

> ⚠️ `T-170` bilinçli olarak *"ölçüm bekliyor"*: bağlayıcılık sorusu sorulmadan önce
> KVKK anonimleştirmesi · E-Fatura dosya arşivi · `admin_audit_logs` immutability'si
> **ölçülmeli** (`CLAUDE.md`: bir kapsam kararı ölçülmemiş bir iddiaya dayanamaz).

## C. Danışman (domain iddiası, pahalıysa)

| ID | Soru | Nerede tanımlı | Neyi blokluyor | Durum |
|---|---|---|---|---|
| `0019 #3` | CAP aşımı → uyarı + Finance override mı? | `docs/analysis/0019 §kuyruk` | `D-01` ile aynı karar | **açık** ⛔ *`D-01`/[[T-176]] ile üçüncü kopya* |
| `0019 #4` | Baseline kapsama kapısının **varlığı** — ve hangi kademe? | `0019 §kuyruk`, `0028 §2` ile **düzeltildi** (MVB-1/2/3) | [[T-024]] | açık — kapının varlığı domain, sayısı konfigürasyon |
| `0019 #8` | `TRANSFER` / `ADJUST` işlem tipleri: tenant mı, ürün mü? | `docs/analysis/0019 §kuyruk` · [[T-145]] | — | 🟡 açık |

> **Danışman filtresi** (`docs/analysis/0019 §filtre`): soru *"gerekçesi yazılı mı"* değil,
> **tür ve maliyet** — teknik/ölçülebilir (biz doğrularız) · kapsam/faz (ürün sahibi) ·
> **domain iddiası** (danışman, pahalıysa).

## D. Teknik ölçüm bekliyor (soru henüz sorulamaz)

| ID | Ne ölçülecek | Nerede tanımlı | Durum |
|---|---|---|---|
| `D-11` | RLS gerekliliği — ⚠️ ama önce **ayrı DB rolü** ön koşulu | `SYSTEM_INVARIANTS §10` · [[T-167]] · `0056 §D.2` | ölçüm bekliyor — bugün `postgres` **bypassrls** |
| `D-12` | Fiscal period saat dilimi | `SYSTEM_INVARIANTS §10` | açık |
| `D-13` | Idempotency key biçimleri | `SYSTEM_INVARIANTS §10` · `INV-L-009` | açık |
| `D-16` | Scale-3 hacim kolonları nasıl temsil edilir? | `SYSTEM_INVARIANTS §10` | açık |
| `D-17` | `unitPrice` / `cogs` **para** mı **fiyat** mı? | `SYSTEM_INVARIANTS §10` | açık |
| [[T-181]] | 77 filtresiz route'un sınıflandırması | `.claude/backlog/tasks/T-181.md` | ölçüm bekliyor |

---

## Bu indeksin sınırları — ölçülmemiş olanlar

⚠️ **Aşağıdakiler bilinçli olarak eksik ve iddia edilmiyor:**

1. ~~**Tur 1–19 kuyruğunun tam envanteri çıkarılmadı.**~~ ✅ **ÖLÇÜLDÜ (2026-08-12)** —
   ve *"~9-10 mu 8 mi"* farkı **kayıp değilmiş, iki farklı şeyi sayıyorlarmış**:

   | tur | kuyruğa giren | ID'ler |
   |---|---|---|
   | `0019` (tur 1) | **4** ✅ | `#1` mod seçimi · `#2` tactic-FU/hacim-SKU · `#3` CAP aşımı · `#4` baseline ≥%95 |
   | `0020` (tur 2) | **3** ✅ + **1** 🟡 | `#5` CAP satırı geçirir · `#6` %90 katmanı · `#7` envelope reddi · `#8` STA/LTA 🟡 |
   | `0023` (tur 5) | **1** ✅ + **1** 🟡 | `ACCRUAL` · ledger sınırı 🟡 |
   | `0021` · `0024` · `0027` | **0** | *"bu turdan yeni domain sorusu çıkmadı"* (kendi ifadeleri) |

   **Toplam: 8 ✅ + 2 🟡 = 10.** Turu 6/9'un *"~9-10"*'u **10'u** (🟡 dahil), indeksteki
   *"8 madde"* ise `0019/0020/0023` **etiketli satırları** sayıyordu. Kalan ikisi
   **kaybolmadı, başka ID altında duruyor**: `0020 #5` → `D-01`, `0020 #7` → `D-08`
   (satırın *"Nerede tanımlı"* sütunu zaten `0020 §6 #7` diyor).

   > **Hiçbir kuyruk maddesi kaçmamış.** Fark, iki sayımın **farklı kümeleri** saymasından
   > geliyordu — `CLAUDE.md`'nin *"sayı yerine niteliksel ayırt edici yaz"* kuralının bir
   > vakası daha.
2. **`bayat?` işaretli maddeler** kaydedildiklerinden beri doğrulanmadı.
3. **Statü sütunu türetilmiş değil, elle yazıldı** — bir karar başka bir belgede
   cevaplandıysa burada hâlâ `açık` görünebilir.

> **Bu dosyanın kendisi bir enumerasyondur, ve `CLAUDE.md` der ki: bir enumerasyona dayanan
> her karar, enumerasyonun kendisi ölçülene kadar bir tahmindir.** Bu indeks o ölçümü
> **başlatır**, tamamlamaz.

### 📏 İndeksin kendi sayımı (ölçüldü 2026-08-12, tahmin değil)

```
A. Ürün sahibi kararı   45
B. Hukuk kararı          1
C. Danışman              3
D. Teknik ölçüm bekliyor 6
                        ──
TOPLAM satır            55
```

Sayım komutu: bölüm başlıklarına göre `| \`` veya `| [[` ile başlayan satırlar (açıklama
tablolarının satırları hariç — `D-*` serisi tablosu ve ID uzayı tablosu **sayılmadı**).

⚠️ **Bu sayı hızla bayatlar** (`CLAUDE.md`: *"dokümanda sayı yazma"*). Buraya yazılmasının
tek gerekçesi, bir sonraki sayımın **neyi saydığını** bilmesi: satır sayısı ≠ karar sayısı —
`D-01`/`D-08` gibi satırlar birden çok kuyruk maddesini taşıyor (bkz. §1 yukarıda).

---

## Bakım kuralı

1. **Yeni açık karar → buraya bir satır.** İçerik nerede yaşarsa yaşasın.
2. **Karar verildiğinde:** satır **silinmez**, `✅ karar verildi` olur ve ADR'ye/task'a
   işaret eder. Silinen bir satır, kararın hiç sorulmadığı izlenimi verir.
3. **İçerik buraya taşınmaz.** Bir satır bir cümleden uzunsa, yanlış yerdedir.
4. **ID nitelendirilir** (`0056-K1`, `TTM-K43-R`) — çıplak `K1` yazılmaz.
