# `B3A` EK 3 · rota→hücre eşlemesi — TRANSCRIPT'TEN DOSYAYA (`T-283`)

**Ölçüm:** 2026-08-24 · `Z35` sonrası · **Üretici:**
`collmind.backend/scripts/analysis/route-cell-map.py`
**Veri:** [`B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv`](B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv) — `211` satır

> `B3A_ESLEME_TABLOSU.md:307` *"Tam `211` satırlık tablo **ajanın raporundadır**"* diyordu.
> Bir transcript **kanonik yüzey değildir**: arandı ve **kurtarılamadı** (dedektör pozitif
> kontrolü verdi — `58` controller atfı ve `231` hücre adı **ayrı kayıtlarda**, aynı kayıtta
> ikisi birden **yok**). Tablo **yeniden türetildi**.

---

## 1 · TÜRETİM KURALI — ve neyin YARGI olduğu

> ⛔ **SAYI SÜTUNU KALDIRILDI (2026-08-24).** Eski hâli elle yazılmıştı ve
> **kendi içinde tutarsızdı**: `190+12+5+2+4 = 213`, ama dosya `211` satır
> (`MEKANIK` gerçekte `188`'di). Kanonik kaynak artık üreticinin **`MUTABAKAT`
> çıktısıdır** (stderr) — bir belge sayısı hiçbir zaman kırmızıya dönmez, bir
> kapı döner.

| kaynak | kural |
|---|---|
| `MEKANIK` | aile = **modül dizini** · fiil = **HTTP yöntemi** (`GET`→`READ`) |
| `Z31/Z32` | `SUMMARY_READ` — *nesne-bağsız + çok-işlem-modüllü portföy özeti* · **üye listesi** |
| `Z35` | `MODES_SUBMIT` — gönderim/iptal/taslak, **onay kararı değil** |
| `Z20` | `USER_READ` silindi → `USER_MANAGE` |
| `YARGI` | `MODES_APPROVE` — **onay-akışı durum geçişi** · **üye listesi** |

⇒ Türetimin ezici çoğunluğu **mekanik**; yargı yalnız birkaç satırda ve **her biri bir
kayda bağlı**. Kırılım için:

```bash
cd collmind.backend && python3 scripts/analysis/route-cell-map.py >/dev/null
```

### ⛔ `YARGI` bir YOL DESENİ değil, bir ÜYE LİSTESİ (düzeltildi 2026-08-24)

Eski hâli `approve|reject|approval-decision` **yol deseniydi** ve iki rotayı
kaçırıyordu — `POST /plans/:id/review` · `POST /plans/:id/escalate-to-finance`.
İkisi de mekanik `POST`→`WRITE` kuralına düşüp **`MODES_WRITE`** görünüyordu.

**Sınıf yol deseninden değil DAVRANIŞTAN tanımlanır** (ürün sahibi kararı,
teyit ölçümü aşağıda). Sınıf: *"onay-akışı durum geçişleri"*, üyeler
`approve · reject · review · escalate`.

| ölçüm | sonuç |
|---|---|
| altı üyenin yazdığı kolonlar | `status`/`approved*`/`rejected*`/`escalated*`/`pendingFinanceReview` — hepsi `updateStatusCas` üzerinden |
| **plan-içerik kolonu** | **`0`** |
| **POZ.KONTROL** `plan.service.updateSkuVolume` | `baseVolume`/`plannedVolume` **yazar**, `status`'ü yalnız **okur** (DRAFT guard) |

Ayırt edici **ters yönlü**: onay rotaları `status`'ü *yazar*, içerik rotaları *okur*.

⚠️ `approval-decision` düşürüldü — **sıfır** rota eşliyordu (ölü desen, ölçüldü).

### MUTABAKAT KAPISI — üretici artık kendi sınıfını yakalar

`route-cell-map.py` çıktısını doğrulayan **dört kapı + bir uyarı**, ve dördü de
**mutasyonla kırmızıya döndürülerek** kanıtlandı (2026-08-24):

| kapı | ne yakalar | mutasyon kanıtı |
|---|---|---|
| `G1` | çift anahtar · boş/geçersiz hücre | `MUT-C` → `exit 2` |
| `G2` | **ölü/çift üye** (bayat üye listesi) | `MUT-A` → `exit 2` |
| `G3` | çözülemeyen `@Roles` (ayrıştırıcı körlüğü) | `MUT-D` → `exit 2` |
| `G4` | **çapraz-araç**: `route-scope.sh` `ROLES` ≠ satır | `MUT-C` → `exit 2` |
| `W1` | `ADMIN` taşımayan rota — **UYARI, kapı DEĞİL** | `Z29`: bir kapı, ölçümün başarısını hata sayamaz |

> ⛔ **VE İSTENEN "kategori toplamı == satır sayısı" KONTROLÜ BİLEREK YAZILMADI.**
> `Counter` satırların **kendisinden** türetilir, yani o eşitlik **tanım gereği**
> sağlanır — kontrol hiçbir girdide kırmızıya dönemez. Ölçüldü (`MUT-B`: sahte satır
> eklendi → `212=212=212`, kapı **ateşlemedi**). Bir totoloji, yeşil olduğu için
> **çalıştığı sanılan** kontroldür; olmayan kapıdan kötüdür. Yerine `G1`+`G4` kondu:
> ikisi de **kırılabilir**, ve ikisi de kırıldı.

### Parser — iki tuzak, ikisi de ölçülerek bulundu

```
1  @Roles HTTP dekoratörünün ÜSTÜNDE de ALTINDA da olabilir  → çift yönlü tarama
2  READ_ROLES = [...WRITE_ROLES, …]  İÇ İÇE SPREAD           → FIXPOINT özyineleme
```

⚠️ İkincisi `capabilities.ts:366`'da **zaten yazılıydı** (`H1`'in dersi) ve parser onu
**yeniden üretti**: tek geçişte `ADMIN`+`FINANCE` düştü, dört `sales-actuals` `GET`'i
`ADMIN` **taşımıyor** göründü. Yakalayan şey bir guard değil, bir **tuhaflık dedektörü**
(*"`ADMIN` taşımayan rota var mı?"*).

---

## 2 · POZİTİF KONTROLLER — dördü de tuttu

| kontrol | beklenen | ölçülen |
|---|---|---|
| `POST /agreement-transactions` (`T-277` daralttı) | `{ADMIN,FINANCE}` | ✅ |
| `sales-actuals` `GET` (fixpoint sonrası) | `5` rol | ✅ |
| `ADMIN` taşımayan rota | `0` | ✅ |
| **`MODES_SUBMIT`** (`Z35`'in kaydı) | **`5`** | ✅ **birebir** |
| `MODES_READ` (`B3a`'nın kaydı `37`) | `37 − 3` (SUMMARY'ye) = `34` | ✅ |
| çözülemeyen `@Roles` | `0` | ✅ |

---

## 3 · ⛔ FARK LİSTESİ — `B3a`'nın SAYILARI BAYAT

**`B3a`'nın hücre sayıları bugünkü koda göre `5` rota fazla.** Sebep kayıtta duruyor:
`B3A:172` *"jenerik onay uçları **silindi**"* (`T-253` · `Z24`) — `B3a` o silmelerden
**önce** ölçülmüştü.

| hücre | `B3a` kaydı | bugün ölçülen | açıklanan | AÇIKLANMAYAN |
|---|---|---|---|---|
| `MODES_READ` | 37 | **34** | `−3` → `SUMMARY_READ` | 0 |
| `SHARED_READ` | 32 | **20** | `−9` → `SUMMARY_READ` | **`−3`** |
| `MODES_APPROVE` | 11 | **6** + `MODES_SUBMIT 5` = **11** | `Z35` böldü | **`0`** ✅ |

> ### ✅ `MODES_APPROVE`'UN AÇIKLANMAYAN `−2`'Sİ KAPANDI (2026-08-24)
>
> İlk okumada `4 + 5 = 9` çıkıyordu ve `−2` **açıklanamıyordu**. Onay-akışı sınıf
> düzeltmesinden sonra `6 + 5 = **11**` — `B3a`'nın kaydıyla **birebir**.
>
> **Eksik olan iki rota tam olarak `review` ve `escalate-to-finance`'ti:** yol-deseni
> sınıflandırıcısı onları `MODES_WRITE`'a yollamıştı. Yani muhasebe açığı, ürün
> sahibinin kararını **bağımsız olarak teyit etti** — karar verilirken bu hesap
> bilinmiyordu.
>
> 📌 Kalan tek açık: `SHARED_READ`'in `−3`'ü.

```
B3a türevi taban    75          ← çıkarma, girdisi bayat
EK 3'ün sayımı      70          ← sayım, sınıf düzeltmesinden ÖNCE
BUGÜN ÖLÇÜLEN       72          ← sayım, onay-akışı düzeltmesi SONRASI
```

> ⛔ **`B3B_RATCHET_TABANI.md`'nin `75`'i BU EK'LE REVİZE EDİLDİ → `70`**, ve
> onay-akışı sınıf düzeltmesiyle **`70` → `72`**. Eski sayılar silinmedi;
> `F12`/`0006-R` deseniyle izleriyle duruyor.

⚠️ Ve bu, `§ MEKANİK OLARAK TÜRETİLMİŞ BİR DEĞER GEREKÇE DEĞİLDİR`'in vakası: `75` bir
**çıkarmaydı** (`80 − 5`), ve çıkarmanın girdisi bayattı. `70` bir **sayımdır**.

---

## 4 · YENİDEN TÜRETME

```bash
cd collmind.backend && python3 scripts/analysis/route-cell-map.py    # exit 0 = MUTABAKAT TAMAM
```

⚠️ **Çıkış kodunu boruya sokma** — `| head` / `| grep` sonrası `$?` borunun son
komutunundur, üreticininki değil. Mutabakat kapısı `exit 2` verir ve boruda kaybolur.

Anahtar (`<dosya>\t<YÖNTEM>\t<yol>`) `route-scope.awk` ve kapsam baseline'larıyla
**aynı** — iki liste birbirine bağlanabilir.

⇒ `B3B1_DEVIR_BRIEF §2`'nin *"üç listeyi repodan yeniden türet"* adımı **artık
uygulanabilir**.
