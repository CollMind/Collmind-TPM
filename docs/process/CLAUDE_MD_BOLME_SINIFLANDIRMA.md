# `CLAUDE.md` BÖLME — TAM SINIFLANDIRMA

> Eki: [`CLAUDE_MD_BOLME_PLANI.md`](CLAUDE_MD_BOLME_PLANI.md)
> **Liste, sayı değil.** ⚠️ Bu ek bölme İNDİKTEN SONRA gerçekten üretildi —
> ilk hâli plandan türetilmişti ve `6` satırda YANLIŞTI (`code-reviewer` `S3`).
> Turnusol: *"bu satırı okumayan bir ajan İLK MESAJINDA yanlış davranır mı?"*

## ÇEKİRDEK — `CLAUDE.md` (26 başlık)

| # | başlık |
|---|---|
| 1 | CollMind — Team Lead & Orkestrasyon Talimatları |
| 2 | 0. Her Oturum Başında (ZORUNLU) |
| 3 | 1. Proje Haritası |
| 4 | Ürün konumu / TTM ilişkisi (ZORUNLU) |
| 5 | 2. Domain Kuralları — kaynak hiyerarşisi |
| 6 | 2.1 Bağlayıcı kaynaklar (öncelik sırasıyla) |
| 7 | ⛔ BRD v2.0 DONMUŞTUR (2026-08-15) — kayıtsız düzenleme yasak (ZORUNLU) |
| 8 | 2.1.1 BRD PDF'leri artık OKUNABİLİR — ve hangisine baktığını yaz (ZORUNLU) |
| 9 | 2.1.2 Bağlayıcı kaynak bir GİRDİ'dir, kanıt değil (ZORUNLU) |
| 10 | 2.2 `.cursor/rules.md` hakkında uyarı (ZORUNLU) |
| 11 | 2.3 Özet hatırlatmalar (normatif DEĞİL — doğrulamadan uygulama) |
| 12 | 2.4 Belirsizlikte DUR (ZORUNLU — her ajan için geçerli) |
| 13 | 2.5 Sessiz sıfır yasağı (ZORUNLU) |
| 14 | 2.6 Exit kodunu boruya sokma (ZORUNLU — ölçüm disiplini) |
| 15 | 2.7 Kanıt kurulumu ölçtüğün durumu değiştirmesin (ZORUNLU — ölçüm disiplini) |
| 16 | 3. Ekip (subagent'lar — `.claude/agents/`) |
| 17 | 4. Yeni Görev Akışı (ZORUNLU — tekrarı önler) |
| 18 | ⛔ `touches:` KESİŞİMİ GEREKLİ AMA YETERLİ DEĞİL — ağaç PAYLAŞILIR (ZORUNLU) |
| 19 | 4.1 Delegasyonda bağlam sadakati (ZORUNLU) |
| 20 | 4.2 "Done" tanımı (ZORUNLU — hepsi sağlanmadan `done` yazılmaz) |
| 21 | 5. Git / Bitbucket Workflow |
| 22 | Doküman yeri (ZORUNLU) |
| 23 | Branch & Release Modeli (ZORUNLU — her üç repoda) |
| 24 | 6. Tipik Orkestrasyon Zincirleri |
| 25 | 7. Yeni kod yazmadan önce ara (ZORUNLU) |
| 26 | 7.1 Düzeltmeden önce say (ZORUNLU) |

## DİSİPLİN — `docs/DISIPLIN.md` (63 kural, 6 aile)

| # | kural | aile |
|---|---|---|
| 1 | Ve yokluk iddiası için üçüncü soru: HANGİ BÖLÜM (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 2 | Negatif sonuçlu tarama, POZİTİF KONTROLSÜZ rapor edilemez (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 3 | Kapsam maskelemesi — desen çalışır, EVREN eksiktir (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 4 | Bir TANIMIN evreni, tanımın ŞARTIYLA seçilemez (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 5 | Arama terimi, ARANAN YERİN DİLİYLE seçilir (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 6 | Bir VARLIĞIN yokluğunu sorarken, TANIMININ yaşadığı yüzeyde ara (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 7 | ENJEKSİYON kullanım değildir — ailenin üçüncü yüzü (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 8 | ⚠️ VE SIKLIK — bu kural bir REFLEKS üretmiyor, bir KONTROL üretiyor | ARAMA UZAYI ve NEGATİF KANIT |
| 9 | ⛔ VE DÖRDÜNCÜ VAKA KURALI GENİŞLETTİ — soru TABLO'ysa, terim de TABLO olmalı | ARAMA UZAYI ve NEGATİF KANIT |
| 10 | `@deprecated` bir NİYET BEYANIDIR, bir ölçüm değil (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 11 | ⚠️ VE SIKLIK BİR DESEN — `500` bu kod tabanında YAYGIN BİR ÖRTÜ | ARAMA UZAYI ve NEGATİF KANIT |
| 12 | Bir SAYI, eşleşmeleri ÖRNEKLENMEDEN raporlanamaz (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 13 | Bir SAYIM FARKI, farkın KAYNAĞI gösterilmeden yorumlanamaz (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 14 | `LEFT JOIN` + `IS NULL` bir YOKLUK testi DEĞİLDİR (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 15 | "Sekiz vaka" gibi bir sayı, LİSTESİYLE anılır ya da HİÇ anılmaz (ZORUNLU) | ARAMA UZAYI ve NEGATİF KANIT |
| 16 | Yazma ile commit arasına bir DOĞRULAMA koy (ZORUNLU) | KAPI ve GUARD YAZIMI |
| 17 | Doğrulama bir KAPIDIR — durdurmuyorsa doğrulama değildir (ZORUNLU) | KAPI ve GUARD YAZIMI |
| 18 | Bir KAPI, ölçümün BAŞARISINI hata sayamaz (ZORUNLU) | KAPI ve GUARD YAZIMI |
| 19 | Yan etkisi olan bir aracı İZOLE hedefte sına (ZORUNLU) | KAPI ve GUARD YAZIMI |
| 20 | DÖRDÜNCÜ SORU — kontrolün girdisi, kontrol ettiği şeyden mi türüyor? (ZORUNLU) | KAPI ve GUARD YAZIMI |
| 21 | DOSYA SINIRI, STATE SIFIRLAMA NOKTASIDIR (ZORUNLU — guard yazımı) | KAPI ve GUARD YAZIMI |
| 22 | Bir kusur, BAŞKA bir kusur tarafından örtülebilir (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 23 | YORUM KİRLİLİĞİ iki yönde birden yanıltır (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 24 | Kod yorumunda "ulaşılamaz" yazmadan önce ölç (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 25 | Bir kuralı yazdığın tur, o kuralı en çok ihlal ettiğin turdur (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 26 | BİLEŞİMSEL FAIL-OPEN — her parça masum, boşluk BİLEŞİMDE (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 27 | Bir doğrulamanın "çalıştığı" sanılması, girdinin ona hiç ULAŞMAMASINDAN gelebilir (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 28 | "Güvenlik" gerekçeleri en az sorgulananlardır (ZORUNLU) | GİZLENEN KUSUR SINIFLARI |
| 29 | Bir SIRA şartı, AYRILABİLİRLİK şartı İÇERMEZ (ZORUNLU) | ŞART · SINIR · KAYIT |
| 30 | Bir DUR listesi, değişikliğin geçtiği HER SINIRI saymalıdır (ZORUNLU) | ŞART · SINIR · KAYIT |
| 31 | Bir kuralın FAZ TABLOSU varsa, YÜRÜRLÜKTEKİ satır okunur (ZORUNLU) | ŞART · SINIR · KAYIT |
| 32 | Karşılanamayan bir ÖLÇÜT revize edilir — uydurma veriyle karşılanmaz (ZORUNLU) | ŞART · SINIR · KAYIT |
| 33 | Bir şartın SAĞLAYICISI yoksa, şart bir erteleme değil bir KİLİTTİR (ZORUNLU) | ŞART · SINIR · KAYIT |
| 34 | Bir KABUL LİSTESİ, değişikliğin BOZABİLECEĞİNİ de saymalıdır (ZORUNLU) | ŞART · SINIR · KAYIT |
| 35 | Bilinen eksiklik TODO ile değil, TASK ile kaydedilir (ZORUNLU) | ŞART · SINIR · KAYIT |
| 36 | Bir Z-KAYDINI kapatan tur, TÜREV BELGELERİ de yazar (ZORUNLU) | ŞART · SINIR · KAYIT |
| 37 | MEKANİK olarak türetilmiş bir değer, GEREKÇE değildir (ZORUNLU) | SAYI · LİSTE · KANIT |
| 38 | Bir TOPLAMIN azalması, bir SINIFIN girmediğinin kanıtı değildir (ZORUNLU) | SAYI · LİSTE · KANIT |
| 39 | Bir yazma işleminin DÖNÜŞ DEĞERİ, yazdığının kanıtı değildir (ZORUNLU) | SAYI · LİSTE · KANIT |
| 40 | Boş gelen bir çıktı, BEKLENEN içerikle doldurulamaz (ZORUNLU) | SAYI · LİSTE · KANIT |
| 41 | ⇒ VE ÖLÇÜM TARAFINDA AYNI ŞEKİL: eşitlik, VARLIĞIN kanıtı değildir (ZORUNLU) | SAYI · LİSTE · KANIT |
| 42 | KANIT RENGİN KENDİSİ DEĞİL, RENGİN SEBEBİDİR (ZORUNLU) | SAYI · LİSTE · KANIT |
| 43 | EN İYİ KONTROL, BAĞIMSIZ BİR KAYITLA ÇAKIŞTIRMADIR (ZORUNLU) | SAYI · LİSTE · KANIT |
| 44 | Elle yazılmış üye-sayısı: ölçülmüş oran DOKUZDA DOKUZ (ZORUNLU) | SAYI · LİSTE · KANIT |
| 45 | Dokümanda sayı yazma — niteliksel ayırt edici yaz (ZORUNLU) | SAYI · LİSTE · KANIT |
| 46 | Beklenen YÖNE yanılan bir hata, ters yöne yanılandan TEHLİKELİDİR (ZORUNLU) | SAYI · LİSTE · KANIT |
| 47 | Test dosyası TASK NUMARASI değil SÖZLEŞME ADI taşır (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 48 | Bir AD, koruduğu SINIFTAN dar olabilir (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 49 | Bir DÜZELTME, düzelttiği SINIFIN yeni bir vakasını üretebilir (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 50 | Bir DÜZELTME de bir iddiadır (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 51 | Bir düzeltmenin iki ekseni vardır: HEDEFİ ve YÖNÜ (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 52 | Ölçüm ortamının bayatlığı da bir maskeleme sınıfıdır (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 53 | BAYAT SÜREÇ BİRİKİR — ve ölçümü ARALIKLI bozar (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 54 | Testler bir ŞARTNAMEDİR — kod silinse bile (ZORUNLU, ve bir kurtarmayla ölçüldü) | DÜZELTME · PORT · BAYATLIK |
| 55 | Bir şema kararını geri alırken entity metadata'sını da geri al (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 56 | Fixture, ayırt etmek istediği iki tarafta FARKLI değer taşımalı (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 57 | Port ederken: davranış taşınır, onu DOĞRU KILAN BAĞLAM taşınmaz (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 58 | Bir ÖLÇÜMÜN geçerliliği de koşullarına bağlıdır — koşulu ölçümle birlikte yaz (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 59 | Bir CACHE İNVALİDASYONU yazıldığında çağıranı AYNI TURDA bağlanır (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 60 | `new Date(kullanıcıGirdisi)` — beş sessiz hata biçimi, hepsi ölçüldü (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
| 61 | Sessiz VARSAYILAN ile sessiz FALLBACK aynı şey değildir (ZORUNLU — §2.5'in sınırı) | DÜZELTME · PORT · BAYATLIK |
| 62 | ⚠️ AMA fallback'in meşruiyeti dar: birincil kaynak GERÇEKTEN okunamıyor olmalı | DÜZELTME · PORT · BAYATLIK |
| 63 | Assert taşıyan migration ÜÇ durumu ayırt etmeli (ZORUNLU) | DÜZELTME · PORT · BAYATLIK |
