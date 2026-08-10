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
| 1 | `docs/decisions/*.md` — **ADR'ler** | **Bağlayıcı.** Ürün sahibinin verdiği kararlar. BRD ile çelişirse ADR kazanır (BRD'nin bilinçli genişletmesidir). |
| 2 | **`docs/brd/`** — BRD paketi (12 bölüm + Addendum + Candidate Log) | **Asıl kaynak metin.** `01_Main_BRD/Section_04` actuals-first, `Section_05` planning-first. `02_Addendum` **zorunlu** okumadır. |
| 3 | `.cursor/rules.md` | **Türetilmiş özet — normatif değil.** |
| 4 | Bu dosyanın §2.3'ü | Hatırlatma listesi. Normatif değil. |
| — | `.cursor/*.pdf` | ⛔ **SÜPERSEDED — normatif DEĞİL** (ADR 0010). Arşiv. |

> **⛔ `.cursor/CollMind_TPM_BRD_v1.0.pdf` kullanılmaz.** Kendi künyesinde *"2025-11-04 ·
> **Initial BRD**"* yazıyor, 62 sayfa, ve `actuals-first`/`planning-first` kelimeleri **hiç
> geçmiyor** — yani ürünün yarısını kapsamıyor. `docs/brd/` iki ay sonrası, ~200 sayfa,
> *"Final · LOCKED"*. Karar ve ölçüm: **ADR 0010** · `docs/analysis/0018`.
>
> Silinmedi, çünkü *"bu karar neden verilmişti"*nin cevabı kayıtta kalsın. **Ama ona
> dayanarak kural yazılmaz.**

**Task'a başlamadan önce ilgili ADR'leri tara.** Bugün dokuz ADR var; hiçbiri opsiyonel değil.

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

- **Çoklu repo:** backend/frontend ayrı Bitbucket repolarıdır (submodule). Kök repo `collmind.team` kod tutmaz; her submodule'ün **commit pointer'ını** tutar. Bir submodule'de iş bitince: o repoya push → kök repo'da pointer'ı güncelle/commit/push.
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

> **Bir kusur sınıfı bulduğun dosyada, aynı sınıfın diğer örneklerini ara.
> Kusurlar dosya bazlı kümelenir.**

> **Bir kalıbı ararken her iki ucunu ara: neye yazıldığını VE neyin okunduğunu.**
> Tek uçtan arama kalıbın yarısını görünmez bırakır.

T-091 bunun kanıtı: transformer'lı **hedef** alanları arandı (10 aday, 4 bozuk), transformer'sız
**kaynak** alanların biriktirilmesi aranmadı — `finance-reporting`'deki aynı kusur (iki canlı
GET rotası) o yüzden ağa takılmadı.

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

