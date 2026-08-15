# Faz 0 Kapanışı + BRD v2.0 Dondurma — Dağıtım Bloğu

> **Tarih:** 2026-08-15 · **Hazırlayan:** Fable · **Yürüten:** Team Lead
> **Statü:** ürün sahibi onayladı (bu oturum) — dağıtım bekliyor
> **Rev 2 (2026-08-15, dağıtım öncesi):** KAYIT 2'nin ileriye bakan tablosu bayattı —
> Adım 0'ın üç kalemi kapanmış, `K-2.6.13a` onaylanmıştı. Düzeltildi; bayat sürüm
> dağıtılmadı.
>
> İki kayıt + bir ek + bir doğrulama listesi. Metinler hedef dosyalara **aynen** taşınır;
> sayılar yeniden yazılmaz, kanıtlara atıf verilir.

---

## KAYIT 1 · Karar defterine — BRD v2.0 dondurma

```
KARAR — BRD v2.0 DONDURULDU (2026-08-15, ürün sahibi)

Kapsam: docs/brd-v2/ altındaki L0 · L1 · L2 · EK_A–EK_E paketi.
Kural sayısının kanonik kaynağı guard çıktısıdır (elle sayı yazılmaz).

Anlamı: yazma modu kapandı, bakım modu açıldı. Bu tarihten sonra pakette
hiçbir değişiklik doğrudan yapılmaz — her değişiklik önce karar defterine
kayıtla girer ve F12/0006-R deseniyle işlenir: eski kayıt silinmez,
"geri alındı / revize edildi (tarih, gerekçe)" iziyle üstüne yazılır.

Dondurma, açık madde yokluğu demek DEĞİLDİR. Açık kalanlar adreslidir ve
dondurmayı engellemez:
  · Hukuk-şartlı: K-2.9.0 (geçici askı) · K-2.9.6a · K-2.8.11/K-2.9.5/K-2.9.7
  · Ölçüm-şartlı: T-209 (discount_amount) · iade temsili · veri ayrımı modeli
  · Domain kuyruğu: F15 (dış talepte kategori) — ilk gerçek kesinti
    belgesiyle ya da danışman B-seti cevabıyla açılır

Sürüm işareti: git tag (brd-v2.0, annotated) — Team Lead atar ve origin'e
push'lar; tag push'u git log/ls-remote ile doğrulanır (rapor kanıt değildir).
```

## KAYIT 2 · Karar defterine — Faz 0 kapanışı

```
KAYIT — FAZ 0 KAPANDI (2026-08-15)

Üç çıkış ölçütü:
  1. Şema yeni modelle uyumlu — B dalgası: tek up/down, çıkarmalar dahil,
     seed atomik (kanıt: 0071 §1.1)
  2. Invariant/regresyon yeşil — 65/65 unit · 17/17 e2e · üç para baseline'ı
     kıpırdamadı (kanıt: 0071 §1.5)
  3. BRD v2.0 donduruldu — bu dağıtımın KAYIT 1'i

İNDİ ≠ KAPANDI — devredilenler bu kapanışın parçasıdır. Kanonik kaynak
0071 §1–§4 VE bu kayıt anındaki durum (0071'den sonra üç kalem kapandı):
  · T-212 KAPANDI — caaa6a5, dört kapı kırmızı-kanıtlı
  · T-113 KAPANDI — b0c8576, iki yönlü kanıt (yeni hata kırmızı ·
    baseline yeşil)
  · T-225 → pin KAPANDI — c671c22, beş dosya, üç dal ampirik
  · Hukuk paketi gönderimi AÇIK — DUR: muhatap kayıtta yok.
    Adım 0'ın tek kalan kalemi; muhatap tanımlanınca gönderilir
  · T-214 (Adım 3 ön kararı) · T-209/T-228/T-230 (kuyruk) ·
    K-2.9.0 askısı (hukuk dönüşüne dek)

Faz 1 durum anı (kapanış anında):
  Adım 0          3/4 kapandı — kalan: hukuk gönderimi (muhatap)
  Adım 1          K-2.6.13 BLOKLAYICISIZ — K-2.6.13a–f ve RLS sonda
                  kabul testi ONAYLANDI (ürün sahibi, 2026-08-15).
                  Başlayabilir.
  Adım 2          ölçüm paketi (5 ölçüm) — Adım 1 ile paralel
  Ürün sahibi     tek girdi: 0056-K3 (seed kararı) — Adım 3'ü bloklar,
                  Adım 1'i DEĞİL
  Dış kuyruk      hukuk paketi (muhatap bekliyor) · danışman turu
```

## EK · CLAUDE.md'ye tek kural

```
BRD v2.0 donmuştur (2026-08-15). docs/brd-v2/ altındaki hiçbir dosya,
karar defterinde o değişikliği açan bir kayıt olmadan düzenlenmez.
Dondurulmuş belgeye kayıtsız düzenleme, ölçülmüş bir ihlal sınıfıdır
(iki-L0 vakası) — fark edildiği yerde durulur ve kayda gidilir.
```

**Guard adayı (T-212'ye not, bu turda implement edilmez):** E6'ya beşinci kontrol —
`docs/brd-v2/` diff'i varsa aynı değişiklik setinde karar defteri dokunuşu ara;
yoksa uyar. Ratchet değil uyarı olarak başlar; yanlış-pozitif oranı ölçülmeden
kapıya bağlanmaz.

---

## DAĞITIM LİSTESİ (Team Lead — sıra önemli)

1. KAYIT 1 + KAYIT 2 → karar defterine (append; mevcut kayıtlar dokunulmaz)
2. EK → CLAUDE.md ilgili bölüme
3. `00_PAKET_INDEKSI` tek durum bloğu: `v2.0 · donmuş (2026-08-15)` satırı —
   durum yalnız orada yaşar (F8 kararı)
4. Guard koşusu (E6 + sayım) — dondurma anındaki guard çıktısı kapanış kaydına
   referans olarak eklenir
5. git tag `brd-v2.0` (annotated, KAYIT 1'e atıf) + push
6. Doğrulama: `git log origin` + `ls-remote --tags` — push kanıtı görülmeden
   bu dağıtım "bitti" yazılmaz
```
