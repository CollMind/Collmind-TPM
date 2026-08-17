# 0073 — `ADIM 3` taksonomi cevabı

> **Mod:** SALT-OKUNUR — tek yazılan dosya bu. · **Yazan:** Fable · **Tarih:** 2026-08-17
> **Brief:** `docs/process/ADIM3_TAKSONOMI_BRIEF_FABLE.md`
> **Kanonik ölçüm:** `docs/analysis/0072-adim3-route-yetki-olcumu.md` — **hiçbir sayı yeniden
> sayılmadı**; bu belgede geçen her sayı `0072`'ye ya da `capabilities.ts` başlığına atıflıdır.
> **Etiketler:** `[ÖLÇÜLDÜ: kaynak]` · `[GEREKÇELİ]` (mantık yürütmesi, ölçüm değil) ·
> `[VARSAYIM]` (karara dayanak yapılamaz).

---

## 0 · Dört cevap tek bakışta

| soru | tercih |
|---|---|
| 1 · kapsam nereye ait | **Ayrı katman** (`K-2.6.9`). Yetenek kapsam varyantı taşımaz. |
| 2 · `READ` çöküşü | **Ne hücre ne route "yanlış" — eksik olan bir ölçüm.** Dar-kümeli okuma route'ları sınıflandırılmadan union kabul edilmez; `B` sınıfı yetenek sorusu DEĞİL, kabul. |
| 3 · `report-only` | Eksik harita değersizleştirmez — **değersizleştiren girdi trafik yokluğu.** Öneri ikiye bölünür: statik kapsama guard'ı (şimdi, kapı) + dinamik telemetri (deploy sonrası). |
| 4 · dışarıdan bakış | Bu ölçekte en olası başarısızlık: **çift mekanizmanın kalıcılaşması.** Liste §4'te. |

⚠️ **`DUR` koşulu 1 kısmen tetiklendi** (Soru 2): gereken ölçüm `0072`'de yok → §5 isteme
listesine yazıldı, türetilmedi. Diğer `DUR` koşulları tetiklenmedi — hiçbir cevap
`0056-K3(b)`'yi ya da `Z7`'yi geri almıyor, BRD v2 paketine dokunmuyor, migration/şema
gerektirmiyor (§6).

---

## 1 · Soru 1 — Kapsam yeteneğe mi, ayrı katmana mı?

### CEVAP

**Kapsam ayrı katmandır.** Yetenek yalnız *"bu işlem sınıfına girebilir mi"* sorusunu
cevaplar (`modül:islem`, bugünkü şekil); *"hangi satırları görür"* sorusunun tek sahibi
`K-2.6.9`'un kapsam filtresidir. `modes:read:own` / `modes:read:all` gibi kapsam varyantlı
yetenek adı **yazılmaz** — ne `Faz B`'de ne sonra.

### GEREKÇE

1. **L2 bu ayrımı zaten karara bağlamış** `[ÖLÇÜLDÜ: L2_03 §2.6.3 "Kapsam katmanı" — ayrı
   bölüm, "Karar verildi 2026-08-12"; K-2.6.9 "kapsam filtresi her zaman aktiftir"]`.
   Kapsamı yeteneğe taşımak o kararı ikinci bir mekanizmayla kopyalar — brief'in adıyla
   koyduğu `İlke 4` gerilimi tam burada doğar. **"Ayrı katman" tercihi gerilimi yönetmez,
   ÇÖZER:** iki mekanizma ancak yetenek kapsam varyantı taşırsa aynı soruyu cevaplar.
   Taşımazsa sorular ayrışır: yetenek = uç sınıfı, kapsam = veri dilimi `[GEREKÇELİ]`.
2. **Kapsamın kendi adımı ve kendi ölçümü var** `[ÖLÇÜLDÜ: FAZ1_PLAN §4 Adım 2 kalem 5 —
   "ayar mı inşa mı değil, İKİSİ"; §6 Adım 4]`. Kapsam sorusu Adım 4'te cevaplanacak;
   yetenek taksonomisine sızdırmak aynı işi iki adıma yayar `[GEREKÇELİ]`.
3. **`A`/`C` ölçümünün kendisi bu yönü gösteriyor** `[ÖLÇÜLDÜ: 0072 §4c]`: kapsam bugün
   fiilen **servis katmanında** yaşıyor (`@CurrentUser → resolveScopeForFilter`). `0072`'nin
   dersi *"dekoratör bir yüzey, DAVRANIŞ başka"* — kapsamı dekoratör yüzeyine (yetenek
   adına) taşımak, o dersin çürüttüğü varsayımın (`POST = yazma`, `@Roles = davranış`)
   yeni bir vakası olur `[GEREKÇELİ]`.
4. **`own` bir kapsam ekseni bile değil** `[ÖLÇÜLDÜ: L2_03 K-2.6.7 — eksen listesi
   kanal · müşteri · kategori; aktör/own listede yok]`. Kapsam varyantlı yetenek ya
   `K-2.6.7b`'nin yasakladığı dördüncü ekseni kararsız ekler, ya da var olmayan bir ekseni
   adlandırır. İkisi de donuk BRD'ye dokunmayı gerektirirdi (`Z1`) — yani bu şık bir brief
   cevabı olamazdı, karar defteri kaydı gerektirirdi `[GEREKÇELİ]`.

### REDDEDİLEN

**Kapsam taşıyan yetenek (`modes:read:own` ↔ `modes:read:all`).** Neden:

- `İlke 4`: `K-2.6.9` ile aynı soruyu cevaplayan ikinci mekanizma doğar — brief'in andığı
  sınıfın ("her ikisi de makul görünüyordu") ders kitabı vakası `[GEREKÇELİ]`.
- Kombinatorik: her `READ` hücresi varyant başına katlanır; `K-2.6.7b`'nin çarpan uyarısı
  ("her eksen bir çarpandır") yetenek tarafında da geçerli `[GEREKÇELİ]`.
- Ve en önemlisi: `A` ile `C`'yi yetenek adında ayırmak, ayrımı **yanlış katmanda
  sabitler.** `C`'nin kusuru rol/yetenek yüzeyinde değil — kapsam filtresinin yokluğunda
  (`K-2.6.9`'un ölçülmüş sapması). Kusuru yetenek adıyla "çözmek", gerçek düzeltmeyi
  (Adım 4) yapılmış gösterirdi `[GEREKÇELİ]`.

### FAZ B'YE

- Taksonomiye üçüncü boyut **girmez**; `modül:islem` tabanı korunur.
- `A` sınıfı route'lar göçerken **servis-katmanı kapsam çağrılarına dokunulmaz** —
  `@RequireCapability` onların yerine geçmez, önlerine gelir. Kabul listesinin
  "ne BOZULABİLİR" sütununa satır: *"`A` sınıfının servis daraltması göç sonrası hâlâ
  çalışıyor mu"* (kapı: o route'larda daraltmayı sınayan test).
- `C` sınıfı **adıyla** Adım 4'e devredilir (`0072 §4c`'deki liste) — bir yetenek işi
  olarak değil, `K-2.6.9` sapmasının ölçülmüş vakaları olarak.
- `A`'nın mekanizması ile `K-2.6.7` eksenlerinin aynı şey olup olmadığı **ölçülmedi** —
  isteme listesi §5/2.

---

## 2 · Soru 2 — `READ` çöküşü: hücre mi yanlış, route mu?

### CEVAP

**İkisi de değil — eksik olan bir ölçüm, ve union o ölçümden önce kabul edilmez.**
Üç `READ` hücresi `DUR`'da kalır; çözüm yolu, hücrelerdeki **dar-kümeli** okuma
route'larının madde madde sınıflandırılmasıdır (isteme listesi §5/1). Alt-soruya doğrudan
cevap: **evet — `B` sınıfı bir yetenek sorusu değildir.** `@deprecated` ikiz bir `İlke 4`
kalıntısıdır; her union hesabının girdisinden düşer ve kaderi bir silme task'ıdır, bir
yetenek adı değil `[ÖLÇÜLDÜ: 0072 §4c B sınıfı]`.

### GEREKÇE

Çöküşün üç bileşeni ölçülmüş durumda ve **üçü farklı muamele istiyor**
`[ÖLÇÜLDÜ: 0072 §4c]`:

- **`A` (servis kapsamlı):** genişliği meşru — `@Roles` kaba kapı, gerçek daraltma
  serviste. Bu route'lar `*_READ`'de kalır; hücrenin `5/5`'e açılmasının meşru kısmı bunlar.
- **`B` (ölü ikiz):** yetenek sorusu değil; girdiden düşer.
- **`C` (kapsamsız, özet değil):** rol yüzeyi bugün zaten `5/5` — union onu değiştirmiyor.
  Kusuru Soru 1'in cevabına göre kapsam katmanına aittir (Adım 4). Hücreyi bloke etme
  gerekçesi **değildir**.

Bu üçü ayıklandıktan sonra çöküşe direnen tek şey kalır: hücrelerdeki **dar kümeli**
route'lar — bugün kısıtlı olup union'la genişleyecek olanlar (`capabilities.ts` DUR notunun
örnekleri: defter/şablon okumaları, `finance-reporting` risk/varyans/cash-flow uçları)
`[ÖLÇÜLDÜ: capabilities.ts "DUR — hücre hücre" bölümü]`. O kısıtların **neyi kodladığı**
(bir iş kuralı mı, tarihsel tesadüf mü) `0072`'de ölçülmedi — ve şart 1 gereği burada
türetilmedi. Karar o ölçümün çıktısıyla verilir; **ön beklenti tablosu** (ölçümü yapan ajan
buradan başlasın — yön hatası kuralı gereği şıklar ve sonuçları önden yazılı):

| dar-küme kısıtı ne çıkarsa | sonuç |
|---|---|
| bir **iş kuralını** kodluyor (L2 atfı bulunuyor — ör. defter görünürlüğü finansal bir kural) | union REDDEDİLİR; o route'lar ürün sahibi kararıyla mevcut bir hücreye taşınır ya da yeni işlem sınıfı **ürün sahibi açar** (11 düzeltme emsali: `SHARED_WRITE → SHARED_MANAGE`) |
| **tarihsel/tesadüfi** (hiçbir kurala atıf çıkmıyor) | union KABUL edilir; çöküş meşrulaşır — okuma yüzeyi rolde geniştir, daraltma kapsama gider (Soru 1) |
| **karışık** | route bazında ayrılır; her satır genişleme kaydına girer (Faz A kayıt şartı emsali) |

`[GEREKÇELİ — tablo bir beklenti, ölçüm değil]`

### REDDEDİLEN

- **Union'ı şimdi kabul etmek (çöküşü onaylamak):** dar-küme route'ların kodladığı kısıt
  ölçülmeden erişim genişletir — *"toplamın azalması, bir sınıfın girmediğinin kanıtı
  değildir"* ailesinin yetki karşılığı: "hiçbir erişim kapanmadı" doğru olurdu **ve**
  "yeni bir erişim sınıfı açılmadı" yanlış olurdu `[GEREKÇELİ; genişleyecek route örnekleri
  ÖLÇÜLDÜ: capabilities.ts DUR notu]`.
- **Hücreyi şimdi bölmek:** Faz A'da reddedilen `(b)`'nin (taksonomiyi yukarı büyütme)
  aynısı, ve `capabilities.ts`'in kendi kapanış cümlesiyle çelişir: *"ölçüm şartı
  sağlanmadan yetenek adı yazılmaz"* (`§2.4`) `[ÖLÇÜLDÜ: FAZ1_PLAN §5 red tablosu;
  capabilities.ts son paragraf]`.
- **Süresiz `@Roles`'ta bırakmak:** Faz A'da reddedilen `(c)` — iki mekanizma kalıcılaşır.
  Buradaki tercih süresiz **değil**: çıkış koşulu yazılı (ölçüm + ürün sahibi kararı),
  ve bekleyen route'lar Soru 3'ün statik guard'ında "kayıtlı-DUR" sınıfında **görünür**
  kalır `[GEREKÇELİ]`.

### FAZ B'YE

- `Faz B` bugünkü dolu hücrelerle başlar (`19/24` `[ÖLÇÜLDÜ: capabilities.ts
  ROLE_CAPABILITIES yorumu]`); üç `READ` hücresi göç kapsamına girmez.
- Ölü ikiz için silme task'ı açılır (Team Lead) — göç envanteri ölü ucu **meşrulaştırmadan**
  (Soru 4 / madde 9).
- Dar-küme sınıflandırma ölçümü göçle **paralel** koşabilir: salt-okunur, `touches`
  kesişmez `[GEREKÇELİ]`.
- `*_APPROVE` ikilisi bu sorunun konusu değil — `K-2.5.12`'ye devri ürün sahibi kararı
  olarak duruyor; ama `capabilities.ts`'in kendi uyarısı (`"onay EKRANINI görme"` tarafının
  nereye düştüğü ölçülmedi) isteme listesine alındı (§5/3), çünkü `Faz B` o iki hücreyi
  atlarken görme tarafı filtresiz kümeye düşebilir `[ÖLÇÜLDÜ: capabilities.ts *_APPROVE
  bölümü — uyarının kendisi; düşüp düşmeyeceği ÖLÇÜLMEDİ]`.

---

## 3 · Soru 3 — Eksik harita `report-only`'yi değersizleştirir mi?

Bu benim önerimdi; değerlendirme kendi önerime karşı yapıldı.

### CEVAP

**Eksik harita değersizleştirmez — ayırt etme sorusu kayıtla çözülür. Öneriyi
değersizleştiren asıl girdi başka: TRAFİK YOKLUĞU.** Bu yüzden tercih: `report-only`
**ikiye bölünür** — (1) **statik kapsama guard'ı**: her route ya eşlenmiş, ya kayıtlı-DUR,
ya işaretli-public, ya kayıtlı-alan-guard'lı; beşinci durum = kırmızı. Şimdi yazılır ve
`Faz B`'nin kapısıdır. (2) **Dinamik telemetri** (asıl report-only): guard kararı loglar,
uygulamaz. Şimdi kurulur, ama **kapanış ölçütü ilk deploy'a bağlanır** — o zamana kadar
ön-izlemedir, kanıt değil.

### GEREKÇE

1. **Ayırt etme mümkün — ama yalnız kayıt makine-okunur olursa.** Brief'in ayırt edici
   sorusuna doğrudan cevap: çıktı dört sınıfa düşmeli, ve dördüncüsü ancak `DUR`/muafiyet
   listesi guard'ın okuyabildiği bir yerde yaşarsa üretilebilir:

   | sınıf | koşul | anlamı |
   |---|---|---|
   | eşlenmiş · izinli | harita izin veriyor | sessiz |
   | eşlenmiş · **deny-olurdu** | harita reddederdi, bugünkü mekanizma geçiriyor | union hatasının kanıtı — asıl sinyal |
   | eşlenmemiş · **kayıtlı** | `DUR` hücresi · `@Public` işaretli · alan-guard'lı ikili | bilinen boşluk; sayaç, alarm değil |
   | eşlenmemiş · **kayıtsız** | hiçbir listede yok | envanter kaçağı — alarm |

   Bugün o kayıt yorumda ve markdown'da yaşıyor (`capabilities.ts` JSDoc + `FAZ1_PLAN`)
   `[ÖLÇÜLDÜ: 5 bloke hücre hiçbir rolün listesinde yok — capabilities.ts]` — guard
   okuyamaz. `Faz B` kalemi: `DUR`/muafiyet listeleri `capabilities.ts`'in yanına
   **kod sabiti** olarak iner. Tablo değil, kod — `0056-K3(b)` ile uyumlu, şema yok
   `[GEREKÇELİ]`. Brief'in sezgisi doğruydu: Faz A'nın union kaydı tam bu ayrım için
   tutuldu — eksik yalnız kaydın **biçimiydi**.

2. **Asıl değersizleştirici girdi: doğrulanacak trafik yok.** Önerinin gerekçesi
   *"envanter fiili trafikte doğrulanır"* idi. CTPM bugün yalnız lokal geliştirme
   ortamında koşuyor; deploy edilmiş staging/production yok `[ÖLÇÜLDÜ: CLAUDE.md §1
   ortam notları, 2026-08-03 denetimi]`. Fiili trafik diye bir doğrulama evreni bugün
   **yok** — ve *"sinyal sabitse sinyal değildir"*: hiç istek görmeyen bir report-only
   penceresi her haritayı temiz gösterir. Bu, kapsamı kendini boşaltan kapı sınıfının
   (`§2.7 #9`) zaman eksenindeki hâli `[GEREKÇELİ]`.

3. **E2E trafiği ikame değil — ama alt sınır olarak işe yarar.** ADIM 2 kalem 3 emsali:
   test koşumundan sayı üretmek test kurgusunu ölçer `[ÖLÇÜLDÜ: FAZ1_PLAN §4]`. Fark şu:
   oradaki soru kullanıcı **davranış dağılımıydı**; buradaki soru *"meşru bir çağıran
   eşlenmemiş bir uca düşüyor mu"*. E2E bunun **alt sınırını** verir (yalnız testlerin
   dokunduğu route'lar konuşur) — üst sınırı ancak statik guard verir. İkisi birlikte:
   statik guard envanter tamlığını deterministik kanıtlar, e2e-altı telemetri
   deny-olurdu sınıfını çalıştırır `[GEREKÇELİ]`. Kapanamayan ölçüt uydurma veriyle
   karşılanmaz — **revize edilir, gerekçesiyle**: gerçek-trafik doğrulaması ilk-deploy
   ön koşulları listesine yazılır (yedekleme/RPO-RTO emsali, `FAZ1_PLAN §0`).

### REDDEDİLEN

- **`report-only`'yi iptal edip doğrudan default-deny:** `roles.guard.ts`'in üç satırı
  `72` ucu aynı anda etkiler `[ÖLÇÜLDÜ: 0072 §4b]` ve alan-guard'lı ikili `@Roles`
  taşımadığı için kesilir (brief'in tuzağı) — dinamik prova olmadan çevirmek, kabul
  listesinin "ne bozulabilir" sütununu boş bırakmaktır `[GEREKÇELİ]`.
- **E2E koşumunu "fiili trafik" sayıp kapanış ölçütü yapmak:** ölçütü test kurgusuyla
  karşılamak — ADIM 2 kalem 3'ün reddettiği şeyin aynısı `[ÖLÇÜLDÜ: FAZ1_PLAN §4]`.
- **Kapanışı takvime bağlamak ("N hafta sessiz kaldı"):** trafiksiz ortamda sessizlik
  bedava — süre değil **sınıf** kapatır: kayıtsız-beklenmedik boş VE her deny-olurdu
  satırı ya düzeltildi ya kabul kaydı aldı `[GEREKÇELİ]`.

### FAZ B'YE

Sıra değişir:

1. **Önce statik kapsama guard'ı** — göç başlamadan. "Eşlenmemiş" kavramını ölçülebilir
   kılar; her göç dalgası guard'ın sayacını düşürür (ratchet deseni).
2. `DUR`/muafiyet listeleri kod sabitine iner (`@Public` işaretli üçlü zaten kodda
   `[ÖLÇÜLDÜ: capabilities.ts USER_WRITE bölümü]`; alan-guard'lı ikili + 5 hücre eklenir).
3. Dinamik telemetri + deny-log şeması (Soru 4 / madde 10) guard'la birlikte yazılır.
4. Default-deny çevirme kapısı: statik guard yeşil + e2e altında kayıtsız-beklenmedik boş +
   deny-olurdu satırları kapanmış. **Gerçek-trafik yeniden değerlendirmesi ilk-deploy ön
   koşulu olarak kaydedilir** — bu satırın muhatabı Team Lead (plan güncellemesi).

---

## 4 · Soru 4 — Bu ölçekte ne genelde yanlış gider?

Tamamı `[GEREKÇELİ — alan bilgisi; bu reponun ölçümü değil]`. Ölçek bağlamı:
`24 yetenek · 5 rol · 237 route · 160 @Roles'lu · 15 küme` `[ÖLÇÜLDÜ: 0072 §2, §3]`.

### CEVAP

Bu ölçekte en olası başarısızlık modu **çift mekanizmanın kalıcılaşmasıdır** — göçün son
dilimi hep en zor hücrelerdir ve "geçici" birlikte-yaşam, bir çıkış ölçütü yoksa varsayılan
hâle gelir. Kalanı, sıklık sırasına yakın bir listeyle:

1. **Çift mekanizma kalıcılaşır.** `@Roles` + `@RequireCapability` birlikte yaşar, hangisi
   bağlayıcı belirsizleşir; kolay route'lar göçer, zorlar kalır, göç "yüzde doksanda"
   durur. Panzehir: kalan-`@Roles` sayacı **ratchet** olarak kapıya bağlanır (bu repo
   deseni zaten kullanıyor); çıkış bir tarih değil, bir ölçüt.
2. **Union tabanlı göç yalnız genişletir.** "Davranışı koru" refleksi her belirsizliği
   erişim yönüne çözer; yıllar içinde yetenek kümeleri monoton büyür — yapısal privilege
   creep. Panzehir: her genişleme kayıtlı (Faz A bunu yaptı) **ve** genişleme kayıtlarına
   planlı bir **daraltma/inceleme turu** bağlanır — kayıt tek başına arşivdir, tur yoksa
   kimse geri okumaz.
3. **Default-deny "işaretsiz"i keser.** Health check, auth, self-servis (`/users/me`),
   webhook, alan-guard'lı uçlar rol metadata'sı taşımaz; flip hepsini birden düşürür.
   Genel kural: muafiyet **açık bir işarettir** (annotation), asla bir çıkarım
   ("guard'ı var, geçir") değil — işaretsizlik her zaman alarmdır. (Brief'in alan-guard'lı
   ikilisi bu sınıfın buradaki vakası.)
4. **Yetenek adları rol adlarına kayar.** Küme-başına adlandırma baskısı (`15` kümenin
   kuyruğu) `finance:approve` tarzı rol-aynası adlar üretir; sonra rol değişikliği yetenek
   adı değiştirtir. Test: *"yeni bir rol eklemek hiçbir yetenek adını değiştirmemeli"* —
   değiştiriyorsa taksonomi rol sızdırıyor.
5. **Kapsam yeteneğe sızar** (`own/team/all` varyantları → kombinatorik patlama). Soru 1'in
   genel hâli; sektörde bilinen çözüm de aynı: yetenek = kaynak sınıfı üzerinde fiil,
   kapsam = ayrı politika boyutu.
6. **Frontend kapıları geride kalır.** Backend yetenek, frontend hâlâ rol kontrol eder;
   iki yüzey sessizce ayrışır — ya 403 veren düğmeler, ya (daha kötüsü) yanlış
   konfigürasyonu gizleyen saklı menüler. Panzehir: tek kaynaktan üretim + iki repoyu
   birden pinleyen sözleşme testi (tel protokolü sınırı — `DUR-5` zaten sayıyor).
7. **Guard'ın boş/kenar durumları test edilmez.** Boş yetenek listesi allow mı deny mı;
   sınıf-vs-metot dekoratör önceliği; guard sırası (auth'tan önce koşan yetki guard'ı
   kimliksiz karar verir). Panzehir: guard'ın kendisine davranışsal test — boş-durum ayrı
   fixture, mutasyonla sınanmış (boş-durum kanıtının kurulumu boş durumu bozmadan —
   `§2.7 #4` sınıfının genel hâli).
8. **Harita testi haritanın kopyası olur.** Test `ROLE_CAPABILITIES` içeriğini assert eder
   — harita ile test birlikte bozulur, hiçbir davranış ölçülmez. Panzehir: örneklem
   haritadan türetilir ama assertion **HTTP sonucudur** (route'a istek, beklenen
   izin/ret).
9. **Göç envanteri ölü uçları meşrulaştırır.** Deprecated bir uca yetenek atamak onu
   silmek yerine sabitler. Göç, "bu uç yaşamalı mı" sorusunu her route için zorlayan en
   iyi fırsattır: ölüler eşlenmez, silinir. (Soru 2'nin `B` sınıfı kararı bu ilkenin
   uygulanışı.)
10. **Deny gözlemlenebilirliği flip'ten sonra düşünülür.** Kapı çevrilir, 403'ler başlar,
    kayıtta hangi route + hangi eksik yetenek + kullanıcının taşıdığı roller üçlüsü
    yoktur; teşhis tahmine döner. Panzehir: deny-log şeması **flip'ten önce** tanımlanır —
    `report-only` zaten o şemanın provasıdır (Soru 3 / FAZ B'YE 3).

### REDDEDİLEN

**"Büyük patlama" tek-dalga göçü** (tüm `@Roles`'ları tek turda çevirmek): çift-mekanizma
penceresini kısaltıyor **gibi** görünür, ama geri alma birimini yok eder — bir hata tüm
yüzeye aynı anda yayılır ve hangi eşlemenin ürettiği ayırt edilemez. Hücre-bazlı dalgalar +
ratchet, pencereyi uzun ama **ölçülür** tutar; madde 1'in panzehiri pencerenin kısalığı
değil, çıkış ölçütünün varlığıdır `[GEREKÇELİ]`.

### FAZ B'YE

Kabul listesine dört somut satır: **(a)** kalan-`@Roles` ratchet'i (madde 1) — Soru 3'ün
statik guard'ıyla aynı mekanizma olabilir; **(b)** guard boş-durum + öncelik + sıra
testleri (madde 7); **(c)** deny-log şeması report-only tasarımının parçası (madde 10);
**(d)** frontend sözleşme pin'i aynı dalgada (madde 6 — `FazA-frontend-rename` şeridiyle
koordinasyon Team Lead'de).

---

## 5 · İsteme listesi — `0072`'de olmayan, türetilmeyen ölçümler

| # | ölçüm | hangi kararın girdisi |
|---|---|---|
| 1 | Üç `READ` hücresindeki **dar-kümeli** route'ların madde madde sınıfı: döndürdüğü veri sınıfı · serviste daraltma var mı · kısıtın L2 atfı (hangi kural, varsa) | Soru 2'nin beklenti tablosu — union kabul/red kararı |
| 2 | `A` sınıfının servis mekanizması (`resolveScopeForFilter` + `my-requests` tarzı saf aktör filtreleri) `K-2.6.7`'nin üç ekseniyle **aynı mekanizma mı, ayrı mı** | Soru 1'in Adım 4 devri — kapsam katmanının "ayar mı inşa mı" kapsamı |
| 3 | Onay **görme** tarafı: `pending` listeleri ve onay ekranı uçlarının hangi hücreye düştüğü (`capabilities.ts`'in kendi ⚠️'si) | `*_APPROVE` devrinin `Faz B`'de filtresiz boşluk bırakmaması |
| 4 | E2E suite'inin route **kapsamı**: hangi route'lara en az bir e2e istek düşüyor (liste, sayı değil) | Soru 3'ün dinamik telemetrisinin alt-sınırının bilinmesi — kapsanmayan route'larda telemetri sessizdir |

## 6 · `DUR` koşulları — durum

| koşul | durum |
|---|---|
| `0072`'de olmayan ölçüm | ⚠️ **Tetiklendi (Soru 2, kısmi)** — §5/1'e yazıldı, türetilmedi; cevap karar yapısı + beklenti tablosuyla sınırlı tutuldu |
| `0056-K3(b)` / `Z7` geri alma | tetiklenmedi — tüm öneriler yetenek/kayıt yapısını **kod sabiti** olarak tutuyor; tablo/tenant-başına yetenek hiçbir cevapta yok |
| BRD v2 paketine dokunma | tetiklenmedi — Soru 1 tam tersine `K-2.6.9`'a yaslanıyor; kapsam-varyantlı yetenek şıkkı zaten bu koşula çarptığı **için** reddedilenler arasında |
| migration/şema gerektiren öneri | tetiklenmedi — statik guard, muafiyet sabitleri, deny-log, ratchet: hepsi kod/script katmanı; `0056-K3(b)` ile çelişki yok |
