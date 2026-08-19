# Faz 1 Planı — Taban

> **Kanonik girdiler:** `docs/analysis/0071-faz-0-durum-fotografi.md` · `FAZ1_BRIEF_FABLE.md`
> **Tarih:** 2026-08-15 · **Yazan:** Fable · **Statü:** ürün sahibi onayı ile yürürlüğe girer
>
> **İşaretleme:** her iddia `[ÖLÇÜLDÜ]` (belgeden) · `[GEREKÇELİ]` (muhakeme,
> doğrulanamaz) · `[VARSAYIM]` taşır. Sayılar yeniden sayılmadı — `0071` kanoniktir.

---

## 0 · Bu planla kaydedilen iki karar güncellemesi

1. **Yedekleme (RPO/RTO) Faz 1 kalemi DEĞİL — ilk deploy'un ön koşulu.** Dış denetimin
   NFR boşluğu bulgusu geçerli; ama bu bir konuşlandırma kalemidir ve bugün yayın
   ortamı yok (`NFR-13`: bazı ölçütler "çözümü konuşlandırma kararında").
   **Kayıt:** ilk-deploy ön koşulları listesine yazıldı — `Faz 4`'te unutulmaması bu
   satırın varlık sebebidir. *(ürün sahibi, 2026-08-15)*
2. **`T-113` kapsamı temizlik değil, ratchet:** bugünkü hata listesi baseline
   (dosya+kural listesi olarak, sayı olarak değil), **yeni** hata kırmızı. 108'i
   sıfırlamak Faz 1 kapsamı dışıdır. `T-212` ile aynı aile. *(ürün sahibi, 2026-08-15)*

---

## 1 · ADIM 0 — Kapılar + dış kuyruk

Hiçbir inşa kalemi bu adımdan önce başlamaz. Gerekçe: dört mekanizmanın hiçbiri bugün
ayırt etmiyor `[ÖLÇÜLDÜ: 0071 §4]` ve Faz 1 işleri şema ağırlıklı — tam korunması
gereken sınıf.

| kalem | kapsam | çıkış kanıtı |
|---|---|---|
| `T-212` | ratchet'ler kapıya; bölme + money-float baseline'ları **liste** olarak; mode-split satır→dosya; guard `⏸️` sayısını da basar | her ratchet için bir kırmızı-kanıt koşusu (yapay ihlal → kırmızı) |
| `T-113` | lint kapısı — §0/2'deki ratchet çerçevesiyle | baseline dışı tek yeni error → kırmızı |
| `T-225` → pin | `BudgetReservation` kararı → pin testi `it.skip`'ten çıkar | pin, yapay entity düşürmede kırmızı `[ÖLÇÜLDÜ: 0071 §1.6 — pin ilk koşuda kusur buldu]` |
| Hukuk paketi | **dört** soru, dışarı gönderim `[ÖLÇÜLDÜ: 0071 §3 — hâlâ gönderilmedi]` | gönderim tarihi + soru listesi kaydı |

## 2 · Bloklayıcı kararlar (ürün sahibi girdisi)

| karar | blokladığı | durum |
|---|---|---|
| `0071 §6` sınıflandırma onayı (12 kalem) | planın tamamı | ⛔ açık — bu plan öneri statüsünde |
| `K-2.6.13a` + kabul testi tanımı | Adım 1 | ⛔ açık `[ÖLÇÜLDÜ: 0071 §5]` |
| `0056-K3` rol seed kararı | Adım 3 | ⛔ açık `[ÖLÇÜLDÜ: 0071 §1.1]` |
| `T-214` katalog ↔ tenant ayrımı | Adım 3'ün politika üretim yolu | ⛔ açık — üretim yolu bu karardan önce yazılırsa yanlış satır modeli API sözleşmesine döner `[GEREKÇELİ]` |

## 3 · ADIM 1 — `K-2.6.13` DB rolleri

> ### ✅ **KAPANDI** — 2026-08-16
>
> ```
> K-2.6.13a  iki rol                    ✅   app_runtime · app_migrate
> K-2.6.13b  sahiplik                   ✅   tablo sahibi app_migrate (app_owner KAPALI)
> K-2.6.13c  kurulum betiği             ✅   setup.sh (01) / grants.sh (02) — göç DEĞİL
> K-2.6.13d  sessiz geri dönüş yasağı   ✅   AC#8 iki bacaklı, mutasyon kanıtlı
> K-2.6.13e  kırmızı-sonra-yeşil        ✅   KALICI suite'te (bir kez gösterim DEĞİL)
> K-2.6.13f  izin envanteri             ✅   92 izin · 36 tablo · her GRANT kaynak yorumlu
> ```
>
> **Kapanan bulgular:** `B1` (64 enum sahipliği) · `B2` (taze DB'de kurulum) · `B3`
> (defter/denetim `DELETE`'i) · `B4` (runtime süreci migrate kimliği) · `M1` (betik
> yakınsaklığı) · `M-3` (guard yüzeyi) · `M-2` · `m-2`…`m-5` · **`B-1`** (grant betiği
> atomikliği — `M1`'in ürettiği yeni vaka).
>
> **Çıktısı `ADIM 5`'in girdisi:** `docs/verification/DB_ROL_IZIN_ENVANTERI.md`.
>
> ⚠️ **Kalan tek kalem ayrı bir task:** [[T-232]] — `bitbucket-pipelines.yml` ölü ama
> **yanıltıcı**; konuşlandırma bir gün ayağa kalkarsa tek-rol modelini miras verir ve
> `K-2.6.13`'ü geri alır.

Issue hazır (`_ISSUE_DB_ROLU.md`), hiç başlamadı `[ÖLÇÜLDÜ: 0071 §5]`. Çıktısı (izin
envanteri, `docs/verification/`) Adım 5'in girdisidir. Migration numarası Team Lead
tahsis eder (DUR-4).

## 4 · ADIM 2 — Ölçüm paketi (beş kalem + `Z8`'in altıncısı; inşa değil)

> ### Durum — 2026-08-16: **beşi de kapandı**, biri *"yapılamaz"* olarak
>
> | # | kalem | sonuç | kayıt |
> |---|---|---|---|
> | 1 | RLS `N` | ✅ **`0/48`** — payda ilk kez ölçüldü (`0/43` uydurmaydı) | `RLS_TABLO_ENVANTERI.md` |
> | 2 | denetim envanteri | ✅ kanonik sözlük **YOK**, dört ayrı aile; 39 uç → 4 sınıf | `ADIM2_OLCUM_2_4_5.md` |
> | 3 | **onay bekleme dağılımı** | ⛔ **BUGÜNKÜ VERİYLE YAPILAMAZ** — sıfır örneklem | `ADIM2_OLCUM_3_ONAY_BEKLEME.md` |
> | 4 | `T-205` bağlamı | ✅ tek yol, **iki alan**; frontend tüketicisi 0 | `ADIM2_OLCUM_2_4_5.md` |
> | 5 | `K-2.6.9` eksenleri | ✅ **`[VARSAYIM]` çözüldü**: cevap "ayar mı inşa mı" değil — **İKİSİ** | `ADIM2_OLCUM_2_4_5.md` |
>
> ⚠️ **Kalem 3 *"yapıldı"* diye kapatılmadı.** Bir sayı üretmek mümkündü (e2e koşumundan
> geçici satırlar, ya da seed'den sentetik dağılım) — ikisi de **test kurgusunu** ölçerdi,
> gerçek kullanıcı davranışını değil. `CLAUDE.md`: *"ölçütü korumak için veri uydurmak,
> ölçütün koruduğu şeyi yok eder."*
>
> → **`B4`'ün şartı YENİDEN YAZILDI** — ürün sahibi kararı `(a)`, 2026-08-16:
> *"ilk müşteri tenant'ında **`N = 20`** tamamlanmış onay biriktiğinde ölç."*
> `N` **bugün** yazıldı, o gün değil — *o gün eldeki veriye bakıp sayı seçmek, ölçümü
> sonuca uydurmaktır.* `N` bir **tahmindir** ve daha iyi gerekçeyle değişebilir.

1. **RLS N:** `tenant_id` tablo envanteri — `0/N` ifadesi ancak bundan sonra yazılabilir
   `[ÖLÇÜLDÜ: 0071 §5 — N kayıtta yok]`
2. **Denetim envanteri:** mevcut kayıt-benzeri yapı var mı + 39 yazma ucunun sınıfları
   — "sözlük" kaleminin iş büyüklüğü bu ölçümden önce taahhüt edilmez
3. **Zamanlayıcı:** onay bekleme dağılımı (`B4`'ün "ölçüm sonrası" şartının kendisi)
4. **`T-205` bağlamı:** `submittedById`'yi boşaltan yolun akışı (kod okuma) — düzeltme
   regresyon notuyla gelir
5. **`K-2.6.9` filtresi:** ayarın arkasındaki filtre `A7`'nin üç ekseninden hangilerini
   fiilen uyguluyor — cevap Adım 4'ün "ayar mı, inşa mı" olduğunu belirler `[VARSAYIM
   çözülür]`
6. ⚡ **Negatif kullanılabilirlik invariantı — TEST VAR MI?** (karar defteri `Z8`,
   2026-08-16 · girdi: `docs/decisions/PLAN_BUTCE_NETLESTIRME.md` madde 4)

   ```
   iddia  : "hiçbir zarf negatif kullanılabilirliğe düşemez"
   statü  : ⛔ ÖLÇÜLMEDİ
   ```

   Bu bir **varlık teyididir**, bir inşa değil: test **varsa** referansı kaydedilir,
   **yoksa** eklenir. `B5`'in *"10 eşzamanlı onay"* senaryosuyla aynı aile —
   `K-2.2.9h`'in atomikliği ve `K-2.2.15`'in veritabanı seviyesi koruması tam olarak
   bu invariantı savunuyor, ama **savunduğunun sınandığı ölçülmedi.**

   ⚠️ Ve `CLAUDE.md`'nin *"bir doğrulamanın çalıştığı sanılması, girdinin ona hiç
   ULAŞMAMASINDAN gelebilir"* maddesi burada doğrudan geçerli: invariant hiç
   tetiklenmediyse doğru olduğu **bilinmiyor** — ne doğru ne yanlış.

Kural: her sonuç **liste** olarak raporlanır; sayı tek başına dayanak değildir.

⚠️ **`6.` kalem beşi kapandıktan SONRA eklendi** (`Z8`) — yukarıdaki *"beşi de kapandı"*
durum tablosu `1–5` içindir. `6` **açıktır**.

## 5 · ADIM 3 — `K-2.6.3` + `K-2.6.6` tek dalga (yetenek modeli + default-deny)

> ### Faz A — SABİT YAZIMI (2026-08-17, ürün sahibi kapsamı)
>
> ```
> CAPABILITIES sabiti            işlem sınıfı bazlı — 24 dolu hücre tabanı (0072 §3)
> ROLE_CAPABILITIES haritası     TEK yerde
> FINANCE_MANAGER key → FINANCE  kayıt Z7
> 3 bilinçli-açık uç → isPublic  auth/login · auth/refresh · GET / (health)
> ```
>
> ⛔ **`@RequireCapability` dekoratörü BU TURDA YAZILMAZ.** `159` `@Roles` göçü **ayrı
> faz**. Sabit + harita önce, **tüketici sonra**.
>
> > **Gerekçe (ürün sahibi):** yoksa `@Roles` ve `@RequireCapability` **aynı anda yaşar**
> > — ve o, `İlke 4`'ün (aynı yetenek iki kez) ihlali. İki yetki mekanizması bir arada,
> > hangisinin bağlayıcı olduğu belirsiz.
>
> ### ⚠️ `FINANCE_MANAGER` kapsamı ÖLÇÜLDÜ — `64` YANLIŞTI
>
> Team Lead route seviyesinde saymıştı. Gerçek kapsam **çapraz-repo**:
>
> ```
> backend   UserRole.FINANCE_MANAGER   76   ·   'FINANCE_MANAGER' toplam  161  (src+test)
> frontend  'FINANCE_MANAGER'          45   ·   kendi enum'u da FINANCE_MANAGER = 'FINANCE'
> ```
>
> ✅ **Sözleşme KIRILMIYOR:** `roleEnumContract.test.ts` `Object.values(UserRole)`
> kullanıyor — **değerleri** pinliyor, key'leri değil. Tel değeri `'FINANCE'` **değişmiyor**.
>
> ⚠️ **Ama ikisi de aynı dalgada olmalı:** iki repoda farklı tanımlayıcı bırakmak,
> `Z7`'nin düzelttiği *"ad benzerliği ile anlam ayrışması"*nı **yeniden üretir**.
>
> ### ⛔→✅ `9/24` BLOKE hücre — karar `(a)` UNION, ŞARTLI (2026-08-17, ürün sahibi)
>
> `1d10cd2` dokuz hücreyi bloke bıraktı: o hücrelere düşen route'lar bugün **farklı** rol
> kümeleri taşıyor, ve tek ad altında toplamak erişimi **genişletir ya da daraltır**.
>
> **Reddedilenler, gerekçeleriyle:**
>
> | şık | neden |
> |---|---|
> | `(b)` alt-sınıf | taksonomiyi `24`'ten **yukarı** büyütür — `0056-K3(b)`'nin karşı çıktığı şey (`İlke 1`) |
> | `(c)` kapsam dışı | dokuzu `@Roles`'ta bırakmak **iki mekanizmayı** yaşatır (`İlke 4`) |
> | `(d)` önce `K-2.6.6` | **sırayı ters çevirir** — default-deny'ı haritasız açmak = *"çevrildiği an eşlenmemiş her uç kırılır"* |
>
> **Ve union körü körüne hesaplanmaz — üç dal:**
>
> ```
> 1  hücre içi tüm kümeler AYNI   →  union = değişiklik yok, MEKANİK
> 2  hücrede FİLTRESİZ route var  →  ⛔ o route union'a GİRMEZ
> 3  kümeler FARKLI               →  GENİŞLEME listesi, tek tek
> ```
>
> ⛔ **İkinci dal kritik:** *"filtresiz bir route'u union'a katmak, o hücredeki **korunan**
> route'ları da açar. O route `77`'nin içindeyse, union onu bir yetenek kümesine değil
> **boşluğa** eşler."* → **Union yalnız `@Roles` taşıyan route'lardan hesaplanır**;
> filtresizler `K-2.6.6`'nın konusu ve `report-only` fazında **ayrı** ele alınır.
>
> **Genişleyen her hücre kayda geçer:** hangi route · hangi rol eklendi · **neden kabul
> edildi**.
>
> 📌 **`(a)` geri alınamaz DEĞİL — `report-only` onun doğrulama katmanı.** Union yanlış
> genişletmişse orada **beklenmedik rol** olarak görünür. ⚠️ Ama bu, kaydı atlamanın
> gerekçesi değil: kayıt olmadan `report-only` çıktısı *"beklenmedik mi, kabul edilmiş mi"*
> diye **ayırt edilemez**.
>
> ### ✅ SONUÇ — `4` çözüldü, `5` DUR (2026-08-17, ölçüldü)
>
> Union `@Roles` **dekoratöründen** hesaplandı (dosya adı değil — `find-entity` dersi), ve
> taban bağımsız olarak doğrulandı: **`237` route · `160` `@Roles`'lu · `77` filtresiz** —
> `0072`'nin tabanıyla birebir. Pozitif kontrol geçti.
>
> ```
> ÇÖZÜLDÜ (4)                                                    dal
>   MODES_WRITE    {ADMIN,FINANCE,PLANNER}                        3   genişleme
>   SHARED_WRITE   {ADMIN,CATEGORY_MANAGER,FINANCE,PLANNER}       3   genişleme (4 filtresiz HARİÇ)
>   TENANT_READ    {ADMIN}                                        1+2 tek küme + 2 filtresiz hariç
>   USER_WRITE     {ADMIN}                                        1+2 tek küme + 5 filtresiz hariç
>
> DUR (5) — hiçbir role ATANMADI
>   MODES_READ · SHARED_READ · USER_READ    union = 5 rolün 5'i → ÇÖKÜŞ
>   MODES_APPROVE · SHARED_APPROVE          onay yeteneği       → K-2.5.12
> ```
>
> **İkinci dal tuttu — ve bağımsız ölçümle doğrulandı:** hiçbir yazma-sınıfı route
> `READONLY` taşımıyor. `READONLY` geçen route'ların **hiçbiri `Get` dışında değil** —
> ⚠️ **sayı düzeltildi (2026-08-17): `31` değil `35`.** İlk ölçüm iç içe spread sabitini
> çözemeyen parser'la yapılmıştı (`sales-actuals`'ın `4` rotası düşmüştü); düzeltilmiş
> parser `35` veriyor. **İnvaryant değişmedi** — `Get` olmayan **sıfır**. Sayı bayatladı,
> niteliksel ayırt edici bayatlamadı (`CLAUDE.md`: *"dokümanda sayı yazma"*). Spread
> sabitleri
> çözülerek de (`sales-actuals` `WRITE_ROLES = {ADMIN,FINANCE}` ↔ `READ_ROLES` = 5 rol).
> Yani çözülen iki `WRITE` hücresinin union'ından `READONLY`'nin dışarıda kalması bir
> tercih değil, **ölçülmüş bir sonuç**.
>
> ⚠️ **Üç `READ` hücresinin çöküşü union'ın kusuru DEĞİL:** o hücrelerde zaten **5 rolün
> 5'ini** taşıyan bir route var (`dashboard-summary` · `approval my-requests` ·
> `sales-actuals` `READ_ROLES`). Union onları yalnız **görünür** kıldı. Yani soru
> *"union yanlış mı"* değil, *"bu geniş route'lar dar olanlarla aynı hücreye mi düşmeli"*
> — taksonomi sorusu, ürün sahibine gider.
>
> ⚠️ **`PATCH /approval-policies/:id` özel işaretli:** bugün `@Roles(ADMIN)` (ölçüldü,
> `approval-policy.controller.ts:33-34`), union onu 3 role daha açıyor. Bir onay
> **politikası** konfigürasyon ucu — davranışsal ağırlığı `yazma` sınıfından büyük.
> `report-only` fazında **önce buraya bakılır**.
>
> 📌 Route × eklenen rol × gerekçe dökümü **`capabilities.ts` başlığında** — kayıt şartı
> (üstteki *"genişleyen her hücre kayda geçer"*) orada karşılandı.
>
> ### ⛔ BAĞLAYICI SIRA — union, `T-235`'ten SONRA (2026-08-17, ürün sahibi onayladı)
>
> Üç `READ` hücresinin union'ı **`T-235` kapanmadan değerlendirilmez.**
>
> **Gerekçe ölçüldü** (`ADIM3_OLCUM_2` + `ADIM3_OLCUM_1`): union kararının ön koşulu
> *"`A` sınıfının genişliği meşru — gerçek daraltma serviste"* idi. Ölçüm o gerekçeyi
> **bugün için çürüttü**: kapsam filtresi `5` rolün `1`'inde aktif
> (`UNRESTRICTED_ROLES = {ADMIN, FINANCE, READONLY}` koşulsuz · `PLANNER` bayrak
> kapalıyken `UNRESTRICTED` · daraltma yalnız `CATEGORY_MANAGER`'da).
>
> ```
> bugün      @Roles = TEK kapı          (kapsam katmanı 4/5 rolde kapalı)
> union      o tek kapıyı gevşetir
> sonuç      iki kapı da aynı anda açık
> ```
>
> **Ters sıra ölçülmüş bir riski gerçekleştirir**, bir tercih değil.
>
> ### Faz B — TÜKETİCİ (ayrı tur)
>
> `@RequireCapability` + `159` `@Roles` göçü + `roles.guard.ts:16-18`'in default-deny'a
> çevrilmesi. ⚠️ O üç satır **72 ucu aynı anda** etkiler → **`report-only` fazı zorunlu**.

- İki kalem ayrılmaz: default-deny, yetenek eşlemesi olmadan çevrilemez; K-2.6.6'nın
  kalıcı düzeltmesi default-deny'dır `[GEREKÇELİ]`.
- **İki aşamalı geçiş:** önce report-only deny (eşlenmemiş uç loglanır, engellenmez) —
  envanter fiili trafikte doğrulanır; sonra kapatılır. `K-2.6.13`'ün izin-envanteri
  yönteminin uygulama-katmanı simetriği `[GEREKÇELİ]`.
- **Tel protokolü sınırları sayılır** (DUR-5): yetenek/rol adları frontend kapılarına
  gider — `B` dalgası vakası emsal `[ÖLÇÜLDÜ: brief §5/5]`.
- Geçici sapmalar (`K-2.6.14` import kısıtı) **koda değil yetenek-eşleme verisine**
  yazılır — Faz 2 açılımı seed değişikliği olur `[GEREKÇELİ]`.

## 6 · ADIM 4 — `K-2.6.9` kapsam filtresi

Adım 2/5 ölçümünün sonucuna göre "ayarı aç" ya da "kapsam çözümlemesini kur". Eksenler
`A7`: kanal + müşteri + kategori; bölge kapsama girmez, boş kapsam = erişim yok.

## 7 · ADIM 5 — `K-2.6.12` RLS

- **Ön karar (bu fazda, bu adımdan önce): operatör (tenant-üstü) erişimi** — Süper
  Yönetici reddi bu soruyu açıkça Faz 1/RLS'e kaydetti `[ÖLÇÜLDÜ: 04_KARAR_KAYDI]`.
  RLS'ten sonra eklenen operatör kapısı BYPASSRLS cazibesidir `[GEREKÇELİ]`.
- Girdiler: Adım 1 izin envanteri + Adım 2 N listesi.
- **Kesişim kalemi:** zamanlanmış işler × kiracı bağlamı tasarımı bu adımın içindedir —
  RLS altında bağlamsız zamanlayıcı ya boş veri görür ya ayrıcalık ister `[GEREKÇELİ]`.
- Kabul mekanizması `_ISSUE_DB_ROLU`'nun RLS sonda testi deseni: kırmızı-sonra-yeşil.

## 8 · ADIM 6 — Denetim ailesi

Sıra: sözlük **tanımı** (L2'ye yalnız Team Lead yazar — DUR-3) → mekanizma → yayılım
(`K-2.7.2` işaretleri · `K-2.11.5` yazarı · `K-2.11.7` mekanizması). Rol dalgasından
sonra gelir: aynı servis dosyalarına iki dalga aynı anda dokunmaz `[GEREKÇELİ]`.

## 9 · Paralel şerit (rol işlerinden bağımsız)

`K-2.5.16b` (boşaltan yol — Adım 2/4 bağlam ölçümüyle) + `K-2.5.11` (`S13` teyidi ön
koşul `[ÖLÇÜLDÜ: 0071 §6]`). Köken-alanı kuralı: kimlik alanları güncellenir, asla
boşaltılmaz.

## 10 · Kuyruk — hukuka bağlı üçlü

`K-2.8.11` · `K-2.9.5` · `K-2.9.7`: paket dönene dek **tasarım yapılmaz** — askı
(`K-2.9.0`) yürürlükte, erken tasarım cevapla çelişirse iki kez yapılır. Adım 0
gönderimi bu kuyruğun saatini başlatır.

## 11 · Kapsam ekleri — öneri statüsünde (ürün sahibi onayıyla kaleme döner)

| ek | gerekçe | önerilen yer |
|---|---|---|
| Bildirim dilimi (olay üretimi + tek kanal) | `C1` %90 bildirimi · `B4` 7/14 hatırlatma bu ucu varsayıyor; 12 kalemde yok | Adım 3 sonrası küçük kalem |
| Kimlik doğrulama standardının adresi | L2'den bilinçli düşürüldü, işaret yok `[ÖLÇÜLDÜ: dış denetim]`; RBAC işi auth'a dokunacak | tek sayfa + L2 işareti |
| Operatör erişim kararı | §7'de ön karar olarak zaten sırada | Adım 5 ön kararı |
| Zamanlayıcı × kiracı bağlamı | §7'de kesişim kalemi olarak zaten sırada | Adım 5 içi |

## 12 · Kapsam DIŞI — tek cümle gerekçeyle

- **7 bütçe/gösterge ihlali** (`K-2.2.6` ailesi): adresleri Faz 1 değil `[ÖLÇÜLDÜ: 0071 §6]`
- **Hakediş eksiklikleri** (`K-2.13.*` + `K-2.1.5`): Faz 2 çekirdeği `[ÖLÇÜLDÜ: 0071 §6]`
- **Hukuk üçlüsünün tasarımı:** dış girdi dönmeden yapılan tasarım iki kez yapılır
- **108 lint hatasının temizliği:** ratchet yeni hatayı durdurur; stok temizliği ayrı,
  fırsatçı iş
- **Yedekleme/RPO-RTO:** ilk deploy ön koşulu (§0/1) — bu fazın kalemi değil
- **`T-209` discount_amount:** üretim verisi ister `[ÖLÇÜLDÜ: 0071 §3]` — kuyrukta

---

## Kaynaklar

`0071-faz-0-durum-fotografi.md` (kanonik) · `FAZ1_BRIEF_FABLE.md` ·
`docs/brd-v2/03_IS_KURALLARI/L2_03*` · `docs/brd-v2/_ISSUE_DB_ROLU.md` ·
`docs/brd-v2/04_KARAR_KAYDI.md` §Kaynak ilişkisi · `docs/decisions/{KARAR_TURU_BES_KONU,OPEN_DECISIONS}.md` ·
`.claude/backlog/tasks/{T-113,T-205,T-212,T-214,T-224,T-225}.md`
