# B3b-1 Devir Brief'i — Yeni Team Lead Thread'i İçin

> **Tarih:** 2026-08-24 · **Hazırlayan:** Fable · **Onay:** ürün sahibi
> **Kimin için:** B3b-1'i devralan YENİ Claude Code (Team Lead) oturumu
> **Tür:** okuma sırası + görev sözleşmesi — ÖZET DEĞİL. Durum anlatısı bu belgede
> yoktur; durum kanonik dosyalardan okunur. Bu belge yalnız sırayı ve sınırları verir.

---

## 0 · Geçerlilik ön koşulu (DUR)

Bu brief ancak devir paketinin **dört** parçası origin'de ise geçerlidir — `git log origin` ile
kanıtla, biri yoksa DUR ve ürün sahibine dön:

1. `docs/process/B3B_RATCHET_TABANI.md` — taban okuması dosyası (B3A'nın kardeşi;
   üstünde **"Z35-sonrası ölçüldü"** damgası OLMALI — yoksa bayat, DUR)
2. `ADIM3_FAZB_PLAN.md` H1 bölümü **KAPANDI (Z35)** işaretli (F12 deseni)
3. `.claude/agents/*.md` frontmatter'larında `model:` eşlemesi

   ```
   opus     architect · code-reviewer · debugger · planner        → İDDİA üretenler
   sonnet   backend · frontend · data-engineer · qa · data-analyst → ARTEFAKT üretenler
   ```

   > ⛔ **GEREKÇE DÜZELTİLDİ (ürün sahibi, 2026-08-24) — eşleme aynı, DAYANAĞI değil.**
   >
   > Ölçüm şunu söyledi: yakalama kalitesini **model katmanı öngörmüyor** — bu oturumun
   > en pahalı iki yakalayışı `sonnet`'ten geldi (`data-engineer`: `Capability` entity ·
   > alt-ajan: `/finance-reporting` enjeksiyon), ve **ikisi de ölçüm anında** geldi.
   >
   > Doğru okuma *"opus daha iyi yakalar"* **değil**:
   > **"yakalama mekanizması nerede ZAYIFSA, güçlü model oraya."**
   > İddia turlarının hata sınıfı farklıdır (yanlış çerçeve · kaçan kesişim) ve bunlar
   > **ölçümle değil muhakemeyle** yakalanır. Artefakt turlarının hatalarını ise zaten
   > guard'lar + pinler + doğrulama yakalıyor — **model değil**.
   >
   > ⇒ Bir sonraki adım: yakalamayı **modele değil TURA gömmek** (`T-282`'nin araç
   > sorusu). `§5` metrikleri yanılıyorsak gösterecek.
4. ⛔ **`docs/process/B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv`** — `211` satırlık rota→hücre
   eşlemesi. **Eşleme eki origin'de yoksa DEVİR GEÇERSİZ.**

   > Gerekçe (`T-283`, ürün sahibi): `§2`'nin *"üç listeyi repodan yeniden türet"* adımı
   > bir **şarttı ve sağlayıcısı yoktu** — eşleme `B3A:307`'ye göre *"ajanın
   > raporunda"*ydı, ve **transcript'ler kanonik yüzey değildir**. `Z25`'in kilit
   > tanımının bir **brief'e** uygulandığı ilk vaka: *"bir şartın sağlayıcısı yoksa şart
   > erteleme değil KİLİTTİR."*
   >
   > ⚠️ Ve ek yazılırken `B3a`'nın sayılarının **bayat** olduğu ölçüldü — taban
   > `75` → **`70`** revize edildi (`EK 3 §3`). Yani ön koşul yalnız bir dosya değil,
   > bir **düzeltme** de getirdi.

## 1 · Okuma sırası (kanonik girdiler — sayıları YENİDEN SAYMA, atıf ver)

```
1  CLAUDE.md                          çalışma kuralları — §0 zorunluları dahil
2  docs/process/ADIM3_FAZB_PLAN.md    faz planı (H1 kapanışı işlenmiş hali)
3  docs/process/B3A_ESLEME_TABLOSU.md rota→hücre eşlemesi (223 evren, kova anahtarları)
4  docs/process/B3B_RATCHET_TABANI.md ÜÇ LİSTE: göçebilir · karar-bekler · istisna-kayıtlı
                                      + modül dağılımı
5  04_KARAR_KAYDI.md  Z30–Z35        B3'ün hukuku: dokuz hüküm · SUMMARY_READ tanımı
                                      (Z32 düzeltmesiyle) · ham-grep/kanonik-ayrıştırıcı
                                      (Z34) · n=1→{A,F} + K-2.6.14 açıklığı (Z35)
6  scope-a1/a2/b/c baseline'ları      kapsam sütunu — DOKUNULMAZ, ama anahtar formatı
                                      B3b ratchet'iyle aynı (<dosya>|<YÖNTEM>|<yol>)
```

## 2 · İlk iş: B3B tabanının BAĞIMSIZ doğrulaması

Dosyayı okuyarak değil ÖLÇEREK devral: üç listeyi repo'dan yeniden türet
(`route-scope.awk` + harita), dosyayla karşılaştır.

- Birebir → "taban doğrulandı" kaydı, ilerle.
- Fark → DUR + fark listesi (sayı değil liste) ürün sahibine. Dosya düzeltilmeden
  dalga planı yazılmaz.

Bu adım atlanamaz — devir bayatlığı bu projede iki kez ölçüldü (Faz-0 Rev-2 ·
ADIM3_FAZB_PLAN/H1). Yeni thread zemini ölçerek devralır.

## 3 · İkinci iş: dalga planı ÖNERİSİ (koşu değil)

B3B'nin üç listesinden + modül dağılımından dalga planını çıkar ve **ürün sahibi
onayına getir** — plan onaylanmadan göç commit'i atılmaz. Planın içermesi gerekenler:

- **Dalga-0 (mekanizma):** `@RequireCapability` dekoratörü + guard çözümlemesi henüz
  canlı kod değil — B3 "kur + türet + göçür"dür (Z30). Kurulum ayrı, küçük, pin'li
  bir dalga: iki-girdi-iki-çıktı (doğru capability → 200 · yanlış → 403), harita
  tek kaynak (`capabilities.ts`), rota-başına tek mekanizma kontrolü guard'a.
- **Modül dalgaları:** yalnız "göçebilir" listesinden; her dalganın pin çifti
  (göç öncesi/sonrası aynı davranış — örneklem: izinli 200 · izinsiz 403), her
  dalga kalan-@Roles liste-ratchet'ini düşürür (Z29 sıfır-güvenli).
- **İstisna dalgası ayrı:** davranış-değiştiren iki kayıtlı istisna (Z20 `GET /users`
  daraltması · varsa Z35 kalıntısı) kendi dalgasında, kendi repro-pinleriyle —
  "göç davranış değiştirmez" kuralının istisnaları sessizce modül dalgasına karışmaz.

## 4 · DUR listesi (her ajan için)

- ⛔ **READ-üçlemesi dilimi KİLİTLİ:** `MODES_READ · SHARED_READ · SUMMARY_READ ·
  MODES_APPROVE` rol kümeleri çözülmedi (H1-READ, Fable'a gidecek) — bu hücrelerin
  rotalarına dekoratör göçü YOK. "Karar-bekler" listesi budur.
- ⛔ **Kapsam sütunu ve baseline'ları DOKUNULMAZ** — B3b yalnız @Roles/yetenek
  sütununu göçürür (Z19b iki-hat ayrımı). Kapsam-❌ satırının "iyileşmesi" bile
  şüphelidir: ratchet düşüşe sevinir, o kör noktayı insan denetler.
- ⛔ Rota-başına TEK mekanizma: `@Roles + @RequireCapability` aynı rotada yaşayamaz.
- ⛔ Kural/hücre/task numarası tahsis etme — numara Team Lead'de, hüküm Fable'da,
  karar ürün sahibinde.
- Sayı değil liste · her iddia işaretli (ÖLÇÜLDÜ/GEREKÇELİ/VARSAYIM) · ham grep
  ön-tarama, hüküm kanonik ayrıştırıcıdan (Z34) · exit kodu boruya girmez ·
  yazma-commit arasına KAPI (assertion `&&`-zincirinin İÇİNDE).

## 5 · İzleme metrikleri (model eşlemesinin ölçümü — her dalga raporunda)

```
çürüyen-iddia oranı    Team Lead doğrulamasında düşen ajan iddiası / toplam
DUR sıklığı            dalga başına DUR'a çarpma sayısı (sınıfıyla)
pin kırmızıları        beklenmeyen kırmızı = davranış değişti = dalga durur
```

Sonnet'e inen ajanlarda bu üçü bozulursa model eşlemesi ürün sahibiyle revize edilir —
varsayımla değil, bu ölçümle.

## 6 · Sıra kaydı

```
1  Dalga-0 + ilk modül dalgası (Sonnet ajanlarla) → metrikler raporlanır
2  CLAUDE.md bölme turu ANCAK ondan sonra — iki değişken aynı anda oynamaz
3  READ-üçlemesi rol kümeleri: B3B doğrulaması sonrası Fable'a karar paketi
```

## 7 · Kapanış hijyeni

Bu thread de kapanırken aynı soruyu ölçerek cevaplar: "kayda inmemiş karar/bulgu
var mı?" — ağaç temizliği + AC uzlaşısı + kuyruk kalemlerinin task varlığı.
"Devir temiz" bir beyan değil, bir ölçüm sonucudur.
