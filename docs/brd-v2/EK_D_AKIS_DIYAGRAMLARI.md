# BRD v2.0 — Ek D · Akış Diyagramları

> `L1`'in metinle anlattığı üç yapının görsel karşılığı. **Kural içermez** — her diyagram
> dayandığı `L2` kuralına atıf verir.
>
> Diyagramlar metin biçiminde tutuluyor: sürüm kontrolünde okunabilir, ve bir kural
> değiştiğinde diyagramın hangi kısmının etkilendiği aranabilir.

- **Sürüm:** taslak, 2026-08-12

---

# D.1 · Değer zinciri

```
   BÜTÇE                PLAN               ONAY            ANLAŞMA
     │                    │                  │                │
     │  zarf tanımlanır   │                  │                │
     ├───── TAHSİS ──────►│                  │                │
     │                    │  hacim + taktik  │                │
     │                    ├─────────────────►│                │
     │                    │                  │  onaylandı     │
     │◄──── TAAHHÜT ──────┼──────────────────┤                │
     │                    │                  ├───────────────►│
     │                    │                  │                │
     │◄──── REZERVE ──────┼──────────────────┼────────────────┤
     │                    │                  │                │
     │                                                        │
     │            GERÇEKLEŞEN              HAKEDİŞ            │
     │                 │                      │               │
     │                 │  satış + fatura      │               │
     │                 ├─────────────────────►│               │
     │                 │                      │               │
     │◄──── TÜKETİM ───┴──────────────────────┤               │
     │                                        │               │
     │                                    KAPANIŞ             │
     │◄──── İADE ─────────────────────────────┤◄──────────────┘
     │                                    (kalan bakiye)
```

**Okuma notu:** her ok bir **defter kaydıdır.** Zincirin hiçbir adımı izsiz geçemez
(`K-2.13.2`).

⚠️ **Ve bir asimetri:** bütçe eşikleri yalnız `TAAHHÜT` ve `REZERVE` oklarını durdurabilir.
`TÜKETİM` oku hiçbir eşiğe takılmaz — borç doğmuştur (`K-2.2.7c`).

---

# D.2 · Plan onay durum makinesi

```
                    ┌─────────┐
                    │ TASLAK  │◄──────────────┐
                    └────┬────┘               │
                         │ gönder             │ düzenle
                         ▼                    │
              ┌──────────────────┐            │
              │  ONAY BEKLİYOR   │            │
              └─────┬───────┬────┘            │
                    │       │                 │
         onayla     │       │  reddet         │
                    ▼       ▼                 │
         ┌───────────┐   ┌─────────────┐      │
         │ ONAYLANDI │   │ REDDEDİLDİ  ├──────┘
         └─────┬─────┘   └─────────────┘
               │
               │ anlaşmaya dönüşür
               ▼
         ┌───────────┐
         │  ANLAŞMA  │
         └───────────┘

    ⛔ Faz 2:  ONAY BEKLİYOR ──(süre dolumu)──► SÜRESİ DOLDU ──► yeniden gönderilebilir
```

## Geçiş kuralları

| Geçiş | Kural |
|---|---|
| `TASLAK → ONAY BEKLİYOR` | Harcama kolonları hesaplanmış olmalı — bayat veriyle gönderilemez |
| `ONAY BEKLİYOR → TASLAK` | ❌ **doğrudan yasak** (`K-2.5.4`) |
| `ONAY BEKLİYOR → ONAYLANDI` | ⚠️ Bütçe rezervasyonu **aynı işlemde** yazılır (`K-2.5.6`) |
| `→ REDDEDİLDİ` | Rezervasyon **aynı işlemde** iade edilir (`K-2.5.7`) |
| `REDDEDİLDİ → TASLAK` | Sınırsız döngü (`K-2.5.5`) |

⚠️ **Onaylayan kısıtı:** gönderen ∪ içeriği son değiştiren **onaylayamaz** — ve kural
**kişiye bakar, role değil** (`K-2.5.11`, `K-2.6.5c`).

⛔ **Faz 1'de otomatik süre dolumu yok** — yalnız bildirim (7. gün hatırlatma, 14. gün
yönetici bildirimi). Otomatik yükseltme **reddedildi** (`K-2.5.10c`).

---

# D.3 · Bütçe kovaları ve eşikler

```
  ┌──────────────────────── AYRILAN ─────────────────────────┐
  │                                                          │
  │  ┌─────────┐   ┌──────────┐   ┌───────────┐              │
  │  │ REZERVE │   │ TAAHHÜT  │   │ TÜKETİLEN │  KULLANILABİLİR
  │  │(anlaşma)│   │  (plan)  │   │(gerçekleşen)│             │
  │  └─────────┘   └──────────┘   └───────────┘              │
  │                                                          │
  └──────────────────────────────────────────────────────────┘

  Kullanılabilir = Ayrılan − Rezerve − Taahhüt − Tüketilen
```

⚠️ `REZERVE` ve `TAAHHÜT` **ayrı kovalardır** ve birleştirilemez (`K-2.2.6`).

## İki merdiven

```
  DAVRANIŞ                          RENK (yalnız görünüm)
  ────────                          ─────────────────────
  %80   uyarı, işlem devam          < 80    yeşil
  %90   finans bildirimi ⚙          80–95   sarı
  %100  BLOK ⛔                      > 95    kırmızı

  ⚙ konfigürasyon: BİLDİRİM | ONAY — varsayılan BİLDİRİM
```

⚠️ **Karıştırılmaz.** `%95` bir **görüntü** sınırıdır; davranış merdiveninde yeri yoktur
(`K-2.2.7`).

## Blok ve kaçış yolları

```
       plan gönderimi                    plan onayı
            │                                 │
            ▼                                 ▼
     ┌─────────────┐                   ┌─────────────┐
     │ erken uyarı │                   │ OTORİTE     │  ← rezervasyon burada yazılır
     └──────┬──────┘                   └──────┬──────┘     kontrol atomik
            │                                 │
            └────── aynı hesap yolu ──────────┘            K-2.2.9g

     %100'de:  ⛔ BLOK — istisnasız, override yolu YOK

     Meşru kaçışlar:
       ├─ zarf revizyonu   finans zarfı büyütür        (denetlenebilir)
       └─ TRANSFER         başka zarftan aktarır        Σ(bacaklar) = 0
```

⚠️ Transfer, kaynak zarfın **kullanılabilir** tutarını aşamaz — aksi hâlde bloğu arkadan
dolanır (`K-2.2.9m`).

---

# D.4 · Hakediş zinciri

```
   BİZ                                          KARŞI TARAF
    │                                                │
    │  kanıt merdiveni                               │  kesinti belgesi
    │  ├─ GÖZLENEN      fatura satırından            │
    │  ├─ TÜRETİLEBİLİR oran × hacim                 │
    │  └─ SÖZLEŞMESEL   koşul sağlandıysa            │
    │                                                │
    ▼                                                ▼
 ┌─────────────┐                              ┌─────────────┐
 │ İÇ TALEP    │                              │ DIŞ TALEP   │
 │ ÜRETİLDİ    │                              │ ALINDI      │
 └──────┬──────┘                              └──────┬──────┘
        │                                            │
        └──────────────┐              ┌──────────────┘
                       ▼              ▼
                  ┌─────────────────────┐
                  │    EŞLEŞTİRME       │
                  │                     │
                  │  1  referans var mı? │──► doğrudan
                  │  2  grain eşleşmesi  │──► aday kümesi
                  │  3  eşleşmeyen       │──► KUYRUK
                  └──────────┬──────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
        tek aday +                    çok aday veya
        tolerans içi                  tolerans dışı
              │                             │
              ▼                             ▼
      ┌──────────────┐            ┌──────────────────┐
      │  OTOMATİK    │            │  İNSAN KARARI    │
      │  EŞLEŞTİ     │            │  (adaylarla)     │
      └──────┬───────┘            └────────┬─────────┘
             │                             │
             └──────────┬──────────────────┘
                        ▼
                 ┌─────────────┐
                 │  MUTABAKAT  │  fark sınıfı: ZAMANLAMA | TUTAR | KAPSAM
                 └──────┬──────┘
                        │
                        ▼
                 ┌─────────────┐
                 │   KAPANIŞ   │
                 └─────────────┘
```

## Üç kritik kural

⚠️ **Gerçekleşme kanıttan gelir, talepten değil.** Dış talep bir **doğrulamadır**
(`K-2.13.14e`).

⚠️ **Otomatik kesinleşme tekillik ister.** Birden çok aday varsa sistem seçim yapmaz —
*yanlış eşleşme, eşleşmemekten pahalıdır* (`K-2.13.12d`).

⚠️ **Açıklanamayan kalıntı dağıtılmaz.** Açık bir `FARK` kalemi olarak kalır:

```
Σ(taktik gerçekleşmeleri) + FARK = dış talep tutarı
```

## Tahakkuk — ara dönem çıktısı

```
  Ay 1 ──► TAHAKKUK ──┐
  Ay 2 ──► TAHAKKUK ──┼──► dönem sonu ──► İÇ TALEP ──► eşleştirme
  Ay 3 ──► TAHAKKUK ──┘                       │
                                              ▼
                                    kapanışta çözülür:
                                    eşleşen → TÜKETİM
                                    fazla   → İADE

                                    Invariant: açık tahakkuk = 0
```

⚠️ **Ayrı bir tahakkuk formülü yoktur** — aynı kanıt merdiveni, ara dönemde tahakkuk, dönem
sonunda talep üretir. **Tek hesap yolu, iki çıktı tipi** (`K-2.13.25d`).

---

# D.5 · Planlama miras zinciri

```
  FU: 500ml Şampuan
  ├── hacim  10.000          ◄── GİRİŞ BURADA
  └── taktik  %10 indirim    ◄── GİRİŞ BURADA
        │
        │  dağıtım (geçmiş hacim payı)      uygulama (kendi cirosu)
        ▼                                    ▼
  ┌──────────────────────────────────────────────────────────┐
  │  SKU A   pay %36  →  3.600      ciro × %10  →  harcama   │
  │  SKU B   pay %48  →  4.800      ciro × %10  →  harcama   │
  │  SKU C   ⚑ tarihsiz  →   0      elle girilir             │
  └──────────────────────────────────────────────────────────┘

  Invariant: Σ(SKU hacimleri) = FU hacmi
```

⚠️ **Yeni ürüne eşit pay verilmez** — lansman hacmi tarihsel bir türetme değil, **ticari bir
karardır.** Sessizce uydurulan eşit pay bir **sessiz tahmindir** (`K-2.1.8b`).

⚠️ **Miras görünürlüğü bir MVP şartıdır.** Kullanıcı dağılımı göremeden düzeltemez; göremezse
tabloya döner (`K-2.1.8i`).

**Elle düzeltme:** düzeltilen hücre kilitlenir, kalan miktar kalan SKU'lara yeniden dağıtılır.

---

# D.6 · Gösterge kapsama durumu

```
                    bağımlılıklar
                         │
              ┌──────────┴──────────┐
              │                     │
         hepsi çözüldü        kısmen çözüldü
              │                     │
              ▼                     ▼
      ┌───────────────┐    ┌──────────────────────┐
      │ TAM KAPSAMA   │    │  KISMİ KAPSAMA       │
      │               │    │                      │
      │ değer + renk  │    │  değer               │
      │ 🟢 🟡 🔴       │    │  + kapsama rozeti    │
      │               │    │  + eksik listesi     │
      │               │    │  ⬜ GRİ              │
      └───────────────┘    └──────────────────────┘
```

⚠️ **Kapsama eşiği yoktur.** Kısmi kapsama kısmi doğruluk değil, **bilinmeyen yönde
yanlılıktır** — maliyeti eksik ürünler sistematik olarak farklı marj taşır (`K-2.4.22`).

> **Renk bir güven beyanıdır, ve güven beyanı kısmi olamaz.**

**Invariant:** kapsama tam değilken tam-kapsama paleti **asla** kullanılamaz
(`K-2.4.22c`).

## Toplama

```
  Üst seviye oran = Σ(pay) ÷ Σ(payda)          ◄── alt oranların ortalaması DEĞİL

  Ve toplama, tüm bağımlılıkların çözüldüğü KESİŞİM üzerinden:
  bir öğenin bir bağımlılığı eksikse, o öğe hem paydan hem paydadan düşer
```

---

# D.7 · İçe aktarma akışı

```
   dosya
     │
     ▼
 ┌────────┐    ┌───────────┐    ┌──────────┐
 │ YÜKLE  │───►│ DOĞRULA   │───►│  ONAYLA  │
 └────────┘    └─────┬─────┘    └────┬─────┘
                     │                │
              satır bazında           │
                     │                ▼
      ┌──────────────┴───────┐   ┌─────────┐
      │                      │   │ YAZILDI │
      ▼                      ▼   └─────────┘
 ┌──────────┐         ┌──────────────┐
 │ GEÇERLİ  │         │  GEÇERSİZ    │
 │ → yazılır│         │  → raporlanır│
 └──────────┘         └──────────────┘
                              │
                    satır no · hata tipi
                    hata mesajı · ham satır

   ⛔ Dosyanın tümü yalnız HİÇBİR satır geçerli değilse reddedilir
```

## Çevrim — yalnız bu sınırda

```
   ham değer  ×  çevrim çarpanı  =  kanonik değer (adet)
      12              12                  144

   Üçü birlikte saklanır → denetlenebilir
```

⚠️ **Çekirdek tablolarda birim alanı yoktur.** *En iyi doğrulama, doğrulanacak alanın
olmamasıdır* (`K-2.1.12b`).

## Belirsizlik reddedilir

```
   1.234       ⛔ ondalık mı binlik mi?
   3/4/26      ⛔ 3 Nisan mı 4 Mart mı?
   1.234,56    ✅ açık
   2026-04-03  ✅ açık
```

> **Yanlış bir tahmin, doğru görünen yanlış bir değerdir.**

---

# Kaynak notu

Her diyagram `L2` kurallarının görsel özetidir; **hiçbiri yeni kural getirmez.**

| Diyagram | Dayandığı bölümler |
|---|---|
| D.1 değer zinciri | `2.2` · `2.3` · `2.13` |
| D.2 onay | `2.5` |
| D.3 bütçe | `2.2` |
| D.4 hakediş | `2.13` |
| D.5 planlama | `2.1` |
| D.6 gösterge | `2.4` |
| D.7 içe aktarma | `2.8` |

Bir kural değişirse ilgili diyagram **aynı turda** güncellenir. Diyagramın kuraldan sapması
bir kusurdur.
