# Araştırma Raporu: Çok Kiracılı SaaS Yapılarında RLS, Denetim İzi ve Operatör Erişim Pratikleri

> # ⛔ DIŞ-GİRDİ — KAYNAK-İZSİZ DERLEME
>
> **Kaynak:** ürün sahibi (NotebookLM derlemesi) · **Tarih:** 2026-08-28
> **Statü:** `DIŞ-GİRDİ` · **Kayıt:** `docs/brd-v2/04_KARAR_KAYDI.md` `Z53`
>
> ## ⛔ BU RAPORDAKİ HİÇBİR SAYISAL/DAVRANIŞSAL İDDİA, YEREL PROBE OLMADAN KARAR TAŞIMAZ.
>
> Sayısal iddialar (ör. *"pgAudit %15-25 throughput kaybı"*) **atıfsızdır** ve
> **`VARSAYIM` rafındadır**.
>
> **Karar-metinlerinde atıf biçimi:** `[dış-girdi, doğrulanmadı]`
>
> ---
>
> ### ✅ TEYİT DEĞERİ — üç yerel ölçümü BAĞIMSIZ doğruluyor
>
> | yerel ölçüm | nerede |
> |---|---|
> | session-`SET` sızıntısı (**in-process havuzda dahi**) | `ADIM5_RLS_KARAR_PAKETI` B/2 probe `E1` |
> | tx-dışı `SET LOCAL` **sessiz no-op** | `Z49 §1` dördüncü ölçüm |
> | **fail-closed boş-küme** | `Z49 §1` üç çıktı |
>
> ⇒ **`Z50`'nin DIŞ TESCİLİ.** *(Ama tescil bir kanıt değil, bir **teyittir** —
> karar zaten yerel ölçümle verilmişti ve bu rapor onu **üretmedi**.)*

---


Bu rapor, çok kiracılı (multi-tenant) SaaS mimarilerinde Row-Level Security (RLS) bağlam taşıma yöntemleri, kesintisiz/değiştirilemez (immutable) denetim izi (audit trail) mimarileri, FORCE RLS rol hijyeni ve operatör erişim (break-glass) modellerine odaklanarak endüstriyel en iyi uygulamaları (best practices) ve teknik karşılaştırmaları derlemektedir.

---

## 1. Çok Kiracılı SaaS'larda RLS Bağlam Taşıma ve Havuzlama (PgBouncer) Etkileşimi

### GUC (Grand Unified Configuration) Kullanımı ve İşlem Sınırları
PostgreSQL'de uygulama katmanının veritabanına hangi kiracı bağlamında işlem yaptığını bildirmek için genellikle kullanıcı tanımlı konfigürasyon parametreleri (GUC - e.g., `app.current_tenant_id`) kullanılır. Ancak bu parametrelerin ömrü ve kapsamı kullanılan komuta göre değişir:

1. **`SET app.current_tenant_id = 'uuid'` (Oturum Seviyesi - Session Scope):**
   * **Mekanizma:** GUC değişkenini mevcut TCP bağlantısı kapatılana kadar oturumda tutar.
   * **Havuzlama Riskleri (PgBouncer):** PgBouncer **Transaction Pooling (İşlem Havuzlaması)** modunda çalıştırıldığında, aynı veritabanı bağlantısı her işlem (`BEGIN ... COMMIT`) tamamlandığında farklı bir istemciye (request) tahsis edilir. Eğer ilk istemci `SET` komutu ile bir kiracı ID yazdıysa ve bağlantı temizlenmeden havuza döndüyse, bir sonraki istemcinin sorguları (GUC atanana kadar veya hata durumlarında) sessizce **önceki kiracının verilerine** erişebilir. Bu durum çok ciddi bir veri sızıntısı (data breach) kaynağıdır.
   * **Önemli Bulgular:** Geleneksel uygulama içi ORM bağlantı havuzlarında (TypeORM vb.) bile, bir oturumda kalan kiracı durumu, bağlantı havuza geri verildiğinde temizlenmezse sonraki isteğe sızmaktadır.

2. **`SET LOCAL app.current_tenant_id = 'uuid'` (İşlem Seviyesi - Transaction Scope):**
   * **Mekanizma:** GUC değişkenini sadece aktif işlem bloğu (`BEGIN ... COMMIT`) boyunca geçerli kılar. İşlem sonlandığında (commit veya rollback) PostgreSQL motoru değişkeni otomatik olarak temizler.
   * **PgBouncer Uyumu:** Bu yöntem PgBouncer'ın işlem havuzlaması moduyla %100 uyumludur. Çünkü bağlantı başka bir istemciye aktarılmadan önce işlem çoktan sonlanmış ve GUC değeri silinmiştir.
   * **Kritik Gereksinim:** `SET LOCAL` komutunun çalışabilmesi için **mutlaka aktif bir işlem bloğunun (`BEGIN`) başlatılmış olması** gerekir. İşlem bloğu dışında (otomatik commit modunda) çalıştırılan `SET LOCAL` sessizce etki etmez ("no-op" davranışı gösterir) ve ardından gelen sorgular RLS politikasında boş/null bir değerle çalışarak veriye erişemez (fail-closed) veya hata verir.

### Bağlantı Doygunluğu (Connection Saturation) ve Eşzamanlılık Dengesi
Her veritabanı çağrı yolunun (özellikle salt-okunur 411 rota gibi geniş kapsamlı durumlarda) `BEGIN ... SET LOCAL ... COMMIT` şeklinde bir işlem bloğuna sarılması veritabanı üzerinde ek yük oluşturur:
* **Maliyetler:** Ek ağ paketleri (`BEGIN` ve `COMMIT` round-trip'leri) ve PostgreSQL işlem motoru (transaction manager) üzerinde kilit yönetim (lock contention) maliyetleri artar.
* **Havuz Doygunluğu:** İşlem süresi uzadığında, havuzdaki bağlantılar daha uzun süre işgal edilir. Bu durum eşzamanlı yük altında havuzun hızlı bir şekilde tükenmesine (connection starvation) yol açabilir.
* **En İyi Pratik (Mitigation):** Uygulama katmanında işlem sürelerini (holding time) milisaniyeler düzeyinde tutmak için veritabanı dışı işlemler (ağ çağrıları, ağır serileştirmeler) asla DB transaction bloğu içerisine alınmamalıdır. PgBouncer'ın transaction modunda `query_timeout` parametresi agresif bir şekilde (örneğin 30-120 saniye arasında) ayarlanarak tıkanmalar önlenmelidir.

---

## 2. Değiştirilemez Denetim İzi (Immutable Audit Trail) Mimarileri

SaaS uygulamalarında denetçilerin ve uyumluluk (compliance) kurallarının (SOC 2, ISO 27001, HIPAA) en kritik taleplerinden biri, denetim kayıtlarının **geriye dönük değiştirilemez (immutable)** ve **silinemez** olmasıdır. Endüstride bu amaca ulaşmak için 4 temel yaklaşım uygulanır:

| Yaklaşım | Mekanizma | Artıları | Eksileri | Performans Etkisi |
| :--- | :--- | :--- | :--- | :--- |
| **pgAudit Uzantısı** | PostgreSQL motoruna entegre DDL/DML loglama uzantısı. Doğrudan sistem log dosyalarına (`logging_collector`) yazar. | • Uygulama kodundan bağımsızdır.<br>• SELECT (okuma) sorgularını da loglar.<br>• Bypass edilemez. | • Veritabanı disk I/O'sunu çok artırır.<br>• Logları sorgulamak için harici log toplayıcı (Elastic, Loki) gerekir. | Yüksek (Yoğun yazma yükü altında %15-%25 arası throughput kaybı). |
| **Uygulama Katmanı Çift Yazım (Double-Write)** | Uygulama ana veriyi DB'ye yazarken, denetim olayını asenkron olarak bir log akışına (Kafka, Kinesis, CloudWatch) gönderir. | • DB yükünü azaltır.<br>• Zengin uygulama bağlamı (HTTP header, IP, istek ID) içerir.<br>• Kolay ölçeklenir. | • **Dual-write problemi:** Ana DB yazımı başarılı olup log akışı başarısız olabilir (veya tam tersi).<br>• DB'ye doğrudan erişimleri (migration vb.) yakalayamaz. | Düşük (Asenkron kuyruklar sayesinde DB üzerinde doğrudan yük oluşturmaz). |
| **DB Triggers ve Denetim Tabloları** | Her tabloda `AFTER INSERT/UPDATE/DELETE` tetikleyicileriyle değişiklikleri bir `audit_logs` tablosuna yazar. | • Veritabanı düzeyinde kesindir.<br>• Eski/Yeni veri farkını (JSONB diff) kolayca çıkarır. | • Salt-okunur (SELECT) işlemlerini yakalayamaz.<br>• DB depolama alanını hızla büyütür.<br>• Tablo kilit sürelerini uzatır. | Orta (%5-%10 arası yazma gecikmesi). |
| **WAL tabanlı CDC (Debezium / pg_recvlogical)** | PostgreSQL Write-Ahead Log (WAL) değişikliklerini asenkron okuyup dışarı aktarır. | • Veritabanı motoruna sıfır etki eder.<br>• Bypass edilemez ve asenkrondur. | • SELECT sorgularını yakalayamaz.<br>• Mimari kurulum ve bakım maliyeti yüksektir. | Çok Düşük (Sıfıra yakın performans kaybı). |

### SaaS Sektör Uygulaması (Fiili Durum)
Modern SaaS mimarilerinde genellikle **Karma Model** tercih edilir:
1. **İdari Değişiklikler ve Okuma Denetimi (Read Auditing):** pgAudit uzantısı sadece kritik tablolardaki (yetki, bütçe zarfları, finansal kayıtlar) `SELECT` ve `ROLE` işlemlerini takip edecek şekilde dar bir kapsamda açılır.
2. **Veri Değişiklikleri (DML):** Değiştirilemezlik (immutability) garantisi sağlamak için veritabanı logları (`logging_collector` ile diske yazılan dosyalar) anlık olarak AWS S3 Glacier veya Google Cloud Storage (Object Lock/WORM etkinleştirilmiş kovalara) stream edilir. Bu sayede veritabanı yöneticisi (superuser) dahi DB'yi hacklese bile harici depolama alanındaki denetim izini silemez.

---

## 3. FORCE RLS ve BYPASSRLS Rol Hijyeni

PostgreSQL'de RLS politikasının güvenle çalışabilmesi için rollerin ve tablo sahipliklerinin (ownership) çok sıkı bir disiplinle yönetilmesi gerekir. Bu konuda sıkça düşülen "güvenlik açığı" tuzakları ve endüstri standartları şunlardır:

### Tablo Sahibi (Table Owner) ve Superuser İstisnaları
* **Varsayılan Davranış:** RLS etkinleştirilmiş bir tabloda (`ENABLE ROW LEVEL SECURITY`), tablonun sahibi olan rol (tabloyu `CREATE TABLE` ile oluşturan veya migration koşturan kullanıcı) ve `superuser` statüsündeki tüm roller **politikalardan tamamen muaftır.** Bu roller sorgu gönderdiğinde RLS filtreleri devreye girmez ve tüm tabloyu görürler.
* **`FORCE ROW LEVEL SECURITY` Önemi:** Tablo sahibini de RLS politikalarına tabi tutmak için mutlaka `ALTER TABLE <tablo> FORCE ROW LEVEL SECURITY` komutu çalıştırılmalıdır. Bu komut, tablo sahibi olan uygulama rolünün kazara tüm tenant verilerini okumasını engeller.
* **Superuser Aşılmaz Sınırı:** Ancak `FORCE RLS` bile **superuser** rollerini veya `BYPASSRLS` özelliğine sahip rolleri kısıtlayamaz. Postgres felsefesinde superuser her türlü güvenlik engelini aşan mutlak bir güçtür.

### Rol Hijyeni Standardı (Migration vs Runtime Ayrımı)
Endüstride kabul görmüş en güvenli tasarım, veritabanı erişiminde rolleri katı bir şekilde ayırmaktır:

1. **`ddl_owner_role` (Yalnızca Şema Yönetimi):**
   * Tabloları oluşturur, şema göçlerini (migration) yönetir.
   * Uygulamanın çalışma zamanında (runtime) bu rol üzerinden bağlantı kurulması **kesinlikle yasaktır.**
   
2. **`app_runtime_role` (Çalışma Zamanı Uygulama Rolü):**
   * Tabloların sahibi değildir; sadece tablolarda DML (CRUD) yetkilerine (`GRANT SELECT, INSERT, UPDATE, DELETE`) sahiptir.
   * `NOINHERIT` özelliğiyle oluşturulur ve kesinlikle `superuser` veya `BYPASSRLS` yetkileri verilmez.
   * Tablo sahibi olmadığı için, `FORCE RLS` etkin olmasa bile varsayılan olarak RLS politikalarına katı bir şekilde uymak zorundadır. RLS'in "fail-closed" çalışmasını garanti eden ana unsur bu rol tasarımıdır.

---

## 4. Operatör/Yönetici Erişim Hijyeni (Break-Glass / Impersonate)

SaaS platformlarında müşteri desteği, sistem bakımı veya teknik sorunların çözümü için operasyon personelinin (operatörler) müşteri verilerine erişmesi kaçınılmazdır. Bu erişimlerin RLS sınırları içinde ve sıkı bir denetimle yapılması gerekir:

### 1. Uygulama Katmanı Kimlik Bürünme (Impersonation / Assumed Role)
* **Yöntem:** Operatör veritabanına doğrudan bağlanmaz. Uygulama kontrol paneli üzerinden "X kiracısına bürün" (impersonate) talebinde bulunur.
* **Güvenlik Akışı:** Uygulama katmanı operatörün bu yetkisini onaylar, arka planda kısa ömürlü bir JWT üretir. Veritabanı katmanında yine standart `app_runtime_role` kullanılır ve işlem başlatılarak `SET LOCAL app.current_tenant_id = 'hedef-kiraci-id'` atanır.
* **Denetim:** Operatörün kimliği uygulama loglarında "Operator [A] assumed Tenant [X] with Reason: [Ticket #123]" şeklinde asenkron denetim izine (audit log) yazılır. Veritabanı sadece standart bir kiracı işlemi görür.

### 2. Çift Anahtarlı / İki Faktörlü Veritabanı Erişimi (Break-Glass)
* **Yöntem:** Acil altyapı müdahalelerinde doğrudan DB seviyesinde sorgu çalıştırılması gerektiğinde uygulanır.
* **Güvenlik Akışı:**
   * Operatörün doğrudan `BYPASSRLS` veya `superuser` şifrelerine sahip olması yasaktır.
   * Acil durumda, HashiCorp Vault veya AWS Secrets Manager gibi gizli anahtar yönetim sistemlerinden **geçici ve süreli (TTL - örn. 1 saat geçerli) veritabanı kimlik bilgileri** talep edilir.
   * Bu talep anında Slack/PagerDuty üzerinden alarm üretir ve onay mekanizmasını tetikler.
   * Alınan geçici rol, RLS'i bypass edebilen ancak her adımı `pgaudit` tarafından izlenen ve doğrudan immutable audit log depolarına akan bir yapıya sahiptir.

---

## Sonuç ve CollMind RLS Yol Haritası Entegrasyonu

Bu bulgular ışığında, CollMind TPM projesinin **önümüzdeki iki haftalık** geliştirme takviminde yer alan belgeler ve kararlar için şu tasarım girdileri önerilmektedir:

1. **FORCE RLS Uygulaması:** Migration script'lerinizin (şema sahipliği `ddl_owner_role` üzerinde olsa bile) her yeni kiracı tablosu oluşturulduğunda otomatik olarak hem `ENABLE ROW LEVEL SECURITY` hem de `FORCE ROW LEVEL SECURITY` komutlarını çalıştırması garanti edilmelidir.
2. **K1b Denetim-İzi Tasarımı Girdisi:** pgAudit'in tüm SELECT sorgularını loglamasının getireceği %15+ performans maliyeti göz önüne alınarak; **Karma Model** tercih edilmeli, kritik bütçe ve finans tablolarında DB seviyesinde asenkron WORM (Glacier) loglama yapılırken, genel operasyonel loglar uygulama katmanı asenkron çift-yazımı ile çözülmelidir.
3. **Rol Ayrımı (BYPASSRLS Hijyeni):** Uygulamanın veri tabanına bağlandığı TypeORM havuz rolünün `BYPASSRLS` içermediği bir entegrasyon testiyle (CI pipeline içinde pgTAP veya benzeri bir probe ile) sürekli doğrulanmalıdır.

---
*Araştırma Tarihi: 28 Ağustos 2026*