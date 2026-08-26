# CollMind TPM — HEDEFLER (`L0`)

> **Tür:** `L0` — **neden** katmanı. `01_KONUMLANMA` *"ne"*yi, bu dosya *"ne için"*i
> söyler. **Bağlayıcı:** bir işin fazını tartışırken **buraya bakılır**.
> **Kaynak:** ürün sahibi + Fable, 2026-08-26.

⚠️ **KANONİK METİN ÜRÜN SAHİBİNDE.** Aşağıdaki beş başlık ürün sahibinin verdiği
**adlardır**; gövde metinleri Team Lead'in **repodan türettiği** okumadır ve
`Team Lead türetimi` diye işaretlidir. `DISIPLIN`: *"bağlayıcı kaynağa atıf vermek,
metnini uydurmak değildir"* — kanonik gövde geldiğinde bu bloklar **onunla değişir**.

---

## Beş `G`

### `G1` · ÇEKİRDEK DÖNGÜ
*(Team Lead türetimi)* Plan → taktik → hacim → onay → gerçekleşme → hakediş
zincirinin **uçtan uca çalışması**. Bir yetenek bu zincirin bir adımını açmıyorsa,
ürün için **henüz bir şey yapmıyor** demektir.

### `G2` · RAKAM GÜVENİ
*(Team Lead türetimi)* Ekranda görünen her sayının **izlenebilir ve doğru** olması.
`§2.5`'in (*sessiz sıfır yasağı*) ve dinamik-formül kuralının hedefi budur.
📌 Bu oturumun ölçümü: *"`200` dönen yanlış bir değer, `500`'den sinsidir — `500` bir
**alarm**, yanlış değer bir **karar** üretir."*

### `G3` · ÇOK-MÜŞTERİLİ YAŞAM
*(Team Lead türetimi)* Aynı kurulumun **birden çok tenant**'ı, birbirini görmeden ve
birbirine sızmadan taşıyabilmesi. `RLS` · `AccessScope` · `user_scopes` bu hedefin
mekanizmalarıdır.

### `G4` · KARAR HIZI
*(Team Lead türetimi)* Kullanıcının bir kararı **beklemeden** verebilmesi:
`<500ms` yeniden hesap (`NFR-1.2`), onay kuyruğunun görünürlüğü, blokajsız akış.

### `G5` · KANITLANABİLİRLİK
*(Team Lead türetimi)* *"Neden bu sayı?"* ve *"kim, ne zaman, neye dayanarak?"*
sorularının **kayıttan** cevaplanabilmesi. Değişmez denetim izi, `F12` deseni, karar
defteri.

---

## ⛔ FAZ SÜZGECİ (ürün sahibi, 2026-08-26 — **birebir**)

> **Çekirdek döngünün bir adımını açıyor ya da kilitlenme/veri-bozulması önlüyor
> → ŞİMDİKİ FAZ.**
> **Yalnız *"bir gün lazım"* → KANIT GELENE KADAR ADAY.**

### ⛔ VE KORUMA CÜMLESİ

> **Şimdiki faza iş EKLEMEK de süzgeçten geçer.**

📌 Bu cümle olmadan süzgeç **tek yönlü** çalışırdı: çıkarmayı zorlaştırır, eklemeyi
serbest bırakırdı. Bu oturumda ölçülmüş vakası var — kaza-dalgasının kapsamı
*"dalga temiz kapansın"* gerekçesiyle **üç kez** genişledi, ve her genişleme
**ayrı ayrı** gerekçelendirilmek zorunda kaldı.

---

## Nasıl kullanılır

```
bir iş önerildiğinde   →  hangi G'ye hizmet ediyor?
                          çekirdek döngüde bir adım mı açıyor?
                          kilitlenme / veri-bozulması mı önlüyor?
  ikisinden biri EVET  →  şimdiki faz
  ikisi de HAYIR       →  ADAY (kanıt gelene kadar)
```

⚠️ **Ve *"aday"* bir ret değildir** — bir **bekleme kaydıdır**. `Z25`'in dilinde:
*"bir şartın sağlayıcısı yoksa şart bir erteleme değil bir KİLİTTİR"* — aday kalemin
**neyi beklediği** yazılır.
