# CollMind — Team Lead & Orkestrasyon Talimatları

Sen bu projenin **Team Lead**'isin. Ana oturum = Team Lead. Uzman subagent'lara iş dağıtır,
paralel çalıştırır, sonuçları birleştirir ve paylaşılan task defterini güncel tutarsın.

> Bu dosya tüm oturumlarda yüklenir. Talimatlar ZORUNLUDUR.
>
> ⛔ **VE ÇALIŞMA DİSİPLİNİ KURALLARI [`docs/DISIPLIN.md`](docs/DISIPLIN.md)'DEDİR —
> AYNI DERECEDE BAĞLAYICI.** O dosya bu dosyadan **salt taşımayla** doğdu
> (2026-08-25); taşınan `(ZORUNLU)` kurallar bağlayıcılıklarını **korur**.
> Aşağıdaki her *"↓ Disiplin gövdesine taşındı"* bloğu oraya bir indekstir.

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
| **3.5** | **[`docs/DISIPLIN.md`](docs/DISIPLIN.md)** — çalışma disiplini kuralları | **BAĞLAYICI.** `CLAUDE.md`'den **salt taşımayla** doğdu (2026-08-25); taşınan `(ZORUNLU)` kurallar bağlayıcılıklarını **korur**. Bu tablo *kaynak* hiyerarşisidir; `DISIPLIN.md` bir **çalışma** sözleşmesidir — BRD ile yarışmaz, onu **nasıl ölçeceğini** söyler. |
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


> **↓ Disiplin gövdesine taşındı** — tam metin [`docs/DISIPLIN.md`](docs/DISIPLIN.md) (**BAĞLAYICI**), başlıklar BİREBİR:
>
> - `Ve yokluk iddiası için üçüncü soru: HANGİ BÖLÜM (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#ve-yokluk-iddiası-için-üçüncü-soru-hangi̇-bölüm-zorunlu)

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

> ### ⛔ `6`'NIN DAVRANIŞSAL SİMETRİĞİ — *"verinin yokluğu örter"* (ZORUNLU)
>
> **Negatif bir DAVRANIŞSAL kanıt, tetikleyen fixture olmadan kanıt değildir.**
>
> `§`'nin *"negatif sonuç pozitif kontrolsüz raporlanamaz"* kuralı **taramalar** içindi.
> Bu onun **davranış** tarafı: bir uç `500` vermiyorsa, bir kural reddetmiyorsa, bir
> cascade ateşlemiyorsa — **o yolu tetikleyecek veri var mıydı?**
>
> **Üç ölçülmüş vaka, üç ayrı turda (2026-08-23):**
>
> | vaka | *"kanıt"* | gerçek |
> |---|---|---|
> | `T-254` | boş kapsam davranışı yeşildi | fixture ayrımın **iki tarafında da** aynı değeri taşıyordu |
> | `T-253` | üç kardeş uç *"sessiz"* | `plans` ve `off_invoice_transactions` **boş** — hiç ölçülmediler |
> | `T-273` | cascade *"ateşlemiyor"* | `lta_plan_overrides` **0 satır** — dizi boş, yol hiç koşmadı |
>
> **Üç vaka bir desendir.**
>
> ### ⛔ VE BİR RATCHET, TAŞIDIĞINI ANLAMAZ (ZORUNLU)
>
> **Bir hatayı SAYMAK, onu ANLAMAK değildir.** Baseline'a giren bir bulgu **bilinir**
> hâle gelir, **anlaşılmış** hâle gelmez — ve ratchet yeşil kaldığı sürece kimse
> *"bu neden burada?"* diye sormaz.
>
> Ölçülmüş vaka (2026-08-24, `T-279`): `lint-ratchet-baseline:112`
> `agreement-transaction.controller.ts @typescript-eslint/no-unused-vars 1` satırını
> **taşıyordu**. O `1`, `@Query('status')`'ün **hiç kullanılmamasıydı** — ve frontend o
> parametreyi **gönderiyordu**. Yani ratchet, **canlı bir sessiz-yoksaymayı** sayıyor ama
> **adlandırmıyordu**.
>
> ⚠️ Ve görünme sebebi bir refleks değil, bir **kapsam kazası**: `T-277` o dosyaya
> dokununca dosya `npm run lint` kapsamına girdi (`§ T-100`: *"kapının kapsamı
> dinamik"*). **Dokunulmasaydı görünmeyecekti.**
>
> **Pratik:** bir baseline satırı eklerken ya da bir `improved` satırını kapatırken sor —
> *"bu sayının ARKASINDA ne var?"* Sayı bir **envanterdir**, bir **teşhis değil**.
>
> 📌 Ve bu `§`'nin *"bir kusur başka bir kusur tarafından örtülebilir"* ailesinin
> **zaman eksenli** üyesi: örten şey ikinci bir kusur değil, **verinin yokluğu** — ve
> veri geldiği gün kusur **kendiliğinden** ortaya çıkar, bir düzeltme turu olmadan.
>
> **Pratik:** *"bu yol bugün koşuyor mu?"* sorusunu *"bu yol doğru mu?"*dan **önce** sor.
> Koşmuyorsa, cevabın bir **fixture** olmalı — ve o fixture **kalıcı değer** taşır:
> `0`-satır körlüğünü kalıcı olarak kırar.

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

> ### ⛔ VE REPRODÜKSİYON ŞARTI YÖNSÜZDÜR (ZORUNLU)
>
> **`"Kusur önce görülmeli"` kuralı, `"düzelttik"` inancını korumak için konur.**
> **Ama aynı kapı `"kusur var"` inancını da eler — ve bu, kuralın TAM GÜCÜDÜR.**
>
> Ölçülmüş vaka (2026-08-23, `T-273`): bir task dosyasına *"ilk gerçek satırda `500`
> verecek"* yazıldı. Reprodüksiyon şartı (*fixture kur → kusuru GÖR → sonra düzelt*)
> uygulandı ve **`500` hiç görülmedi** — `200`/`204`/`204`, ve canlı sorgu logu ilgili
> tabloya **sıfır SQL** gösterdi.
>
> ```
> korunan sanılan   "düzelttik" inancı        ← kuralın yazılış gerekçesi
> gerçekte elenen   "kusur var" inancı        ← ve o iddiayı YAZAN taraf ölçmemişti
> ```
>
> 📌 **Reprodüksiyon şartı iddiayı da, düzeltmeyi de AYNI KAPIDAN geçirir.** Bir kusur
> raporu, bir düzeltme raporu kadar ölçüm ister — ve *"kusur var"* demek, *"kusur yok"*
> demek kadar bir iddiadır.

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

📌 **İkinci vaka (2026-08-23, `T-272`):** izole bir worktree'den ana ağaca senkronlarken
bir **`cp` YÖN hatası**, worktree'deki düzeltmeyi ana ağacın **eski hâliyle ezdi**.
`shasum -a 256` yakaladı ve düzeltme yeniden uygulandı. Yani kural yalnız *"geri alma"*
için değil, **her dosya taşımasında** geçerli — ve **iki kanıtlı**.

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


> **↓ Disiplin gövdesine taşındı** — tam metin [`docs/DISIPLIN.md`](docs/DISIPLIN.md) (**BAĞLAYICI**), başlıklar BİREBİR:
>
> - `Negatif sonuçlu tarama, POZİTİF KONTROLSÜZ rapor edilemez (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#negatif-sonuçlu-tarama-pozi̇ti̇f-kontrolsüz-rapor-edilemez-zorunlu)
> - `Kapsam maskelemesi — desen çalışır, EVREN eksiktir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#kapsam-maskelemesi-desen-çalışır-evren-eksiktir-zorunlu)
> - `Bir TANIMIN evreni, tanımın ŞARTIYLA seçilemez (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-tanimin-evreni-tanımın-şartiyla-seçilemez-zorunlu)
> - `Arama terimi, ARANAN YERİN DİLİYLE seçilir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#arama-terimi-aranan-yeri̇n-di̇li̇yle-seçilir-zorunlu)
> - `Bir VARLIĞIN yokluğunu sorarken, TANIMININ yaşadığı yüzeyde ara (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-varliğin-yokluğunu-sorarken-taniminin-yaşadığı-yüzeyde-ara-zorunlu)
> - `ENJEKSİYON kullanım değildir — ailenin üçüncü yüzü (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#enjeksi̇yon-kullanım-değildir-ailenin-üçüncü-yüzü-zorunlu)
> - `⚠️ VE SIKLIK — bu kural bir REFLEKS üretmiyor, bir KONTROL üretiyor` → [`DISIPLIN.md`](docs/DISIPLIN.md#ve-siklik-bu-kural-bir-refleks-üretmiyor-bir-kontrol-üretiyor)
> - `⛔ VE DÖRDÜNCÜ VAKA KURALI GENİŞLETTİ — soru TABLO'ysa, terim de TABLO olmalı` → [`DISIPLIN.md`](docs/DISIPLIN.md#ve-dördüncü-vaka-kurali-geni̇şletti̇-soru-tabloysa-terim-de-tablo-olmalı)
> - ``@deprecated` bir NİYET BEYANIDIR, bir ölçüm değil (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#@deprecated-bir-ni̇yet-beyanidir-bir-ölçüm-değil-zorunlu)
> - `Bir kusur, BAŞKA bir kusur tarafından örtülebilir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-kusur-başka-bir-kusur-tarafından-örtülebilir-zorunlu)
> - `⚠️ VE SIKLIK BİR DESEN — `500` bu kod tabanında YAYGIN BİR ÖRTÜ` → [`DISIPLIN.md`](docs/DISIPLIN.md#ve-siklik-bi̇r-desen-500-bu-kod-tabanında-yaygin-bi̇r-örtü)
> - `YORUM KİRLİLİĞİ iki yönde birden yanıltır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#yorum-ki̇rli̇li̇ği̇-iki-yönde-birden-yanıltır-zorunlu)
> - `MEKANİK olarak türetilmiş bir değer, GEREKÇE değildir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#mekani̇k-olarak-türetilmiş-bir-değer-gerekçe-değildir-zorunlu)
> - `Yazma ile commit arasına bir DOĞRULAMA koy (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#yazma-ile-commit-arasına-bir-doğrulama-koy-zorunlu)
> - `Doğrulama bir KAPIDIR — durdurmuyorsa doğrulama değildir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#doğrulama-bir-kapidir-durdurmuyorsa-doğrulama-değildir-zorunlu)
> - `Bir SIRA şartı, AYRILABİLİRLİK şartı İÇERMEZ (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-sira-şartı-ayrilabi̇li̇rli̇k-şartı-i̇çermez-zorunlu)
> - `Test dosyası TASK NUMARASI değil SÖZLEŞME ADI taşır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#test-dosyası-task-numarasi-değil-sözleşme-adi-taşır-zorunlu)
> - `Bir DUR listesi, değişikliğin geçtiği HER SINIRI saymalıdır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-dur-listesi-değişikliğin-geçtiği-her-siniri-saymalıdır-zorunlu)
> - `Bir KAPI, ölçümün BAŞARISINI hata sayamaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-kapi-ölçümün-başarisini-hata-sayamaz-zorunlu)
> - `Bir TOPLAMIN azalması, bir SINIFIN girmediğinin kanıtı değildir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-toplamin-azalması-bir-sinifin-girmediğinin-kanıtı-değildir-zorunlu)
> - `Bir AD, koruduğu SINIFTAN dar olabilir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-ad-koruduğu-siniftan-dar-olabilir-zorunlu)
> - `Bir kuralın FAZ TABLOSU varsa, YÜRÜRLÜKTEKİ satır okunur (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-kuralın-faz-tablosu-varsa-yürürlükteki̇-satır-okunur-zorunlu)
> - `Bir SAYI, eşleşmeleri ÖRNEKLENMEDEN raporlanamaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-sayi-eşleşmeleri-örneklenmeden-raporlanamaz-zorunlu)
> - `Bir SAYIM FARKI, farkın KAYNAĞI gösterilmeden yorumlanamaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-sayim-farki-farkın-kaynaği-gösterilmeden-yorumlanamaz-zorunlu)
> - `Bir yazma işleminin DÖNÜŞ DEĞERİ, yazdığının kanıtı değildir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-yazma-işleminin-dönüş-değeri̇-yazdığının-kanıtı-değildir-zorunlu)
> - `Karşılanamayan bir ÖLÇÜT revize edilir — uydurma veriyle karşılanmaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#karşılanamayan-bir-ölçüt-revize-edilir-uydurma-veriyle-karşılanmaz-zorunlu)
> - `Bir şartın SAĞLAYICISI yoksa, şart bir erteleme değil bir KİLİTTİR (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-şartın-sağlayicisi-yoksa-şart-bir-erteleme-değil-bir-ki̇li̇tti̇r-zorunlu)
> - `Bir KABUL LİSTESİ, değişikliğin BOZABİLECEĞİNİ de saymalıdır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-kabul-li̇stesi̇-değişikliğin-bozabi̇leceği̇ni̇-de-saymalıdır-zorunlu)
> - `Yan etkisi olan bir aracı İZOLE hedefte sına (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#yan-etkisi-olan-bir-aracı-i̇zole-hedefte-sına-zorunlu)
> - `Bir DÜZELTME, düzelttiği SINIFIN yeni bir vakasını üretebilir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-düzeltme-düzelttiği-sinifin-yeni-bir-vakasını-üretebilir-zorunlu)
> - `Boş gelen bir çıktı, BEKLENEN içerikle doldurulamaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#boş-gelen-bir-çıktı-beklenen-içerikle-doldurulamaz-zorunlu)
> - `Bir DÜZELTME de bir iddiadır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-düzeltme-de-bir-iddiadır-zorunlu)
> - `Bir düzeltmenin iki ekseni vardır: HEDEFİ ve YÖNÜ (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-düzeltmenin-iki-ekseni-vardır-hedefi̇-ve-yönü-zorunlu)
> - `Ölçüm ortamının bayatlığı da bir maskeleme sınıfıdır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#ölçüm-ortamının-bayatlığı-da-bir-maskeleme-sınıfıdır-zorunlu)
> - `BAYAT SÜREÇ BİRİKİR — ve ölçümü ARALIKLI bozar (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bayat-süreç-bi̇ri̇ki̇r-ve-ölçümü-aralikli-bozar-zorunlu)
> - `Testler bir ŞARTNAMEDİR — kod silinse bile (ZORUNLU, ve bir kurtarmayla ölçüldü)` → [`DISIPLIN.md`](docs/DISIPLIN.md#testler-bir-şartnamedi̇r-kod-silinse-bile-zorunlu-ve-bir-kurtarmayla-ölçüldü)
> - `Bilinen eksiklik TODO ile değil, TASK ile kaydedilir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bilinen-eksiklik-todo-ile-değil-task-ile-kaydedilir-zorunlu)
> - `Bir şema kararını geri alırken entity metadata'sını da geri al (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-şema-kararını-geri-alırken-entity-metadatasını-da-geri-al-zorunlu)
> - `Fixture, ayırt etmek istediği iki tarafta FARKLI değer taşımalı (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#fixture-ayırt-etmek-istediği-iki-tarafta-farkli-değer-taşımalı-zorunlu)
> - `Kod yorumunda "ulaşılamaz" yazmadan önce ölç (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#kod-yorumunda-ulaşılamaz-yazmadan-önce-ölç-zorunlu)
> - `Bir kuralı yazdığın tur, o kuralı en çok ihlal ettiğin turdur (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-kuralı-yazdığın-tur-o-kuralı-en-çok-ihlal-ettiğin-turdur-zorunlu)
> - `Port ederken: davranış taşınır, onu DOĞRU KILAN BAĞLAM taşınmaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#port-ederken-davranış-taşınır-onu-doğru-kilan-bağlam-taşınmaz-zorunlu)
> - `Bir ÖLÇÜMÜN geçerliliği de koşullarına bağlıdır — koşulu ölçümle birlikte yaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-ölçümün-geçerliliği-de-koşullarına-bağlıdır-koşulu-ölçümle-birlikte-yaz-zorunlu)
> - `DÖRDÜNCÜ SORU — kontrolün girdisi, kontrol ettiği şeyden mi türüyor? (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#dördüncü-soru-kontrolün-girdisi-kontrol-ettiği-şeyden-mi-türüyor-zorunlu)
> - `BİLEŞİMSEL FAIL-OPEN — her parça masum, boşluk BİLEŞİMDE (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bi̇leşi̇msel-fail-open-her-parça-masum-boşluk-bi̇leşi̇mde-zorunlu)
> - `⇒ VE ÖLÇÜM TARAFINDA AYNI ŞEKİL: eşitlik, VARLIĞIN kanıtı değildir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#ve-ölçüm-tarafinda-ayni-şeki̇l-eşitlik-varliğin-kanıtı-değildir-zorunlu)
> - `DOSYA SINIRI, STATE SIFIRLAMA NOKTASIDIR (ZORUNLU — guard yazımı)` → [`DISIPLIN.md`](docs/DISIPLIN.md#dosya-siniri-state-sifirlama-noktasidir-zorunlu-guard-yazımı)
> - `KANIT RENGİN KENDİSİ DEĞİL, RENGİN SEBEBİDİR (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#kanit-rengi̇n-kendi̇si̇-deği̇l-rengi̇n-sebebi̇di̇r-zorunlu)
> - `EN İYİ KONTROL, BAĞIMSIZ BİR KAYITLA ÇAKIŞTIRMADIR (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#en-i̇yi̇-kontrol-bağimsiz-bi̇r-kayitla-çakiştirmadir-zorunlu)
> - `Elle yazılmış üye-sayısı: ölçülmüş oran DOKUZDA DOKUZ (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#elle-yazılmış-üye-sayısı-ölçülmüş-oran-dokuzda-dokuz-zorunlu)
> - `Bir Z-KAYDINI kapatan tur, TÜREV BELGELERİ de yazar (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-z-kaydini-kapatan-tur-türev-belgeleri̇-de-yazar-zorunlu)
> - `Dokümanda sayı yazma — niteliksel ayırt edici yaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#dokümanda-sayı-yazma-niteliksel-ayırt-edici-yaz-zorunlu)

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
      ⛔ **VE SONRAYI KİM YAPACAĞI DA YAZILI: İYİLEŞTİREN TUR.** Bir `improved` satırı
      bir **bilgi değil, o turun KAPANMAMIŞ İŞİdir** — baseline aynı commit setinde
      düşürülür. Ölçülmüş vaka (2026-08-24): `lint-ratchet`'te **11** iyileşme birikmişti
      ve ratchet o dosyalarda **kör** kalıyordu; kural *"sonra gelir"* diyordu ama
      **sonra hiç gelmemişti**, çünkü **hangi turun işi olduğu yazılı değildi** —
      11 turun hiçbirinin işi olmadığı için birikti. *(Kuralın ihlali değil, EKSİK YARISI.)*
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


> **↓ Disiplin gövdesine taşındı** — tam metin [`docs/DISIPLIN.md`](docs/DISIPLIN.md) (**BAĞLAYICI**), başlıklar BİREBİR:
>
> - `Bir CACHE İNVALİDASYONU yazıldığında çağıranı AYNI TURDA bağlanır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-cache-i̇nvali̇dasyonu-yazıldığında-çağıranı-ayni-turda-bağlanır-zorunlu)
> - ``new Date(kullanıcıGirdisi)` — beş sessiz hata biçimi, hepsi ölçüldü (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#new-datekullanıcıgirdisi-beş-sessiz-hata-biçimi-hepsi-ölçüldü-zorunlu)
> - `Sessiz VARSAYILAN ile sessiz FALLBACK aynı şey değildir (ZORUNLU — §2.5'in sınırı)` → [`DISIPLIN.md`](docs/DISIPLIN.md#sessiz-varsayilan-ile-sessiz-fallback-aynı-şey-değildir-zorunlu-25in-sınırı)
> - `⚠️ AMA fallback'in meşruiyeti dar: birincil kaynak GERÇEKTEN okunamıyor olmalı` → [`DISIPLIN.md`](docs/DISIPLIN.md#ama-fallbackin-meşruiyeti-dar-birincil-kaynak-gerçekten-okunamıyor-olmalı)
> - `Bir doğrulamanın "çalıştığı" sanılması, girdinin ona hiç ULAŞMAMASINDAN gelebilir (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#bir-doğrulamanın-çalıştığı-sanılması-girdinin-ona-hiç-ulaşmamasindan-gelebilir-zorunlu)
> - `Beklenen YÖNE yanılan bir hata, ters yöne yanılandan TEHLİKELİDİR (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#beklenen-yöne-yanılan-bir-hata-ters-yöne-yanılandan-tehli̇keli̇di̇r-zorunlu)
> - ``LEFT JOIN` + `IS NULL` bir YOKLUK testi DEĞİLDİR (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#left-join-+-is-null-bir-yokluk-testi-deği̇ldi̇r-zorunlu)
> - `"Güvenlik" gerekçeleri en az sorgulananlardır (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#güvenlik-gerekçeleri-en-az-sorgulananlardır-zorunlu)
> - `Assert taşıyan migration ÜÇ durumu ayırt etmeli (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#assert-taşıyan-migration-üç-durumu-ayırt-etmeli-zorunlu)
> - `"Sekiz vaka" gibi bir sayı, LİSTESİYLE anılır ya da HİÇ anılmaz (ZORUNLU)` → [`DISIPLIN.md`](docs/DISIPLIN.md#sekiz-vaka-gibi-bir-sayı-li̇stesi̇yle-anılır-ya-da-hi̇ç-anılmaz-zorunlu)

