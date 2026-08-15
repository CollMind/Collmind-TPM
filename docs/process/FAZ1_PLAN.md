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

Issue hazır (`_ISSUE_DB_ROLU.md`), hiç başlamadı `[ÖLÇÜLDÜ: 0071 §5]`. Çıktısı (izin
envanteri, `docs/verification/`) Adım 5'in girdisidir. Migration numarası Team Lead
tahsis eder (DUR-4).

## 4 · ADIM 2 — Ölçüm paketi (beş kalem, tek tur; inşa değil)

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

Kural: her sonuç **liste** olarak raporlanır; sayı tek başına dayanak değildir.

## 5 · ADIM 3 — `K-2.6.3` + `K-2.6.6` tek dalga (yetenek modeli + default-deny)

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
