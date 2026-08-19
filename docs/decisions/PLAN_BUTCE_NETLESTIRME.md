# Plan–Bütçe İlişkisi Netleştirmeleri — Dağıtım Bloğu

> **Tarih:** 2026-08-15 · **Hazırlayan:** Fable · **Yürüten:** Team Lead
> **Statü:** ürün sahibi onayladı (bu oturum) — dağıtım bekliyor
> **Bağlam:** `K-2.2.9i` ailesi ("onay bekleyen plan bütçe yazmaz") tartışıldı ve
> **korundu** — kilitleme/soft-reserve modeli reddedildi. Promosyon uzmanı görüşü
> (dayanak türü: *gözlem*) üç garantiyi zorunlu kıldı ve bir statü değişikliği getirdi.
> BRD v2.0 donmuş olduğundan bu blok, L2 değişikliklerini **açan karar kaydıdır**.

---

## KAYIT · Karar defterine

```
KARAR — PLAN–BÜTÇE NETLEŞTİRMELERİ (2026-08-15, ürün sahibi)

Çekirdek karar değişmedi: onay bekleyen plan deftere yazmaz; bütçeye dokunan
tek an onaydır (K-2.2.9i ailesi). Gönderim kontrolü bilgilendirici, onay
kontrolü atomik ve bağlayıcıdır. Kilitleme (gönderimde düşüm / soft-reserve)
reddedildi — gerekçe: onaysız eylem finansal davranış üretemez; yarışın
hakemi gönderim hızı değil, bütçe sahibinin onay sırasıdır.

Uzman itirazının kabul edilen çekirdeği: kilitlemesiz model, görünürlük
olmadan savunulamaz. Dört netleştirme:

1 · BEKLEYEN-TALEP GÖRÜNÜRLÜĞÜ: aday → ZORUNLU.
    Üç yüzey: (a) zarf görünümünde kalıcı "bekleyen talep" satırı
    (planlamacı planlarken görür), (b) gönderim anında çekişme uyarısı
    ("bu zarfa bakan N bekleyen plan, toplam talep X / kullanılabilir Y"),
    (c) onay kuyruğunda zarf bazlı toplam talep.
    Statü: gönderim kontrolünün implement edildiği dalganın ŞARTI —
    kontrol görünürlüksüz inemez.
    Değişmez sınır: bu bilgi hesaba, renge, blok mantığına asla girmez.

2 · TOPLU ONAY SEMANTİĞİ (yeni L2 kuralı):
    Toplu onay ayrı bir finansal işlem değildir; tekil onayların sıralı
    uygulamasıdır. Her tekil onay kendi atomik kullanılabilirlik
    kontrolünü taşır. Kısmi sonuç (N onaylandı · M reddedildi, sebepli)
    geçerli ve beklenen çıktıdır. YASAK: ön-kontrollü ya-hep-ya-hiç
    davranışı ve tek-kontrol-çok-yazım.
    UI kuralı: kuyruk toplamı kullanılabiliri aşıyorsa "tümünü onayla"
    ya sunulmaz ya "sığmayacak — sırayla değerlendirin" uyarısıyla sunulur.

3 · RAPOR İZOLASYONU (yeni L2 kuralı):
    Bekleyen talep hiçbir finansal raporda, yüzde hesabında veya dışa
    aktarımda kullanım rakamına dahil edilemez; yalnız açıkça "bekleyen
    talep" etiketli ayrı bilgi satırı olarak gösterilebilir.
    Guard adayı: rapor katmanında kuyruk-toplamına erişen kod yolu →
    uyarı (E ailesine; kapıya terfi kuralı gereği uyarı olarak başlar).

4 · NEGATİF-KULLANILABİLİRLİK İNVARIANTI:
    Hiçbir zarf negatif kullanılabilirliğe düşemez. Bu invariantın test
    altında olup olmadığı ÖLÇÜLMEDİ — Faz 1 Adım 2 ölçüm paketine 6.
    satır olarak girer: test varsa referansı kaydedilir, yoksa eklenir
    (B5 kararının 10-eşzamanlı-onay senaryosuyla aynı aile).

Kullanıcı diline çevirisi (UI/eğitim metinlerine esas):
"Gönderim bir taleptir, onay bir taahhüttür; para taahhütte ayrılır,
talepte görünür. Sıradaki herkes aynı bakiyeyi görür — bakiyeyi yalnız
onaylanan alır."

Gelecek seçenek (bugün YAPILMIYOR, kayıt için): pilotta kronik çekişme
kaosu ölçülürse "gönderim kontrolü: bilgilendirici | katı" bir tenant
politikası olarak eklenebilir. İlke 1: kanıt gelmeden eklenmez.
```

---

## DAĞITIM LİSTESİ (Team Lead — sıra önemli)

1. KAYIT → karar defterine (append)
2. **L2 yazımı** (yalnız Team Lead, tek kanal): 2. ve 3. maddeler yeni kural olarak;
   1. madde `K-2.2.9` ailesine ek fıkra; kural numaralarını Team Lead tahsis eder.
   Guard koşusu — sayım artışı beklenen ve meşru (dondurma sonrası ilk kayıtlı değişiklik)
3. **FAZ1_PLAN Adım 2'ye 6. ölçüm satırı:** negatif-kullanılabilirlik invariant
   testinin varlık teyidi
4. **Danışman paketi** henüz gönderilmediyse C setine soru: *"Gönderilen ama
   onaylanmamış talepler sahada bütçeyi fiilen 'tutar' mı; hangi model kaosa
   dönüşür?"* — gönderildiyse görüşme turu notlarına. Uzman görüşü ilk saha
   verisi olarak işlenir (dayanak: gözlem)
5. Doğrulama: guard yeşil + `git log origin` — push kanıtı görülmeden "bitti" yazılmaz
