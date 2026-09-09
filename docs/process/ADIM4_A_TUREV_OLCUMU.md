# `(A)`-KÜÇÜK — TÜREV ÖLÇÜMÜ, VAKASIZ 23 MADDE
### Team Lead · 2026-09-09

## `A1` · KÜME ÖLÇÜLDÜ
```
[ÖLÇÜLDÜ: vaka-işaretleyici taraması, 218 kural]  ⛔ ADAY listesi, TEŞHİS DEĞİL
  skor 0  vakasız      : 23   ⇒ TÜREV ÖLÇÜMÜ GEREKEN küme
  skor 1  tek işaret   : 133
  skor ≥2 çok vakalı   : 62   ⇒ türev GEREKMEZ, KALIR (H2)
```

## `A2` · ⛔ İLK ÖLÇÜMÜM ÇÜRÜDÜ — VE **DÖRDÜNCÜ** KEZ AYNI SINIF

Anahtarları **başlığın sözcüklerinden** seçtim. Sonuç:
```
"YENİ KAPI, BİLİNEN BİR KIRMIZIYI GÖRMEDEN…"   → türev 0 ⇒ "GÜNLÜĞE"
```
⛔ Ama o madde **`Z83` doğum kuralıdır** — bu oturumdaki **her brief'in** dayandığı kural.

```
[ÖLÇÜLDÜ]  başlıktan seçtiğim anahtar  'BİLİNEN BİR KIRMIZIYI GÖRMEDEN'  →   1
           kavramın ATIF ADI            'Z83'                             →  10
                                        'bilinen-kırmızı'                 →  10
           (tüm korpusta, script'ler dahil)                               →  81
```

> ### ⛔ Anahtar **başlığın dilinden** seçildi; atıflar **kavramın kanonik adıyla**
> ### yapılıyor. Ve beni kurtaracak kural **ölçtüğüm listenin İÇİNDE**:
> ### *"Arama terimi, **ARANAN YERİN DİLİYLE** seçilir"* (`DISIPLIN:179`, türev **12**).

📌 Bu, **`R7 YÜZ 2`'nin dördüncü vakası** — ve öncekilerden farkı: anahtarı **elle**
seçmiştim, yani *"insan yargısı"* çözüm sanılmıştı. Çözüm insan yargısı değil,
**doğru dilde** bir insan yargısıydı.

## `A3` · DÜZELTİLMİŞ ÖLÇÜM — kanonik atıf adlarıyla

| türev | madde | sınıf |
|---:|---|---|
| **189** | BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR | ⭐ KÖŞE TAŞI |
| **81** | YENİ KAPI — bilinen-kırmızı görmeden (`Z83`) | ⭐ KÖŞE TAŞI |
| **75** | Bir kapı ağının KENDİ SAĞLIĞINI ölçmesi | ⭐ KÖŞE TAŞI |
| 30 | Kaskadın ZORUNLU dört parçası | ⭐ ⚠️ anahtar GENİŞ (aşağıda) |
| 21 | Bir SAYI, ÖRNEKLENMEDEN raporlanamaz | ⭐ KÖŞE TAŞI |
| 20 | Doğrulama bir KAPIDIR — durdurmuyorsa | ⭐ KÖŞE TAŞI |
| 17 | Kapsam maskelemesi — desen / EVREN | ⭐ KÖŞE TAŞI |
| 12 | Arama terimi, ARANAN YERİN DİLİYLE | ⭐ KÖŞE TAŞI |
| 9 | BİR KAPININ EVREN-KAYNAĞI | ⭐ KÖŞE TAŞI |
| 6 | KARAR-GİRDİSİ YÜZEYLERİ | ⭐ KÖŞE TAŞI |
| 5 | Bir DÜZELTME de bir iddiadır | ⭐ KÖŞE TAŞI |
| 3 | eşitlik, VARLIĞIN kanıtı değildir · KAPSAM-BEYANI ≠ KANITI · Dokümanda sayı yazma | ⭐ KÖŞE TAŞI |
| 2 | Yetkiler DB mi kod mu · VARSAYILAN ≠ FALLBACK · KOMŞU KAPININ görevi · HÜCRE KÜMESİ | KALIR |
| 1 | SAHTE GÜVENLİK SİNYALİ · ÜÇ İHLAL TEK TURDA · ÖLÇÜM KOLAYLIĞI · GEREKÇE-ÇÜRÜMESİ | KALIR |
| **0** | KÖR-NOKTA TÜRLERİ MUTASYON TÜRÜNE GÖRE | ⇒ **GÜNLÜK** |

```
⇒ KÖŞE TAŞI 14 · KALIR 8 · GÜNLÜK 1   (23 vakasız maddeden)
```

## `A4` · ⭐ SONUÇ — `H1`'İ **SAYIYLA** DOĞRULUYOR

> ### 23 vakasız maddeden **YALNIZ BİRİ** günlüğe iniyor.

`H1` *"amaç BULUNABİLİRLİK, kısaltma DEĞİL; madde sayısının düşmesi YAN ÜRÜN"* demişti.
Ölçüm bunu doğruluyor **ve daha da ileri gidiyor**: kısaltma **yan ürün bile değil**,
**neredeyse sıfır**. Değerin tamamı `(C)` **aile** + `(B)` **tetikleyici**'de.

## `A5` · ⛔ NE ÖLÇEMEDİM
```
· 'Kaskadın ZORUNLU dört parçası' → 30: anahtar 'kaskad' GENİŞ (bütçe kaskadı
  bağlamlarını da yakalıyor olabilir). ⚠️ KÖŞE TAŞI etiketi bu maddede ŞÜPHELİ.
· skor-1 kümesi (133) HİÇ ÖLÇÜLMEDİ — proxy kaba, ve 'tek işaret' bir maddenin
  gerçekten tek vakalı olduğunu KANITLAMAZ. (A)'nın kalanı bu.
· türev sayıları KORPUSA bağlı: docs + CLAUDE.md + scripts. Test dosyaları ve
  task dosyaları DAHİL DEĞİL ⇒ sayılar ALT SINIRDIR.
```
