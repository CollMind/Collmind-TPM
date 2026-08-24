# Tasarım Katmanı Kararı + Hat Kayıtları — Dağıtım Bloğu

> **Tarih:** 2026-08-22 · **Hazırlayan:** Fable · **Onay:** ürün sahibi (bu oturum)
> **Yürüten:** Team Lead — üç kalem, sıra önemli değil, üçü de küçük

---

## KAYIT 1 · Karar defterine — tasarım katmanının üç sorusu (YOL_HARITASI §3'ün ⛔'si kapanıyor)

```
KARAR — TASARIM KATMANI (2026-08-22, ürün sahibi)

YOL_HARITASI_EKRAN_VE_SENARYO §3'ün üç açık sorusu:

1 · NEREDE YAŞAR: meta repo, docs/design/ altında.
    Ayrı repo REDDEDİLDİ — üçüncü senkron yükü, F8 fabrikası.
    Yapı senaryo→ekran zincirini taşır:
      docs/design/senaryolar/
      docs/design/ekranlar/<ekran-adı>/   ← L3 spec + Claude Design çıktısı
                                            YAN YANA (ayrı yaşarlarsa sessizce ayrışırlar)

2 · VERSİYONLANIR: evet, git ile — ama çıktı değil KAYNAK+ÇIKTI çifti:
    Claude Design'a giden brief/prompt dosyası da commit'lenir.
    Görsel tek başına yeniden üretilemez artefakttır; brief'iyle
    birlikte yaşarsa tasarım da veridir (İlke 3'ün tasarım hali).

3 · KİM SAHİPLENİR: sahipsizliğin bedeli ölçüldü (T-243: backend sözleşme
    değişikliği varsayılan yolu kırdı, yakalayan ekran sahibi değil
    code-reviewer blocker'ıydı). Kural:
      "Ekran spec'i olan her ekran için, backend sözleşmesini değiştiren
       PR o ekranın spec'ine dokunur ya da dokunmama gerekçesini yazar."
    (fırsatçı-kural deseninin tasarım hali)
    Spec'lerin karar sahibi ürün sahibi; bakım yürütücüsü o dalganın turu.

Bu kararla YOL_HARITASI §Sıra'nın Faz 2 giriş koşulu kapanır.
```

## KAYIT 2 · YOL_HARITASI_EKRAN_VE_SENARYO güncellemesi — T-075 durumu

§1'e durum satırı (F12 deseni — mevcut metin silinmez, üstüne durum düşülür):

```
DURUM (2026-08-22): hakediş senaryoları koşuldu — T-075, 18 aday bulgu →
9 doğrulanmış gap, Faz 2 girdisi. Fiilî sıra §1'in önerdiği iki 🔒 vakadan
sapmıştır (hakediş öne alındı) — sapma verimliydi ve kayıtlıdır. İki 🔒
vakanın (anlaşma kapanışı · formül doğrulaması) senaryosu HÂLÂ AÇIK ve
Faz 2'nin en ucuz iki görünür kazanımı olmaya aday.
```

## KAYIT 3 · Hatlar bloğu — OPEN_DECISIONS'a (ya da Team Lead'in uygun gördüğü tek kanonik yere)

Amaç: durum özetleri son aktiviteden değil bu bloktan türer; bir hattın
sessizliği "yok" değil "sırada" olarak görünür (F8'in sözlü haline karşı).

```
HATLAR — tek satır durum, her dağıtımda güncellenir

güvenlik/ADIM-3     B3a koşuyor · B4'e üç sayaç + ratchet sıfırı kaldı
ekran/senaryo       kanonik: YOL_HARITASI_EKRAN_VE_SENARYO ·
                    EK_E şema-uyum turu açık · denetim Faz 2'de başlar
tasarım             karar verildi (KAYIT 1) · docs/design/ Faz 2 girişinde doğar
veri kalitesi       T-209 üretim verisi bekliyor · Ö4 kapandı
dış kuyruk          hukuk (muhatap DUR) · danışman (gönderim bekliyor) ·
                    değerlendirme turu (bulgu bekleniyor)
faz-2 hazırlık      9 gap kayıtlı · iki 🔒 senaryosu açık · L3 spec sırada
```

## Doğrulama

Push kanıtı görülmeden "bitti" yazılmaz (`git log origin`).
