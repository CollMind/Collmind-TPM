# Danışman Paketi — Ekran Görüntüleri INDEX

> Ortam: backend :3000, frontend :5173 (localhost) · Tarih: 2026-09-03 · Pencere: 1440×900
> Kaynak adım listesi: docs/domain/BOLUM1_AKIS_DOGRULAMASI_TASLAK.md (+ docs/domain/DANISMAN_PAKETI_v1.md)
> Not: dosya adlarındaki halka numarası (0-5) şu şekilde kullanıldı: 0 = role/genel (login, menü, ayarlar,
> çıkış — belirli bir halkaya özgü değil), 1-5 = BOLUM1 dokümanındaki ilgili halka. Bu bir ürün yorumu
> değil, yalnız dosya organizasyonu kolaylığı için seçilen bir kuraldır.
> SALT-OKUMA modunda gezildi: hiçbir form submit edilmedi, hiçbir onay/red butonuna basılmadı, yeni
> plan/anlaşma oluşturulmadı. "Yeni Plan Oluştur" modalı yalnız görüntülendi, İptal ile kapatıldı.

## PLANNER (planner@wella.com)

- 0-planner-01-login.png — Login ekranı, e-posta/parola dolu (submit öncesi)
- 1-planner-02-dashboard-sifir.png — Planner dashboard "Panelim", Dönem 2026-09, Aktif anlaşma 0 / Onay bekleyen 0 / Açık görev 0
- 2-planner-03-off-invoice-liste.png — "Fatura İşlemleri" (Off-Invoice) listesi, 3 off-invoice kaydı, Toplam İşlem ₺1.500,00
- 0-planner-04-sol-menu-tam.png — Sol menü, tüm alt öğeler açık (Planlama>Planlar, Anlaşmalar>STA/LTA, Off-Invoice, On-Invoice, Bütçe>Dashboard, Settings)
- 1-planner-05-planlar-listesi.png — "Planlar" listesi: 2 plan (PLAN-2026-Q3-002-0752 ONAYLANDI, PLAN-2026-Q3-001-9726 ONAY BEKLEYEN)
- 1-planner-06-plan-detay-grid-onay-bekleyen.png — PLAN-2026-Q3-001-9726 (Hair Care) Planning Grid, PLAN STATUS: GRİ · %0 kapsama; sağ üstte "Forbidden resource" toast hatası görüldü
- 1-planner-07-fu-sku-detay.png — Aynı plan, FU satırı genişletilmiş: 1 FU + 3 SKU (Baseline eksik / Hesaplanmadı etiketleri)
- 1-planner-08-analiz-rapor.png — Aynı plan, "Analiz & Rapor" sekmesi: GP ROI %0.0 Hesaplanmadı, Target ROI %20, Incremental GP -₺400.000
- 1-planner-09-plan-detay-onaylandi.png — PLAN-2026-Q3-002-0752 (Saç Boyası) Planning Grid, durum ONAYLANDI, Base/Planned Volume 0
- 1-planner-10-yeni-plan-modal.png — "Yeni Plan Oluştur" modalı (boş form: Plan Adı, Kanal, CPL, Kategori, Dönem) — İptal ile kapatıldı, submit edilmedi
- 2-planner-11-on-invoice-yukleme.png — On-Invoice Yükleme sayfası, adım 1/3 "Dosya Yükle", açıklama metni ve sürükle-bırak alanı
- 1-planner-12-anlasmalar-liste.png — "Anlaşmalar" listesi (STA+LTA), Toplam Anlaşma 5 (STA:4, LTA:1), Toplam Cap ₺295.000
- 1-planner-13-anlasma-detay.png — "Wella NKA CarrefourSA Şubat Promosyon" anlaşma detayı (Approved, STA) — "İptal Et" butonu görüldü, tıklanmadı
- 5-planner-14-butce-dashboard.png — Bütçe Yönetimi > Dashboard: Toplam Tahsis ₺1.600.000, Reserved ₺0, Toplam Consumed ₺0, Toplam Available ₺1.600.000
- 5-planner-15-butce-envelope-listesi.png — Bütçe Yönetimi > Envelope Listesi: Toplam Tahsis ₺1.600.000, Consumed ₺0 (%0.0), Available ₺1.428.500 (%89.3) — BOLUM1 §5a(ii) bulgusuyla birebir eşleşiyor
- 0-planner-16-settings.png — Settings sayfası: Theme=Light, Language=English (arayüz içeriği Türkçe olmasına rağmen)
- 0-planner-17-user-menu-logout.png — Sağ üst kullanıcı menüsü açık: Profile / Settings / Log out

## CATEGORY MANAGER (category.manager@wella.com)

- 0-cm-01-login.png — Login ekranı, e-posta/parola dolu
- 1-cm-02-onay-paneli-sifir.png — CM dashboard "Onay Paneli": Onay bekleyen 0 / Hakediş onayı 0 / Aktif anlaşma 0 (2026-09 dönemi) — Planlar listesinde 1 adet ONAY BEKLEYEN plan (Hair Care) olmasına rağmen burada 0 görünüyor
- 0-cm-03-sol-menu-tam.png — Sol menü tam açık: Planlama>Planlar/Plan Onayları, Anlaşmalar>STA/LTA, Finans Paneli, Bütçe>Dashboard/Envelope Listesi/Ledger (Read Only), Settings
- 1-cm-04-plan-onaylari-bos-scope.png — "Plan Onayları" ekranı: "Onay bekleyen plan bulunmamaktadır" (Bekleyen 0). BOLUM1 §1a bulgusuyla birebir örtüşüyor: category.manager@wella.com'un scope'u (Saç Boyası, Set Boya) sistemde bekleyen tek planın kategorisini (Hair Care) kapsamıyor, plan bu CM'e hiç görünmüyor
- 5-cm-05-butce-envelope-listesi.png — Bütçe Yönetimi > Envelope Listesi (CM görünümü): Toplam Tahsis ₺1.600.000, Consumed ₺0, Available ₺1.428.500 — Planner ile aynı veri; CM'de ayrıca "+ Yeni Envelope" butonu var (Planner'da yok)
- 5-cm-06-ledger-erisilemedi-dashboarda-yonlendi.png — **[ULAŞILAMADI]** Sol menüdeki "Ledger (Read Only)" (`/budget/ledger`) linkine tıklandığında sayfa açılmıyor, otomatik olarak `/dashboard`'a yönlendiriliyor. Hem menü linkine (href doğrulandı) hem doğrudan URL'e giderek 3 kez denendi, aynı sonuç. BOLUM1 §5a(i)'de bahsedilen "CONSUME" ekranı bu nedenle bu turda görüntülenemedi.
- 0-cm-07-finans-paneli-hata.png — **[HATA]** Sol menüden "Finans Paneli" açılınca React hata ekranı: "Something went wrong / Rendered more hooks than during the previous render." + toast hataları: "No budget en[velope]... requested period/filters — a utilization figure cannot be computed", "property startDate should not exist / property endDate should not exist" (bu ikinci mesaj 2 kez tekrarlanmış olarak görünüyor). Sayfa "Reload Page" ile kurtarıldı, herhangi bir veri değiştirilmedi.
- 1-cm-08-anlasmalar-liste-bos-scope.png — "Anlaşmalar" listesi (CM görünümü): "Anlaşma bulunamadı", Toplam Anlaşma 0 (STA:0, LTA:0), Toplam Cap ₺0 — Planner'ın gördüğü 5 anlaşmadan hiçbiri bu CM'e görünmüyor (kategori/scope filtresi)
- 0-cm-09-settings.png — Settings sayfası: Theme=Light, Language=English
- 0-cm-10-user-menu-logout.png — Sağ üst kullanıcı menüsü açık (category.manager@wella.com): Profile / Settings / Log out

## FINANCE (finance@wella.com)

- 0-finance-01-login.png — Login ekranı, e-posta/parola dolu
- 0-finance-02-dashboard-butce-uyarisi.png — Finance dashboard "Finans Paneli": Aktif anlaşma 0, Fatura bekleyen 0, Açık görev 0 + sarı uyarı bandı: "Bütçe kullanımı hesaplanamadı. Bu, bütçe verisinin boş olduğu anlamına gelmez — rakamlar okunamadı. Sorun sürerse destek ile görüşün." Hızlı erişimde "Actuals Yükle" butonu (diğer rollerde yok)
- 0-finance-03-sol-menu-tam.png — Sol menü tam açık: Planlama>Planlar/Plan Onayları, Anlaşmalar, Off-Invoice, On-Invoice, Finans Paneli, Bütçe>Dashboard/Envelope Listesi/Ledger (Read Only), Settings
- 5-finance-04-ledger-consume-kayitlari.png — "Financial Ledger" (`/budget/ledger`) sayfası, Finance rolüyle sorunsuz açıldı (CM'de açılmıyordu — bkz. 5-cm-06): 3 kayıt, hepsi TRANSACTION=CONSUME, -₺500,00, ENTITY TYPE=AGREEMENT, SCOPE=NKA. BOLUM1 §5a(i) bulgusunun (ekranda "CONSUME" etiketi = ledger_entries.DEBIT'in ön-yüz çevirisi) doğrudan görsel kanıtı
- 1-finance-05-plan-onaylari-erisilemedi.png — **[ULAŞILAMADI]** Sol menüde "Plan Onayları" öğesi görünüyor ama hem menüden tıklanınca hem doğrudan `/plan-approvals` URL'ine gidilince otomatik `/dashboard`'a yönlendiriliyor. BOLUM1 §1a'daki "⚠️ FINANCE yok" (`GET /plans/pending-approvals` yalnız ADMIN/CM/READONLY) bulgusuyla birebir örtüşüyor — menü öğesi var ama rol yetkisi yok
- 1-finance-06-anlasmalar-liste.png — "Anlaşmalar" listesi (Finance görünümü): Toplam Anlaşma 5 (STA:4, LTA:1), Toplam Cap ₺295.000 — Planner ile aynı, CM'in gördüğü 0'dan farklı (scope kısıtı Finance'ta yok)
- 2-finance-07-off-invoice-liste-manuel-giris.png — "Fatura İşlemleri" (Off-Invoice) listesi: 3 kayıt, Toplam İşlem ₺1.500,00 — ayrıca "Manuel Giriş" butonu var (Planner/CM'de görülmedi)
- 2-finance-08-on-invoice-yukleme.png — On-Invoice Yükleme sayfası (Finance görünümü), Planner ile aynı
- 5-finance-09-butce-dashboard.png — Bütçe Yönetimi > Dashboard (Finance): Toplam Tahsis ₺1.600.000, Reserved ₺0, Toplam Consumed ₺0, Toplam Available ₺1.600.000 — Planner ile aynı veri
- 0-finance-10-settings-user-menu.png — Settings sayfası + sağ üst kullanıcı menüsü açık (finance@wella.com): Theme=Light, Language=English, Profile/Settings/Log out

## ADMIN (admin@wella.com)

- 0-admin-01-login.png — Login ekranı, e-posta/parola dolu (submit öncesi)
- 0-admin-02-dashboard-operasyon-paneli.png — Admin dashboard "Operasyon Paneli": Aktif anlaşma 0 / Onay bekleyen 0 / Açık görev 0 (2026-09), sarı bütçe uyarı bandı; Hızlı erişimde diğer rollerde olmayan "+ Yeni Anlaşma" ve "Onay Kuyruğu" butonları var
- 0-admin-03-sol-menu-tam.png — Sol menü tam açık/scroll edilmiş: Admin alt menüsü eksiksiz görünüyor (Genel Bakış, Kullanıcılar, KPI/FU/SKU/Müşteri/CPL/Taktik/Mekanik/Marka/Kategori/Kanal/Generic Unit/Bölge Yönetimi, Audit Log)
- 0-admin-04-genel-bakis.png — Admin > Genel Bakış: Müşteri 29, CPL 29, FU 12, SKU 170, KPI 32 (master veri özet kartları)
- 0-admin-05-kullanicilar.png — Admin > Kullanıcılar: "9 kullanıcı bulundu" tablosu (İsim/Email/Rol/Durum/Departman), "Yeni Kullanıcı" butonu görüldü, tıklanmadı
- 0-admin-06-kpi-yonetimi.png — Admin > KPI Yönetimi: Toplam KPI 32, Aktif 29, Grid'de Görünen 11, Hedef ROI Tanımlı 1; formül tablosu (BASE_VOL, PLAN_VOL, PLAN_TURNOVER = PLAN_VOL * BPTT, vb.)
- 0-admin-07-fu-yonetimi.png — Admin > FU Yönetimi: Forecasting Unit kartları (FU-E2E-GRID-SINGLE-SKU, FU-WELLA-HC-500ML, FU-INTENSE, FU-KARMA-KOLI, FU-KOLESTON, FU-KOLESTON-KIT, ...), her biri SKU sayısı ve TOPLAM BASE VOL ile
- 0-admin-08-sku-yonetimi.png — Admin > SKU Listesi: Ürün master datası tablosu (Kod/Ürün Adı/Marka/Kategori/Liste Fiyatı/COGS/Durum), Import ve Yeni SKU butonları
- 0-admin-09-musteri-listesi.png — Admin > Müşteri Listesi ("Müşteriler"): CUST-* kodlu müşteri tablosu (Kod/Ad/Kanal/CPL/Durum/Şehir/Şube Sayısı)
- 0-admin-10-cpl-yonetimi.png — Admin > CPL Yönetimi: Müşteri Planlama Grupları kart listesi (Ak Temizlik, A.S.Watson, Bim, Bozkuşlar, Carrefoursa, CarrefourSA NKA, vb.), her biri Aktif/Müşteri sayısı ile
- 0-admin-11-taktik-yonetimi.png — Admin > Taktik Yönetimi: 5 taktik (TAC-OFF-DISCOUNT, TAC-ON-DISCOUNT, TAC-PRICE-SUPPORT, TAC-PROMO, TAC-VISIBILITY), hepsi Aktif
- 0-admin-12-mekanik-yonetimi.png — Admin > Mekanik Yönetimi: 6 mekanik (CPP_OFF_PCT, CPP_ON_PCT, MEC-DISCOUNT, DISPLAY_FEE, PRICE_SUP, VIS_LS), her biri bir Taktik ID'ye bağlı — BOLUM1'in "6/6 satır" bulgusuyla birebir eşleşiyor
- 0-admin-13-marka-yonetimi.png — Admin > Marka Yönetimi: Tek kayıt — WELLA / Wella / Aktif
- 0-admin-14-kategori-yonetimi.png — Admin > Kategori Yönetimi: 8 kategori (Diğer, Hair Care, Karma Koli, Köpük, Peroksit, Saç Boyası, Şekillendirici, Set Boya), hepsi Aktif
- 0-admin-15-kanal-yonetimi.png — Admin > Kanal Yönetimi: 8 kanal, sıralama ile (NKA, Traditional Trade, E-Commerce, Export, Wholesale, Retail, HORECA, Distributor)
- 0-admin-16-generic-unit-yonetimi.png — Admin > Generic Unit Yönetimi: Marka+Kategori bazlı Generic Unit kartları (GU-WELLA-DIGER, GU-WELLA-HC-001, GU-WELLA-KARMA-KOLI, vb.)
- 0-admin-17-bolge-yonetimi-veri-yok.png — **[veri yok]** Admin > Bölge Yönetimi: "Henüz kayıt bulunmamaktadır" — sistemde hiç bölge tanımlanmamış
- 0-admin-18-audit-log-stub.png — **[stub/boş]** Admin > Audit Log: "Bu sayfa yakında eklenecek." — menüde görünüyor ama içerik henüz geliştirilmemiş
- 0-admin-19-anlasma-onaylari.png — Admin > Anlaşma Onayları (`/agreement-approvals`) — BOLUM1'de ayrıca adlandırılmamış, Planlama>Plan Onayları'ndan FARKLI bir ekran: "Onay bekleyen anlaşma bulunmamaktadır", Bekleyen 0, Ort. Tutar ₺0, Yüksek Tutar (>100K) 0
- 1-admin-20-planlar-listesi.png — Planlama > Planlar (Admin görünümü): 2 plan (PLAN-2026-Q3-002-0752 ONAYLANDI, PLAN-2026-Q3-001-9726 ONAY BEKLEYEN) — Planner ile aynı
- 1-admin-21-plan-onaylari.png — Planlama > Plan Onayları (Admin görünümü): BEKLEYEN 1 — PLAN-2026-Q3-001-9726 (Bölüm-1 Danışman Ölçümü) görünür, Onayla/Reddet butonları var ama **tıklanmadı** (salt-okuma). CM'de scope filtresiyle 0 görünen, Finance'ta hiç erişilemeyen bu ekran Admin'de tam görünür — rol bazlı erişim farkının doğrudan kanıtı
- 1-admin-22-anlasmalar-liste.png — Anlaşmalar listesi (Admin görünümü, STA+LTA birleşik): Toplam Anlaşma 5 (STA:4, LTA:1), Toplam Cap ₺295.000 — Planner/Finance ile aynı, CM'in gördüğü 0'dan farklı
- 2-admin-23-off-invoice-liste.png — Fatura İşlemleri (Off-Invoice) listesi (Admin): 3 kayıt, Toplam İşlem ₺1.500,00 — "Manuel Giriş" ve "Off/On-Invoice Yükle" butonları görüldü, tıklanmadı
- 2-admin-24-on-invoice-yukleme.png — On-Invoice Yükleme sayfası (Admin görünümü), adım 1/3 Dosya Yükle — diğer rollerle aynı
- 0-admin-25-finans-paneli-hata.png — **[HATA]** Sol menüden "Finans Paneli" açılınca AYNI React hata ekranı CM'de görülenle birebir tekrarlandı: "Something went wrong / Rendered more hooks than during the previous render" + "No budget envelope data..." / "property startDate should not exist" toast'ları. Bu, hatanın yalnızca CATEGORY_MANAGER'a özgü olmadığını, ADMIN rolünde de (dolayısıyla muhtemelen role-bağımsız/genel) tekrarlandığını gösteriyor — BOLUM1'deki CM-özel varsayımını genişleten önemli bir bulgu. Sayfa "Reload Page" ile kurtarılamadı, `/budget/dashboard`'a doğrudan navigasyonla devam edildi (veri değiştirilmedi)
- 5-admin-26-butce-envelope-listesi.png — Bütçe Yönetimi > Envelope Listesi (Admin): Toplam Tahsis ₺1.600.000, Consumed ₺0, Available ₺1.428.500 — diğer rollerle aynı veri; Admin'de de "+ Yeni Envelope" butonu var (CM'dekiyle aynı)
- 5-admin-27-butce-dashboard.png — Bütçe Yönetimi > Dashboard (Admin, sekme üzerinden erişildi): Toplam Tahsis ₺1.600.000, Reserved ₺0, Toplam Consumed ₺0, Toplam Available ₺1.600.000 — diğer rollerle aynı
- 5-admin-28-ledger-consume-kayitlari.png — Financial Ledger (`/budget/ledger`, Admin): sorunsuz açıldı (CM'de açılmıyordu), 3 kayıt, TRANSACTION=CONSUME, -₺500,00, ENTITY TYPE=AGREEMENT, SCOPE=NKA — Finance ile aynı veri; bu da Ledger yönlendirme sorununun CM-role'e özgü olduğunu (Admin/Finance'ı etkilemediğini) doğruluyor
- 0-admin-29-user-menu.png — Sağ üst kullanıcı menüsü açık (admin@wella.com): Profile / Settings / Log out
- 0-admin-30-settings.png — Settings sayfası: Theme=Light, Language=English
- 0-admin-31-logout.png — Log out sonrası: Login ekranına yönlendirildi ("Welcome Back") — oturum düzgün sonlandı

## ÖZET

Toplam 68 PNG (Planner 17, Category Manager 10, Finance 10, Admin 31).

Etiketli bulgular:
- **[veri yok]**: 1 — Bölge Yönetimi (Admin) boş, sistemde hiç bölge kaydı yok
- **[stub/boş]**: 1 — Audit Log (Admin) "Bu sayfa yakında eklenecek"
- **[ULAŞILAMADI]**: 2 — CM için Ledger (Read Only) otomatik /dashboard'a yönlendiriyor (3 kez doğrulandı); Finance için Plan Onayları otomatik /dashboard'a yönlendiriyor (3 kez doğrulandı, BOLUM1 §1a "⚠️ FINANCE yok" bulgusuyla örtüşüyor)
- **[HATA]**: React error boundary crash — "Rendered more hooks than during the previous render" — Finans Paneli açılırken hem CATEGORY_MANAGER hem ADMIN rolünde tekrarlandı (Planner ve Finance rollerinde bu sayfa yok/sorunsuz). Role-bağımsız, muhtemelen genel bir render hatası.

Ekstra/bonus bulgular (BOLUM1'de ayrı adlandırılmamış): Admin'e özgü "Anlaşma Onayları" (`/agreement-approvals`) ekranı — Planlama > Plan Onayları'ndan tamamen ayrı bir onay kuyruğu; şu an boş.

Rol bazlı erişim farkları görsel olarak doğrulandı: Plan Onayları — Admin'de tam görünür (1 bekleyen plan + Onayla/Reddet), CM'de scope filtresiyle 0 görünür, Finance'ta menüde var ama erişilemiyor. Anlaşmalar listesi — Planner/Finance/Admin'de 5 kayıt, CM'de scope filtresiyle 0.

Sunucular KAPATILMADI — backend (:3000) ve frontend (:5173) hâlâ çalışıyor durumda bırakıldı.

