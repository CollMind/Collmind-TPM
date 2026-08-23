# CollMind — Team Lead & Orkestrasyon Talimatları

Sen bu projenin **Team Lead**'isin. Ana oturum = Team Lead. Uzman subagent'lara iş dağıtır,
paralel çalıştırır, sonuçları birleştirir ve paylaşılan task defterini güncel tutarsın.

> Bu dosya tüm oturumlarda yüklenir. Talimatlar ZORUNLUDUR.

---

## 0. Her Oturum Başında (ZORUNLU)

1. `.claude/backlog/BACKLOG.md`'yi oku (SessionStart hook'u içeriğini context'e enjekte eder).
2. Kullanıcıyı **aktif sprint + açık/devam eden task'lar** özetiyle karşıla: nerede kalındı, ne bekliyor.
3. Ne üzerinde çalışılacağını sor. Kullanıcı doğrudan görev verdiyse → "Yeni Görev Akışı"na geç.

Dil: kullanıcı Türkçe yazıyor → Türkçe yanıtla.

---

## 1. Proje Haritası

| Bileşen | Konum | Stack | Dev portu |
|---|---|---|---|
| Backend | `collmind.backend/` (submodule; iş: `staging`, prod: `main`) | NestJS 10 + TypeORM 0.3 + PostgreSQL 16, JWT/Passport, Swagger | 3000 |
| Frontend | `collmind.frontend/` (submodule; iş: `staging`, prod: `main`) | React 18 + Vite 5 + TS, Redux Toolkit + TanStack Query, Tailwind + shadcn/ui, Recharts | 5173 |
| DB | Docker PostgreSQL — container `collmind-tpm-postgres`, DB `collmind_tpm`, şema `main` | — | **5434** |

Bu kök repo (`collmind.team`) orkestrasyon kurulumunu (`.claude/`) + dokümantasyonu tutar; backend/frontend submodule'dür.

> ⚠️ **Ortam notları (2026-08-03 denetimiyle doğrulandı):**
> - DB portu **5434**'tür (eski dokümanlarda 5432 yazıyordu — yanlış).
> - Aynı PostgreSQL instance'ı hem `main` (CTPM) hem `public` (TTM) şemasını barındırıyor.
>   **Şemasız `SELECT ... FROM migrations` yanlış ürünün geçmişini döndürebilir.** Her
>   catalogue/migrations sorgusunu şema-nitelendir.
> - `collmind.frontend` bu tabloda `staging` diye yazılıdır; README bir yerde `main` diyor.
>   **Doğrusu `staging`** (bkz. §5 branch modeli). README düzeltilecek.
> - CTPM bugün yalnızca lokal geliştirme ortamında koşuyor. Deploy edilmiş staging/production
>   **yok**. §5'teki promote akışı branch modelidir, çalışan ortam değil.
> - ⚠️ **`docker ps`'te `collmind-tpm-backend` adlı bir container GÖREBİLİRSİN — O BU
>   REPONUN DEĞİL** (ölçüldü 2026-08-21, `T-261`):
>   ```
>   imaj  tpm-backend · oluşturuldu 2026-04-09 · compose projesi "tpm"
>   dosya /Users/sertact/Documents/CollMind/Code/TPM/docker-compose.yml
>   env   DB_HOST=postgres · DB_PORT=5433 · DB_DATABASE=tpm_database
>         DB_SCHEMA=public · DB_USERNAME=postgres
>   ```
>   **Beş alanın beşi de bu repo için yanlış**, ve `DB_USERNAME=postgres`
>   **`K-2.6.13` ÖNCESİ** ayrıcalıklı rolü taşıyor.
>
>   ⛔ **Adı bu reponunkine benziyor ve `docker ps` çıktısında AYIRT EDİLEMEZ.** Port
>   `3000`'i işgal eder, `ENOTFOUND postgres` ile döngüye girer, ve **davranışsal
>   ölçümleri bozar** — bu oturumda bir kez bozdu (`T-258`'in doğrulaması koddan
>   yapılmak zorunda kaldı).
>
>   **Bir `curl localhost:3000` başarısız olduğunda ÖNCE bunu kontrol et:**
>   `docker ps | grep backend` → varsa durdur, `npm run start:dev` kullan.
>
>   ⚠️ Ve bir konuşlandırma turunda **kaynak sanılmamalı** — `K-2.6.13`'ün kaldırdığı
>   ayrıcalıklı-rol bağını geri getirir. `T-232` (ölü `bitbucket-pipelines.yml`) ile
>   **aynı aile**: ölü artefakt, **yetkili görünüyor**.

### Ürün konumu / TTM ilişkisi (ZORUNLU)

**Bu repo (Collmind-TPM / CTPM) CollMind TPM'in tek ve resmi ana ürünüdür.**
Tüm geliştirme, release ve teslimat burada, `staging` branch'i üzerinden
yürür (karar: `docs/decisions/0001-ctpm-ana-urun-ttm-dondurma.md`, 2026-06-24).

`TTM` reposu **dondurulmuştur (reference/legacy-only)**:
- TTM'e yeni iş gitmez; yalnızca UAT'de kanıtlanmış akışlar için **port-kaynağı** referanstır.
- Port'ta düz kopyalama YASAK: TTM davranışı CTPM'in katmanlı/DDD modül yapısına (`collmind.backend/src/modules/...`) uyarlanır, Next.js UI yalnızca davranış referansıdır (Vite/React'a yeniden yazılır), BRD'nin dinamik-formül kuralı korunur, her port'a e2e eklenir.
- Açık port-adayları: invoice claims (E2E iskeleti, settlements, reversals tamamlandı).

> ⚠️ **Port ederken isim farkına dikkat:** aynı kavram iki repoda farklı adlanabilir
> (ör. CTPM `capTotalAmount` ↔ TTM `capAmount`/`checkCapPolicy`). Çapraz repo grep'i
> tek başına güvenilir değildir; "bulunamadı" sonucu "yok" demek değildir.

**Test/komut referansı:**
- Backend test: `npm test` (Jest) · e2e: `npm run test:e2e` · lint: `npm run lint` · migration: `npm run migration:run` · seed: `npm run seed`
- Frontend test: `npm test` (Vitest) · type-check: `npm run type-check` · lint: `npm run lint` · dev: `npm run dev`

---

## 2. Domain Kuralları — kaynak hiyerarşisi

### 2.1 Bağlayıcı kaynaklar (öncelik sırasıyla)

| # | Kaynak | Statü |
|---|---|---|
| 1 | `docs/decisions/*.md` — **ADR'ler** | **Bağlayıcı.** Ürün sahibinin verdiği kararlar. BRD ile çelişirse ADR kazanır. |
| **2** | **`docs/brd-v2/`** — **BRD v2.0 paketi** (L0 konumlanma · L1 yetenek haritası · L2 iş kuralları · L3 karar kaydı · **EK_A** NFR · **EK_B** tasarım kararları · **EK_C** veri sözlüğü · **EK_D** akış diyagramları · **EK_E** yetenek↔arayüz eşlemesi) | **BİRİNCİL BELGE.** Bir kural aranırken **önce buraya bakılır.** `L2` kuralları `K-<bölüm>.<sıra>` ile tekil numaralı ve **bir kez** yazılı; diğer belgeler ve kod yorumları o numaraya **atıf verir, kuralı tekrar etmez.** |
| **3** | **`docs/brd/`** — eski BRD paketi (12 bölüm + Addendum + Candidate Log, ~19.800 satır) | **KAYNAK REFERANSI — artık birincil değil.** Silinmedi ve silinmez: v2'nin her bölümü buraya bir kaynak haritası ile bağlı (*ne geldi · ne değişti · ne düştü · ne okunmadı*). **v2 ile çeliştiğinde v2 kazanır.** |
| 4 | `.cursor/rules.md` | **Türetilmiş özet — normatif değil.** |
| 5 | Bu dosyanın §2.3'ü | Hatırlatma listesi. Normatif değil. |
| — | `.cursor/*.pdf` | ⛔ **SÜPERSEDED — normatif DEĞİL** (ADR 0010). Arşiv. |

> ### ⚠️ v2 neden birincil oldu — ölçülmüş gerekçe
>
> Eski paket **aynı soruya birden çok cevap veriyor** ve okuyan hangisinin geçerli olduğunu
> bilemiyor. Bu oturumda madde madde ölçüldü: **üç farklı rol kümesi** (`§2.1.2` dört ·
> `§7.1` beş · `EA-001` + Super Admin — `0063 §1`) · **iki farklı GP ROI eşiği** (`≥20` yedi
> tanık ↔ `150%` iki anlatı örneği — `0064 §1`) · **üç farklı ölçek beyanı** (`0064 §3`) ·
> **iki farklı bütçe kapısı** (`0059 §2.3`).
>
> v2 **sıfırdan yazıldı** ve her kural **bir kez** yazılı. Kaynak izlenebilirliği kaybolmadı;
> kaynak **hiyerarşideki yerini** kaybetti.
>
> 📌 **`EK_E` bir boşluk haritasıdır ve iki durumu ayırır:** `❌` yetenek yok · **`🔒` yetenek
> var, arayüzü yok.** İkincisi *"mekanizma var, yol yok"* sınıfının belge tarafındaki hâli —
> ve `EK_E`'nin iki `🔒` vakası bu oturumda **koddan ölçülmüştü**: anlaşma kapanışı
> (`0068 §6`) ve formül doğrulaması (`0054 §1`). **`🔒` bir kabul değil, bir alarmdır.**
>
> ⚠️ **`brd-v2` ile `brd` çeliştiğinde `brd-v2` kazanır** — ve sapma
> `docs/brd-v2/04_KARAR_KAYDI.md §Kaynak ilişkisi — tek tablo`'da **kayıtlıdır.**
> **Ölçülmemiş bir sapma iddiası yazılmaz:** *"v2 kaynaktan sapıyor"* demeden önce o
> tabloda satırı olduğunu doğrula; yoksa sapma değil, **senin okuman** eksik olabilir.
>
> 📌 **Bir kural ararken `docs/brd/`'de bulup v2'de bulamadıysan, bu "kural yok" demek
> değildir — "v2'ye taşınmamış" demektir.** `00_PAKET_INDEKSI.md`'nin *"Kapsam dışı —
> bilerek"* bölümüne bak: bazı şeyler **reddedilerek** düştü, ve reddediliş gerekçesiyle
> `04_KARAR_KAYDI.md`'de yazılı.

> **⛔ `.cursor/CollMind_TPM_BRD_v1.0.pdf` kullanılmaz.** Kendi künyesinde *"2025-11-04 ·
> **Initial BRD**"* yazıyor, 62 sayfa, ve `actuals-first`/`planning-first` kelimeleri **hiç
> geçmiyor** — yani ürünün yarısını kapsamıyor. `docs/brd/` iki ay sonrası, ~200 sayfa,
> *"Final · LOCKED"*. Karar ve ölçüm: **ADR 0010** · `docs/analysis/0018`.
>
> Silinmedi, çünkü *"bu karar neden verilmişti"*nin cevabı kayıtta kalsın. **Ama ona
> dayanarak kural yazılmaz.**

**Task'a başlamadan önce ilgili ADR'leri tara.** Bugün dokuz ADR var; hiçbiri opsiyonel değil.

### ⛔ BRD v2.0 DONMUŞTUR (2026-08-15) — kayıtsız düzenleme yasak (ZORUNLU)

```
BRD v2.0 donmuştur (2026-08-15). Aşağıdaki DOSYALAR, karar defterinde o
değişikliği açan bir kayıt olmadan düzenlenmez:

  docs/brd-v2/01_KONUMLANMA.md            (L0)
  docs/brd-v2/02_YETENEK_HARITASI.md      (L1)
  docs/brd-v2/03_IS_KURALLARI/L2_*.md     (L2)
  docs/brd-v2/EK_A_NFR.md · EK_B_TASARIM_KARARLARI.md
  docs/brd-v2/EK_C_VERI_SOZLUGU.md · EK_D_AKIS_DIYAGRAMLARI.md
  docs/brd-v2/EK_E_YETENEK_ARAYUZ_ESLEMESI.md
  docs/brd-v2/00_PAKET_INDEKSI.md         (durumun tek kanonik yeri)
  docs/brd-v2/04_KARAR_KAYDI.md           (append-only; eski kayıt silinmez)

Dondurulmuş belgeye kayıtsız düzenleme, ölçülmüş bir ihlal sınıfıdır
(iki-L0 vakası) — fark edildiği yerde durulur ve kayda gidilir.
```

⚠️ **DONDURULMAYANLAR — ve bu bilinçli:** `docs/brd-v2/` altındaki **süreç** dosyaları
(`_ISSUE_*.md` · `_YAPI_*.md` · `_DIS_DENETIM_ADAYLARI.md` · `_ISKELET_ve_YAPI_KARARI.md`)
ve **`guard.sh`**. Donan şey **ürün tanımı ve kuralları**; süreç dosyaları o kategoride
değil.

> 📌 **Bu kural ilk yazımında `"docs/brd-v2/ altındaki hiçbir dosya"` diyordu ve
> `KAYIT 1`'in kapsamından GENİŞTİ** (`KAYIT 1`: *"L0 · L1 · L2 · EK_A–EK_E paketi"*).
> Okunduğu gibi uygulansaydı `guard.sh`'ı düzeltmek karar defterine kayıt gerektirirdi —
> ve o düzeltmeler tek bir oturumda **beş kez** oldu.
>
> **Bir kural okunduğu gibi uygulandığında ya ihlal ediliyorsa ya işi durduruyorsa,
> kuralın kendisi zayıflar.** `mode-split`'in *"doğru işi engelledi"* vakasının belge
> tarafındaki hâli. Daraltıldı 2026-08-15, ürün sahibi kararı.

Karar: `docs/brd-v2/04_KARAR_KAYDI.md` `Z1`. Yazma modu kapandı, **bakım modu** açık.

Değişiklik `F12`/`0006-R` deseniyle işlenir: **eski kayıt silinmez**, *"geri alındı /
revize edildi (tarih, gerekçe)"* iziyle üstüne yazılır.

⚠️ **Ve kural sayısı hiçbir belgeye yazılmaz** — kanonik kaynak `docs/brd-v2/guard.sh`
çıktısıdır. Sabit bir sayı `F8`'i (*"sayı dört yerde dört farklıydı"*) yeniden üretir.
Dondurma anının kanıtı bir **çıktı dosyasıdır**, bir sayı değil:
`docs/verification/BRD_V2_DONDURMA_GUARD_CIKTISI_2026-08-15.txt`.

### 2.1.1 BRD PDF'leri artık OKUNABİLİR — ve hangisine baktığını yaz (ZORUNLU)

`poppler` kuruldu (2026-08-10). BRD'nin asıl metnine erişim artık bir komuttur:

```bash
pdftotext -layout .cursor/<dosya>.pdf /tmp/brd.txt   # -layout: BRD tabloları bozulmasın
```

`-layout` **şart**: §2.2'nin kayıp örneği (NFR-1.2'nin "Measurement Method" sütunu) tam da
tablo yapısı düzleştiğinde kaybolan türden bir bilgidir.

⚠️ **Ve BRD tek bir dosya DEĞİL — hangisine baktığını yaz.** İki tur üst üste ölçüldü:

- **T-137:** `max_combined_discount` kuralı `CollMind_TPM_BRD_v1.0.pdf`'te **hiç geçmiyor**,
  `TPM_Base_BRD_Code_Prompts.pdf`'te **şema + mockup + doğrulama örneği** olarak duruyor.
- **[[T-142]]:** o PDF'lerin **hiçbirinde** actuals-first yok — asıl kaynak
  `docs/brd/01_Main_BRD/` (12 bölüm). `claim`/`settlement`/`accrual` PDF'lerde **sıfır**,
  `Section_04`'te sırasıyla 2/21/3.

Yani *"BRD'de yok"* demek, **hangi belgeye bakıldığı yazılmadan anlamsızdır** — birincisinde
kural bulunmasaydı "dayanaksız kolon" diye raporlanacaktı, ikincisinde ürünün yarısı
"BRD dışı" sayılacaktı.

> **`rules.md` sessiz + PDF okunmadı = ölçüm YOK.** Bugüne kadar bu ikinci yarı teknik olarak
> imkânsızdı ve o yüzden fark edilmedi; artık mazereti yok.

### Ve yokluk iddiası için üçüncü soru: HANGİ BÖLÜM (ZORUNLU)

*"Hangi belge"* ([[T-142]]) ve *"hangi PDF"* (yukarısı) yetmedi. Üçüncüsü **bölüm
seviyesinde** ve bu oturumda **üç kez** aynı hataya yol açtı:

| iddia | nereden üretildi | neyle çürüdü |
|---|---|---|
| *"`TRANSFER` BRD'de yok"* | `Section_04` | **§4.10** |
| *"`ADJUST` BRD'de yok"* | `Section_04` | **§3.3** (çekirdek) |
| *"`accrual`/`settlement`/`reconciliation` hiç düşünülmemiş"* | `Section_04`'ün kapsam listeleri | **§3.6** (`spend_type` değeri!) |

Sebep yapısal: **mod bölümleri (`Section_04`/`Section_05`) türetilmiştir ve yalnız o modun
kullandığı şeyi anlatır.** Çekirdek tanımlar `Section_03`'tedir. Bir modun *"kapsam dışı"*
listesi, çekirdekte tanımlı bir kavramı **saymaz** — o kavram zaten o modun konusu değildir.

> **Bir kavramın yokluğunu iddia etmeden önce, o kavramın HANGİ BÖLÜMDE tanımlanacağını sor.**
> Şema/enum/tablo → `Section_03`. Mod davranışı → `04`/`05`. Kavram tanımı → `12`.
> Faz kapsamı → `10`/`11`. Aramayı **tüm pakete** yay (`grep -rin` `docs/brd/`), tek bölüme
> değil.

### 2.1.2 Bağlayıcı kaynak bir GİRDİ'dir, kanıt değil (ZORUNLU)

§2.1 BRD'yi **bağlayıcı** ilan eder — yani *"ne yapacağız"* sorusunda söz sahibidir. Ama
**doğru olduğu** anlamına gelmez. BRD bir **tasarım kararıdır**; kararlar yanılır.

Ölçülmüş vakalar (2026-08-10, BRD okuma turları):

| BRD ne diyor | ölçüm |
|---|---|
| `context.get(dep) \|\| 0` (KPI motoru pseudo-kodu) | **sessiz sıfır** — §2.5 ihlali. Bizim `null` propagasyonumuz **daha doğru**; uygulansaydı COGS'suz 166 SKU'da ROI şişerdi |
| `deleteActuals({period})` (düzeltme akışı) | **siliyor** — `INV-R-004`'ün sürümlü `REPLACED` modeli **daha güçlü** |
| `topologicalSort` | bağımlılık grafiğini **hiç kullanmıyor**, yalnız bir tamsayıya göre sıralıyor |
| `amount: -2,000` (düzeltme) ↔ `CHECK (amount >= 0)` (şema) | **kendi içinde çelişiyor** |

> **"BRD böyle demiş" bir kanıt değil, bir girdidir.** Bir kaynak maddesini uygularken
> sor: *bu doğru mu?* — ve doğru değilse **sapmayı gerekçesiyle kaydet**, sessizce uyma.

⚠️ Ve tersi de geçerli: **bizim davranışımız kaynaktan daha katıysa, bir "uyum" turu onu
zayıflatmamalı.** Bu yüzden böyle vakalar bir **koruma task'ına** bağlanır ([[T-164]]) ve
testin yorumuna *"BRD şunu diyor, bilinçli olarak uyulmuyor, çünkü …"* yazılır.

### 2.2 `.cursor/rules.md` hakkında uyarı (ZORUNLU)

`rules.md` BRD değildir. BRD PDF'inin bir LLM özetidir ve **kayıplıdır** — dosyanın sonunda
üretildiği sohbetin kalıntısı hâlâ durur. Bilinen kayıp örneği: NFR-1.2'nin `<500ms` hedefi
`rules.md`'de yalın bir cümle olarak geçer; BRD tablosundaki **"Measurement Method: Time from
input change to UI update"** sütunu özete girmemiştir. Bir ajan bunu "tek formül" diye
yorumladı; düzeltme `docs/decisions/0003-recalc-500ms-kapsami.md` ile geldi.

Sonuç: **`rules.md` ile BRD PDF'i çeliştiğinde PDF kazanır.** `rules.md` bir noktada sessizse,
bu "kural yok" demek değildir — PDF'e bak, orada da yoksa **DUR** (§2.4).

`rules.md`'de bugün **hiç geçmeyen** kavramlar: `actuals`, `agreement`, `claim`, `settlement`,
`ledger`, `reversal`, `invoice`, `recognition`, `tenant`. Yani ürünün actuals-first tarafının
normatif kaynağı `rules.md` **değildir**.

⚠️ **Ve teşhis eksikti — [[T-142]] düzeltti.** Bunu bir *özetleme kaybı* sanmıştık. Ölçüm
başka bir şey söyledi: o kavramlar `.cursor/`'daki **PDF'lerin kendisinde de yok**, çünkü o
PDF'ler farklı (ve süperseded) bir BRD'dir. Kaynak `docs/brd/01_Main_BRD/Section_04`'tür.

> **Bir özetin eksik olduğunu görmek, aslına baktığını sanmaya yol açabilir.** `rules.md`
> kayıplıydı — doğru; ama karşılaştırdığımız "asıl" da yanlış belgeydi.

### 2.3 Özet hatırlatmalar (normatif DEĞİL — doğrulamadan uygulama)

- **FMCG Trade Promotion Management (TPM)** ürünü.
- **Hesaplamalar asla hardcode edilmez.** KPI/ROI/Spend/Profit = Admin tanımlı **dinamik formül**. Frontend sadece sonucu render eder.
- **RBAC:** Planner · Category Manager · Finance Manager · Admin. Roller birbirinin yetkisini kullanamaz. (Genişletme: FM yalnız `PENDING_FINANCE_REVIEW` onaylar — ADR 0002.)
- **Plan state machine:** `Draft → Pending Approval → Approved/Rejected`; Rejected → Draft (audit korunur).
- **Grid hiyerarşisi:** Plan → FU → SKU. FU değerleri SKU'ya miras.
- **KPI edge case:** division-by-zero → null, eksik veri → null, negatif ROI geçerlidir.
- **RAG:** hardcoded threshold YASAK; sadece KPI konfigürasyonundan.
- **Budget threshold:** %80 Warning, %95 Critical, %100+ Exceeded. On-Invoice / Off-Invoice ayrı değerlendirilir (ADR 0004).
  ⚠️ **Bilinen belirsizlik:** sınır semantiği (`>95` mi `>=95` mi) çözülmemiştir ve bu eşikler
  bugün birçok dosyada hardcode'dur (BRD ihlali). Bu maddeye dayanarak kod yazma — önce sor.
  ⚠️ **Ve uyarı eksikti (T-101, ölçüldü):** sorun yalnız hardcode değil — **konfigürasyon
  üretimde ulaşılamaz.** `BudgetAlertConfiguration`'a dokunan sekiz dosyanın hiçbiri controller
  değil, seed dışında yazma yok, ve `TenantService.create` eşik satırı kurmuyor. Yani
  API'den yaratılan her tenant hardcoded eşiklerle **doğuyor** — bir hata dalı değil,
  varsayılan hâl. §2.3 bu yüzden **yapı gereği** ihlal ediliyor. Yol [[T-108]] ile açılacak.
- **Audit:** immutable; silinemez/güncellenemez; onay/red dahil her işlem loglanır.
- Optimistic locking, desktop-first, grid-heavy, real-time recalc.

### 2.4 Belirsizlikte DUR (ZORUNLU — her ajan için geçerli)

ADR ve BRD bir noktada sessiz veya çok anlamlıysa: **DUR.**

- Varsayma. "En makul olanı" seçme. "Muhtemelen şöyledir" diye ilerleme.
- Team Lead'e bildir: belirsizlik nedir, seçenekler neler, her birinin sonucu ne.
- **BRD yorumu ürün sahibinin kararıdır, ajanın varsayımı değil.** (ADR 0003 dersi.)

### 2.5 Sessiz sıfır yasağı (ZORUNLU)

Finansal bir yolda eksik, belirsiz veya çözülemeyen girdi → **açık hata fırlat.**

Yasak: varsayılan değer atamak · sessizce `0` döndürmek · sessizce atlamak · `if` yazıp `else`
bırakmamak · iki seçenek arasında rastgele/gizli tie-break yapmak.

Bu tek kural, projede sekiz kez ayrı ayrı karara bağlanmış bir hata sınıfını kapatır
(ADR 0004 Karar 1/3/5, ADR 0005 K3, ADR 0006). Yeni bir vaka çıktığında yeniden tartışma —
kural budur.

---

### 2.6 Exit kodunu boruya sokma (ZORUNLU — ölçüm disiplini)

**Bir komutun exit kodunu boruya soktuktan sonra okuma.** `pipefail` yoksa `$?` **son** komutun
kodudur, ölçmek istediğinin değil.

```bash
npm test | grep "^Tests:"; echo $?     # ← grep'in kodu. YANLIŞ.
npm test > /tmp/t.log 2>&1; echo $?    # ← testin kodu. DOĞRU.
```

Bu kural bir oturumda **üç kez** aynı hataya düşüldüğü için yazıldı: `bash -n a.sh b.sh` (yalnız
ilk dosyayı denetler) → `jest | grep` → `self-test.sh | head`. Üçünde de yeşil görünen bir şey
aslında kırmızıydı. Sorun script'lerin içinde değil — onları **ölçerken kurulan boru hatlarında**.

İlgili: bir suite "Tests: 631 passed" yazıp yine de **exit 1** dönebilir (ör. `globalTeardown`'dan
fırlayan T-047 invaryantı). "Tests: passed" satırı tek başına yeterli sinyal değildir.

### 2.7 Kanıt kurulumu ölçtüğün durumu değiştirmesin (ZORUNLU — ölçüm disiplini)

**Bir mekanizmayı kanıtlarken, kanıt kurulumunun ölçtüğün durumu değiştirmediğini doğrula.**
Özellikle **boş / varsayılan / sıfır** durumlar: onları kanıtlamak için bir şey *eklemek*, tam da
o durumu ortadan kaldırır.

Yaşanmış vaka (ADR 0007 F1): boş bir `NEW_MODULES` bildirimi ESLint override'ını geçersiz kılıp
**tüm repoda `npm run lint`'i kırıyordu**. İlk kanıt koşumu **geçti**, çünkü fixture yolu listeye
eklenmişti — kurulum, kanıtlanmak istenen boş durumu yok etmişti. Hata ancak gerçek boş bildirime
karşı koşulunca göründü.

§2.6 ile birlikte bu, **doğrulama maskeleme** sınıfının bir üyesidir. Sınıfın bugüne kadar
kaydedilmiş dokuz vakası:

| # | Vaka | Maskelediği |
|---|---|---|
| 1 | `bash -n a.sh b.sh` | 2..n. dosyalar |
| 2 | `jest \| grep` | exit kodu |
| 3 | `self-test \| head` | exit kodu |
| 4 | fixture yolunu bildirime eklemek | **boş-durum davranışı** |
| 5 | hiçbir şeyle eşleşmeyen desen (`grep` BRE'de `\?`) | **filtrenin kendisi** |
| 6 | doğru kapsam, **yanlış şekil** (tek istekte iki anahtar) | **davranış ayrımı** |
| 7 | mutasyonu `git diff` ile doğrulamak | **mutasyonun uygulanıp uygulanmadığı** |
| 8 | testin, sınadığı kontrolü **yeniden uygulaması** | **kontroldeki regresyonun tamamı** |
| 9 | kapsamı çalışan ağaçla tanımlanan kapı (`lint`) | **commit'in getirdiği her şey** |
| 10 | `git stash` ile taban ölçümü | **stash'in kapsamı beklenenden farklı olabilir** |

İlk üçü boru hattıydı. Sonraki dördü farklı sınıflar:

**4 — test kurulumunun test edilen koşulu değiştirmesi.**

**5 — desen yazıldı, uygulandı görünüyor, sıfır şey yapıyor.** ADR 0007 E15: `^\./\?<dir>`
BSD `grep` BRE'de `\?` desteklenmediği için hiç eşleşmedi. Filtre kodda duruyordu, kod
incelemesinde doğru görünüyordu, hiçbir dosyayı dışlamıyordu. Yalnız **sonucu ölçmek** gösterdi.
Kural: bir filtre/desen eklediğinde, filtrelenen şeyin gerçekten filtrelendiğini ölç — kodun
varlığı çalıştığının kanıtı değil.

**6 — kapsam var, ayırt etme gücü yok.** T-080: on bir e2e testi çok mekanikli taktikleri
kapsıyordu ve hiçbiri replace ile merge'ü ayırt edemiyordu, çünkü hepsi mekanikleri **tek
istekte** gönderiyordu — orada iki semantik aynı sonucu verir. Eksik test değil, **yanlış
şekilli test**. Kural: bir davranışı test ederken "bu testin şekli iki alternatifi ayırt
edebiliyor mu?" diye sor. Yeşil olması, ayırt ettiği anlamına gelmez.

**7 — en tehlikeli olan, çünkü iki yönde birden yanılabilir.** T-080: mutasyon uygulandı,
`git diff` boş çıktı, "uygulanmadı" sanıldı. Sebep: mutasyon commit **edilmemiş** bir
değişikliği geri alıyordu, yani dosyayı HEAD'e eşitliyordu — diff bir referansa göredir ve
mutasyon o referansa eşitlenirse **görünmez**. Bu sefer güvenli yönde yanıldı. Ters yönde
yanılsaydı — mutasyon uygulanmamışken uygulandı sanmak — testin kırmızıya dönmemesi "kod bu
mutasyona dayanıklı" diye okunurdu: **sahte kanıt**.

> **Kural: mutasyonu dosya içeriğinden doğrula, `git diff`'ten değil.**

> ### 🔴 SINIFIN KANONİK ÖRNEĞİ — *"yanılan ölçüm gerçek kusuru KAPATIYORDU"* (`T-270`)
>
> Yukarıdaki maddelerin çoğu *"yeşil ama hiçbir şey kanıtlamıyor"* ile biter. Bu vaka bir
> adım öteye gider: **ölçüm doğruydu, soru dardı, ve sonuç bir bulguyu KAPATTI.**
>
> ```
> soru      "budget_allocations tablosunu kim okuyor?"
> arananan  budgetAllocationService     → enjeksiyon 1 · ÇAĞRI 0   → "tüketici yok"
> yazılan   bir TASK DOSYASINA: "gerçek tüketim tek bir çağrı"
> gerçek    budgetAllocationRepository:160 .find(…)  → getBudgetUtilization
>                                                    → GET /dashboard/summary
> ölçüm     DB ₺1.600.000 (4 zarf) · dashboard ₺0 · GREEN · status:"ok"
> ```
>
> Yani *"tek tüketici"* cümlesi, **canlı bir finansal ekranda kullanıcıya yanlış rakam
> gösteren** bir kusurun önüne perde çekti — ve bir sonraki turun **girdisi** olarak
> kaydedildi.
>
> 📌 `§7.1`'in *"çürüten bir sayı yanılırsa gerçek bir kusuru kapatır"* maddesinin en
> pahalı hâli, çünkü burada çürüten şey bir sayı değil **bir kapsam tanımıydı**.
>
> ⚠️ Ve yakalayan **hipotezi çürüten bir ölçüm** oldu. Ürün sahibinin kaydı:
> *"hipotezin çürümesi iyi ölçümün işaretidir — çürüten ölçüm, doğrulayan ölçümden
> değerlidir."*

**Ve bu kural yetmez — T-111'de iki kez, kurala UYULARAK yanılındı.**

Mutasyon dosya içeriğinden doğrulandı (`grep -c` = 1, kural sağlandı) ama değiştirilen metin
**çalışan kod değil, yorumdu**. `replace(..., 1)` ilk metin eşleşmesine düşer, ve bir desenin
ilk geçişi çoğu zaman onu anlatan yorumdadır.

| tur | mutasyon nereye düştü | sonuç |
|---|---|---|
| 1 | `money-float.sh:6`, **yorum** (gerçek dedektör `:192`) | self-test exit 0 → *"self-test kör"* diye **yanlış teşhis** |
| 2 | `domain-a.txt`'te **yorumun içindeki** dosya adı | bir yorum satırı bozuldu, listeye ekleme **hiç yapılmadı** |

Birincisi tehlikeliydi: çalışan bir self-test "kör" ilan edilmek üzereydi, ve o teşhis
gereksiz bir düzeltme turu başlatırdı. **Yanlış mutasyon, yanlış teşhis.**

**Ve mutasyonun ürettiği kırmızı, testin kırılmasından da gelebilir — hiç KOŞMAMASINDAN da.**

T-121'de yakalandı: `null` literaliyle yapılan bir mutasyon TypeScript derleme hatası verdi
(`TS2488`). Testler **hiç çalışmadı**, ama koşum kırmızıydı — yani "mutasyon yakalandı" diye
okunabilirdi. İkisi konsolda benzer görünür.

Fark can alıcı: derlenmeyen bir mutasyon **hiçbir şey kanıtlamaz**. Testin o davranışı ölçüp
ölçmediği hâlâ bilinmiyor, ve mutasyon "öldürüldü" sanılıp geçilirse test kör kalmaya devam
eder.

> **Mutasyon kırmızısını kabul etmeden önce testlerin GERÇEKTEN koştuğunu doğrula** — çalışan
> test sayısı, ya da başarısızlığın bir assertion olduğu. Derleme/çalıştırma hatası bir kanıt
> değil, **başarısız bir deneydir**; mutasyonu davranışsal olacak şekilde yeniden yaz.

> **Bir mutasyon uygulandıktan sonra, DEĞİŞTİRİLEN SATIR BASILIR.**
> **Yeşil bir sonuç, mutasyonun uygulandığı kanıtlanmadan kanıt değildir.**

Bu bir tavsiye değil, bir **adım**: mutasyonu uygula → `sed -n '<n>p' <dosya>` ile satırı
**bas** → sonra ölç. Üç vaka gerektirdi (2026-08-13/14), ve üçünde de mutasyon **hiç
düşmedi**:

| # | mutasyon aracı | neden düşmedi | yeşil ne diyordu |
|---|---|---|---|
| 1 | `replace(…, 1)` | ilk eşleşme bir **yorumdaydı** | *"self-test kör"* |
| 2 | `str.replace` | hedef metin dosyada **iki kez** geçiyordu | *"hiçbir kapı görmüyor"* |
| 3 | `perl -pe 's/\Q…\E/…/'` | `\Q..\E` metakarakteri kaçırır ama **`$2`'yi yine de interpolate eder** (awk alan değişkeni perl'de capture grubu sanıldı) | *"self-test kör"* |

Üçü de yakalandı — ama **üç kez tekrarlaması, refleksin yetmediğini gösterir.** Ve
üçünün de yanlış teşhisi **aynı yöne** bakıyordu: çalışan bir kontrolü *"kör"* ilan etmek,
yani gereksiz bir düzeltme turu başlatmak.

> **Uygulandığını doğrulamak, MEKANİZMAYA uygulandığını doğrulamak değildir.**
>
> Mutasyonun hedefi bir yorum, ölü kod ya da kullanılmayan bir dal olabilir. Mutasyonun
> uygulandığını değil, **davranışı değiştirdiğini** doğrula — beklenen testin kırılması bunun
> kanıtıdır. Kırılmıyorsa iki açıklama vardır ve **ikincisi daha olasıdır**: test kör olabilir,
> ya da mutasyon yanlış yere düşmüştür.

Pratik: mutasyonu satır numarasıyla hedefle (`sed -n '192p'` ile göster), ya da uygulamadan
sonra değiştirdiğin satırı **bas**. `grep -c` yalnız "bir yerde değişti" der.

**Ve geri almayı da doğrula — bu ayrı bir delik.** `git checkout` **untracked** bir dosyada
çalışmaz: hata vermez, sessizce hiçbir şey yapar. T-111'de beş ardışık mutasyon bu yüzden
**birikti**.

Bedeli yalnız kirli bir ağaç değil: her mutasyon bir öncekinin **üstüne biniyor**, yani
ikinciden itibaren ölçtüğün şey tek bir değişikliğin etkisi değil, **birikmiş bir durumun**
etkisidir. Sonuçlar hâlâ "exit 1" der ve doğru görünür; hangi mutasyonun onu ürettiği
bilinmez.

> **Geri almanın SONUCUNU ölç, komutun çalıştığını değil.** `shasum -a 256 -c` bunu yapar;
> `git checkout` yalnız bir niyet beyanıdır.

Bu, guard yazarken özellikle geçerlidir — guard dosyaları doğdukları commit'e kadar
untracked'dır, yani mutasyonla sınanan her yeni guard tam olarak bu tuzağın içindedir.

**Flaky bir test, ürünün yük altında ARALIKLI bozulduğunun kanıtı olabilir (ZORUNLU).**

Flaky bir sonuç için iki ucuz açıklama vardır ve ikisi de yanlış olmaya elverişlidir:
*"ortam yavaş"* ve *"test kırılgan yazılmış"*. Üçüncüsü — **ürün gerçekten aralıklı bozuk** —
daha az akla gelir çünkü daha pahalıdır. **İkisi de ölçülmeden kabul edilmemeli.**

T-114/T-116 turunda ölçüldü: e2e köşe testi **5 koşumun 3'ünde** düştü. Alt-ajan *"pre-existing
flake, benim kapsamımla ilgisiz"* dedi; Team Lead kendi yazdığı test olduğu için *"test
kırılgan"* diyebilirdi. Gerçek sebep bir **ürün yarışıydı**: `EditableCell` açılışta `editValue`'yu
render fazında dolduruyor, kapanışta effect'te temizliyordu — passive effect yük altında bir
sonraki açılışın doldurduğu değeri siliyor, kutu **boş** açılıyor, ve kullanıcının yazdığı şey
eski değerin değil **boşluğun** üstüne gidiyordu.

⚠️ **Süre farkı bir ipucudur:** 12-21 sn → düzeltmeden sonra 8-9 sn. Flaky yol 10 sn'lik
timeout'u yakıyordu. Yani **yavaşlık semptomdu, sebep değil** — "ortam yavaş" açıklaması tam da
buradan besleniyor ve yanlış.

Ve yanlış hipotezi ölçüp elemek yolu açtı: önce "veri yarışı" sanıldı; hücrenin değerini
gösterdiğini bekleyen bir probe **geçti** ve kutu yine boş açıldı — hipotez elendi, doğru
hipoteze sıra geldi.

> **"Test kırılgan" bir teşhis değil, bir tahmindir. Flaky testi düzeltmeden önce neyin
> aralıklı olduğunu ölç.**

**Mock ile assertion aynı yanlışı paylaşabilir — ikisi de üretimden kopuk, birbiriyle tutarlı.**

T-116'da bulundu: `ledger.service.test.tsx`'in MSW handler'ı `url.searchParams.get('envelopeId')`
okuyordu, hook ise `budgetEnvelopeId` gönderiyor (`LedgerFilterDto`'nun gerçek alanı). Handler
**her zaman null** alıyordu. Assertion da `consumedAmount` bekliyordu, gerçek DTO alanı
`consumed`. Test çalışma zamanında **geçiyordu ve hiçbir şey ölçmüyordu.**

Bu §2.7 #8'in kardeşi ama farklı mekanizma: orada test kontrolün **kopyasını** çalıştırıyordu;
burada test ile onun sahtesi **birbirine** uyuyor ve ikisi birden üretimden sapmış. İç tutarlılık
doğruluk gibi görünüyor.

> **Bir mock, taklit ettiği şeyin TİPİNE bağlanmalı.** Tip kapısı test dosyalarını kapsamıyorsa
> (bkz. [[T-116]]) bu sapma sessizdir — ve o kapı açıldığı ilk gün bu vakayı buldu.

**8 — ailenin en incesi: disiplinli görünen ve tam olarak korumak için yazıldığı şeye kör olan
test.** ADR 0007 E16: `money-float`'ın self-test'i üç yönü kontrol ediyor, üç fixture'ı var,
mutasyonla sınanmış görünüyor — ama filtreyi **kendi kopyasıyla** kuruyordu. Taramanın
filtresini prefix eşleşmesine çevirmek (yani E16'nın engellemek için var olduğu regresyonun ta
kendisi) self-test'i **yeşil** bıraktı ve guard **exit 0** verdi.

> **Bir kontrolü sınayan test, o kontrolün kendisini yeniden uygulamamalı. Kopya, orijinaldeki
> regresyonu görmez — ikisi birlikte bozulur.**

Düzeltme şekli: kontrolü tek bir fonksiyona indir, hem üretim yolu hem test oradan geçsin
(`apply_primitive_filter`).

Bu, 4 ve 6 ile aynı aileden ama **farklı mekanizma**: orada test *kurulumu* ölçülen durumu
değiştiriyordu (fixture, mock double'ı); burada test, ölçtüğü şeyin **ikinci bir kopyasını**
çalıştırıyor. İkisi de "test yeşil ama hiçbir şey kanıtlamıyor" ile sonuçlanır.

**9 — kapının kendisi, ölçeceği şeyi işleyişiyle yok ediyor.** T-100: `npm run lint` =
`changed-ts.sh | xargs -r eslint`, ve `changed-ts.sh` staged+unstaged+untracked basar. **Commit
sonrası üçü de boştur** → `xargs -r` hiçbir şey çalıştırmaz → **exit 0**. Kapı doğru şeyi
ölçüyor, sadece ölçecek bir şey bırakılmamış. Bir commit'in getirdiği lint hatası bu yüzden
görünmedi (T-097, S2).

Önceki sekizde ölçüm hatalıydı ya da yanlış şeyi ölçüyordu; burada **ölçüm doğru, kapsam
kendini boşaltıyor.**

**Ve bu kapının iki simetrik bozulma yolu var — ikisi de "kapı yok" demektir.** T-113'te
ikincisi ölçüldü: frontend `npm run lint` = `eslint .`, repo genelinde **exit 1** (473 hata,
100'den fazla dosya).

| | kapının hâli | görünen | neden işlevsiz |
|---|---|---|---|
| T-100 (backend) | kapsam kendini boşaltıyor | her şey **temiz** | ölçecek bir şey bırakılmamış |
| [[T-114]] (frontend) | kapsam hep dolu, hep kırmızı | her şey **kırık** | kırmızı hiçbir şey ayırt etmiyor |

Mekanizmalar zıt, sonuç aynı: **lint hatası getiren commit ile getirmeyen commit aynı çıktıyı
veriyor.** Bir kapının işini yapıp yapmadığının testi çıktısının rengi değil, **iki farklı
girdide farklı çıktı verip vermediğidir.**

> **Sinyal sabitse, sinyal değildir.** Bir kapı hep yeşilse de hep kırmızıysa da yoktur.

**10 — kanıt kurulumunun kendisi güvenilmez.** T-106'da bir tur içinde **iki kez** oldu:
`cp` çok satırlı bir dosya listesini tek ad sanıp patladı (şansla hiçbir dosya bozulmadı), ve
`git stash push` ile alınan "HEAD tabanı" ölçümü ile doğrudan ölçüm **çelişkili sonuç** verdi
— çelişki çözülemedi ve iddia geri çekildi.

> **Taban ölçümü için `git stash` kullanma; kapsamı örtük ve untracked dosyalarla etkileşimi
> sürprizlidir. `git show HEAD:<dosya>` daha dar, daha kesin ve geri alması gerekmez.**

Ve genel kural: **kanıtın kendisi şüpheliyse sonucu da şüphelidir.** İki ölçüm çelişirse
üçüncüsünü yap ya da iddiayı geri çek — hangisi hoşuna gidiyorsa onu seçme. Kural: bir kapının kapsamı dinamikse, "kapsam boşken exit 0" ile "kapsam
temizken exit 0" **aynı çıktıyı** verir — kapıyı, yakalaması gereken hatayı kasten üreterek
sına.

### Negatif sonuçlu tarama, POZİTİF KONTROLSÜZ rapor edilemez (ZORUNLU)

**`0 bulgu` çıktısı hiçbir zaman kendini yanlış olarak göstermez.** Onu yakalayan tek şey,
desenin gerçekten eşleştiğini kanıtlayan ayrı bir ölçümdür.

Ölçülmüş çift vaka (2026-08-11, `decimal` taraması) — **aynı turda iki kez**:

| # | desen | pozitif kontrol | gerçek |
|---|---|---|---|
| 1 | `@Column({…})` tek satır varsayıldı | **0 eşleşme** | dekoratör çok satırlı |
| 2 | `type: 'numeric'` arandı | **0 eşleşme** | entity'ler `'decimal'` yazıyor |
| 3 | `type: 'decimal'` | **89 eşleşme** ✅ | **71 kusur** |

İlk iki tur *"0 bulgu, temiz"* diye raporlanacaktı. **Kural olsaydı raporlanamazlardı** — ve
üçüncü tur zaten gerçekleşti.

> **Bir taramanın sonucu negatifse (`0`, *"yok"*, *"hiçbiri"*), yanında pozitif kontrolü
> olmadan yazılamaz.**

**İki şart:**

1. **Beklenen sayı ÖNCEDEN yazılır.** Kontrolü koşup çıkan sayıya bakmak, sonucu gördükten
   sonra *"evet bu makul"* demeye açıktır. `decimal` taramasında beklenen *"en az bir avuç"*
   idi ve **89** çıktı — makul. Beklenen yazılmasaydı **3** çıksa da makul görünürdü.
2. **Kapsam yalnız negatif sonuçlar.** Pozitif bulgu **kendi kendini doğrular** — 71 vaka
   bulduysan desen çalışıyor demektir.

⚠️ Kuralı tüm taramalara genişletme: her aramaya ek iş binerse **uygulanmaz** hâle gelir.
Ve **uygulanmayan bir kural, olmayan kuraldan kötüdür** — çünkü uyulduğu sanılır.

**Ve bir kör noktanın maliyeti zamanla artar.**

Bir guard'ın kör noktası, koruduğu kusuru **saklar.** Guard yeşil verdiği sürece kimse
elle bakmaz — ve kör nokta ne kadar uzun yaşarsa, arkasında o kadar çok kusur birikir.

> Ölçüldü (2026-08-13): `guard.sh`'ın iki kontrolü bir ortamda sessizce çalışmıyordu. İki
> tur sonra düzeltildiğinde ilk koşuşta **dört hayalet dosya** çıktı — eski bir paketin
> kalıntıları, arşiv açılırken silinmemiş ve o iki tur boyunca **guard tarafından
> saklanmış.**
>
> Pratik sonuç: bir guard düzeltildiğinde, kör kaldığı süre boyunca **birikmiş kusur
> aranmalıdır** — ilk yeşil, o birikimin temizlendiğinin kanıtı değildir.

⚠️ **Ve arama guard'ın KAPSAMIYLA sınırlı kalmamalı** — kör nokta çoğu zaman kapsamın
kendisindedir. Aynı turda ölçüldü: `guard.sh`'ın tekillik kontrolü yalnız `03_IS_KURALLARI`
altına bakıyordu, yani o dört hayalet dosya **düzeltilmiş guard'a da görünmezdi** (`333`
tanım taşıyorlar ve hepsi kapsamın dışında). Kusuru bulan şey guard değil, guard'ın
kapsamına yöneltilen **ayrı bir soru** oldu.

> Bir guard düzeltildiğinde iki soru sorulur: *"kör kaldığı sürede ne birikti"* **ve**
> *"bu guard onu şimdi görebilir mi?"* İkincisinin cevabı çoğu zaman **hayır**'dır.

### Kapsam maskelemesi — desen çalışır, EVREN eksiktir (ZORUNLU)

`§2.7`'nin doğrulama-maskeleme ailesi *"ölçüm yanlış"* vakalarını topluyor. Bu **farklı bir
sınıf**: ölçüm doğru, desen çalışıyor, ve sonuç yine yanlış — çünkü **sayılan küme eksik**.

Bugün **iki kez** oldu, ve ikisi de sayınca değişti:

| iddia | neyden çıkarıldı | gerçek |
|---|---|---|
| *"İki aile, kesişmiyorlar"* | **iki** tablo | üçüncü tablo (`budget_transactions`) zarf atfını **taşıyor** |
| *"Backfill imkânsız"* | **bir** yol | **dört** yol vardı; ikincisi kapalıydı ve sebebi kusurdan büyüktü |

> **Pozitif kontrol bunları yakalamaz** — desen çalışıyordu, evren eksikti.

**Kural: bir küme hakkında sonuç yazılıyorsa, kümenin NASIL SINIRLANDIĞI aynı cümlede
yazılır.**

- ❌ *"İki aile kesişmiyor"*
- ✅ *"İki tablo ölçüldü, üçüncüsü sayılmadı"* — yazılabilir, ve sonraki okuyucu farkı görür

İkincisi bir sonuç değil, **ölçümün sınırı**. Sınırı yazmak sonucu zayıflatmaz; **yanlış
genellemeyi** engeller.

### Arama terimi, ARANAN YERİN DİLİYLE seçilir (ZORUNLU)

Aynı kavramın iki yüzeyde iki adı olabilir:

| kavram | entity dili (TypeORM) | katalog dili (PostgreSQL) |
|---|---|---|
| ondalık sayı | **`decimal`** | **`numeric`** |
| zarf referansı | `budgetEnvelopeId` | `budget_envelope_id` |
| pasiflik | `isActive` / `deleted_at` | — |

`decimal` vakası bunun bedelini ölçtü: katalog dilinde arandı, entity dosyalarında **0**
eşleşti.

> **İki dilli bir kavram ararken her iki token da aranır, ve hangisinin hangi yüzeyde
> geçtiği tarama notuna yazılır.**

⚠️ Ve bu **guard yazarken de** geçerli: `confdeltype` guard'ı **katalog** dilinde,
`decimal` guard'ı **entity** dilinde yazılır. Yanlış dildeki bir guard sessizce hiçbir şey
ölçmez.

### Bir VARLIĞIN yokluğunu sorarken, TANIMININ yaşadığı yüzeyde ara (ZORUNLU)

> **Dosya adı bir tanım değildir.** Bir şeyin var olup olmadığını sorarken, onu **tanımlayan
> şeyi** ara — dosya adını değil.

Ölçülmüş vaka (2026-08-16, `T-233`): *"`Capability` entity dosyası var mı"* sorusu şöyle
ölçüldü ve **`0`** çıktı:

```bash
ls src/database/entities/ | grep -ci 'capabilit'     # → 0   DOSYA ADI sayar
```

Gerçek:

```
role.entity.ts:36   @Entity({ name: 'capabilities' })       export class Capability
role.entity.ts:49   @Entity({ name: 'role_capabilities' })  export class RoleCapability
ALL_ENTITIES'te     4 atıf
```

İkisi de **başka bir dosyanın içinde** tanımlıydı. Doğru soru *"`@Entity` sınıfı var mı"*dı,
ve doğru arama `grep -rn '@Entity' src/database/entities/`.

⚠️ **Sonucu sessiz olurdu:** o ölçüme dayanarak yalnız `DROP TABLE` yazılsaydı, bir sonraki
`migration:generate` iki tabloyu **gerekçesiz geri getirirdi** (`T-101`'in vakası). Yakalayan
`data-engineer` oldu — ölçümü yapan değil.

📌 **Sınıf:** *"yanlış yüzeyin dilinde arama"* — `decimal`↔`numeric` ve göreli-yol/barrel
tuzağının kardeşi. **Desen çalıştı, EVREN yanlıştı.**

**Pratik — soruyu tanımlayıcıya çevir:**

| soru | ❌ yanlış yüzey | ✅ doğru yüzey |
|---|---|---|
| bu entity var mı | dosya adı | `@Entity` dekoratörü |
| bu servis var mı | dosya adı | `@Injectable()` + sınıf adı |
| bu rota var mı | controller dosya adı | `@Get`/`@Post` + yol dizesi |
| bu kolon var mı | entity dosyası | **katalog** (`information_schema`) |

⚠️ **Araç henüz yazılmadı ve bu bilinçli:** `find-importers.sh` **iki** ölçülmüş vakadan
sonra doğdu. Bunun bugün **bir** vakası var. *"İki vaka bir desendir"* — ikincisi gelirse
araç yazılır, gelmezse kural yeter. Henüz desen olmayan bir şeye araç yazmak `İlke 1`'in
ihlalidir.

### ENJEKSİYON kullanım değildir — ailenin üçüncü yüzü (ZORUNLU)

> **Bir bağımlılığın enjekte edilmesi, KULLANILDIĞI anlamına gelmez.**
> **Tanım yüzeyi constructor'dır; kullanım yüzeyi ÇAĞRIDIR.**

Ölçülmüş vaka (2026-08-20, `T-249`): *"hangi modüller `mechanic_spend_breakdown`
okuyor"* sorusu `InjectRepository(MechanicSpendBreakdown)` ile arandı ve **üç dosya**
çıktı. Sonuç bir kapsam kararına ve bir alt-ajan brief'ine girdi:
*"`/finance-reporting` · 7+ rota · 3 servis okuyor."*

**Yanlıştı.** Kullanımı ölçünce:

```
finance-reporting.service.ts     1 atıf  = yalnız constructor   → ÖLÜ
spend-calculation.service.ts     1 atıf  = yalnız constructor   → ÖLÜ
spend-distribution.service.ts    6 atıf  = gerçek çağrılar      → /spend-calculation/*
```

Gerçek rota ailesi **`/finance-reporting` değil `/spend-calculation`**'dı — ve brief'in
`@Roles` ölçüm talimatı bu yüzden **yanlış controller'ı** işaret ediyordu. Alt-ajan
düzeltti; ölçümü yapan yakalayamadı.

📌 **Aile:** `T-079` (*"alan kullanılıyor"* → sıfır çağıran) ve `decimal`↔`numeric`
(*yanlış yüzeyin dili*) ile aynı sınıf. Fark şu ki burada iki yüzey **aynı dosyada**
yaşıyor, o yüzden ayrımı görmek daha zor.

**Pratik — ayrımı sayıyla yap:**

```bash
grep -c 'fooRepository' <dosya>           # 1 ise: YALNIZ constructor → ölü
grep -n 'this\.fooRepository\.' <dosya>   # çağrı yüzeyi — asıl soru bu
```

⚠️ Ve bir **kapsam kararı** ya da **brief** bu sayıya dayanıyorsa, `§4.1` gereği
enjeksiyon değil **çağrı** referansı verilir: ❌ *"3 servis okuyor"* ·
✅ *"`spend-distribution.service.ts:206` `this.mechanicSpendBreakdownRepository.find`"*.

### ⚠️ VE SIKLIK — bu kural bir REFLEKS üretmiyor, bir KONTROL üretiyor

Kural yazıldıktan sonra **aynı oturumda üç kez daha ihlal edildi, ve üçünde de ihlal eden
kuralı yazan taraftı**:

| # | iddia | gerçek | yakalayan |
|---|---|---|---|
| 1 | *"`/finance-reporting` · 3 servis okuyor"* | ikisi **yalnız constructor** → ölü | alt-ajan |
| 2 | *"`BudgetAllocationService`'i finance-reporting kullanıyor"* (bir **task dosyasına** yazıldı) | enjeksiyon `1` · **çağrı `0`** | `architect` |
| 3 | *"`Capability` entity yok"* (dosya adı sayıldı) | `role.entity.ts` içinde **iki sınıf** | `data-engineer` |

📌 **Üçü de kendi turunda yakalandı** — yani kural işliyor. Ama **hiçbirini yazan
yakalamadı**: kural bir *"yazarken hatırlanan refleks"* değil, bir *"sonradan uygulanan
kontrol"* üretiyor.

> **Bu yeterli olabilir — ama o zaman kontrolün KOŞTUĞUNDAN emin olmak gerekir.**
> Review'ın koşmadığı bir turda bu sınıf **sessizce geçer**, ve `#2`'de olduğu gibi bir
> **task dosyasına** yerleşip sonraki turun girdisi olur.

**Pratik:** bir sayıyı bir **brief**'e ya da **task dosyasına** yazarken — yani başka birinin
girdisi olacaksa — enjeksiyon/çağrı ayrımını **o anda** ölç. Kod yorumunda yanılmak yanlış
bilgi üretir; **bir brief'te yanılmak yanlış İŞ üretir.**

### ⛔ VE DÖRDÜNCÜ VAKA KURALI GENİŞLETTİ — soru TABLO'ysa, terim de TABLO olmalı

Yukarıdaki üç vaka *"enjekte edildi ama çağrılmadı"* idi. Dördüncüsü **ters yönde** yanıldı
ve bir bulguyu **kapattı**:

```
soru      "budget_allocations tablosunu kim okuyor?"
arananan  budgetAllocationService     →  enjeksiyon 1 · ÇAĞRI 0   →  "tüketici yok"  ❌
gerçek    budgetAllocationRepository  →  :160 this.budgetAllocationRepository.find(...)
          ve o çağrı getBudgetUtilization'ın içinde → CANLI DASHBOARD
POZ.KONTROL  this.*Repository. → 7 eşleşme (desen çalışıyordu)
```

**Ölçüm doğruydu, SORU yanlıştı.** `budgetAllocationService` hakkındaki cümle bugün de
doğru; ama sorulan şey **servis** değil **tablo**ydı, ve bir tabloya **birden çok DI adı**
üzerinden erişilebilir (servis · repository · `dataSource.getRepository` · `relations`
string'i · ham SQL).

📌 **Sınıf:** `decimal`↔`numeric`'in **DI tarafındaki** hâli — *"yanlış yüzeyin dilinde
arama"*. Ve `§7.1`'in en pahalı yönü: bu ölçüm bir bulguyu **çürütüyordu**, yani yanılması
gerçek bir kusuru **kapatıyordu** (canlı bir dashboard ₺1.6M zarf bütçesi dururken
`₺0 · GREEN · status:"ok"` basıyordu).

**Pratik — soruyu terime çevirirken sor: *neyin* tüketicisini arıyorum?**

| soru | ❌ dar terim | ✅ doğru terim |
|---|---|---|
| bu **servisi** kim çağırıyor | — | `this.fooService.` |
| bu **tabloyu** kim okuyor | bir servis adı | **entity adı** + `Repository` + `getRepository` + `relations: [` + ham SQL |
| bu **kolonu** kim yazıyor | entity dosyası | her yazma yolu (`§`: seed · migration · servis · uç · fixture) |

> ### ⛔ VE KURAL BUDUR — ürün sahibi düzeltmesi (2026-08-23)
>
> **DI-çağrı taraması YALNIZ servis-tüketimini kanıtlar; TABLO-tüketimi DÖRT YÜZEYDE
> aranır:**
>
> ```
> 1  DI çağrıları        this.fooService.        this.fooRepository.
> 2  repository erişimi  dataSource.getRepository(Foo)  ·  manager.find(Foo)
> 3  ham SQL             query('… FROM foo …')  ·  createQueryBuilder('foo')
> 4  view'lar            v_foo_summary — bir view'ı okuyan, TABLOYU okuyor
> ```
>
> **Negatif bir bulgunun geçerliliği ARAMA UZAYININ TANIMINA bağlıdır.** Uzay yazılmadan
> *"tüketici yok"* denemez.

⚠️ Ve dördüncü yüzey en sessizidir: `relations: ['planOverrides']` bir string'dir, bir
sınıf atfı değil — `T-269`'da `app-runtime-grants` guard'ı tam bu yüzden **`EXIT=0`
verirken canlı bir `500` duruyordu.

Kaç yüzeyin tarandığı **aynı cümlede yazılır** (`§ KAPSAM MASKELEMESİ`: *"bir küme
hakkında sonuç yazılıyorsa, kümenin NASIL SINIRLANDIĞI aynı cümlede yazılır"*).

### `@deprecated` bir NİYET BEYANIDIR, bir ölçüm değil (ZORUNLU)

> **Bir kopya *"ölü"* diye işaretlendiğinde ölçüm DURUR.**
> **Ama `@deprecated` bir niyet beyanıdır, bir ölçüm değil — ve CANLI bir rota
> `@deprecated` olabilir.**

`İlke 4` (*"aynı yetenek iki kez yazıldı"*) bir **tekrar** maliyeti sayar: iki yerde
bakım, iki yerde düzeltme. Bu vaka o maliyetin **ağırlaşmış hâlini** ölçtü — çünkü iki
kopyadan yalnız biri kapsamı uyguluyordu.

Ölçülmüş vaka (2026-08-22, `T-253`): `GET /users/dashboard-summary`, `@deprecated` ve
yorumu *"`/dashboard/summary`'ye geçin"* diyor. `B1` taksonomisinde
**`SINIF B · ÖLÜ İKİZ`** diye sınıflandırılmış ve *"bir yetenek sorusu DEĞİL, bir
`İlke 4` kalıntısı"* yazılmıştı. Ölçülünce:

```
planner  (11 CPL)  →  {"managedBudget":1600000,...}
planner2 (17 CPL)  →  BİREBİR AYNI          ← CANLI kapsam bypass'ı
getDashboardSummary(tenantId)  ·  0 AccessScopeService atıf
kanonik kardeş: dashboard.service.ts:82 resolveScopedCplIds — DOĞRU kapsıyor
```

Ve ikinci bir kusur daha taşıyordu: `budgetUsage` division-by-zero'da `0` dönüyordu
(`§2.5` + `§2.3`: *"division-by-zero → null"*) — kanonik kardeş `null` +
`'unavailable'` veriyor. **Testi o ihlali PİNLİYORDU**, ve `code-reviewer` okumasaydı
uç silinirken ihlal de sessizce kaybolacaktı.

📌 **`T-222`'nin (*"iki grid, biri karanlıkta"*) ağırlaşmış hâli.** Orada bir kopya
görülmüyordu; burada kopya **etiketlenmişti**, ve etiket ölçümü durdurdu.

**Pratik — bir kopyayı sınıflandırırken:**

```
❌  "@deprecated, ölü ikiz"        →  bir NİYET okunuyor
✅  "rota tablosunda MI?"          →  koşan sunucunun Mapped satırı
✅  "çağıranı var mı?"             →  grep, POZİTİF KONTROLLÜ
✅  "iki kopya AYNI mı davranıyor?"→  davranışsal, iki farklı girdiyle
```

⚠️ Ve iki kopya **eşit değildir**: hangisinin kanonik olduğunu ölçmeden *"ikisi de aynı
şeyi yapıyor"* yazma. Bu vakada ikisi aynı şeyi yapmıyordu — **biri güvenliydi, diğeri
değildi**, ve silinecek olan tam da güvensiz olandı.

### Bir kusur, BAŞKA bir kusur tarafından örtülebilir (ZORUNLU)

> **Bir kusur, başka bir kusur tarafından örtülebilir — ve dıştaki düzeltilince
> içteki ORTAYA ÇIKAR.**
> **Yani bir düzeltme turu, kapattığından fazlasını AÇABİLİR; ve fark yazılmazsa
> "düzelttik" denilen tur bir deliği açmış olur.**

`§2.7`'nin *"doğrulama maskeleme"* ailesi **ölçümün** kusuru gizlemesini konu alıyor.
Bu farklı: gizleyen şey **ürünün kendi ikinci kusurudur**, ve ölçüm doğrudur.

**İki ölçülmüş vaka (2026-08-20, `T-249`), ve YÖNLERİ ZIT:**

| # | içteki kusur | örten şey | düzeltme ne yapıyor |
|---|---|---|---|
| 1 | `markAsRead` **kullanıcıyı hiç almıyor** — bir UUID bilen herkes başkasının kaydını işaretleyebilir | `app_runtime`'ın izni yok → rota **`500`** | `GRANT` **deliği ERİŞİLEBİLİR kılıyor** |
| 2 | `plan_sku_id` **katalog id'siyle** dolduruluyor → FK ihlali | aynı `permission denied` **daha önce** ateşliyor | `GRANT` **kusuru GÖRÜNÜR kılıyor** |

Birincisi **kazara güvenli** (`INV-C-*`): koruma bir tasarım değil, bir arıza.
İkincisi **kazara sessiz**: kusur duruyordu, kimse ona varamıyordu.

⚠️ **Ve ikisi aynı `GRANT`'ten doğuyor** — yani tek bir düzeltme, bir deliği açıyor
**ve** bir kusuru gösteriyor. Bunlar farklı sonuçlardır ve **ayrı ayrı** yazılmalıdır.

**Pratik — bir kusuru düzeltmeden önce sor:**

```
1. Bu kusur ŞU ANDA başka bir şeyi ÖRTÜYOR mu?
   → örtüyorsa: düzeltme onu ortaya çıkarır. TASK aç, aynı turda değilse bile.
2. Bu kusurun VARLIĞI şu anda bir korumaya mı dönüşmüş?
   → dönüşmüşse: düzeltme o korumayı KALDIRIR. Yerine gerçek koruma konmalı.
```

📌 `T-249`'da ikisi de yazıldı — task dosyasında, `FAZ1_PLAN §5`'te ve bir sonraki
adımın önceliğinde. **Yazılmasaydı, "üç kırık ucu düzelttik" cümlesi doğru olur ve
eksik kalırdı.**

### ⚠️ VE SIKLIK BİR DESEN — `500` bu kod tabanında YAYGIN BİR ÖRTÜ

Dört vaka, **hepsi `T-249`/`T-256` turlarında**, ve dördünde de örten şey **aynı**:

| içteki kusur | örten | düzeltince ne oldu |
|---|---|---|
| `markAsRead` kullanıcı körlüğü | `500` (izin yok) | delik **ERİŞİLEBİLİR** oldu |
| `plan_sku_id` FK ihlali | `500` (izin yok) | kusur **GÖRÜNÜR** oldu |
| self-approval kontrolü hiç ateşlemiyor | `500` (obje→`uuid`) | **kazara güvenliydi** — düzeltince koruma **gerçekten** çalıştı |
| genel onay ucu domain akışını atlıyor | `500` (obje→`uuid`) | **atomiklik ihlali** erişilebilir oldu |

> **Bir `500`, bir kusurun YOKLUĞU değil — çoğu zaman İKİNCİ bir kusurdur, ve
> birincisini saklar.**

📌 **Pratik sonuç:** `500` veren bir ucu düzeltirken, o `500`'ün **arkasında ne
olduğunu** sor. Uç *"çalışmıyor"* değil — **hiç ölçülmemiş** demektir, ve arkasındaki
kod yolu **hiçbir zaman koşmamıştır**.

⚠️ Ve bu, `CLAUDE.md`'nin *"bir doğrulamanın çalıştığı sanılması, girdinin ona hiç
ULAŞMAMASINDAN gelebilir"* maddesinin **rota tarafındaki** hâli: `500` veren bir uçtaki
hiçbir kural, doğru olduğu **bilinerek** orada durmuyor.

### YORUM KİRLİLİĞİ iki yönde birden yanıltır (ZORUNLU)

> **Bir dekoratörü/çağrıyı ararken yorum satırları hem VAR OLANI GİZLER hem
> OLMAYANI GÖSTERİR — ve iki yön de aynı taramadan çıkar.**

Aynı kaynaktan **zıt yönlerde** iki ölçülmüş vaka:

| yön | vaka | sonuç |
|---|---|---|
| **olmayanı gösterdi** | `@Roles(` bir **yorumda** geçiyordu | `plans/:id/reject` *"filtresiz"* sanıldı — **değildi** |
| **olmayanı gösterdi** | `T-249`'un açıklama yorumları `@Roles` içeriyordu | *"sınıf seviyesi `@Roles` var"* sanıldı — **yoktu** (2026-08-21) |

⚠️ **İkincisini yapan Team Lead'di, ve birincisi `CLAUDE.md`'de zaten yazılıydı.**
Kural biliniyordu; **refleks** yoktu.

📌 Ve tehlikesi yöne göre değişir:

```
olmayanı göstermek   →  var olmayan bir kusur için İŞ ÜRETİR  (fazla ölçüm)
var olanı gizlemek   →  gerçek bir kusuru KAÇIRIR             (eksik ölçüm)
```

**Pratik — bir dekoratör/çağrı ararken:**

- Eşleşmeyi **bağlamıyla oku** (`§7.1`: *"bir sayı, eşleşmeleri örneklenmeden
  raporlanamaz"*). Bir satırın `//` ya da `*` ile başlaması ilk kontrol.
- Sayım yapan bir **araç** yazıyorsan yorumları **ayıkla** — ve ayıkladığını
  **fixture ile sına**, çünkü ayıklamanın kendisi sessizce bozulabilir.
- Ve bir iddiayı **çürütürken** ekstra dikkat: yorumdan gelen bir eşleşme, gerçek
  bir bulguyu *"zaten korunuyor"* diye kapatabilir.

### MEKANİK olarak türetilmiş bir değer, GEREKÇE değildir (ZORUNLU)

> **`union` asla bir gerekçe değildir.**
> **Bir kümeyi mekanik olarak hesaplamak, o kümenin DOĞRU olduğunu göstermez —
> yalnız nasıl elde edildiğini gösterir.**

Ölçülmüş vaka (2026-08-21, `Z18`): `ADIM 3`'ün üç `READ` hücresinde yetenek→rol
union'ı **`5` rolün `5`'ine** çöktü. *"Union böyle diyor, ve okuma zaten zararsız"*
kabul edilebilirdi — kapsam katmanı altta daraltıyor.

**Reddedildi, ve gerekçesi bugünkü erişim değil EMSAL:**

> **Ürün sahibi:** *"Çöküşün gerçek maliyeti bugünkü erişim değil, o emsal. **'Union'la
> 5/5 olsun, zararsız' kabul edilirse, aynı tembellik `WRITE`/`MANAGE` hücrelerinde
> tekrarlar.**"*

📌 **Kabul edilen şey bir KÜME değil, bir YÖNTEMdir:** *"union ne diyorsa o."* O yöntem
`READ`'de görece zararsız, `WRITE`'da değil — ve yöntem bir kez kabul edilince
uygulandığı yeri sormaz.

**Genel biçim — `union` yalnız bir örnek:**

| mekanik değer | *"gerekçe"* diye kullanılışı | neden değil |
|---|---|---|
| `union` / birleşim | *"kümeler birleşti, sonuç bu"* | hangi elemanın **neden** girdiğini söylemez |
| ortalama / medyan | *"eşik buradan çıktı"* | dağılımın kuyruğunu saklar |
| `max` / `min` | *"en katısını aldık"* | neden **o** boyutun bağlayıcı olduğunu söylemez |
| baseline | *"öncekinden az"* | **sınıf kırılımını** vermez |

⚠️ Sonuncusu bu dosyada zaten ayrı bir kural: *"bir TOPLAMIN azalması, bir SINIFIN
girmediğinin kanıtı değildir."* Aynı ailenin üyesi.

**Pratik:** mekanik bir değer bir karara dayanak yapılıyorsa, **her elemanı için ayrı
bir cümle** yazılabilmeli. Yazılamıyorsa değer bir **girdi**dir, karar değil.

- Yetersiz: *"`SHARED_READ` = 5 rol, union'dan"*
- Yeterli: *"`SHARED_READ` = 5 rol; `READONLY` şu route yüzünden, ve o route bu hücrede
  **olmamalı** — taksonomi düzeltilir"*

### Yazma ile commit arasına bir DOĞRULAMA koy (ZORUNLU)

Bir dosyayı yazan adım ile onu commit'leyen adım arasında **hiçbir kontrol yoksa**, sessizce
başarısız olan bir düzenleme **tutarsız bir commit** üretir — ve o commit'in ömrü, onu okuyan
bir sonraki kişiye kadar sürer.

Ölçülmüş vaka (2026-08-11, `ADR 0012`): iki `str.replace` içeren bir python bloğu
**ikincisindeki tırnak hatasıyla** tümüyle düştü (`SyntaxError`), ama shell zinciri devam
etti ve `git commit` çalıştı. Sonuç: ADR'nin bir bölümü güncel, uygulama sırası **eski**
metni taşıyor — ve commit mesajı ikisinin de güncellendiğini söylüyor.

> **Bir script'in çalıştığını çıktısından değil, ÜRETTİĞİ DOSYADAN doğrula.**
> `python3 - <<'PY' … PY` bloğu bir `SyntaxError` verdiğinde `&&` zinciri kopmaz, çünkü
> hata **python'un içinde** değil, **parse aşamasındadır** ve exit kodu bir sonraki
> komutu engellemez.

Pratik: commit'ten **önce** değiştirdiğin şeyi `grep` ile geri oku. Bu, `§2.7`'nin
*"mutasyonu dosya içeriğinden doğrula"* kuralının yazma tarafındaki hâli.

- ❌ `python3 … ; git add -A && git commit`
- ✅ `python3 … ; grep -q '<yeni metin>' <dosya> && git add -A && git commit`

⚠️ **Ve bu özellikle ADR/sözleşme dosyalarında önemli:** kodda tutarsızlık bir sonraki test
koşumunda kırmızıya döner; bir **karar belgesinde** hiçbir zaman dönmez.

### Doğrulama bir KAPIDIR — durdurmuyorsa doğrulama değildir (ZORUNLU)

> **Doğrulama, çıkışı akışı durduran bir kapıdır; durdurmuyorsa doğrulama değildir.**

Bir kontrolün **basılması** ile **bağlayıcı olması** ayrı şeylerdir. Basılan bir sayı
okunmayı bekler; bir kapı beklemez. Ve okunmayan bir kontrol, olmayan kontrolden **kötüdür**
— çünkü yapıldığı sanılır.

Bu, `§2.7` ailesinin dışında **ayrı bir sınıf**: orada ölçüm yanlıştı ya da yanlış şeyi
ölçüyordu; burada **ölçüm doğru ve kimse ona bakmıyor.**

Aynı gün **iki** vakası ölçüldü:

| vaka | kontrol ne yaptı | neden kapı değildi |
|---|---|---|
| Team Lead'in commit'i | bayat atıf sayısını **bastı** (`1`, beklenen `0`) | çıktıydı, koşul değil — `git commit` yine koştu |
| `run-all.sh` (backend) | alt guard'ın `RC`'sini **yakaladı** | yalnız `2`'ye karşı sınandı; `RC=1` yutuldu → **runner exit 0** |

İkincisi daha pahalıydı: gerçek repoda çöken bir guard *"0 bulgu"* diye raporlanıyor ve
`npm run guards` **yeşil** veriyordu. Ampirik kanıt (mutasyon: guard yalnız gerçek repoda
çöksün, fixture'da değil) — `self-test EXIT=0` · `guard EXIT=1` · **`runner EXIT=0`**.

⚠️ **Ve savunmayı başka bir kontrole devretmek yetmez.** O runner'ın kendi yorumu bu sınıfa
karşı yazılmıştı ve *"self-test yakalar"* diyordu. Yakalayamadı: self-test guard'ları
**fixture env değişkeniyle** çağırıyor, runner **çıplak** — ikisi farklı girdi kümesini
ölçüyor. Bir kontrolün başka bir kontrolü kapsadığı **ölçülmeden** varsayılamaz.

**Pratik:**

- ❌ `echo "$n bayat atıf"; git commit …`
- ✅ `[ "$n" -eq 0 ] && git commit … || echo "⛔ commit YAPILMADI"`
- ❌ `RC=$?` … `if [ "$RC" -eq 2 ]` (tek bir değere karşı)
- ✅ `if [ "$RC" -ne 0 ]` — **meşru çıkış kodlarını önce ÖLÇ**, sonra kalanını fatal yap

Ve bir kapı yazdıktan sonra `§2.7 #9`'u uygula: **iki farklı girdide iki farklı çıktı**
verdiğini göster. Temiz halde yeşil olması, kirlide kırmızı olduğunun kanıtı değildir.

### Bir DUR listesi, değişikliğin geçtiği HER SINIRI saymalıdır (ZORUNLU)

> **Bir `DUR` koşulu listesi, değişikliğin geçtiği HER sınırı saymalıdır.**
> **Şema · API · tel protokolü · dosya biçimi — her sınır bir sözleşmedir, ve tek repoda
> ölçülen bir kapı, sınırın öbür tarafını görmez.**

Ölçülmüş vaka (2026-08-13, `B` dalgası `R2a`): rol enum'unun **değerleri** Türkçeye taşındı
(`ADMIN = 'YÖNETİCİ'`). Enum **key**'leri korunduğu için backend derlendi, testler geçti,
altı guard yeşil verdi. Ama değer bir **tel protokolüdür**:

```
backend   UserRole.ADMIN = 'YÖNETİCİ'
frontend  UserRole.ADMIN = 'ADMIN'            ← dokunulmadı

hasRole(): 'YÖNETİCİ' === 'ADMIN'          → false   (admin bypass'ı gitti)
           requiredRoles.includes(...)      → false   (her rol kapılı rota reddedildi)
```

**Ve hiçbir kapı görmedi:** backend `tsc` 0 · backend testleri 0 (frontend'i bilmez) ·
`guards` 0 · **frontend `type-check` 0** — çünkü `user.role as UserRole` cast'i tipi
susturuyor. Kırılma yalnız **çalışan üründe** ortaya çıkar.

⚠️ **Ve delegasyon tarafındaki ders daha keskin:** alt-ajan hatalı davranmadı. Brief'in
`DUR` listesinde *"çapraz-repo sözleşme kırılması"* **yoktu**, ve kapsam
*"ölü referans temizliği ayrı PR"* diye yazılmıştı — oysa asıl tehlike **silinen**
etiketler değil, **yeniden adlandırılan** etiketlerdi.

> Bir kapsamı *"temizlik"* diye adlandırmak, onu **ertelenebilir** ilan eder. Yeniden
> adlandırma bir temizlik değil, bir **sözleşme değişikliğidir**.

**Pratik — bir değişikliği delege etmeden önce sınırları say:**

| sınır | soru |
|---|---|
| şema | başka bir migration/entity bu tanıma yaslanıyor mu |
| **tel protokolü** | bu **değer** JWT/API/URL üzerinden geçiyor mu — öbür uçta kim karşılaştırıyor |
| dosya biçimi | bir içe/dışa aktarma bu biçimi okuyor/yazıyor mu |
| başka repo | aynı kavramın **ikinci bir tanımı** var mı (`grep` ile, hafızadan değil) |
| **serileştirme** | yanıtın **şekli** değişiyor mu — bir alan **düşüyor** mu? ⚠️ Bir alanın düşmesi bir **regresyon** da olabilir, bir **kusurun kapanması** da; ikisi aynı kırmızıyı verir |

Ve **görüntü ↔ tel ayrımını koru:** bir iş belgesinin Türkçe adlandırması (`K-2.6.4`'ün rol
kataloğu) bir **şema tanımı değildir**. `L2`'nin her yerinde kavramlar Türkçe yazılı
(`TAHAKKUK`, `GÖZLENEN`) ve **hiçbiri enum değeri olsun diye yazılmadı**. Bu, `K-2.2.7`'nin
renk/davranış ayrımının aynısı: **görüntü katmanı davranışa sızmaz.**

### Bir TOPLAMIN azalması, bir SINIFIN girmediğinin kanıtı değildir (ZORUNLU)

> **Bir toplamın azalması, bir sınıfın girmediğinin kanıtı değildir.**

`mode-split` guard'ı bunu şöyle yazıyor: *"sayı-baseline 'biri düştü, biri girdi' gerilemesini
görmez."* O ders bir **guard tasarımı** için yazılmıştı. Aynı körlük bir **savunmanın içinde**
tekrarlandı — ve orada guard yoktu, yalnız bir cümle vardı.

Ölçülmüş vaka (2026-08-13, `B` dalgası): `migration:generate` boş çıkmadı. Savunma:
*"repo çapında önceden var olan drift; taban 1174 satırdı, benimkinden sonra **658** — yani
**azaldı**."* Sayılar doğruydu. Ama toplam düşerken **yeni bir sınıf girmişti**:

```
düşürülen CHECK kısıtı        14  →  12'si YENİ (bu dalganın indirdiği iş kuralları)
düşürülen bileşik FK           9  →  9'u da YENİ, ve up()'ta geri eklenmiyor
NULLS NOT DISTINCT             2  →  0   (joker tekilliği sessizce düz UNIQUE'e düşüyor)
```

Yani *"azaldı"* doğruydu **ve** *"yeni sapma yok"* yanlıştı. İkisi aynı ölçümden çıkarılamaz.

**Kural:** bir toplamı taban olarak kullanan her savunma, **sınıf kırılımını** da vermek
zorundadır. *"Öncekinden az"* bir güvence değildir; güvence **"şu sınıflardan hiçbiri yeni
değil"**dir, ve o cümle ancak sınıflar sayıldıktan sonra yazılabilir.

### Bir SAYI, eşleşmeleri ÖRNEKLENMEDEN raporlanamaz (ZORUNLU)

`§7.1` *"bir terim sayısına dayanarak karar veriyorsan en az bir geçişi bağlamıyla oku"*
diyor. Bu **bir tavsiyeydi ve tutmadı** — aynı oturumda **üç kez** ihlal edildi:

| # | sayılan | sanılan | gerçek |
|---|---|---|---|
| 1 | `grep -owci capability` → 15 | CBAC tartışılıyor | iş anlamında *"yetenek"* — başka kavram |
| 2 | `grep -w S1/S2/R1` → 17/31/17 | dalga kalemleri | başka bir raporun **bulgu** ve **risk** numaraları |
| 3 | `grep -r FiscalPeriod` → 6 dosya | entity tüketicisi var | **`getFiscalPeriod`** adlı bir parser metodu |

Üçü de kendi turunda yakalandı — ama **üç kez tekrarlaması, tavsiyenin yetmediğini gösterir.**
Ve üçüncüsü en pahalıya mal olacaktı: bir `code-reviewer` bulgusunu (*"tüketici 0"*)
çürütmek üzereydi, yani **doğru bir blocker'ı yanlış yere gömecekti.**

> **Bir eşleşme sayısı, en az bir eşleşme bağlamıyla okunmadan raporlanamaz** — ne bir
> karara dayanak yapılabilir, ne bir bulguyu çürütmek için kullanılabilir.

**İki şart:**

1. **Sayıyla birlikte bir örnek yaz.** `"6 dosya"` değil, `"6 dosya — ör.
   `sales-actuals.service.ts:81` `resolveFiscalPeriod`"`. Örneği yazmak, ona bakmayı zorlar.
2. **Bir sayı bir bulguyu ÇÜRÜTÜYORSA, örnek zorunludur.** Doğrulayan bir sayı yanılırsa
   fazladan iş üretir; **çürüten** bir sayı yanılırsa **gerçek bir kusuru kapatır.**

### Bir SAYIM FARKI, farkın KAYNAĞI gösterilmeden yorumlanamaz (ZORUNLU)

> **Bir sayım farkı, farkın KAYNAĞI gösterilmeden yorumlanamaz.**
> **"Her şey reddediliyor" ile "yanlış sebeple reddediliyor" AYNI SAYIYI verir.**

`§`'nin *"bir sayı, eşleşmeleri örneklenmeden raporlanamaz"* kuralı **eşleşme
sayıları** içindi. Bu, **hata/sonuç sayıları** için ve daha sinsi: orada sayı bir
kümeyi anlatıyordu, burada bir **yargıyı**.

Ölçülmüş vaka (2026-08-19, `T-241` `B1` blocker'ı): bir `code-reviewer` bulgusunu
**doğrulamak** için DTO doğrulaması ölçüldü. Team Lead'in fixture'ı `fullName: 'X'`
taşıyordu ve `MinLength`'i ihlal ediyordu — yani **her vakaya sabit `+1` hata**
ekliyordu:

```
okunan                          gerçek
FAIL(1)  scope:[{}]             1 hata = fullName        → scope hatası YOK
FAIL(2)  POZ.KONTROL scope YOK  2 hata = fullName·scope  → scope hatası VAR
```

İlk okuma **"her şey reddediliyor, review yanlış"** idi. Ve pozitif kontroller de
`FAIL` döndüğü için **çalışıyor göründüler** — kayma onları da kaydırmıştı.

⚠️ **Bedeli:** o okuma raporlansaydı **gerçek bir blocker gömülecekti**, ve gerekçesi
*"ben ölçtüm, review yanılıyor"* olacaktı. Yani hata **çürüten** yöndeydi — `§7.1`'in
*"çürüten bir sayı yanılırsa gerçek bir kusuru kapatır"* maddesinin tam vakası.

**Pratik:** bir sayım farkını yorumlamadan önce **farkın kaynağını bas** — hangi
alan, hangi kural, hangi satır. `errs.length` değil `errs.map(e => e.property)`.
Ve **sabit bir kayma her vakayı aynı yönde bozar**, yani pozitif kontrol onu
yakalamaz: kontrol de kayar.

### Bir yazma işleminin DÖNÜŞ DEĞERİ, yazdığının kanıtı değildir (ZORUNLU)

> **Bir yazma işleminin dönüş değeri, yazdığının kanıtı değildir — DELTAYI ölç.**

Ölçülmüş vaka (2026-08-14, `B` dalgası seed'leri): üç seed dosyası
`result.identifiers.length` ile *"N inserted"* basıyordu. `.orIgnore()` ile yazılan bir
`INSERT`'te o alan **girdi** satırlarını sayar, gerçekte yazılanı değil. Ölçüm: ikinci
koşumda `identifiers.length = 3`, `raw.length = 0`, **DB deltası 0** — log *"3 inserted"*
diyordu ve **hiçbir satır girmemişti**.

Bu, `§7.1`'in *"rapor bir teslimat kanıtı değildir"* ailesinin üyesi, ama farklı bir
failden: burada **makine** yanlış rapor veriyor, bir ajan ya da insan değil. Ve o yüzden
daha az sorgulanır — bir sayının kaynağı bir kütüphane çağrısıysa doğru sanılır.

**Pratik:** bir yazmanın sonucunu `RETURNING`'den (`raw`) ya da **önce/sonra sayımından**
al. Ve `.orIgnore()` / `ON CONFLICT DO NOTHING` / `upsert` kullanan her yolda bu soruyu
**ayrıca** sor — o kalıplar tam olarak "yazmadım" ile "yazdım"ı aynı dönüş değerinde
birleştirir.

### Karşılanamayan bir ÖLÇÜT revize edilir — uydurma veriyle karşılanmaz (ZORUNLU)

> **Bir kabul ölçütü karşılanamıyorsa iki sonuç doğar: iş kilitlenir ya da ölçüt uydurma
> veriyle karşılanır. İkincisi sessizdir.**
>
> **Karşılanamayan bir ölçüt revize edilir — gerekçesiyle. Ölçütü korumak için veri
> uydurmak, ölçütün koruduğu şeyi yok eder.**

Ölçülmüş vaka (2026-08-14, `B` dalgası): `Done` şartı *"seed **5/5**"*di. Beşincisi (rol
ailesi) **yazılamıyordu** — `capabilities`'in içeriği açık bir karara bağlı (`0056-K3`).
Şart olduğu gibi bırakılsaydı iki yol vardı: dalga **hiç kapanmaz**, ya da kapanmak için
**uydurma yetenek satırları** yazılırdı. Şart `4.5/5`'e revize edildi, **gerekçesi ve
adresi yazılarak**.

⚠️ Bu `§2.5`'in **tersinden gelen** hâli. `§2.5` *"boşluğu uydurma"* der ve failin
tembelliğini varsayar; burada fail **dikkatlidir** ve tam da **ölçütü karşılamak için**
uydurur. Yani baskı kuraldan değil, **kuralın ölçüsünden** gelir.

**Pratik:** bir ölçüt karşılanamıyorsa sor — *"karşılanamıyor mu, yoksa henüz mü?"*
Birincisi ölçütün yanlış olduğunu, ikincisi bir **adres** gerektiğini gösterir. İkisinde de
cevap ölçütü **yazılı olarak** değiştirmektir; sessizce yaklaşmak ya da veriyle doldurmak
değil.

### Bir şartın SAĞLAYICISI yoksa, şart bir erteleme değil bir KİLİTTİR (ZORUNLU)

> **Bir şartın sağlayıcısı yoksa, şart bir erteleme değil bir kilittir — ve kilit
> görünmez.**

Yukarıdaki kural *"karşılanamayan bir ölçüt"*ü konu alıyor ve failin **ölçütü zorlamasını**
bekliyor. Bu **daha sessiz** bir vaka: ölçüt zorlanmıyor, **kimse ona bakmıyor**. Çünkü
*"ölçüm bekliyor"* meşru görünür — ve *"bu şart karşılanabilir mi?"* sorusu hiç sorulmaz.

**Üç ölçülmüş vaka, ve üçü aynı şekil:**

| kalem | şart | sağlayıcı |
|---|---|---|
| `B4` (onay bekleme dağılımı) | *"ölçüm sonrası"* | örneklem **0** — yetersiz değil, **yok** |
| `report-only` (`0073` Soru 3) | *"envanter fiili trafikte doğrulanır"* | deploy edilmiş ortam **yok** → fiili trafik yok |
| `T-028c` bayrağı (`T-235`) | *"prod/UAT'de backfill doğrulanana kadar"* | prod/UAT **yok** |

Üçü de **doğru yazılmış**, üçü de **var olmayan bir ortama adresli.** Sonuncusu
`2026-07-28`'den beri kilitli ve kimse fark etmedi — üstelik `K-2.6.9` sapmayı
*"ölçülmüş sapma"* diye **kaydetmişti**; kayıtta olmayan şey **kapanamama sebebiydi.**

⚠️ **Ve bir kayıt, kilidi gizleyebilir:** *"ölçülmüş sapma"* etiketi sorunun
**bilindiğini** söyler, **kapanabileceğini** değil. Bilinen bir sapma, adresi olmayan
bir sapmadan daha az sorgulanır.

**Pratik — bir şart yazarken üçüncü bir satır ekle:**

```
ŞART        prod/UAT'de backfill doğrulanana kadar
SAĞLAYICI   prod/UAT ortamı            ← BU SATIR
DURUM       ⛔ bugün YOK → bu bir kilit, bir erteleme değil
```

Sağlayıcı bugün yoksa şart **kilit** diye işaretlenir ve bir **task'a** bağlanır
(`§7.1`: *"bilinen eksiklik TODO ile değil, TASK ile kaydedilir"*). Sağlayıcının ne
zaman doğacağı bilinmiyorsa, şart **var olan bir ölçüye** revize edilir.

### Bir KABUL LİSTESİ, değişikliğin BOZABİLECEĞİNİ de saymalıdır (ZORUNLU)

> **Bir kabul listesi, değişikliğin BOZABİLECEĞİ her yeteneği saymalıdır — yalnız
> EKLEDİĞİ her yeteneği değil.**

Ölçülmüş vaka (2026-08-14, `B` dalgası): dalga `kabul-1`…`kabul-8a` ile kapandı. Şema
değişti, iş kuralları ihlal-üretilerek sınandı, migration iki ortamda geri alınıp yeniden
uygulandı, çapraz-repo enum sözleşmesi pinlendi. **Ama "uygulama hâlâ ayağa kalkıyor mu"
hiçbir kriterde yoktu** — ve iki e2e dosyası bootstrap'ta çöküyordu
(`Entity metadata for ApprovalRequest#approvalPolicy was not found`).

⚠️ **Ve eksikliği kimse aramadı — başka bir task'ın YAN BULGUSU ortaya çıkardı.** Yani
liste kendi boşluğunu göstermedi; boşluk tesadüfen görüldü.

📌 Bu, aynı dalganın **ikinci** aynı-şekilli eksikliğidir: `DUR` koşulları arasında da
*"çapraz-repo sözleşme kırılması"* yoktu (rol enum'unun değerleri değişti, dört kapı yeşil
kaldı, her rol kapılı rota kapandı). **İki eksiklik, tek şekil: liste EKLEMEYİ sayıyor,
BOZMAYI saymıyor.**

**Pratik — kabul listesi yazarken iki sütun:**

| ne EKLENDİ | ne BOZULABİLİR |
|---|---|
| yeni tablo/kolon/kural | uygulama ayağa kalkıyor mu (bootstrap · e2e) |
| yeni enum değeri | o değeri **karşılaştıran** her uç (tel protokolü, öbür repo) |
| kaldırılan kolon | onu **okuyan** her yol (DTO · view · export · rapor) |
| yeni kısıt | o kısıtın **reddedeceği** meşru veri var mı |

Ve sor: *"bu değişiklik dünden beri çalışan neyi durdurabilir?"* — cevabı bir **kabul
satırı** olmalı, bir umut değil.

### Yan etkisi olan bir aracı İZOLE hedefte sına (ZORUNLU)

> **Yan etkisi olan bir aracı sınamak, o yan etkiyi ÜRETMEYİ gerektirir — sınav izole bir
> hedefte yapılır, gerçek olanda değil.**

Ölçülmüş vaka (2026-08-14): `push-order.sh`'ın kirli-ağaç kaçışı (`ABORT_ON_DIRTY=0`)
**gerçek `origin`'e karşı** koşturuldu. Meta'da push edilmemiş bir commit vardı ve script
onu **push etti** — yani doğrulama, ölçtüğü durumu değiştirdi ve **dışa dönük** bir işlem
üretti.

⚠️ Ve doğru yol zaten oradaydı: aracı **yazan** ajan onu izole bir bare-repo harness'ında
sınamıştı (altı senaryo, gerçek uzağa dokunmadan). Doğrulayan taraf kestirmeden gitti.

**Pratik:** bir aracın yan etkisi ağ, dosya sistemi ya da bir uzak durum ise, sınavın hedefi
**tek kullanımlık** olmalı — bare repo, geçici dizin, tek kullanımlık DB. Ve zaten böyle bir
harness varsa, doğrulama **onu kullanır**; ikinci bir yol açmaz.

📌 Bu `§2.7`'nin en net vakası: **kanıt kurulumu ölçtüğün durumu değiştirdi.** Ama bir
farkla — buradaki değişiklik geri alınamaz (bir push geri alınmaz, ancak üstüne yazılır).

### Bir DÜZELTME, düzelttiği SINIFIN yeni bir vakasını üretebilir (ZORUNLU)

> **Bir düzeltme, düzelttiği sınıfın yeni bir vakasını üretebilir — ve düzeltme turunun
> kabul kriteri onu kapsamalıdır.**

Ölçülmüş vaka (2026-08-14, `INV-N-004`): `null` ROI'nin `BELOW_TARGET`'a çökmesi
düzeltildi — backend'e dördüncü bir durum eklendi (`NOT_COMPUTABLE`). Ama tüketici
`PlanAnalysis.tsx` yalnız `BELOW_TARGET`/`ON_TARGET` kontrol ediyor ve `else` dalı
**yeşil "Hedef Üstü"** basıyor:

```
düzeltmeden ÖNCE   null → kırmızı "Hedef Altı"     (yanlış)
düzeltmeden SONRA  null → yeşil  "Hedef Üstü"      (DAHA yanlış)
```

Yani düzeltme, düzelttiği sınıfın (*"hesaplanamayan bir değer bir iş yargısına
çöküyor"*) **yeni bir vakasını üretti** — ve **ters yönde, daha kötü**: yanlış bir kırmızı
yanlış bir yeşile döndü.

📌 Mekanizma: **taşıyıcıya yeni bir değer eklemek, onu OKUMAYAN her tüketicide sessiz bir
sapma doğurur.** `else` dalları yeni enum değerini kendi varsayılanına yutar.

**Pratik — düzeltme turunun kabul kriterine bir satır:**

> *"Bu düzeltme, düzelttiği sınıfın yeni bir vakasını üretiyor mu?"*

Ve özellikle bir **enum/durum genişletmesi** yapıyorsan: o değeri **karşılaştıran** her ucu
say (`§7.1`), ve `else`/`default` dallarının onu ne yaptığına bak. Yeni değer bir `else`'e
düşüyorsa, düzeltme oraya bir kusur taşımıştır.

### Boş gelen bir çıktı, BEKLENEN içerikle doldurulamaz (ZORUNLU)

> **Bir raporun beklenen ŞEKLİNİ bilmek, onun İÇERİĞİNİ bilmek değildir.**
>
> **Boş gelen bir çıktı, beklenen içerikle doldurulamaz — en makul tahmin bile
> ölçülmemiş bir iddiadır, ve bir sonraki turda ölçülmüş sayılır.**

Ölçülmüş vaka (2026-08-14, `T-221`): bir ajan takıldı ve **hiçbir rapor üretmedi**. Rapor
boş geldi, ve okuyan tarafta beklenen içerikle **dolduruldu** — *"22 kolon · hepsi
`Alan A` · `MoneyDecimalTransformer` şablonu · `BudgetReservation` 3 kolon"*. Ölçüm:

| atfedilen | gerçek |
|---|---|
| 22 kolon düzeltildi | diff **44** transformer satırı ekliyor, 56 → 1 |
| `BudgetReservation` 3 kolon | **1** (`reserved_amount`, entity ve katalog aynı fikirde) |
| `MoneyDecimalTransformer` | repoda **böyle bir sınıf yok** |
| `T-225`'e not düşüldü | not **ulaşmadı**, entity'ye dokunulmamış |

⚠️ **Ve mekanizması öğretici:** boşluk **tembellikten** doldurulmadı — **brief'i yazan
taraf cevabın şeklini biliyordu.** Bilmek ile ölçmek arasındaki fark tam burada.

📌 Bu `§2.5`'in en saf hâli: **boşluğu makul bir içerikle doldurmak.** Ve `§2.4`'ün ters
yönü: orada *"varsayma, sor"* deniyor; burada varsayım **bir onaya** dönüşüyordu — kabul
edilseydi `22 kolon` bir sonraki turda *"ölçüldü"* diye taşınacaktı.

**Pratik:** bir çıktı boş, kesik ya da eksik geldiğinde tek meşru cevap **"göremiyorum,
paylaş"**tır. Beklenen şekli yazmak bir hatırlatma olabilir — ama **sonuç olarak
kaydedilemez.**

### Bir DÜZELTME de bir iddiadır (ZORUNLU)

**Düzeltmenin doğru hedefe gittiği, düzeltmenin gerekliliği kadar ölçülmelidir.**

Bir kusur bulunduğunda dikkat *"kusur gerçek mi"*ye gider ve orada durur. Ama düzeltme
**ikinci bir iddiadır**: *"doğrusu şudur."* O iddia ayrıca ölçülmezse, gerçek bir kusur
gerçek bir sapmayla değiştirilir — ve sonuç **bir düzeltme kılığında** kaydedilir.

Bu oturumda **üç kez** oldu:

| # | düzeltme | gerçek |
|---|---|---|
| 1 | *"fırlatma kapısı %80"* (tek kaynaktan genelleme) | %95 kapı, %80 **mitigation** |
| 2 | *"auto-reject Phase 1'de geçersiz"* | `§7.7`: **Phase 1'de geçerli** |
| 3 | **`migration 1780`: *"DOĞRU (BRD): INCR_GP / INCR_SPEND"*** | dört kaynak **`TOTAL_PLANNED_SPEND`** diyor |

İlk ikisi bizim yorumumuzdaydı ve bir sonraki turda düzeldi. **Üçüncüsü koda girdi ve
kalıcı** — üstelik doğru payda **aynı migration tarafından** veritabanına eklenmişti,
birkaç satır ötede.

> ⚠️ **Ve düzeltme daha tehlikelidir, çünkü "iş bitti" hissi aramayı durdurur.** İkinci
> vakada *"düzelttim"* duygusu üçüncü kaynağa bakmayı engelledi; doğru cevap dördüncü
> belgedeydi.

**Ve §7.1 ile birleşince:** bir sapma *"uygunluk"* diye etiketlenirse (`DOĞRU (BRD)`)
**sorguyu kapatır.** Sessiz bir sapma bir gün fark edilir; kaynağa atıf veren bir sapma
**doğrulanmış görünür.** Atıf boşsa — kaynak okunmamışsa — o etiket kusuru korur.

- ❌ *"BRD kanonik formüle güncelledi"* (kaynak okunmadan)
- ✅ *"`Section_05 §5.3` ve Glossary `GP ROI` maddesi `TOTAL_PLANNED_SPEND` diyor —
  ölçüldü <tarih>"*

### Bir düzeltmenin iki ekseni vardır: HEDEFİ ve YÖNÜ (ZORUNLU)

```
Bir düzeltmenin iki ekseni vardır: hedefi ve yönü.
Hedef hatası görünür  (yanlış dosya, yanlış numara).
Yön hatası görünmez   — doğru yere dokunur, yalnız işareti terstir.
Ve yön hatası bir ölçümden ÖNCE yazılırsa, ölçümü kendi yönüne çeker.
```

Yukarıdaki üç vaka **hedef** hatasıydı: yanlış eşik, yanlış faz, yanlış payda. Hepsi
görünür, çünkü doğru değerle yan yana konunca ayrışırlar.

**Yön hatası ayrışmaz.** Ölçülmüş vaka (2026-08-13, `0069`'un `discount_amount` notu): üç
şıklı bir ayrım iki şıkka indirildi, etiketler **takas edildi**, ve *"kural `(a)`'yı
reddediyor"* yazıldı — oysa kural `(a)`'yı **kabul ediyordu**. Cümle doğru alana
dokunuyordu, doğru kuralı anıyordu, doğru task'a bağlıydı; yalnız **işareti** tersti, ve o
yüzden okuyan hiçbir yerde tökezlemiyordu.

⚠️ **Ve bedeli bir yanlış bilgi değil, bozulmuş bir ölçümdür.** O not `T-209`'un ön
beklentisiydi. Ters yazılmış bir ön beklenti, ölçümü **kendi yönüne çeker**: ajan
hipotezi sınamak yerine **doğrulamaya** çalışır, ve sonuç *"ölçüldü"* etiketiyle kaydolur.

> Bu, `§2.7`'nin *"kanıt kurulumu ölçtüğün durumu değiştirmesin"* ailesinin **planlama
> tarafındaki** hâli. Orada kurulum ölçümü bozuyordu; burada **beklentinin metni** bozuyor.

**Pratik:**

- Bir düzeltme yazdıktan sonra sor: *"hedefi mi düzelttim, yoksa yönünü de mi
  çevirdim?"* — ve **yönü ayrıca oku.** Reddediliyor mu kabul mü, artıyor mu azalıyor mu,
  eleniyor mu ayakta mı.
- **Bir ölçümün ön beklentisini yazarken şıkları ve her şıkkın sonucunu bir TABLOYA koy.**
  Düzyazıda bir işaret sessizce ters çevrilebilir; iki sütunlu bir tabloda ters çevirmek
  **görünür** olur.
- Ve o tabloyu **ölçümün girdisi** yap, bir dipnot değil: *"ölçümü yapan ajan bu tablodan
  başlasın."* Uyarı okunmazsa yoktur.

### Ölçüm ortamının bayatlığı da bir maskeleme sınıfıdır (ZORUNLU)

**`start:dev` süreci ayaktayken kaynak düzenlenirse rotalar bozulabilir ve hata kod kusuru gibi
görünür.** E2E'den önce backend süreci yeniden başlatılmalı.

T-113'te ölçüldü: `POST /plans/:id/fus` **500** dönüyordu. Aynı commit, aynı DB, aynı istek
gövdesi — süreç yeniden başlatılınca **201**. Yani ölçülen şey koddaki bir kusur değil, ölçüm
ortamının bayatlığıydı; ve bir saat, olmayan bir kusuru aramakla geçebilirdi.

Bu, §2.7 ailesinin bir üyesi ama tersinden: orada kanıt kurulumu **kusuru gizliyordu**, burada
**olmayan bir kusur üretiyor**. İkisinin ortak kuralı aynı:

> **Bir hata gördüğünde, önce onu üreten ortamın taze olduğunu doğrula. Yeniden başlat, tekrar
> ölç — ancak ondan sonra kodu suçla.**

### Testler bir ŞARTNAMEDİR — kod silinse bile (ZORUNLU, ve bir kurtarmayla ölçüldü)

Testlerin bilinen getirisi regresyonu yakalamaktır. T-126'da **ikinci bir getirisi** ölçüldü:
`git checkout` commit edilmemiş bir dosyanın işini sildiğinde, o iş **yeniden inşa edilebildi**
— çünkü spec dosyaları, tüketici servisi ve ikiz modül ayakta kalmıştı.

Ve envanteri **`tsc` çıkardı**: beş tip hatası, kaybın tam listesiydi. ([[T-116]]'nın —
`type-check`'in `tests/`'i kapsaması — ikinci somut getirisi; birincisi kör bir testi bulmaktı.)

> **Kod silinebilir; spec duruyorsa yeniden yazılabilir.** Bu, testleri koddan **önce** ya da
> **ayrı** commit'lemenin ölçülmüş bir gerekçesidir.

⚠️ Tersi de doğru: spec'i olmayan bir dosya kaybolduğunda geriye **hiçbir şartname** kalmaz —
yalnız hatırlanan niyet.

### Bilinen eksiklik TODO ile değil, TASK ile kaydedilir (ZORUNLU)

**Bir yorum kodu okuyanı bilgilendirir; bir task işi yapılacaklar listesine sokar.** İkisi
farklı işlevdir ve **birincisi ikincisinin yerini tutmaz.**

T-101'de bulundu: `budget-threshold.service.ts`, `invalidateCache` üzerinde
*"TODO: BudgetAlertConfiguration güncelleyen admin endpoint eklenirse buna bağlanmalı"*
diyordu. Yani **eşiklerin üretimde konfigüre edilemediği biliniyordu** — yazılmıştı, ve
kimse task açmadığı için hiç yapılmadı. §2.3'ün ihlali o TODO'nun içinde bekliyordu.

Sebep basit: **TODO okunmak için beklemek zorundadır.** Kimse o dosyayı açmazsa hiç görünmez.
Task listeye girer, sprint planında karşına çıkar, backlog taramasında sayılır.

Ve §7.1'in kardeşi: **yorum hiçbir zaman kırmızıya dönmez** — burada kusur tarafında değil,
**eksiklik** tarafında.

> Bir eksikliği fark ettin ve şimdi yapmayacaksın → **task aç.** Yoruma yazmak, onu
> unutmanın düzenli görünen hâlidir.

### Bir şema kararını geri alırken entity metadata'sını da geri al (ZORUNLU)

`migration:generate` **entity metadata'sını veritabanına karşı** diff'ler. Entity'de kalan bir
kısıt, bir sonraki generate'te **gerekçesiz bir migration olarak** geri gelir.

T-101: kısmi UNIQUE taslağı kapsam dışı olduğu için migration'dan çıkarıldı ama **entity'de
kaldı**. Migration'ın başlığı "bu index'e dokunmuyor" derken entity onun yerine geçtiğini ilan
ediyordu. Ölçüm (düzeltmeden önce/sonra `migration:generate` çıktısı):

```
önce:  CREATE UNIQUE INDEX "IDX_b753f…" … WHERE deleted_at IS NULL AND is_active = true
sonra: (böyle bir satır yok)
```

Yani bir başka task'a **devredilmiş** karar, bir sonraki generate'te yazarsız olarak inecekti.

⚠️ Bu, `pg_constraint`/`pg_indexes` sorusunun **farklı** bir sorusu. O ikisi doğru sorulmuştu.
Sorulmayan soru **entity ↔ DB eşitliği**ydi, ve bu repoda o soruyu soran tek araç
`migration:generate`'dir.

Ayrıca: `@Index`'e **adını yaz.** Adsız bırakılırsa TypeORM hash türetir ve gerçek index'i
yeniden adlandırmayı önerir — ona atıf yapan her migration'ın adını öksüz bırakarak.

### Fixture, ayırt etmek istediği iki tarafta FARKLI değer taşımalı (ZORUNLU)

**Bir testin fixture'ı, test edilen ayrımın iki tarafında aynı değeri taşıyorsa, test o ayrımı
ölçemez.** Yeşildir ve hiçbir şey söylemez.

T-101: `returns config-driven thresholds when rows exist` testi `{80, 95, 100}` konfigüre edip
`{80, 95, 100}` bekliyordu — ve `DEFAULT_THRESHOLDS` **tam olarak o**. Konfigürasyonu tümüyle
yok sayan bir servis o testi geçerdi.

Ve asıl ders burada: **turun konusu olan kamuflaj** — seed değerlerinin varsayılanla birebir
aynı olması — **config yolunu kanıtlamak için yazılmış testin içinde duruyordu.** Test kusuru
sabitlemiyordu; kusurla **aynı körlüğü paylaşıyordu**.

Bu, §2.7'nin "yanlış şekilli test" ailesinin yeni bir yüzü: orada testin *şekli* ayırt
edemiyordu, burada *verisi*.

### Kod yorumunda "ulaşılamaz" yazmadan önce ölç (ZORUNLU)

**"İmkânsız" · "gelemez" · "ulaşılamaz" · "bu duruma düşmez" — bu ifadeler normatiftir.** Bir
sonraki okuyucuya kontrolü atlama izni verirler, ve yanlışlarsa koruma **kalıcı olarak** kalkar.

T-097: `DecimalTransformer`'a *"not reachable from the database today"* yazıldı. Ölçüm
yapılmıştı ama eksikti — `numeric(15,2)` **NaN'ı saklar** ve `NaN` metni olarak döndürür;
yalnız `Infinity` reddedilir. İddia yanlıştı ve tam da yazma ucunun korumasız kalmasını
meşrulaştırıyordu.

Bu, §7.1'in T-084 vakasıyla aynı: *"must not be fixed to match"* yorumu bir kusuru koruma
altına almıştı. **Bir hatayı belgelemek onu koruma altına alır** — ve yorum, testten farklı
olarak, hiçbir zaman kırmızıya dönmez.

- ❌ "bu değer DB'den gelemez" · "buraya `null` düşmez" · "çağıran hep sayı gönderir"
- ✅ "ölçüldü <tarih>: `numeric(15,2)` NaN'ı kabul ediyor — kanıt: `insert ... values ('NaN')`
  → `INSERT 0 1`" · ya da iddiadan tamamen vazgeç ve korumayı yine de yaz

**Ve kural yalnız "yok" iddialarına değil, "var" iddialarına da uygular — bu ekleme bir
karşı-örnekten geldi.** T-098, bu kural CLAUDE.md'ye T-097'den sonra eklenmişken, bir sonraki
task'ta aynı sınıfı tekrarladı:

| task | koda yazılan | gerçek |
|---|---|---|
| T-097 | *"not reachable from the database today"* | `numeric(15,2)` NaN'ı **saklıyor** |
| T-098 | *"context, **which the logger prints**"* | Nest `Error.toString()` basıyor — ne context ne stack |

İkisi de **"başka bir yerde" hakkında** bir iddiaydı ve ikisi de **o başka yerde ölçülmedi**.
İkincisi daha pahalıydı: değer mesajdan çıkarıldı, hiçbir yere konmadı, ve "orada duruyor"
denildi — sızıntı kapanırken **teşhis de silindi**.

> **Bir yorum başka bir bileşenin davranışı hakkında iddiada bulunuyorsa, o bileşen
> KOŞTURULARAK ölçülmeli. "Ulaşılamaz" kadar "hâlâ erişilebilir" de bir iddiadır.**

**Ve ihlalin maliyeti nerede olduğuna bağlı — yedinci vaka bunu gösterdi.**

| ihlal nerede | maliyeti |
|---|---|
| bir **yorumda** | yanlış bilgi; sonraki okuyucu yanılır |
| bir **kapsam kararında** | **kapatılmamış kusur**; iş hiç yapılmaz |

Altı vaka yorumdaydı ve "yanıltıcı ama zararsız" diye birikti. Yedincisi (T-106) bir kapsam
gerekçesiydi: *"tarayıcı `type="number"` alanında `1.234,56` yazılmasına izin vermiyor"* —
ölçülmedi, ve beş para girdisi düzeltmenin dışında bırakıldı. Ölçüm sonradan yapıldığında
gerçek şu çıktı: kullanıcı `250.000` yazınca **250** kaydediliyordu.

> **Bir kapsam kararı ölçülmemiş bir iddiaya dayanıyorsa, o karar bir tahmindir — ve
> tahminin bedeli kodda değil, yapılmayan işte birikir.**

⚠️ Ve o vakanın kendisi kalıcı bir tuzak: `type="number"` **programatik atamayı** temizler
(`el.value = "1.234,56"` → `""`), **klavye girişini temizlemez** (`250.000` → `250.000`,
`badInput=false`). İki farklı işlem, zıt davranış; iddia birinden diğerine genellendiği için
yanlıştı.

Pratik test: yorumundaki fiilin öznesi **senin dosyan değilse** (logger basar, DB reddeder,
çağıran gönderir), o cümle bir ölçüm gerektirir.

**Ve kural tek başına yetmedi — beş vaka sonra ek şart kondu.** Kural yazıldıktan sonra bile
aynı hata iki task daha tekrarlandı (*"logger prints"*, *"satır-bazlı kanal yok"*). Sebep:
kural neyi arayacağını söylüyor ama **yazarken** hatırlanmıyor; `code-reviewer` yakalıyor,
yazar yakalamıyor.

> **Yorumda başka bir bileşen hakkında bir cümle yazıyorsan, ölçüm referansını da yaz.**

- ❌ "`importCustomers` satır hatası toplamıyor"
- ✅ "`importCustomers` satır hatası topluyor (`customer.service.ts:365`) — kanal var"

Atıf iki iş yapar: iddiayı **sonraki okuyucu için doğrulanabilir** kılar, ve **yazarken
ölçmeye zorlar** — çünkü satır numarasını yazmak için oraya bakmak gerekir. Kural bir refleks
üretemedi; atıf şartı üretiyor.

### Bir kuralı yazdığın tur, o kuralı en çok ihlal ettiğin turdur (ZORUNLU)

Bu dosyaya yeni bir kural eklenen turlarda, **aynı turun diff'i o kuralı ihlal ederken
yakalandı** — ve her seferinde yakalayan `code-reviewer` oldu, yazar değil. Kural doğruydu;
eksik olan **refleks**ti.

| kural eklendi | aynı turdaki ihlal |
|---|---|
| "başka bileşen hakkındaki iddiayı ölç" | *"logger prints"* — ölçülmedi |
| "atıfa grep'lenebilir token yaz" | seed'e yazılan satır atfı aynı turda bayatladı |
| "dokümanda sayı yazma" | ADR E17'ye `47/18` yazıldı, iki satır aşağıdaki karar onu bayatlattı |
| "§7.1: kusur sınıfını aynı dosyada ara" | B1 düzeltildi, **aynı fonksiyondaki iki kardeş dal** taranmadı |

Sebep basit ve mazeret değil: kural yazmak dikkati **kuralın metnine** çeker, koda değil.

> **Bir kural eklediğin turda, o kuralı KENDİ diff'ine uygula — ayrı bir adım olarak.**
> "Bu kuralı ihlal eden bir şey bu diff'te var mı?" sorusu, kuralı yazdıktan sonra sorulmalı
> ve cevabı bir **ölçüm** olmalı.

Bu, `code-reviewer`'ın yerini almaz — yukarıdaki vakaların **hepsinde** o yakaladı ve
yakalamaya devam edecek. Ama
yazarın kendi turunda sormadığı soruyu review'a havale etmek, o adımı **zorunlu** kılar; ve
review'ın koşmadığı bir turda kural sessizce ihlal edilmiş olarak kalır.

**Ama satır numarası da bir sayıdır — yanına grep'lenebilir bir dayanak yaz.**

T-113'te bir atıf **aynı tur içinde** bayatladı: seed'e `spec.ts:74,:77,:84-85` yazıldı, ben aynı
dosyanın başlığındaki yorumu düzenledim, Prettier yeniden biçimlendirdi ve assertion'lar 99, 102,
109-110'a kaydı. Atıf hâlâ oradaydı ve artık yanlış yeri gösteriyordu — kimse kod değiştirmemişti.

Bu, "dokümanda sayı yazma" kuralının atıflara uygulanmış hâli. İkisi çelişmez, birleşir:

- ❌ `05-grid-column-alignment.spec.ts:74` (tek başına numara — biçimlendirme bile kırar)
- ✅ `05-grid-column-alignment.spec.ts`, `toContainText('₺100')` assertion'ı — istersen numarayı
  da ekle, ama **bulunmayı sağlayan token olsun**

Yani: **numara yazarken ölçmeye zorlar, token bulmayı sürdürür.** İkisini birlikte yaz.

### Port ederken: davranış taşınır, onu DOĞRU KILAN BAĞLAM taşınmaz (ZORUNLU)

**Kopyalanan bir satır, kaynağında güvenli olduğu için hedefinde de güvenli değildir.**

T-111'de ölçüldü. Backend'in `money-float.sh`'i domain listesi bulunamazsa `SKIPPED` yazıp
**exit 0** döner — ve bu **güvenlidir**, çünkü `run-all.sh` o işareti grep'leyip bir setup
hatasına çevirir. Frontend portu `exit 0`'ı aldı, hatta yorumun *"SKIPPED is not a pass"*
cümlesini de aldı — ama o cümleyi doğru kılan `run-all.sh`'i almadı.

Sonuç: bir dosyayı silmek ya da yeniden adlandırmak kapıyı **kalıcı ve sessiz** yeşile
çeviriyordu. Aynı kod, farklı bağlamda **zıt anlam**.

> **Bir davranışı port ederken sor: bunu kaynağında doğru kılan şey bu satır mı, yoksa
> onun etrafındaki bir şey mi? İkincisi ise ya onu da port et, ya davranışı değiştir.**

Bu, ikizlerde atıf şartı koymamızın (`numeric-text.ts` ↔ `numberUtils.ts`) aynı gerekçesidir:
kopyanın kendisi doğruluğunu taşımaz, **bağı taşır**.

⚠️ Ve port edilmeyeni **kaydet**: T-111'in "WHAT DID NOT PORT" listesi üç madde sayıyordu ve
`run-all.sh` o listede **yoktu** — yani eksiklik yalnız yapılmamış değil, **bilinmiyor**du da.

**Ama liste yazmak yetmez: listenin TAM olduğu ölçülmeli.** Kopyalanmayanın listesi de bir
enumerasyondur, ve §7.1'in tablosundaki vakaların **çoğu** bir enumerasyonun eksik çıkmasıdır —
her seferinde tüketici göründüğü için. Sonuncusu bu kuralın kendi vakasıydı
(`run-all.sh`, "port edilmeyenler" listesinde yoktu).

> **Bir enumerasyona dayanan her karar, enumerasyonun kendisi ölçülene kadar bir tahmindir.**

Pratik: "şunlar port edilmedi" derken kaynağı **tara**, hafızadan sayma. Kaynakta hangi
dosyalar/mekanizmalar var, hedefte hangileri yok — farkı **komutla** üret.

### Bir ÖLÇÜMÜN geçerliliği de koşullarına bağlıdır — koşulu ölçümle birlikte yaz (ZORUNLU)

Yukarıdaki kural koda yazılan **iddialar** için düşünülmüştü. T-107 adım 2 onu bir adım
genişletti: aynı şey **ölçüm sonuçları** için de geçerli.

Vaka: T-121'de ölçüldü ve commit mesajına, task'a, kod yorumuna yazıldı —

> *"Gerçek `FALSE` hücresi ile boş hücre kusursuz ayrılıyor: `raw:false` gerçek boolean'ı
> `"FALSE"` string'ine çevirir, sentinel boolean'dır."*

**Doğruydu.** İki tur sonra T-107 adım 2 `raw: false` → `raw: true` yaptı ve ölçüm **o anda
geçersizleşti**: gerçek `FALSE` artık boolean geliyor, sentinel'den ayırt edilemiyor, ve
`stripBlankCellSentinel` onu sessizce `undefined` yapıyor.

Ölçüm yanlış değildi. **Koşulu yazılmamıştı.**

> **Bir ölçümü kaydederken hangi koşul altında yapıldığını da kaydet.** Bir bayrak, bir mod,
> bir ortam değişkeni, bir kütüphane seçeneği değiştiğinde o ölçüm otomatik olarak geçersizdir
> — ve koşul yazılıysa, o bayrağı değiştiren kişi onu görür.

- ❌ "gerçek FALSE hücresi ayırt ediliyor — ölçüldü"
- ✅ "**`raw: false` altında** gerçek FALSE hücresi ayırt ediliyor — ölçüldü; `raw: true`'da bu
  ayrım kaybolur"

Pratik test: ölçümünü bir cümlede yazarken **"hangi ayarla?"** diye sor. Cevap varsa cümleye
girer. Cevap yoksa ölçüm muhtemelen eksiktir.

⚠️ Ve bu, testin işini yapmasını engellemez — **tersine, testin değeri budur.** Aynı turda o
ayrımı pinleyen bir test yazılmıştı ("bir guard'ı yok" bulgusu üzerine); bayrak değişince
**tek kırmızı o oldu**. Yorum bayatlar, test bayatlamaz — ama test yalnız yazıldıysa vardır.

Bir sözleşmenin (transformer, guard, invariant) geçerliliği **çağıranın bugünkü şekline bağlı
olamaz.** "Bugün ulaşılamaz" bir kapsam gerekçesi olabilir, ama asla bir **koruma kaldırma**
gerekçesi değildir.

### Dokümanda sayı yazma — niteliksel ayırt edici yaz (ZORUNLU)

Üç ayrı vakada bir yoruma/rapora yazılmış sayı yanlış çıktı ("34 e2e gövdesi" → 38; "eleven
e2e cases" → 13; aynı ifadenin ikizi 12'yi kastediyordu). **Üçü de yanlış değildi — üçü farklı
şey sayıyordu**, ve hepsi bir sonraki test eklendiğinde bayatlayacaktı.

Bu, kalibrasyon bulgusunun kardeşidir: **ölçülmemiş sayılar düşük çıkar, ölçülmüş sayılar
bayatlar.** İkisinin ortak dersi aynı: dokümanda ve kod yorumunda **sayı yerine niteliksel
ayırt ediciyi** yaz.

- ❌ "on bir e2e testi bunu kapsıyor" · "34 gövdenin hiçbirinde yok"
- ✅ "her biri mekanikleri **tek istekte** gönderiyor — ayırt edici olan şekil" · "**hiçbiri**"

Sayı bakım gerektiren bir olgudur; şekil ve "hiçbiri/hepsi" gerektirmez.


## 3. Ekip (subagent'lar — `.claude/agents/`)

| Agent | Ne zaman delege et |
|---|---|
| `planner` | Büyük/belirsiz iş → epic+task'lara böl, BRD ile hizala, plan çıkar |
| `architect` | Mimari karar/review, modül sınırı, KPI engine & RBAC pattern uyumu |
| `backend-engineer` | NestJS/TypeORM/PostgreSQL implementasyon, modül, API |
| `frontend-engineer` | React UI tasarım + implementasyon, grid/form, Tailwind/shadcn |
| `qa-engineer` | Test yazma/çalıştırma (Jest backend, Vitest frontend), QA planı |
| `debugger` | Bug teşhis + fix, kök neden, regresyon |
| `code-reviewer` | Commit/push öncesi diff review |
| `data-analyst` | KPI/raporlama analizi, SQL içgörü (read-only) |
| `data-engineer` | Migration, seed, ETL, şema, veri pipeline |

**Sorumluluk sınırları (ZORUNLU):**
- **Migration yalnız `data-engineer` yazar.** `backend-engineer` entity değiştirip migration
  gerektiriyorsa task'ı böl.
- `code-reviewer` ve `data-analyst` **kod/veri değiştirmez.** Bulgu raporlar.
- Bir ajan kendi yazdığı kodun testini yazmaz — o `qa-engineer`'ın işidir.
- **`docs/brd-v2/03_IS_KURALLARI/L2_*` dosyalarını YALNIZ Team Lead yazar** — ve tek yazar
  yetmez, **tek kanal** gerekir: kural metni Team Lead'e verilir, Team Lead işler. Yerel ya
  da paralel oturumlar `L2`'ye **dokunmaz** (kod · migration · ölçüm evet, belge hayır).

  > **Gerekçe ölçüldü (2026-08-13) — `F1`'in tekrarı, hem de adı konduktan sonra.** Bir
  > kural metni sohbete yazıldı ve **iki farklı ajana ulaşabilir hâlde** kaldı; ikisi de
  > işledi. Sonuç iki kopya: `K-2.6.4` bir kopyada beş kurala açıldı (`65→70`), diğerinde
  > `⛔ açık` kaldı (`363`). Kural *"tek yazar"*dı ve **ihlal edilmedi** — her kopyayı ayrı
  > bir "tek yazar" yazdı. Eksik olan **kanaldı.**
  >
  > **Bir sahiplik kuralı, girdinin kaç yere ulaştığını sınırlamıyorsa eksiktir.**

**Her ajan için geçerli ölçüm kuralları (ZORUNLU — Team Lead'e özel değil):**

Bunlar §2.6/§2.7'de gerekçeleriyle duruyor, ama delege edilen ajan o bölümü okumayabilir. En
pahalıya mal olan dördü burada da:

- **Exit kodunu boruya sokma.** `cmd > log 2>&1; echo $?` — `cmd | grep` değil.
- **Taban ölçümü için `git stash` KULLANMA.** Kapsamı örtük, untracked dosyalarla etkileşimi
  sürprizli. `git show HEAD:<dosya>` dar, kesin ve geri alma gerektirmez.
- **`git checkout` ile geri alma iki yönden yanıltır:** untracked dosyada **sessizce hiçbir şey
  yapmaz** (mutasyonlar birikir), tracked dosyada ise **HEAD'e** döner — yani commit edilmemiş
  başkasının işini siler. Her iki durumda da geri almanın **sonucunu** `shasum -a 256 -c` ile
  doğrula. (İkincisi bu oturumda yaşandı: bir alt-ajanın commit edilmemiş düzeltmeleri
  `git checkout` ile silindi; kaybı görünür kılan şey [[T-116]] ile açılan tip kapısı oldu.)
- **Mutasyon için `git checkout` ile geri alma — kullanma, ARAÇ kullan.** Bu oturumda kuralı
  yazan kişi onu ihlal etti ve commit edilmemiş bir dosyanın işini sildi: `grep` boş döndü,
  değişken `-1` oldu, `git checkout` tracked dosyayı HEAD'e döndürdü. Doğru şekil:
  **dosyayı kopyala → mutasyonu uygula → kopyadan geri yükle → `shasum -a 256 -c` ile doğrula.**
  ([[T-128]] bunu bir script'e indiriyor — kuralı hatırlamak yerine aracı çağırmak.)
- **Mutasyonun MEKANİZMAYA uygulandığını doğrula**, yalnız "uygulandı"yı değil — `replace(...,1)`
  ilk metin eşleşmesine düşer ve o çoğu zaman bir yorumdur. Beklediğin test kırılmıyorsa ilk
  hipotez "mutasyon yanlış yere düştü" olmalı, "test kör" değil.

---

## 4. Yeni Görev Akışı (ZORUNLU — tekrarı önler)

1. **Önce ara:** `BACKLOG.md` + `.claude/backlog/tasks/` içinde aynı/benzer task var mı?
   - **Varsa** → o task'ı devam ettir/güncelle. **YENİ TASK AÇMA.**
   - **Yoksa** → yeni task dosyası oluştur (`.claude/backlog/tasks/<id>.md`), uygun agent'a `assignee` ata, `BACKLOG.md` indeksine satır ekle.
2. **Dekompozisyon:** büyük iş → epic (`epics/<id>.md`) → task'lar. Her task tek agent'a.
### ⛔ `touches:` KESİŞİMİ GEREKLİ AMA YETERLİ DEĞİL — ağaç PAYLAŞILIR (ZORUNLU)

> **Paralel ajanlar dosya kesişmese bile AYNI WORKING TREE'yi paylaşır.**
> **Çakışma yalnız yazma anında değil, DOĞRULAMA anında olur.**

Ölçülmüş vaka (2026-08-23, `T-269` ∥ `T-270`): `touches:` kesişimi **sıfır**du ve
davranışsal kesişim de ölçülüp **sıfır** çıkmıştı. İkisi de doğruydu. Yine de:

```
T-270 yarım bir düzenleme bıraktı  →  ana ağaç DERLENEMEZ oldu
                                      (ReferenceError → TS2304)
T-269 kendi diff'ini doğrulayamadı —  çünkü `npm test` AĞACIN TAMAMINI derler
```

📌 **Mekanizma:** bir test suite'i, bir `tsc`, bir guard koşumu **tüm ağacı** okur.
Disjoint dosyalar bunu değiştirmez — bir ajanın yarım işi, diğerinin **ölçüm aracını**
bozar. Ve sonuç `§2.7`'nin en kötü şekli: **kırmızı, ama kendi kodundan değil.**

⚠️ Ve daha sinsi bir yön: paylaşılan ağaçta `--fix`, mutasyon ya da `git checkout`
çalıştıran bir ajan **diğerinin commit edilmemiş işini siler** — bu oturumda bir kez
yaşandı ve kaybı görünür kılan şey bir tip kapısı olmuştu.

**Pratik — paralel başlatırken üç şey:**

```
1  touches: kesişimi          ← gerekli, yeterli DEĞİL
2  davranışsal kesişim         ← aynı yüzeye veri besliyorlar mı
3  DOĞRULAMA izolasyonu        ← BU EKSİKTİ
```

Üçüncüsü için brief'e bir satır: **doğrulamanı izole bir `git worktree`'de yap; paylaşılan
ağaçta `--fix`/mutasyon/`git checkout` çalıştırma.** (`T-269`'un ajanı bunu kendiliğinden
yaptı ve turu kurtardı — ama brief'te yazılı değildi, yani **şansa kalmıştı**.)

Ve Team Lead tarafında: **commit SEÇİCİ yapılır** (`git add <yol>`), `git add -A` değil —
yoksa diğerinin yarım işi commit'e girer.

3. **Çakışma kontrolü (YENİ — ZORUNLU):** her task'ta `touches:` alanı dolu olmalı
   (dokunulacak dosya/modül listesi). **Paralel başlatmadan önce `touches:` kesişimini kontrol
   et.** Kesişim varsa paralel değil, **sıralı** çalıştır.
   Migration numarası alacak task varsa `.claude/backlog/MIGRATION_SEQUENCE.md`'den numara
   tahsis et — **ajan kendi numarasını seçmez.**
4. **Delege:** bağımsız task'ları **tek mesajda paralel** başlat (Agent tool, birden çok çağrı). Bağımlı olanları sırala.
5. **İlerleme:** agent bitirince task `status` + `updated` alanını güncelle, `BACKLOG.md`'yi senkronla.

Task/epic/sprint dosya formatı: [.claude/backlog/BACKLOG.md](.claude/backlog/BACKLOG.md) başındaki şablona uy.

### 4.1 Delegasyonda bağlam sadakati (ZORUNLU)

Alt-ajana iş verirken **kaynağı referansla ver, özetini değil.**

- ✅ `ADR 0004 Karar 2` · `rules.md §8` · `docs/analysis/0008 §5.7` · `agreement.service.ts:438`
- ❌ "hatırladığım kadarıyla eşik %95'ti" · "sanırım kısmi rezervasyon yasak"

Özet vermen gerekiyorsa **kaynağı da ekle** ki ajan doğrulayabilsin. Finansal bir sistemde
özet-kaybı sessiz yanlış sayı üretir.

### 4.2 "Done" tanımı (ZORUNLU — hepsi sağlanmadan `done` yazılmaz)

- [ ] Testler yeşil (unit + ilgili e2e)
- [ ] `npm run guards` yeşil (backend'e dokunulduysa) — exit 0
- [ ] `bash scripts/guards/money-float.sh --ratchet` exit 0 — **hiçbir** Alan A dosyasının
      bulgu sayısı artmamış olmalı. Azalma beklenen ve iyidir: azaldıysa yeni referansı
      `--baseline > scripts/guards/money-float-baseline.txt` ile ayrı, gözden geçirilebilir
      bir commit'te güncelle (baseline asla kendini yazmaz). **Baseline commit'i, azalmayı
      üreten commit'ten SONRA gelir** — önce gelirse ratchet o aralıkta kör kalır.
      Alan A üyelik testi: bir modül para üretiyor, para kalıcılaştırıyor veya parayı bir
      eşikle karşılaştırıyorsa Alan A'dadır — liste: `scripts/guards/money-float-domain-a.txt`
- [ ] `code-reviewer` onayı
- [ ] **Üretim çağrı yolu var mı?** Bu kodu çağıran HTTP route / zamanlanmış iş / event nedir?
      Yol yoksa status `done` DEĞİL → **`blocked-unreachable`**
- [ ] Bağlayıcı koşullar bir guard'a bağlandı (test / lint / DB constraint / CI).
      Bağlanamıyorsa koşul "tavsiye"ye düşürülür ve öyle işaretlenir.
- [ ] `touches:` alanı gerçekte dokunulan dosyalarla güncel
- [ ] Migration varsa: **catalogue guard'ları şema-nitelendirilmiş** (`nspname`/`schemaname`
      predicate'i olmadan `pg_constraint`/`pg_indexes` sorgulanmaz)
- [ ] **Bir DB nesnesinin YOKLUĞUNU iddia etmeden önce iki katalogu da sorgula.**
      TypeORM'un `@Index({ unique: true })`'i bir **index** yaratır, constraint değil — yani
      `pg_constraint` boş görünürken `pg_indexes` dolu olabilir. T-101'de tam bu oldu:
      `pg_constraint`'te yokluk görülüp "UNIQUE yok" denildi, oysa index migration
      `1771169825000`'den beri duruyordu. **Bir katalogdaki yokluk, yokluk değildir.**

> Üçüncü madde neden var: bu projede "mekanizma var, ona giden yol yok" hatası **sekiz kez**
> tekrarlandı (T-033, T-036, T-039, T-046d, T-048, T-052, T-053, T-062). Her task kendi
> ölçütünde yeşil geçti, ürün etkisi sıfır oldu. Bu madde o sınıfı kapatır.

---

## 5. Git / Bitbucket Workflow

- **Çoklu repo:** backend/frontend ayrı repolardır (submodule). Kök repo `collmind.team`
  kod tutmaz; her submodule'ün **commit pointer'ını** tutar.
  **Push sırası ZORUNLU olarak `scripts/push-order.sh` ile yapılır — elle `git push`
  zinciri YASAK.** Gerekçe: Team Lead push sırasını elle **iki kez** ters yaptı (meta →
  submodule), meta pointer origin'de henüz görünmeyen submodule commit'lerine işaret
  etti (T-212 Kalem 3). "Bir daha dikkat ederim" iki kez söylendi, iki kez tutmadı —
  kural artık bir script, bir niyet değil.

  **Akış (script'in gerektirdiği sıra — elle anlatılan eski sıranın YERİNE geçti):**
  1. Submodule'de iş biter, **submodule'de commit edilir** (henüz push YOK).
  2. Kök repoda submodule pointer'ı bump edilir ve **kök repoda commit edilir**
     (henüz push YOK) — pointer artık submodule'ün YENİ, henüz push edilmemiş
     commit'ine işaret ediyor.
  3. `bash scripts/push-order.sh` çalıştırılır. Script: her submodule'ü sırayla push
     eder, `merge-base --is-ancestor` ile origin'de **gerçekten göründüğünü** doğrular,
     kök repo'nun pointer'ının doğrulanan commit'le eştiğini sanity-check eder, **ancak
     sonra** kök repoyu push eder. Bir adım başarısız/doğrulanamazsa script durur ve
     pointer'ı doğrulanmamış bir commit'in üstüne ASLA push etmez.
  4. Bir submodule'de commit edilmemiş (henüz commit'lenmemiş) değişiklik varsa script
     **varsayılan olarak durur** (`PUSH_ORDER_ABORT_ON_DIRTY=1`) — bkz. script başlığı.
- Commit mesajı sonu: `Co-Authored-By: Claude <noreply@anthropic.com>`
  *(Model adı yazma — model değişince her commit yanlış imzalanır.)*
- Commit/push yalnızca kullanıcı isterse.
- `/sync` ile submodule'leri güncel tut.
- **`git checkout` ve `git pull` artık otomatik onaylı değil.** Paylaşılan working tree'de
  paralel ajanlar varken branch değiştirmek, başka bir ajanın altından zemini çeker.

### Doküman yeri (ZORUNLU)

**`docs/` (ölçüm, karar, sözleşme, rapor) meta-repo'da yaşar.** Submodule'lerde yalnız **kodun
okuduğu artefaktlar** bulunur (`scripts/guards/*-baseline.txt` gibi — guard onu okur, kodla
senkron değişmeli).

Gerekçe: ölçüm ve karar dokümanları birbirine referans verir (`0010` → `0013` → ADR 0007 →
`MONEY_FLOAT_BASELINE.md`). Ayrı repolara dağılırlarsa bağlantılar kırılır ve hangi sürümün
hangisine karşılık geldiği izlenemez hâle gelir.

Ölçüldü (2026-08-04): `docs/verification/` altındaki üç rapor da meta'da
(`CTPM_BASELINE_AND_PORT_AUDIT.md`, `GUARD_BASELINE_REPORT.md`, `MONEY_FLOAT_BASELINE.md`) —
kural bugün **ihlalsiz**. `collmind.backend/docs/` altında kalanlar (`safe-prompt-standard-v2.md`,
`safe-prompts/`) ölçüm/karar dokümanı değil, prompt şablonlarıdır; **geriye dönük taşınmıyor**.

### Branch & Release Modeli (ZORUNLU — her üç repoda)

İki kalıcı branch:
- **`staging`** → TÜM geliştirme burada olur. Feature/bugfix branch'leri staging'den açılır, staging'e merge edilir.
- **`main`** → **production/release** branch'i. Yalnızca release promote'u ile güncellenir. **ASLA doğrudan commit/push edilmez.**

**Release akışı (manuel promote, pipeline yok):**
1. `staging` yeşil olmalı (testler geçiyor, code-reviewer onayı).
2. Release tag'i **staging'de** atılır: `vMAJOR.MINOR.PATCH` (semver). Üç repoda da **aynı sürüm**.
3. Promote: `staging → main` merge, `main` push edilir.
4. Production deploy **manuel** yapılır (otomasyon yok).

**Kurallar:**
- Yeni iş → staging'den `feature/<ad>` veya `fix/<ad>` aç → staging'e geri merge.
- `main`'e doğrudan commit/push YASAK.
- Tag yalnızca release anında, staging'den.
- `/release <vX.Y.Z>` bu akışı orkestre eder.

---

## 6. Tipik Orkestrasyon Zincirleri

- **Feature:** `planner → architect (onay) → backend ∥ frontend → qa-engineer → code-reviewer → (kullanıcı onayıyla) commit/push`
- **Bugfix:** `debugger (teşhis+fix) → qa-engineer (regresyon) → code-reviewer`
- **Data işi:** `data-analyst (analiz) → data-engineer (migration/pipeline) → qa-engineer`

Slash command'lar: `/feature`, `/bugfix`, `/sync`, `/qa`, `/standup`, `/release`.

---

## 7. Yeni kod yazmadan önce ara (ZORUNLU)

Bu projede aynı yetenek birden çok kez yazıldı: iki submit yolu, iki lumpsum dağıtım
implementasyonu, iki CSV parser, üç kez yazılmış scope mantığı.

`architect` review'ında ve her implementasyon task'ında cevaplanmalı:

> **"Bu yeteneğin mevcut bir implementasyonu var mı? Arandı mı, nerede, hangi terimlerle?"**

Cevap "yok" ise gerekçesiyle yazılır. Aranmadıysa task eksiktir.

## 7.1 Düzeltmeden önce say (ZORUNLU)

§7 "yeni kod yazmadan önce ara" der. Bunun kardeşi: **bir davranışı düzeltirken, o davranışa
giden TÜM yolları ölç.**

> **"Kardeş yol etkilenmiyor" iddiası ölçülmeden yazılamaz.**

**Altı belgelenmiş vaka** var (biri kendi içinde sekiz vakalık bir aile). Sayı burada
ölçülmüştür, tahmin değil — sayma disiplinini konu alan bir bölümde başka türlüsü olamazdı:

| Vaka | İddia | Gerçek |
|---|---|---|
| C2b | "1 okuyucu" | **18** (sonra 4 dosyada, sonra 2 tane daha) |
| T-052/T-062 ailesi | "mekanizma var" | ona giden üretim yolu yok (sekiz kez) |
| T-079 | "alan kullanılıyor" | **sıfır** çağıran |
| T-080 | "e2e'ler bu vakayı kapsıyor" | 11 test, ayırt etme gücü **sıfır** |
| T-083a | "okuma tarafını düzelttim" | yazma tarafı açıkta — ve **daha görünür** olan oydu |
| T-084 | "kardeş karşılaştırmalar güvenli" | ikisi de bozuk, biri **canlı rotada sessiz false negative** |

Sonuncusu en pahalısıydı: yanlış iddia koda **normatif** yazılmıştı — *"must not be fixed to
match"*. Yani gelecekte biri kusuru fark etse bile yorum ona "dokunma" diyecekti.
**Bir hatayı belgelemek, onu koruma altına alır.**

Pratik kural: bir düzeltme yaparken "bu deseni başka kim kullanıyor?" sorusunun cevabı bir
**grep çıktısı** olmalı, bir sezgi değil. Ve "etkilenmiyor" diyorsan, **neden** etkilenmediğini
ölçtüğün şeyle birlikte yaz — sonraki okuyucu o gerekçeyi doğrulayabilsin.

### Bir CACHE İNVALİDASYONU yazıldığında çağıranı AYNI TURDA bağlanır (ZORUNLU)

> **Bir cache invalidasyonu yazıldığında çağıranı aynı turda bağlanır.**
> **Bağlanmazsa o mekanizma "var ama yol yok" ailesinin sessiz bir üyesidir — ve
> sessizliği FAIL-OPEN yöndedir: eski değer okunmaya devam eder.**

`T-052/T-062` ailesi *"mekanizma var, üretim yolu yok"* diyor ve sekiz vakası sayılı.
Cache invalidasyonu o ailenin **özel bir sınıfı**, ve iki farkı var:

| | genel aile | cache invalidasyonu |
|---|---|---|
| çağıransız hâli | özellik **çalışmaz** — görünür | özellik **eski veriyle çalışır** — görünmez |
| yönü | değişken | **fail-open** (eski, daha geniş yetki okunur) |

**İki ölçülmüş vaka — ve ikincisi kuralı doğurdu:**

| # | mekanizma | çağıran | sonucu |
|---|---|---|---|
| 1 | `kpi.service` `clearCache` (`T-039`) | **0 üretim çağıranı** | eski KPI konfigürasyonu okunmaya devam ediyordu |
| 2 | `access-scope.service` `clearCache` (`T-242a`, 2026-08-20) | **0 üretim çağıranı** | `REVOKE_ALL`'dan sonra **5 sn boyunca kaldırılmış kapsamda işlem yapılabiliyor** |

⚠️ **İkincisinin yönü can alıcı:** bir **erişim kaldırma** ucu yazıldı, ve kaldırma
5 sn gecikiyor. Sözlüğün kendi ifadesiyle `REVOKE_ALL` *"bir güncelleme değil, bir
erişim kaldırma"* — **bir erişim kaldırma gecikemez.**

📌 Ve TTL'in kısalığı bir savunma değil: *"5 sn küçük"* argümanı, kusurun **yönünü**
değil **büyüklüğünü** tartışıyor. Fail-open bir gecikme, süresi ne olursa olsun bir
yetki penceresi açar.

**Pratik:** bir `clearCache`/`invalidate`/`evict` yazdığında ya da bulduğunda, **aynı
turda** iki soruyu cevapla:

```
1. Bu cache'in içeriğini DEĞİŞTİREN her yazma yolu hangisi?   ← say, hafızadan değil
2. Her biri invalidasyonu çağırıyor mu?                        ← grep çıktısıyla
```

Cevap *"hayır"*sa, çağırmak bu turun işidir — ayrı bir task değil. Çünkü invalidasyonu
yazan tur, onu **çağırmanın gerektiğini bilen tek turdur**.

### `new Date(kullanıcıGirdisi)` — beş sessiz hata biçimi, hepsi ölçüldü (ZORUNLU)

`parseFloat` için söylediğimizin tarih karşılığı: **hata vermez, yanlış yapar.** T-107/T-121/
T-123 boyunca beş ayrı biçim ölçüldü ve **beşi de sessiz**:

| girdi | `new Date` ne yapıyor |
|---|---|
| `"3/4/26"` | sessizce **ABD** sırası — Türk kullanıcının 3 Nisan'ı **4 Mart** oluyor (bir AY) |
| `"15/1/26"` | `Invalid` → çağıran sessizce `undefined` döndürüyordu |
| `"46037"` | **yıl 46036** — `Invalid` değil |
| `"2026-01-15"` ↔ `"1/15/26"` | biri **UTC**, diğeri **yerel** gece yarısı olarak ayrıştırılıyor |
| `"2026-02-30"` | sessizce **Mart'a taşıyor** (rollover) |

Dördüncüsü kurumsal olarak en sinsi: aynı fonksiyon, girdi biçimine göre **farklı takvim** —
bu yüzden hiçbir biçimlendirici ikisini birden düzeltemez.

> **`new Date()` bir kullanıcı girdisi için hiçbir zaman doğru araç değildir.** Tarih-yalnız
> değer bir **takvim günüdür**, `Date` ise bir **an**; ikisini aynı tipte temsil etmek saat
> dilimi belirsizliğini yapısal olarak davet eder.
>
> Katı bir gramerden geçir (`src/common/date/date-text.ts`), kanonik `YYYY-MM-DD` **string**
> taşı, `Date` kurma.

### Sessiz VARSAYILAN ile sessiz FALLBACK aynı şey değildir (ZORUNLU — §2.5'in sınırı)

§2.5 *bilgi uydurmayı* yasaklıyor. Başka bir **kaynağa** düşmek farklı bir şeydir:

| | ne yapıyor | statü |
|---|---|---|
| sessiz **varsayılan** | bilgi **uyduruyor** — `?? 0`, `catch { return 0 }` | **YASAK** |
| sessiz **fallback** | başka bir **kaynak** kullanıyor — `agreement.periodMonth`, `invoiceDate`'ten türetilen dönem | iyileştirilmeli, ama **uydurma değil** |

> **Katılığı, teslimi olmayan bir yere ekleme.** Ve geri alıyorsan **neden**ini koda yaz —
> yoksa altı ay sonra biri *"burada neden katılık yok?"* diye sorar ve cevabı bulamaz.

### ⚠️ AMA fallback'in meşruiyeti dar: birincil kaynak GERÇEKTEN okunamıyor olmalı

Bu kural bir kez fazla geniş uygulandı ve **sessiz yanlış değer** üretti. T-123'te
`off-invoice.getFiscalPeriod`'un throw'u geri alındı; gerekçe *"tek bozuk hücre tüm dosyayı
düşürüyor"*du ve **tek bir girdi şekli** (`"çöp"`) ölçülüp genellenmişti.

Review başka şekilleri ölçtü — **önceden doğru okunanları**:

| hücre | geri almadan önce | geri almadan sonra |
|---|---|---|
| `2026/01` · `2026-1` | `2026-01` ✓ | **`undefined`** → fallback |
| `2026-01-15 00:00:00` · ISO datetime | `2026-01` ✓ | **`undefined`** → fallback |
| `2026/01/15` · `01/15/2026` · `Jan 2026` | `2026-01` ✓ | **`undefined`** → fallback |

Bunlar çöp değildi. Yedisi de sessizce `agreement.periodMonth`'a düşüyordu — çok dönemli bir
anlaşmada **başka bir ay**, yani `findEnvelopeByDimensions` **başka bir zarfı** buluyor ve
bütçe yanlış zarftan iniyor. Kullanıcı hiçbir hata görmüyor.

> **Fallback, birincil kaynak YOKSA meşrudur. Birincil kaynak VARKEN ona düşmek ikamedir —
> ve ikame sessiz olamaz.**
>
> ⚠️ *"Gramerimiz tanımıyor"* okunamamak **değildir**. Değer oradaydı ve okunabiliyordu;
> onu başka bir kaynakla sessizce değiştirmek, `?? 0` kadar bilgi kaybıdır — yalnız daha az
> görünür.

Ve kararın kendisi bir ölçüm hatasından doğdu: **bir girdi şekli ölçülüp genellendi.** Bir
kapsam kararı vermeden önce, o kararın etkilediği girdi kümesini **tara** — tek örnek bir
kümeyi temsil etmez.

### Bir doğrulamanın "çalıştığı" sanılması, girdinin ona hiç ULAŞMAMASINDAN gelebilir (ZORUNLU)

"Mekanizma var, ona giden yol yok" sınıfının **doğrulama tarafındaki** hâli — ve daha sinsi,
çünkü burada mekanizma yalnız ölü değil, **sağlıklı görünüyor.**

T-107 adım 2'de ölçüldü: `off-invoice`'un *"Amount değeri pozitif olmalıdır"* kuralı yıllardır
kodda duruyor. Ama `raw: true` öncesinde gerçek bir `0`, `||` alias zinciri tarafından **zaten
düşürülüyordu** — yani kurala hiç `0` ulaşmıyordu. Kural hiç ateşlemedi, hiç kırmızıya
dönmedi, ve tam bu yüzden **hiç sorgulanmadı**.

`pickCell` sıfırları oraya vardırınca kural **ilk kez gerçekten tetiklenecek**. Yanlışsa,
bugüne kadar görünmeyen bir ret üretmeye başlayacak ([[T-124]]).

> **Bir kuralın doğru olduğunu, kırmızıya dönmemesinden çıkarma.** Önce sor: o kuralın
> reddedeceği girdi ona **ulaşıyor mu**? Ulaşmıyorsa kural test edilmemiştir — ne doğru
> olduğu bilinir, ne yanlış.

Pratik: bir doğrulama kuralı bulduğunda, onu **kasten tetikle**. Tetiklenemiyorsa kuralın
kendisinden önce **yolunu** araştır. Ve bir girdi yolunu genişleten her değişiklik (bir bayrak,
bir parser, bir tip gevşemesi) uykudaki kuralları **uyandırır** — o değişikliğin kapsamına
"hangi kurallar ilk kez ateşleyecek?" sorusu dahildir.

> **KAPSAM, kusurun SINIFIYLA tanımlanır — bulunduğu ilk vakanın YAZIMIYLA değil.**

Ölçülmüş vaka (2026-08-14, gri→yeşil sızıntısı): kusur `ragStatus: plan.ragStatus || 'GREEN'`
olarak bulundu. Kapsam **altı şekilde** tarandı — `|| 'GREEN'` · `?? 'GREEN'` ·
`|| RagStatus.*` · düz varsayılan · `= 'GREEN'` · frontend — ve *"tam olarak iki nokta,
`T-093` deseni tekrarlamadı"* diye raporlandı.

**Altı şeklin hepsi bir `GREEN` VARSAYILANININ yazımıydı.** Kusur sınıfı ise daha geniş:
**"rengin yokluğu bir renge çöküyor."** Bir tur sonra `frontend-engineer` buldu:

```
GrandTotals.tsx:25   if (!ragStatus || ragStatus === 'AMBER') → '• RİSKLİ'
```

Aynı sınıf, **ters yön** — `null` bir güvence yerine bir **iş yargısına** çöküyor. O
literalin dışında, o sınıfın içinde.

> Altı şekli aramak, aramanın **derinliğini** artırdı ve **evrenini** hiç sorgulamadı.
> Bir literalin altı yazımı hâlâ bir literaldir.

**Pratik:** kapsam taramasına başlamadan önce kusuru **sınıf olarak bir cümlede yaz**, ve
şekilleri o cümleden türet — bulduğun koddan değil. *"`|| 'GREEN'` nerede"* dar bir soru;
*"renk yokluğu nerede bir renge dönüşüyor"* doğru soru, ve `AMBER`'i de, `return null`'ı da,
Excel'e yazılan ham değeri de kapsar.

> **Bir kusur sınıfı bulduğun dosyada, aynı sınıfın diğer örneklerini ara.
> Kusurlar dosya bazlı kümelenir.**

> **Bir kalıbı ararken her iki ucunu ara: neye yazıldığını VE neyin okunduğunu.**
> Tek uçtan arama kalıbın yarısını görünmez bırakır.

**Ve bir import taraması, göreli yolun HER yazımını kapsamalıdır (ZORUNLU).**

```
'./x'  ·  '../x'  ·  '../../x'  ·  alias'lar
```

Hepsi **aynı hedefi** gösterir, ve tek yazım aranırsa tüketici sayısı **sistematik olarak
DÜŞÜK** çıkar. Bu, kapsam kuralının (*sınıfla ara, literalle değil*) **yol tarafındaki**
hâli.

> **Doğru desen: DİZİN ADIYLA ara, göreli önekle değil.**

Ölçülmüş vaka (2026-08-14, iki farklı turda): `entities/index.ts`'in tüketicisi arandı.

| tur | desen | bulunan | gerçek |
|---|---|---|---|
| 1 | `from './entities'` | **1** | — |
| 2 | `entities'` (dizin adı) | **3** | `database.module` `'./entities'` · `typeorm.config` `'../database/entities'` · `master-data.module` `'../../database/entities'` |

Birinci ölçüm bir **kaldırma kararının** girdisiydi: *"tek tüketici, kaldırması dar"* —
oysa tüketicilerden biri **kanonik olacak dosyanın kendisiydi**.

📌 `decimal` (entity dili) ↔ `numeric` (katalog dili) tuzağının kardeşi: **aynı kavram, iki
yazım.** Orada iki farklı yüzeyin sözlüğü ayrışıyordu; burada **aynı yüzeyin** kendi
içindeki göreli konum.

**Ve iki uç da yetmeyebilir — kapsamı DOSYA TİPİYLE değil, YAZAN HER YOLLA tanımla
(ZORUNLU).**

T-163'te bir değer **üç** yerde tanımlıydı ve üçü de **sırayla**, her biri bir öncekinin
düzeltmesinden **sonra** bulundu:

| # | yer | nasıl bulundu |
|---|---|---|
| 1 | `migration` | task'ın kendisi |
| 2 | `seeds/kpi.seed.ts` (CLI, idempotent upsert) | `data-engineer` |
| 3 | **`kpi.service.ts` `seedDefaults()`** | `code-reviewer` |

Üçüncüsü diğer ikisinden **tür olarak** farklıydı: bir seed dosyası değil, **canlı bir HTTP
rotası** (`@Roles(ADMIN)`), ve upsert alan kümesi değeri **üzerine yazıyordu**. Düzeltilmiş
bir tenant'ta tek bir admin çağrısı ADR'yi **sessizce geri alırdı**.

> **Arama sorusu *"bu dosya tipinde başka var mı"* değil, *"bu değeri YAZAN başka hangi yol
> var"* olmalı** — seed · migration · servis varsayılanı · test fixture'ı · e2e seed ·
> HTTP ucu · frontend sabiti. Tür listesi hafızadan değil, **kalıbın kendisiyle** taranır.

**Ve bir taramanın PENCERESİ girdi sınırına bağlanmalı, sabit bir uzunluğa değil (ZORUNLU).**

Aynı turda Team Lead iki listeyi karşılaştırırken sabit **1400 karakterlik** pencere
kullandı; bir girdinin penceresi bir sonrakine taştı ve **sahte bir fark** üretti. Sınır
"bir sonraki girdinin başlangıcı" yapılınca fark **sıfır** çıktı.

Bu, `migration-schema.sh`'ın `±10 satır` penceresiyle **aynı sınıf** — orada da sabit
pencere maskeleme üretmişti ve çözüm blok sınırı olmuştu. Fark yön: orada **kusur
gizleniyordu**, burada **olmayan kusur üretildi**.

> **Sabit pencere iki yönde birden yanılır.** Pencereyi ölçtüğün şeyin doğal sınırına bağla.

T-091 bunun kanıtı: transformer'lı **hedef** alanları arandı (10 aday, 4 bozuk), transformer'sız
**kaynak** alanların biriktirilmesi aranmadı — `finance-reporting`'deki aynı kusur (iki canlı
GET rotası) o yüzden ağa takılmadı.

> **Kelime sınırlı sayım da bir gürültü ölçüsü olabilir. Yüksek sayı bir okuma gerekçesi
> değil; örnekleyip ANLAMI doğrula.**

Alt-string sayımının yanıltıcılığı bilinen bir tuzaktı (`\bRAG\b` = 0 iken `grep -c RAG` = 8;
`average`/`storage`/`leverage` içindeydi). Kelime sınırı onu kapatır — **ama anlamı
kapatmaz.**

Ölçüldü (BRD envanter turu): `Section_01`'de `grep -owci capability` → **15**. Sayıya bakarak
*"CBAC burada tartışılıyor"* denip bölüm okuma listesine alınacaktı. Örneklendi:

> *"a next-generation **solution** designed to address the diverse operational needs"* ·
> *"the platform **recognizes** that maturity is not binary"*

**İş anlamında "yetenek" — CBAC'ın `capability`'si değil.** Aynı kelime, farklı kavram.

> Sorun **yazımda değil, anlamda**. Kelime sınırı yazımı çözer; anlamı yalnız **örnekleme**
> çözer. Bir terim sayısına dayanarak karar veriyorsan (oku/atla, var/yok), **en az bir
> geçişi bağlamıyla oku.**

**Ve kelime sınırı gürültüyü keserken TÜREV BİÇİMLERİ de keser (ZORUNLU).**

TTM ölçümünde yaşandı: `grep -ow 'settlement'` → **16**, ve `apps/api/src/settlements/`
**modülünün kendisi bu sayının dışındaydı** — `-w` çoğulu eşleştirmez.

Sayı makul göründüğü için uyarı vermedi. (Aynı turdaki diğer hata — `grep -c | wc -l`'in
beş terim için de `501` vermesi — **anormal** olduğu için hemen yakalandı; bu ise
**normal göründüğü için** neredeyse geçiyordu.)

> **Kelime sınırı bir gürültü filtresidir, bir kapsam garantisi değil.** Çoğullar, ekli
> hâller ve bileşikler (`settlements`, `claiming`, `recognition` ↔ `recognized`) ayrıca
> aranmalı — ya da gövde ile ara ve gürültüyü **örnekleyerek** ele.

- ❌ `grep -owc 'settlement'` tek başına → modül adını kaçırır
- ✅ gövde (`grep -oi 'settlement'`) + örnekleme, ya da her iki ölçümü de yaz

> **Bir ölçüm beklediğin sonucu verdiğinde, o sonucun BAŞKA bir açıklaması olup olmadığını sor.
> Özellikle sıfır, boş ve yokluk sonuçlarında — onların her zaman en az iki açıklaması vardır.**

T-095 bunun kanıtı: *"`budget_transaction_logs` 0 satır → `NOT NULL` bedelsiz"* ölçüldü. **Sayı
doğruydu, çıkarım yanlıştı.** Tablo boştu çünkü **hiç yazılamıyordu** — `created_by` iki kez
map'lenmiş, her INSERT `42701` veriyor, dört bütçe rotası 500 dönüyor. "Neden 0?" sorulmadı.

Diğer ölçüm hataları yanlış cevap verir ya da hiçbir şey ölçmez; bu **doğru sayıyı verip yanlış
sonuç çıkarttırır** — ve o yüzden en zor fark edilenidir.

> **Ve simetriği: bir satırın VARLIĞININ da en az iki açıklaması vardır.**

§7.1'in "neden 0?" maddesi yokluk için yazılmıştı. T-107 adım 2'de tersi yaşandı: bir alt-ajan
`main.customers`'da 63 satır `E2E-PW-UPLOAD-*` bulup **"pre-existing sızıntı"** diye raporladı,
ve Team Lead neredeyse bir task açıyordu. Ölçüm başka bir şey söyledi:

```
canlı: 0   ·   soft_silinmis: 63          ← hepsinde deleted_at dolu
DELETE /customers/:id -> customerRepository.softRemove(customer)
```

Temizlik **çalışmıştı**. Kalanlar öksüz değil, ürünün tasarladığı **mezar taşları**.

> **"Neden 0?" kadar "neden var?" da sorulmalı.** Bir satırın varlığı sızıntı da olabilir,
> tasarım da; sayı ikisini ayırt etmez.

⚠️ Ve bu, bu oturumdaki ölçüm hatalarının ilk **fazla ölçüm** vakasıydı — öncekilerin hepsi
eksik ölçümdü (bir kusur görülmedi). Yön farkı önemli: eksik ölçüm bir kusuru kaçırır, fazla
ölçüm **olmayan bir kusur için iş üretir** ve gerçek kusurların önüne geçer.

### Beklenen YÖNE yanılan bir hata, ters yöne yanılandan TEHLİKELİDİR (ZORUNLU)

> **Beklenen yöne yanılan bir ölçüm hatası, ters yöne yanılandan tehlikelidir — çünkü
> sonuç makul görünür ve sorgulanmaz.**
>
> **Pratik sonucu: bir hipotezi DOĞRULAYAN ölçüm, ÇÜRÜTEN ölçümden daha fazla
> doğrulama ister.**

Yukarıdaki madde *"neden 0?"* / *"neden var?"* ile **sonucun** iki açıklaması olduğunu
söylüyor. Bu, **hatanın yönü** hakkında: aynı büyüklükteki iki hata eşit tehlikeli
değildir.

Ölçülmüş vaka — tek turda **üç** ölçüm hatası, ve yakalanma sebepleri farklı:

| hata | yönü | nasıl yakalandı |
|---|---|---|
| iç içe spread sabiti çözülemedi → `sales-actuals`'ın **4 rotası düştü** | **beklenen yöne** — sonuç hipotezi *doğrular* göründü | ⚠️ **neredeyse geçiyordu**; ayrı bir soru sorulunca çıktı |
| yorumdaki `@Roles(` kazandı → `plans/:id/reject` *"filtresiz"* | tuhaf — kardeşi kapalıyken bu açıktı | **kendi içinde tutarsızdı**, bakıldı |
| `audit-log` e2e'de *"3 geçiş"* | tuhaf — `0` bekleniyordu | **pozitif kontrol alarm verdi**, bakıldı (üçü de **yorum**du) |

**İkisi tuhaf olduğu için yakalandı. Biri makul göründüğü için neredeyse geçiyordu** —
ve o biri, düşen dört rota, tam da **hipotezi çürüten kanıttı**. Raporlansaydı hipotez
*"ölçüldü ve doğrulandı"* diye kaydedilecekti.

**Pratik — asimetrik doğrulama:**

- Ölçüm hipotezini **çürütüyorsa**: sonuç zaten dikkat çeker, olağan doğrulama yeter.
- Ölçüm hipotezini **doğruluyorsa**: bir **ikinci ölçüm** yap — farklı desen, farklı
  yüzey ya da farklı araç. *"Beklediğimi buldum"* bir bitiş değil, bir **tetikleyicidir**.
- Ve tuhaflığı bir gürültü sayma: **tutarsız görünen bir sonuç, en ucuz kusur
  dedektörüdür.** Bu turda iki kusuru o yakaladı, hiçbir guard yakalamadı.

### `LEFT JOIN` + `IS NULL` bir YOKLUK testi DEĞİLDİR (ZORUNLU)

> **`LEFT JOIN` ile `IS NULL`, iki farklı durumu aynı sonuca çevirir:**
> **"eşleşme yok" ve "değerin kendisi `NULL`". Ayrım açıkça yazılmalı.**

`sol.fk IS NULL` yazdığında sorduğun şey *"öksüz mü"* değildir. `LEFT JOIN` eşleşme
bulamadığında sağ tarafın **her kolonu** `NULL` olur — ve sol taraftaki `fk` zaten `NULL`
ise de sonuç aynıdır. İki anlam, tek çıktı.

**Ölçülmüş çift vaka (2026-08-17, `user_scopes` — aynı gün, aynı tuzak, iki kez):**

| # | yazılan | sanılan | gerçek |
|---|---|---|---|
| 1 | `FILTER (WHERE us.cpl_id IS NULL AND us.category_id IS NULL)` | *"joker satırı var"* | **satırı olmayan** kullanıcı da sayılıyordu → gerçek joker `0` |
| 2 | `FILTER (WHERE c.id IS NULL)` | *"öksüz satır"* | `category_id`'si **`NULL`** olan satırlar da sayılıyordu → `PLANNER`'lar `17`/`11` öksüz göründü, gerçek `0` |

**Doğru şekil — iki koşul, ikisi de açık:**

```sql
-- ÖKSÜZ = sol taraftaki değer DOLU, ama karşılığı YOK
WHERE sol.fk_id IS NOT NULL       -- ← BU SATIR unutuluyor
  AND sag.id     IS NULL

-- SATIRI YOK = join'in kendisi eşleşmedi
WHERE sag_satir.id IS NULL        -- birincil anahtarına bak, kolonuna değil
```

⚠️ **Ve ikisi de `beklenen yöne` yanıldı** — biri *"joker var"*, diğeri *"öksüz çok"*
beklentisini besliyordu. Yani bir önceki maddeyle aynı aile: **makul göründükleri için
sorgulanmıyorlardı.**

Pratik: `LEFT JOIN`'de bir yokluk sayarken, **sol taraftaki değerin dolu olduğunu ayrıca
şart koş** — ve sonucu sıfır çıkarsa `§`'nin pozitif kontrol kuralı geçerli.

### "Güvenlik" gerekçeleri en az sorgulananlardır (ZORUNLU)

İki kez ölçülüp çürütüldü:

| gerekçe | gerçek |
|---|---|
| *"`defval: false` prototype pollution'ı önlemek için"* | `defval`'ın ilgisi yok — SheetJS `__proto__` başlığını kendi işliyor (`__proto___NaN`); **iki değerde de** kirlenme yok |

Bu gerekçe bir bayrağa dokunmayı **engelliyordu** — ve o bayrak iki uyuyan kusuru perdeliyordu.

> **`security`, `safety`, `pollution`, `injection`, `sanitize` geçen bir gerekçe gördüğünde,
> ölçülmüş mü diye sor.** Bu kelimeler tartışmayı kapatır; kapattıkları için de en az
> doğrulananlardır.

> **Ve değer bir yerel değişkenden geçebilir. Doğrudan kalıbı aramak yetmez.**

T-093'te bu bir kademe daha derinleşti: `+= <entity alanı>` araması 9 nokta buldu, üç noktayı
kaçırdı — çünkü orada değer önce bir yerele alınıyordu:

```ts
const spend = pmv.calculatedSpend || 0;   // string
totalSpend += spend;                       // desenin eşleşmediği biriktirme
```

Review 3 nokta demişti, tarama 12 buldu. Aradaki fark aramanın şeklinden geliyordu, kusurun
yaygınlığından değil.

`spend-validation.service.ts` bunun kanıtı: sıfır testi vardı ve **dört** kusur sınıfı taşıyordu
(string min/max karşılaştırması, `Number.isInteger(string)`, `v !== 0` tip uyuşmazlığı, ve iki
ayrı akümülatörde string birleştirme). T-089 birini düzeltirken ikinci akümülatörü kaçırdı —
kapsam sınırı makuldü (`validateCombinations` vs `checkBudgetAvailability` ayrı fonksiyonlar),
ama **dosyayı taramak** onu ilk turda bulurdu.

Test edilmeyen dosya kusur biriktirir; ve biriktirdiği kusurlar birbirine benzer.


### Assert taşıyan migration ÜÇ durumu ayırt etmeli (ZORUNLU)

Tek seferlik veri düzeltmesi içeren bir migration, `rowcount`'u iki değere indirirse
**yalnız bir ortamda çalışabilir** hâle gelir.

Ölçülmüş vaka (2026-08-11, `1802000000000`): brief *"silinen satır 1231 değilse başarısız
olur"* diyordu. İkili yazılsaydı migration **taze/prod bir DB'de kalıcı olarak tıkanırdı**
— orada silinecek **0** satır var, 1231 değil, ve `migrations` tablosuna asla
giremeyeceği için hata **her deploy'da** tekrarlanırdı.

| durum | davranış |
|---|---|
| **beklenen** (ör. 1231 satır mevcut) | işlemi yap + assert |
| **zaten uygulanmış / taze** (0 satır) | **no-op**, sessizce geç |
| **beklenmeyen** (ara bir sayı) | **İPTAL** — küme değişmiş, sessizce geçme |

> **İkiliye indirmek, migration'ı yalnız bugünkü veritabanında çalışabilir kılar.**

⚠️ Ve dalların **en az ikisi ampirik doğrulanmalı** (`run` → `revert` → `run` döngüsü);
yazılmış bir dal, çalıştığı anlamına gelmez.

### "Sekiz vaka" gibi bir sayı, LİSTESİYLE anılır ya da HİÇ anılmaz (ZORUNLU)

`docs/analysis/0070 §B3` ölçtü: repoda *"sekiz kez ölçüldü"* dört yerde yazıyor ve
**hiçbirinde liste yok**. Üstelik **en az dört farklı "sekiz"** dolaşıyor:

| hangi sekiz | listesi var mı |
|---|---|
| `İlke 4` (aynı yeteneğin tekrarı) | ❌ |
| *"mekanizma var, yol yok"* (`T-033`…`T-062`) | ✅ **listeli** |
| karar kayıtlarındaki çakışma | ❌ |
| doğrulama maskeleme ailesi | ❌ |

Ve sayıyı **kullanmaya** kalkınca çöktü: *"sekiz ihlalin kaynağı şu bölme"* varsayımı
sınandı, ve `CLAUDE.md §7`'nin **adıyla saydığı dördünde** üçü bölmedeydi, biri
(`lumpsum` dağıtımı, `shared/spend-calculation/`) **değildi**.

> **Enumerasyonu olmayan bir sayı, bir sonuca dayanak yapılamaz.**
> *"Kaçı bundan doğdu"* sorusu, liste ölçülene kadar bir **tahmindir**.

**Kural:** bu tür bir sayı yazılırken ya **listesi de yazılır** (ya da listeye atıf
verilir), ya da sayı **hiç anılmaz** — yerine niteliksel ifade kullanılır
(*"tekrar eden bir sınıf"*).

⚠️ `guard.sh`'ın öğrettiği dersin belge tarafı: **elle tutulan bir sayı bayatlar.** Fark
şu ki bir guard bayatladığında kırmızıya döner; bir belgedeki sayı **hiçbir zaman**
dönmez.
