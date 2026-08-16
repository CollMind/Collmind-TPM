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
| **`00_PAKET_INDEKSI.md`** | *"Açık kalanlar"* bölümünde **beş maddeyi** türleriyle listeliyor (2 karar · 1 **hukuk** · 2 teknik ölçüm) ve *"`OPEN_DECISIONS.md` bunları indeksler"* diyor. ⚠️ **Altıydı** — kişi bazlı raporlama 2026-08-12'de kapandı (`K-2.9.6`) |
| **`04_KARAR_KAYDI.md`** | **21 kararın** tamamı — soru · karar · gerekçe · açtığı `K-*` kuralları. Aşağıdaki satırların çoğunun **cevabı burada** |

✅ **İşlendi (2026-08-12).** `04_KARAR_KAYDI.md`'nin 21 kararı bu indekse uygulandı:
**25 satır kapandı** (silinmedi — `✅ KAPANDI` + tarih + tek cümle + karar atfı), üç satır
*"karar turu etkiledi"* diye işaretlendi, staging'de doğan iki karar eklendi ve reddedilen
seçenekler için `E` bölümü açıldı. Sayılar `§Bu turun bilançosu`'nda **sayılarak** yazıldı.

📌 Ve iki kayıt yeri **çelişmemeli**: paket indeksi beş maddeyi **özetler**, bu dosya
onları **işaret eder**. İçerik ikisinde de yaşamaz — `04_KARAR_KAYDI.md`'de yaşar.

---


**Durum:** `açık` · `karar verildi` · `ölçüm bekliyor` (soru sorulabilmesi için önce bir
teknik ölçüm gerekiyor) · `bayat?` (kaydedildiğinden beri doğrulanmadı)

## A. Ürün sahibi kararı

| ID | Soru | Nerede tanımlı | Neyi blokluyor | Durum |
|---|---|---|---|---|
| `D-01` | CAP aşımında ne olur: skip · clamp · reject? | `SYSTEM_INVARIANTS §10` · [[T-176]] | `INV-B-002` · `INV-B-005` · claim portu | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A5` — tavan aşımı gerçekleşmeyi **durdurmaz**; hakediş tavana kırpılır |
| `D-02` | CAP'in doğruluk kaynağı nedir? | `SYSTEM_INVARIANTS §10` | `INV-B-004` | açık · ⚠️ **karar turu etkiledi:** A5 tavan davranışını değiştirdi — CAP'in doğruluk kaynağı sorusu **yeniden okunmalı** |
| `D-03` | CAP zorunlu mu, kapsamı ne? | `SYSTEM_INVARIANTS §10` | `INV-B-002` | açık · ⚠️ **karar turu etkiledi:** A5 sonrası kapsam sorusu değişti — **doğrulanmadı** |
| `D-04` | Append-only hangi seviyede zorlanır (kolon mu, trigger mı)? | **`ADR 0012`** (birleşti) · `SYSTEM_INVARIANTS §10` · `§3` | `INV-L-001` · `INV-L-003` | ✅ **KAPANDI 2026-08-12** · `ADR 0012` — *ikisi tek karardır*: finansal kayıtlar **fiziksel silinemez**; zorlama seviyesi ADR'de |
| `D-06` | Settlement tabanı nedir? | `SYSTEM_INVARIANTS §10` | `INV-R-007` | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A4` — türetilebilir sınıfın tabanı **net satış** (varsayılan), taban mekanikle değişir |
| `D-07` | Recognition dağıtım kuralı? | `SYSTEM_INVARIANTS §10` | `INV-R-007` · `INV-R-008` | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A3.c` — atıf **kanıt merdiveniyle**; açıklanamayan kalıntı hiçbir taktiğe yazılmaz — orantısal atıf **reddedildi** |
| `D-08` | Envelope bulunamazsa: reddet mi, otomatik yarat mı? | `SYSTEM_INVARIANTS §10` · `0020 §6 #7` | `INV-B-006` (+1) | **açık** ⛔ *iki yerde* |
| `D-09` | Envelope çözümleme boyutları? | `SYSTEM_INVARIANTS §10` | `INV-B-007` | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §B2` — **iki boyut** (kanal, kategori), çakışmasız, öncelik kolonu **yok**, zorunlu joker varsayılan |
| `D-10` | Claim modeli CTPM'e girecek mi, hangi şekilde? | `SYSTEM_INVARIANTS §10` · [[T-176]] · `0055` | claim portu | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A3.a` — iç ve dış talep **tek varlık**, `kaynak: İÇ | DIŞ` alanıyla |
| `D-14` | Actuals replace semantiği bir **tenant politikası** mı? | `SYSTEM_INVARIANTS §10` | `INV-R-003` | açık |
| `D-15` | Hesaplanan **sıfır** KPI ile *"KPI yok"* aynı şey mi? | `SYSTEM_INVARIANTS §10` · `0057` | **`INV-N-002`'nin transformer fazı** (tüm `INV-N-*` değil) | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A10` — **eşik yok** — renk yalnız tam kapsamada; `GRİ` dördüncü birinci-sınıf durum |
| [[T-144]] | Bütçe eşiği orta kademesi **90** mı **95** mi, ve sınır `>` mi `>=` mi? | `.claude/backlog/tasks/T-144.md` · `0049 §2b` · **`0059 §2.3`** | RAG gösterimi · onay kapısı | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §C1` — **iki merdiven**: davranış `80/90/100`, renk `80/95`; %90 Faz 1'de **bildirim** |
| [[T-156]] | Konfigürasyon katmanı (altı tablo) hangi şekilde yazılacak? | `.claude/backlog/tasks/T-156.md` | Phase 2'nin tamamı | **açık** — ⚠️ port referansı **yok**, sıfırdan tasarım · ⚠️ **karar turu etkiledi:** `B1`/`B2` konfigürasyon katmanının **şeklini** verdi (politika tablosu + üç şablon, kural motoru yok) — kalan kapsam doğrulanmalı |
| [[T-176]] | LTA'nın uygulanabilirliği **dönem etiketinden** mi **tarih aralığından** mı gelir? | `.claude/backlog/tasks/T-176.md` · `0055 §1.2` | claim portu | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A5` — CAP maddesi A5 ile kapandı — ⚠️ satırın **LTA uygulanabilirliği** kısmı ayrıca doğrulanmalı |
| [[T-177]] | Oran KPI'ları üst seviyede nasıl toplanır, ve **kısmi null** bir plan ne gösterir? | `.claude/backlog/tasks/T-177.md` | Gate 3 (*"%70 yeşil"*) ölçülebilirliği | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A10` — **eşik yok**, renk yalnız tam kapsamada, `GRİ` birinci sınıf |
| [[T-174]] | Çok-birim (UOM) gerekiyor mu, yoksa tek kanonik birim mi? | `.claude/backlog/tasks/T-174.md` · `0052 §3` | fatura ↔ plan hacim karşılaştırması | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A8` — **tek kanonik birim: adet**; çevrim yalnız içe aktarma sınırında |
| `0056-K1` | Deprecated enum etiketleri (`MANAGER`·`FINANCE`·`APPROVER`) ne olacak? | `0056 §C` | [[T-165]] | açık — ⚠️ enum kaldırma, veri taşıyan ortamda pahalı · 🔵 **v2'nin altı açık maddesinden biri** (*rol kümesi*): `docs/brd-v2/04_KARAR_KAYDI.md §Hâlâ açık` — kaynak **üç farklı küme** veriyor, karar [[T-200]]/[[T-165]] ile birlikte |
| `0056-K2` | Çok-rol gerekiyor mu (junction ↔ enum)? | `0056 §C` | [[T-165]] | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §B3` — çok rollülük **evet** (birleştirme tablosu, union çözümleme) |
| `0056-K3` | Yetenek granularitesi: `§7.2`'nin 20 yeteneği mi, daha kaba mı? | `0056 §C` | [[T-167]] · [[T-156]] | ✅ **KAPANDI 2026-08-16 → (b)** sabit tanım, tablo yok (kayıt `Z4`) |
| `0056-K4` | `user_permission_overrides` gelecek mi? | `0056 §C` | [[T-165]] | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §B3` — kişiye özel yetki istisnası **HAYIR** — kaynaktan bilinçli sapma |
| `0056-K5` | Kapsam eksenleri: `category` kalsın mı, **`region` ZORUNLU olsun mu**? | `0056 §C` · `0052 §1` | [[T-165]] | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A7` — kapsam **kanal + müşteri + kategori**, bölge Faz 2. ⚠️ **Ama soru şekil değiştirdi** (`0069 §F14`): `plans.region_id` **kolonu zaten var, nullable** — yani *"eklensin mi"* değil, **"zorunlu olsun mu"**. Bu `A7`'yi etkilemiyor, Faz 2'nin şeklini belirliyor |
| `0056-K6` | `SCOPE_ENFORCEMENT_ENABLED` ne zaman açılacak? | `0056 §C` | planner kapsam izolasyonu | açık — **bugün kapalı** |
| `0056-K7` | `RolesGuard` fail-open kalacak mı? | `0056 §C` · [[T-181]] | 77 route | açık |
| `0056-K8` | Yetki **veri** mi olacak (üretimden konfigüre edilebilir mi)? | `0056 §C` · [[T-108]] | [[T-156]] | açık |
| `0056-K9` | Dört ölü tenant/admin mekanizması: sil mi, bağla mı? | `0056 §C` · [[T-180]] | — | açık — **öneri: sil** |
| `0056-K10` | Login'in tenant çözümü çok-tenant'ta ne yapacak? | `0056 §C` | çok-tenant login | açık |
| `0019 #1` | Mod seçimi bağlamla mı çözülür (üç katmanlı yığın)? | `docs/analysis/0019 §kuyruk` · `0037` | [[T-148]] · [[T-156]] | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A1` — **mod öldü** — davranışları sahiplerine dağıtıldı, geriye görünürlük bayrağı kaldı |
| `0019 #2` | Tactic FU seviyesinde, hacim SKU seviyesinde — doğru mu? | `0019 §kuyruk` · **`0057` (ölçüldü 2026-08-11)** | grid · veri modeli · miras | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A2` — giriş **FU**'da, SKU **türetilmiş ve düzeltilebilir**; giriş grain'i ≠ hesap grain'i |
| `0020 #6` | %90'da *"Finance onayı gerekir"* katmanı — üç kademeli bütçe kapısı | `docs/analysis/0020 §6` | [[T-144]] | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §C1` — %90 Faz 1'de **bildirim**; onay kapısı konfigürasyon |
| `0020 #8` | STA ≤30 gün / LTA >30 gün ayrımı | `docs/analysis/0020 §6` | — | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §C3` — süre bir **sınıflandırıcı olmaktan çıktı** — davranışı `settlement_cadence` belirler |
| `§3.1 ↔ §5` | Hacim **FU** seviyesinde mi tahmin edilir, **SKU** seviyesinde mi? Kaynak kendi içinde çelişiyor (`Section_03:112` *"FU → SKU volumes (optional detail)"* ↔ `Section_05:169` *"Volume planning occurs at SKU level"*) | `0057 §1` | grid mimarisi | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A2` — giriş **FU**'da; SKU katmanı hesapta yaşar, satır olarak malzemeleşmez |
| `0023` | `spend_type = ACCRUAL` — tahakkuk ne zaman yazılır, nasıl kapanır? | `docs/analysis/0023 §3` | ledger tahakkuk yolu | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A6` — **operasyonel tahakkuk bizim**, muhasebe tahakkuku ERP'nin |
| `§7.2 ↔ backend` | `import.invoice`: BRD *"Typical Roles: **Planner**, Finance"* diyor, backend `PLANNER`'ı **dışlıyor** — hangisi doğru? | `.claude/backlog/tasks/T-179.md` · `agreement-transaction.controller.ts:288` | fatura yükleme yetkisi | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §C5` — içe aktarma yetkisi **fazlanır**: bugün finans, eşleştirme gelince planlamacı |
| `ADR 0002 ↔ §7.1` | Finance Manager yalnız `PENDING_FINANCE_REVIEW`'u mu onaylar, yoksa genel Level-2 mi? | `0056 §F.1` · `docs/decisions/0002` | onay akışı | ✅ **KAPANDI 2026-08-12** → **`ADR 0002-R`** · `K-2.5.12` ailesi: onay hattını **yalnız atanmış şablon** belirler, ikinci bir yükseltme mekanizması **yok**. `escalate-to-finance` bir hat değil bir **eylem** (`FİNANSA DEVRET`). ⚠️ Eski sonuç (*FM yalnız kendisine geleni onaylar*) **hâlâ doğru** ama gerekçesi değişti: BRD okuması değil, **şablon tercihi** (`K-2.5.12e`) |
| `0064-ROI` | GP ROI RAG ölçeği: `≥20%` mi `150%+` mı? | `0064 §1` · `Section_05:432` (formül) ↔ `Section_02:561` · `Section_01:163` | yeni BRD'nin örnekleri · Gate 3 (*"%70 yeşil"*) | **açık** — ölçüldü: **7 tanık `≥20`**, 2 tanık `150%` ve **ikisi de anlatı örneği**; öneri: örnekleri düzelt |
| `0064-TENANT` | Çok-kiracılık Phase 1'de **var** mı, yol haritası mı? | `0064 §2` · **`0066 §3`** | RLS · `0056-K10` · [[T-179]] | **açık** ⛔ — `0063-SSO`'nun sözleşmesi burada **işlemiyor** (yön ters: faz bölümü *var*, yetenek bölümü *roadmap* diyor). `§9.2` faz etiketli + sayısal + mekanizma seviyesinde (RLS, pgBouncer); `§2.5` tek cümlelik not |
| `0064-SCALE` | Performans testi **kapasite tavanını** mı (10.000 SKU / 100 kullanıcı) yoksa **Yıl-1 projeksiyonunu** mu (5.000 / 50) hedefler? | `0064 §3` · **`0066 §2` (çerçeve düzeltildi)** | performans testi hedefleri · [[T-154]] | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §B5` — hedef **Yıl-1 projeksiyonu** (5.000 SKU · 10 eşzamanlı onay); tavan iddiası çıkarıldı |
| `0067-LUMPSUM` | Lumpsum dağıtım tabanı **base** mi **planned** hacim mi — ve `null base` SKU pay alır mı? | `0067 §1-2` · [[T-202]] · `ADR 0006` (öncülü yanlışlandı) | yeni ürün lansmanlarında SKU kârlılığı · bütçe rezervasyonu | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A9` — taban **planlanan hacim**, ve dağıtım bir **rapor katmanı hesabı** — deftere yazılmaz |
| [[T-194]] | `Section_12`'nin *"ledger bütçe kullanımının **tek** hakikat kaynağıdır"* ifadesi mi yanlış, **model mi**? (`reserved` `budget_transactions`'tan geliyor) | `.claude/backlog/tasks/T-194.md` (staging, 2026-08-11) | `Available` formülünün iki ailesi · çift sayım guard'ı | **açık** — ⚠️ `ADR 0012` migration'ı **bunu düzeltmez**; semptom (`consumed=0`) düzelir, yapısal soru kalır |
| [[T-195]] | Bir tenant **offboard** edilirken ne olur? | `.claude/backlog/tasks/T-195.md` (staging) · `ADR 0012` madde 4 | `*/tenants` FK'larının `ADR 0012` kovası · migration | **açık** — bugünkü çözüm `RESTRICT` (**kararı erteliyor, vermiyor**) |
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
| [[T-170]] | Vergi Usul · KVKK · E-Fatura bu üründe **hangi kayıtlara**, hangi biçimde uygulanır? | `.claude/backlog/tasks/T-170.md` · `0050` | `INV-C-001`…`INV-C-004` | **ölçüm bekliyor** — üç teknik ölçüm önce · 🔵 **v2 açık maddesi** (*saklama sürelerinin bağlayıcılığı* — **hukuk**): `docs/brd-v2/04_KARAR_KAYDI.md §Hâlâ açık`. ⚠️ Kapsam `0065 §4`'te **on kurala** genişledi · ⏸️ **2026-08-13: `K-2.9.0` askısı** — mütalaaya dek hiçbir kayıt silinmez. Sorunun şekli keskinleştirildi (`L2_03 §2.9.6 Hukuk paketi`): *"7 yıl doğru mu"* değil, **"hangi kayıt sınıfımız hangi rejime girer"** |
| `v2-RAPOR-KISI` | **Kişi bazlı performans raporlaması** hukuken yapılabilir mi (KVKK)? | `docs/brd-v2/04_KARAR_KAYDI.md §Hâlâ açık` · `0061 §5` (kaynakta `Report 5`, *"Use Case: performance reviews"*) | kişi bazlı rapor · [[T-170]] ailesi | ✅ **KAPANDI 2026-08-12** — soru **cevaplanmadan** kapandı: `K-2.9.6` raporu **süreç metriği** olarak tanımladı, kişi kimliği kırılım boyutu değil. Kişi bazlı versiyon `K-2.9.6a` ile **hukuk şartlı ertelendi** — artık hiçbir işi bloklamıyor |

> ⚠️ `T-170` bilinçli olarak *"ölçüm bekliyor"*: bağlayıcılık sorusu sorulmadan önce
> KVKK anonimleştirmesi · E-Fatura dosya arşivi · `admin_audit_logs` immutability'si
> **ölçülmeli** (`CLAUDE.md`: bir kapsam kararı ölçülmemiş bir iddiaya dayanamaz).

## C. Danışman (domain iddiası, pahalıysa)

| ID | Soru | Nerede tanımlı | Neyi blokluyor | Durum |
|---|---|---|---|---|
| [[T-209]] | **`sales_actuals.discount_amount`'ın kaynağı nedir?** Satış iskontosu mu, fatura-içi ticari indirim mi — üç soru: hangi kaynaktan doluyor, Wella'nın iş tanımı ne, `on_invoice_entries` ile aynı olayı mı temsil ediyor | `.claude/backlog/tasks/T-209.md` · `docs/brd-v2/_ISSUE_B_DALGASI.md §5` · `K-2.13.14h6a` / `K-2.1.19a` / `K-2.7.4a` (hepsi ⛔ bu ölçüme bağlı) | **`S3` (dalgadan çıktı)** · `K-2.13.14h6` net taban · `K-2.1.19` satış tablosu sözleşmesi · `K-2.7.4a` | **açık — DOMAIN** ⚠️ **ön karar verildi** (2026-08-13, `(b)`: kaynak `on_invoice_entries`) ama beslendiği ölçüm henüz koşmadı. Zemin: `CHECK (net=gross−discount)` seed verisine karşı **reddedildi** (`is violated by some row`), sapma **3/3 satır** · en büyük `25.000` · toplam `63.000`. **%100 sapma bir veri kalitesi sorunu değil, model uyuşmazlığı işaretidir** |
| `0019 #3` | CAP aşımı → uyarı + Finance override mı? | `docs/analysis/0019 §kuyruk` | `D-01` ile aynı karar | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §A5` — ⛔ **üç madde tek kararla kapandı** (`D-01` · `0019 #3` · `T-176`'nın CAP maddesi): tavan aşımı gerçekleşmeyi **durdurmaz**, hakediş tavana **kırpılır** |
| `0019 #4` | Baseline kapsama kapısının **varlığı** — ve hangi kademe? | `0019 §kuyruk`, `0028 §2` ile **düzeltildi** (MVB-1/2/3) | [[T-024]] | açık — kapının varlığı domain, sayısı konfigürasyon |
| `0019 #8` | `TRANSFER` / `ADJUST` işlem tipleri: tenant mı, ürün mü? | `docs/analysis/0019 §kuyruk` · [[T-145]] | — | ✅ **KAPANDI 2026-08-12** · `04_KARAR_KAYDI.md §B6` — `TRANSFER` **Faz 1**'e girer (blok kararının kaçış yolu); **devir Faz 1 dışı** |

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
| `v2-VERI-AYRIMI` | **Veri ayrımı modeli** hangisi olacak — ve geçiş maliyeti ne? | `docs/brd-v2/04_KARAR_KAYDI.md §Hâlâ açık` · `docs/brd-v2/00_PAKET_INDEKSI.md §Açık kalanlar` | çok-kiracılık · `0064-TENANT` · `0056-K10` | **açık — TEKNİK ÖLÇÜM** · 🔵 v2 açık maddesi (*geçiş maliyetleri*) |
| `v2-IADE` | **İadenin veri temsili** ne olacak? | `docs/brd-v2/04_KARAR_KAYDI.md §Hâlâ açık` · `docs/brd-v2/00_PAKET_INDEKSI.md §Açık kalanlar` | iade/ters kayıt · `INV-L-004` ailesi | **açık — TEKNİK ÖLÇÜM** · 🔵 v2 açık maddesi (*tek sorgu*) |

---

## E. Kapsam dışı — **bilerek reddedildi** (açık karar DEĞİL)

> Bu bölüm bir kuyruk değil, bir **kayıt**. Buradaki hiçbir madde beklemiyor — hepsi
> **gerekçesiyle reddedildi** (2026-08-12 karar turu). Silinmiyorlar, çünkü altı ay sonra
> *"bu neden yok"* sorusunun cevabı burada olmalı.
>
> **Reddedilmiş bir seçenek, unutulmuş bir seçenekten iyidir.**

### E.1 · Hiçbir faza girmiyor

| Reddedilen | Gerekçe (özet — tamamı `docs/brd-v2/04_KARAR_KAYDI.md`'de) | Karar |
|---|---|---|
| **Muhasebe tahakkuku** | ERP'nin işi; operasyonel tahakkuk bizim, muhasebe onun | `A6` |
| **Kişiye özel yetki istisnası** | *"yetki modeliniz nedir"* sorusuna *"tablo + kişiye özel delikler"* cevabı verdirir | `B3` |
| **Karma çalışma biçimi** | kullanıcıya *"hangi biçimde çalışmak istersin"* diye sormak, **ürünün veremediği bir kararı kullanıcıya devretmektir** | `A1` |
| **Serbest biçimli kural motoru** | bu segmentte kanıtlanmış aşırı mühendislik — *"ilk müşteride kimsenin doldurmayacağı boş bir kural editörü"* | `B1` |
| **Orantısal atıf** | açıklanamayan kalıntı hiçbir taktiğe yazılmaz; atıf **kanıt merdiveniyle** yapılır | `A3.c` |
| **Kapsama eşiği** | renk yalnız **tam kapsamada**; eşik, kısmi hesabı tam gibi gösterir | `A10` |

⚠️ Üçü **kaynaktan bilinçli sapmadır** (`A1` üç katmanlı çözümleyici · `B3` kişiye özel
istisna · `A3.c` orantısal atıf) — yani *"BRD böyle diyordu"* itirazının cevabı
`docs/brd-v2/04_KARAR_KAYDI.md`'nin *"yöntem notu"* bölümünde yazılı.

### E.2 · Faz 2'ye bırakıldı (reddedilmedi, **ertelendi**)

devir · onay politikası **kural yazımı** · otomatik zaman aşımı · senaryo analizi ·
**bölge ekseni** · yapay zeka kenarları

📌 Fark önemli: `E.1` bir **ret**, `E.2` bir **sıra**. `E.2`'deki bir madde için yeniden
karar istemek meşru; `E.1` için gerekçeyi çürütmek gerekir.

---

### 🔗 Üç madde **birleşti ve tek kararla kapandı** — indeksin kuruluş gerekçesi doğrulandı

`D-01` · `0019 #3` · `[[T-176]]`'nın CAP maddesi **aynı soruydu** ve `A5` üçünü birden
cevapladı: *tavan aşımı gerçekleşmeyi durdurmaz; hakediş tavana kırpılır, tavan üstü ayrı
kovaya.*

> Bu dosya tam olarak bunun için açılmıştı. Açılış cümlesi şuydu:
> *"`D-01` ile `T-176`'nın CAP maddesi **aynı karardır** … bugün bir çakışma; yarın
> **ikisi ayrı cevaplanır ve ikisi de 'verilmiş karar' sayılır**."*
>
> **Yarın gelmedi** — üçü birlikte görüldüğü için birlikte kapandı. Ve üçüncüsü
> (`0019 #3`) indeksin **başka bir bölümündeydi** (C · danışman kuyruğu); tek dosyada
> durmasalardı üçüncüsü muhtemelen kaçardı.

⚠️ **`T-176`'nın satırı tamamen kapanmadı:** o satır *"LTA'nın uygulanabilirliği dönem
etiketinden mi tarih aralığından mı"* diye yazılı ve `A5` o kısmı cevaplamıyor —
**CAP maddesi** kapandı. Task dosyası ayrıca okunmalı.

---

### 📊 Bu turun bilançosu (sayıldı, tahmin değil)

```
karar turunda kapanan satır          25
karar turunun ETKİLEDİĞİ (açık)       3    D-02 · D-03 · T-156
staging'de doğup indekse giren        2    T-194 · T-195
bilerek reddedilen (E.1)              6
AÇIK kalan satır                     35
Faz 2'ye ertelenen (E.2)              6
```

📌 **Ek 2 (2026-08-13, DB ölçüm turu):** `v2-UC-ALAN` **eklendi** (domain) → **26 kapanan ·
35 açık · 61 satır.** Bir ölçüm bir kararı kapatmadı, **yenisini açtı**: `C3`'ün *"tolerans
kısıtta olmasın"* kararı geçerliliğini yitirdi, çünkü kısıtın dayandığı **alan tanımı**
belirsiz çıktı.

📌 **Ek (2026-08-13):** `v2-RAPOR-KISI` de kapandı (`K-2.9.6` — süreç metriği) → **26
kapanan · 34 açık.** Kapanış sorunun **cevaplanmasıyla değil, ortadan kalkmasıyla** oldu:
ürün kişi kimliğini kırılım boyutu olarak kullanmayınca hukuk sorusu bir iş bloklamıyor.
Toplam satır sayısı değişmedi (60) — bu tabloya yeni satır girmedi.

⚠️ **21 karar ≠ 25 kapanan satır.** Bir karar birden çok satırı kapatabiliyor (`A5` üçünü:
`D-01` · `0019 #3` · `T-176`'nın CAP maddesi; `A2` ikisini; `A10` ikisini; `B3` ikisini;
`C1` ikisini) ve bazı kararlar (`A3.b`, `B4`, `C2`, `C4`) **hiçbir mevcut satıra**
karşılık gelmiyordu — indekste olmayan soruları cevapladılar.

> **Yani indeks, karar turunun kapsamının bir ölçüsü değildi.** Bu, `CLAUDE.md`'nin
> *"bir enumerasyona dayanan her karar, enumerasyonun kendisi ölçülene kadar bir tahmindir"*
> kuralının bu dosyaya uygulanmış hâli.

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
                        önce (2026-08-11)   sonra (2026-08-12)
A. Ürün sahibi kararı          45              47   (23 ✅ · 24 açık)
B. Hukuk kararı                 1               2   ( 0 ✅ ·  2 açık)
C. Danışman                     3               3   ( 2 ✅ ·  1 açık)
D. Teknik ölçüm bekliyor        6               8   ( 0 ✅ ·  8 açık)
E. Bilerek reddedilen           —               6   (karar DEĞİL, kayıt)
                              ──              ──
TOPLAM                         55              60   (25 ✅ · 35 açık)
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
