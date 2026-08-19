# Değerlendirme Turu Modeli — Salt-Okur Çalışma Düzeni

> **Tarih:** 2026-08-15 · **Hazırlayan:** Fable · **Onay:** ürün sahibi (bu oturum)
> **Kimin için:** BRD'yi değerlendirmek üzere ekibe katılan ikinci kişi (soru + değerlendirme
> rolü) · **Kapsam:** yalnız değerlendirme turları — yazma/karar turları bu belgenin dışında
>
> Bu belge, Fable ile yapılacak değerlendirme oturumlarının sözleşmesidir. İlk oturumunu
> bu dosyanın yoluyla aç; Fable gerisini buradan devralır.

---

## 1 · Tur açılış etiketi (zorunlu)

Her oturumun ilk mesajı şu etiketi taşır:

```
değerlendirme turu — salt okuma
```

Bu etiketi gören Fable şu modda çalışır:

- **Yapar:** soruları cevaplar · karşı-soru sorar · repo dosyalarını okur · bulgu
  önerir · her iddiayı işaretler (aşağıda §4)
- **Yapmaz:** dosya yazmaz · karar üretmez · karar defterine/L2'ye hiçbir şeyi
  öneri-üstü statüde geçirmez · "şunu hemen düzeltelim" akışı açmaz
- Bir konu karar gerektiriyorsa Fable onu **kapısıyla işaretler** ("bu, ürün sahibi
  kapısı — K/ADR sınıfı") ve geçer. Kararı tartışmak serbest, vermek değil.

## 2 · Okuma sırası

Kimse projeyi anlatmaz; sistem kendini anlatacak şekilde kuruldu. Sıra:

```
1  CLAUDE.md                      çalışma kuralları ve guard'lar
2  docs/brd-v2/00_PAKET_INDEKSI   paketin haritası + tek durum bloğu
3  01_KONUMLANMA                  neden bu ürün
4  02_YETENEK_HARITASI            hangi yetenek, hangi kademede
5  L2 bölümleri                   indeksten, bölüm bölüm — tek oturumda değil
6  04_KARAR_KAYDI                 kararlar + kaynak ilişkisi (sapma tablosu)
7  docs/analysis/0071-*           kod tarafının durum fotoğrafı
8  docs/process/FAZ1_PLAN.md      sıradaki işin şekli
```

Kurallar:

- **BRD v2.0 donmuş** (2026-08-15). Değerlendirme serbest, düzenleme kapalı —
  düzeltme ihtiyacı bir *bulgudur*, bir edit değil.
- **Fable'a bağlam anlatma; dosya yolu ver.** Fable'ın hafızası kolaylıktır,
  otorite değil — kanonik kaynak her zaman repodur.
- **Soruları teker teker ve dar sor.** "BRD'yi değerlendir" değil; "K-2.2.7'nin
  iki merdiveni neden ayrı?" gibi. Bu depoda en iyi çalışan desen budur.
- **Fable'ın cevapları öneridir; itiraz işin parçasıdır.** Emsal: Faz 0 kapanış
  belgesinin ileriye bakan tablosu bayattı — insan kapısı yakaladı, Rev 2 ile
  düzeltildi, bayat sürüm dağıtılmadı. Aynı dikkat senden de beklenir.

## 3 · Değerlendirme çerçevesi — dört nişan

Açık uçlu "değerlendir" yerine dört hedefli soru ailesi:

1. **Anlaşılırlık testi** *(en değerli katkın — bunu yalnız sen yapabilirsin):*
   belgeyi bağlamsız okuyan ilk insansın. Nerede durdun, neyi iki kez okudun,
   hangi terim havada kaldı? Her durak bir bulgudur — "anlamadım" geçerli ve
   istenen bir bulgu sınıfıdır.
2. **Rol gerçekliği:** rol modeli (Planner/KAM planlar · Kategori Müdürü bütçe
   sahibi olarak onaylar · Finans eşik üstü + mutabakat) ve üç onay şablonu,
   bizim fiilî organizasyonumuzla örtüşüyor mu? Örtüşmeyen her yer bir bulgu.
3. **Zayıf dayanak avı:** Fable'ın `GEREKÇELİ` işaretiyle geçtiği ve
   `04_KARAR_KAYDI`'nda dayanağı "görüş/kalibrasyon bekliyor" olan yerler —
   hangileri senin sorularınla yeniden açılmayı hak ediyor?
4. **Serbest bölge:** eksik gördüğün, kimsenin sormadığı ne var?

## 4 · İşaretleme disiplini (iki yönlü)

- **Fable her iddiasını işaretler:** `ÖLÇÜLDÜ` (belgeden, atıfla) · `GEREKÇELİ`
  (muhakeme, doğrulanamaz) · `VARSAYIM`. İşaretsiz iddia kabul etme — iste.
- **Sen de bulgularını işaretle:** *gözlem* (belgeden gösterebilirim) · *soru*
  (cevabını bilmiyorum) · *itiraz* (katılmıyorum, gerekçem şu). Üçü farklı
  işlenir; karışırsa bulgu listesi kullanılamaz.

## 5 · Çıktı formatı — aday bulgu şablonu

Bulgular oturum içinde şu şablonla toplanır; Fable oturum sonunda derler:

```
D-XX · [gözlem|soru|itiraz]
  bulgu     : tek cümle
  yer       : dosya + bölüm/kural numarası
  dayanak   : ne gördün / neden böyle düşünüyorsun
  öneri     : (varsa) — statüsü her zaman ADAY
```

Kurallar:

- Her bulgu **ADAY** statüsündedir. Uygulanması ayrı bir karardır ve **karar
  ürün sahibindedir** — bu, dış denetim turunda kurulmuş ve işlemiş desendir
  (F-listesi: 17 bulgu → aday → seçilerek uygulandı).
- Derlenen liste `DEGERLENDIRME_NOTLARI_<tarih>.md` olarak **ürün sahibinin
  yazma turunda** repoya girer — değerlendirme turu dosya yazmaz; Fable listeyi
  oturum sonunda mesaj olarak verir, taşıma ürün sahibinindir.
- Bir bulgu acil görünüyorsa (ör. güvenlik): etiketi `⚡` olur ama yolu değişmez —
  yine ürün sahibine gider, sadece beklemez.

## 6 · İlk oturum önerisi

Tek konu, dar kapsam: **01_KONUMLANMA + 02_YETENEK_HARITASI okuması + anlaşılırlık
bulguları.** L2'ye ilk oturumda girme — 300+ kurallık gövde, harita anlaşılmadan
okunursa anlaşılırlık testi kirlenir (bağlam yerleşir, taze göz kaybolur; ve o göz
bir kez kaybolunca geri gelmez — en değerli varlığını ilk oturumda harcama).
