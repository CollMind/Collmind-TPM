# `B4` — KABUL KRİTERLERİ (biriken)

> **Tür:** `B4` brief'i yazılana kadar kabul kriterlerinin **biriktiği** dosya.
> Brief açıldığında bu kalemler **oraya taşınır** (silinmez, taşınır — `F12`).

---

## ⛔ `KİLİTLİ-TENANT PİNİ` (ürün sahibi, 2026-08-26 · `Z40`)

> **`default-deny` altında admin UÇTAN UCA çalışabilmeli:**
> **kullanıcı yarat → rol ata → kapsam ata** — ve pin bunu **CANLI** ölçer,
> **mock ile DEĞİL.**

### Neden bu pin

`B4` `RolesGuard`'ı öldürüp `default-deny`'a geçiyor. `default-deny`'ın klasik
kilitlenmesi şudur:

```
kapı kapanır  →  admin de kapıda kalır  →  kimse yeni kullanıcı/rol/kapsam ATAYAMAZ
              →  sistem KENDİNİ KİLİTLER, ve açacak kimse YOK
```

⇒ Bu bir **veri-bozulması değil, kilitlenme** sınıfı — `HEDEFLER.md`'nin faz
süzgecinde **şimdiki faz** tarafında.

### Pinin ŞEKLİ — üç adım, TEK zincir

```
1  admin, default-deny altında YENİ KULLANICI yaratabiliyor
2  o kullanıcıya ROL atayabiliyor
3  o kullanıcıya KAPSAM atayabiliyor      ← H8: kapsamsızlık bir KAYITTIR
```

⛔ **Üçü ayrı ayrı yeşil olması YETMEZ** — zincir **kesintisiz** olmalı. Üçünü ayrı
test etmek, `§2.7 #6`'nın (*"kapsam var, ayırt etme gücü yok"*) yeni bir vakası olur:
her adım kendi başına geçer, **zincir kopuk kalır**.

### ⛔ `CANLI, mock DEĞİL` — ve bunun sebebi ÖLÇÜLMÜŞ

`T-301`'de kaydedildi: bir MSW handler'ı silinmiş bir uca **başarı** dönüyordu ve
`T-289`'un **canlı kırıklığı** frontend testlerinde **hiç görünmüyordu**.

> **Bir kilitlenme pini mock'la yazılırsa, kilidi mock açar — ürün değil.**

### Ek şart — NEGATİF YARI

Pin **iki-girdi-iki-çıktı** olmalı:
```
admin        → zincirin üçü de GEÇER
admin-DIŞI   → zincirin İLK adımında durur (403)
```
Tek yönlü bir pin, *"herkese açtık"* bozukluğunda da **yeşil kalır** (`§2.7 #9`).
