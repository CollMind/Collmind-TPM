# Bildirim Dilimi + Auth Standardı Adresi — Dağıtım Bloğu

> **Tarih:** 2026-08-22 · **Hazırlayan:** Fable · **Onay:** ürün sahibi (bu oturum)
> **Yürüten:** Team Lead — iki karar, tek kayıt; FAZ1_PLAN §11'in iki öneri kalemi
> karar statüsüne terfi ediyor.

---

## KAYIT · Karar defterine

```
KARAR — BİLDİRİM DİLİMİ + AUTH STANDARDI ADRESİ (2026-08-22, ürün sahibi)

── 1 · BİLDİRİM DİLİMİ: Faz 1'e girer — DAR dilimle ──

Soru "yapılsın mı" değildi; üç yürürlük kuralı (K-2.2.7b %90 finans
bildirimi · K-2.5.10 7/14 hatırlatma · %80 eşik uyarısı) var olmayan bir
uca yazıyordu. Karar, dilimin enidir:

DİLİMDE:
  1  Olay üretimi — bildirim bir TABLO kaydıdır
     (kime · olay türü · bağlam ref · okundu mu); kanaldan bağımsız,
     denetlenebilir, test edilebilir
  2  Tek kanal: uygulama-içi — notifications yüzeyi T-249/T-275'te
     güvenlik katmanından geçti; bu bir ekleme değil, besleme
  3  Üç olay türü: eşik-%80 uyarı · eşik-%90 finans bildirimi ·
     onay-hatırlatma (7/14) — yalnız yürürlük kurallarının yazdıkları

BİLİNÇLİ DIŞARIDA (gerekçeli):
  · e-posta kanalı — teslimat/konfigürasyon sınıfı, deploy'suz ortamda
    test edilemez; Faz 4 kurulum paketine komşu
  · K-2.10 tam olay listesi — sözlük ölçümü (Adım 6) belirler; üç türle
    başlamak sözlüğün "ayrı tür ölçütü"nü canlı test eder
  · bildirim tercihleri — K-2.10.2 kapıyı zaten kapatıyor
    (kanal olay türüne göredir, kullanıcı tercihine göre değil)

YERLEŞİM: B4 sonrası, RLS öncesi küçük kalem. Gerekçe: 7/14 hatırlatması
zamanlayıcının ilk gerçek işi olacak; bildirim tablosu ondan önce var
olursa zamanlayıcı×kiracı tasarımı (Adım 5 kesişim kalemi) somut bir iş
üstünde yapılır, soyut değil.

KABUL PİNİ (K-2.2.7b'nin fiilî yürürlük anı):
  zarf %90'ı geçer → FINANCE kullanıcılarına bildirim satırı düşer
  %89'da düşmez — iki girdi, iki çıktı.

── 2 · AUTH STANDARDI: tek sayfa, docs/process/AUTH_STANDARDI.md ──

Belge bugün NE VARSA onu kayda alır, ne olması gerektiğini değil —
mevcut zincir ölçüldü ve çalışıyor; sorun davranışta değil adressizlikte.
Dört blok:

  1  KİMLİK ZİNCİRİ   login → JWT → req.user.sub · refresh · logout
                      (SELF ölçüm turunun bulguları buraya taşınır)
  2  KURAL BAĞLARI    auth'a yaslanan K-kuralları: SoD kimlik
                      karşılaştırmaları · SELF yüklemi · denetim "kim"
                      alanı — L2'deki "kimlik doğrulama standardına ait"
                      işareti BU dosyaya bağlanır (dış denetim tamlık
                      bulgusu kapanır)
  3  BİLİNÇLİ AÇIKLAR parola politikası · oturum süresi · MFA —
                      statüleri "yok" DEĞİL "karar verilmedi";
                      ilk-deploy ön koşulları listesine bağlı
  4  DEĞİŞİM KURALI   bu dosyaya dokunmadan auth davranışı
                      değiştirilemez (tel-protokol dersinin auth hali)

Yazım: Team Lead, tek tur derleme — içeriğin yarısı SELF ölçümlerinde
zaten üretildi.
```

## DAĞITIM LİSTESİ (Team Lead)

1. KAYIT → karar defterine (append)
2. `FAZ1_PLAN` §11: iki satır öneri statüsünden çıkar — bildirim kalemi
   yerleşimiyle (B4-sonrası) plana; auth-adresi "derleme turu açıldı" notuyla
3. `AUTH_STANDARDI.md` derleme turu — SELF ölçüm raporu girdi
4. Hatlar bloğu `faz-1 / güvenlik` satırı güncellenir
5. Doğrulama: guard yeşil + push kanıtı (`git log origin`) görülmeden "bitti" yazılmaz
