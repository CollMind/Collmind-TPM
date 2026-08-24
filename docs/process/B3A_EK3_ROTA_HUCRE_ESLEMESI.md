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

| kaynak | satır | kural |
|---|---|---|
| `MEKANIK` | **190** | aile = **modül dizini** · fiil = **HTTP yöntemi** (`GET`→`READ`) |
| `Z31/Z32` | **12** | `SUMMARY_READ` — *nesne-bağsız + çok-işlem-modüllü portföy özeti* |
| `Z35` | **5** | `MODES_SUBMIT` — gönderim/iptal/taslak, **onay kararı değil** |
| `Z20` | **2** | `USER_READ` silindi → `USER_MANAGE` |
| `YARGI` | **4** | `MODES_APPROVE` — yol deseni (`approve`/`reject`) |

⇒ **`211`'in `190`'ı tümüyle mekanik.** Yargı yalnız `21` satırda, ve **her biri bir kayda
bağlı**.

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
| `MODES_APPROVE` | 11 | **4** + `MODES_SUBMIT 5` = 9 | `Z35` böldü | **`−2`** |

```
B3a türevi taban    75
BUGÜN ÖLÇÜLEN       70          ← fark 5 = silinmiş rotalar
```

> ⛔ **`B3B_RATCHET_TABANI.md`'nin `75`'i BU EK'LE REVİZE EDİLDİ → `70`.** Eski sayı
> silinmedi; `F12`/`0006-R` deseniyle iziyle duruyor.

⚠️ Ve bu, `§ MEKANİK OLARAK TÜRETİLMİŞ BİR DEĞER GEREKÇE DEĞİLDİR`'in vakası: `75` bir
**çıkarmaydı** (`80 − 5`), ve çıkarmanın girdisi bayattı. `70` bir **sayımdır**.

---

## 4 · YENİDEN TÜRETME

```bash
cd collmind.backend && python3 scripts/analysis/route-cell-map.py
```

Anahtar (`<dosya>\t<YÖNTEM>\t<yol>`) `route-scope.awk` ve kapsam baseline'larıyla
**aynı** — iki liste birbirine bağlanabilir.

⇒ `B3B1_DEVIR_BRIEF §2`'nin *"üç listeyi repodan yeniden türet"* adımı **artık
uygulanabilir**.
