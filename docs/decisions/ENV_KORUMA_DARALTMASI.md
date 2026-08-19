# `.env*` koruma daraltması — kapsam düzeltmesi, güç azaltması DEĞİL

> **Tarih:** 2026-08-18 · **Karar:** ürün sahibi · **Uygulayan:** Team Lead
> **Dosya:** `.claude/settings.json` → `permissions.deny`

---

## Bulgu

`T-235`'in son kalemi *"`SCOPE_ENFORCEMENT_ENABLED`'ı `.env.example`'a yaz"* idi.
Team Lead **yapamadı** — `.env.example`'a hem okuma hem yazma reddedildi:

```
Read(./**/.env.*)     ← .env.example'ı DA kapsıyordu
```

`.env.example` bir **şablondur ve sır taşımaz** — içindeki her değer `change-me`,
`your-secret-key-change-in-production` gibi yer tutucudur. Metin hazırdı
(`docs/verification/T235_SCOPE_FLAG_ENV_ORNEGI.md`) ve **iş durdu**.

## Sınıf — bu oturumun tekrar eden deseni

> **Bir kural okunduğu gibi uygulandığında ya ihlal ediliyorsa ya işi durduruyorsa,
> kuralın kendisi zayıflar.** (`CLAUDE.md`, `mode-split` dersi)

`mode-split` sınıfının **dördüncü** ölçülmüş vakası:

| # | vaka | kural neyi durdurdu |
|---|---|---|
| 1 | `mode-split` satır sayısı | doğru bir düzeltmeyi *"büyüdü"* diye işaretledi |
| 2 | `M-3` guard yüzeyi | — |
| 3 | `PUSH_ORDER_ABORT_ON_DIRTY` self-test sızıntısı | kaçış kapağını **kullanılamaz** yaptı |
| 4 | **`.env.*` deseni** | **bir şablona yazmayı engelledi** |

## Karar — dar

```
KORUNUR    .env · .env.local · .env.development · .env.test
           .env.staging · .env.production · .env.*.local
HARİÇ      .env.example · .env.sample · .env.template
```

> **Daraltma, korumanın KAPSAMINI düzeltiyor — GÜCÜNÜ değil.** Gerçek `.env`
> korumada kalır; şablon dışarı çıkar.

⚠️ Bu cümle gerekçe olarak yazıldı, çünkü bir sonraki okuyucu diff'e bakıp
*"koruma gevşetilmiş"* sanabilir.

## Ölçüm — tanım kaç yerde?

`F1` deseni (*"aynı kural iki yerde, biri güncellenmedi"*) arandı ve **bulunmadı**:

```
.claude/settings.json           ✅ TEK uygulama noktası (permissions.deny)
.claude/settings.local.json     — env/deny anahtarı YOK
~/.claude/settings.json         — permissions anahtarı YOK (yalnız anlatı metni)
CLAUDE.md                       — `.env` kuralı yazılı DEĞİL (oturum talimatında)
```

## ⚠️ Kalan risk — bilinçli ve kayıtlı

Katalog artık **enumerasyon**: `.env.<yeni-ad>` biçiminde **listede olmayan** bir
dosya adı **reddedilmez**. Bu, kaçınılan bir seçimin bedeli — bir *"hariç tut"*
ifadesi bu yapılandırmada yok, `deny` `allow`'u ezer.

**Pratik sonuç:** yeni bir ortam dosyası adlandırması doğarsa (`.env.uat` gibi)
bu listeye **eklenmelidir**. Elle tutulan bir liste — ve bu oturumun `Z9`/`Z10`
dersine göre **bayatlamaya açık** bir yüzey.

📌 Ama fark şu: `Z9`/`Z10`'daki sayılar bayatladığında **sessizdi**. Burada
bayatlama, gerçek bir dosyanın **okunabilir hâle gelmesidir** — yani sessiz değil,
ama fark edilmesi de otomatik değil. **Yeni bir `.env.*` dosyası eklenirse bu
dosyaya bakılır.**

## Kabul kanıtı — iki girdi, iki çıktı

Daraltmadan sonra korumanın **kalktığı değil daraldığı** kanıtlanmalı:

| girdi | beklenen | ÖLÇÜLEN (2026-08-18) |
|---|---|---|
| `collmind.backend/.env.example` oku | izin | ✅ **okundu** — `# Server Configuration / NODE_ENV=development …` |
| `collmind.backend/.env.example` yaz | izin | ✅ **yazıldı** — `SCOPE_ENFORCEMENT_ENABLED=false` bloğu eklendi (26 → 42 satır) |
| `collmind.backend/.env` oku | **RET** | ⛔ **reddedildi** — *"File is in a directory that is denied by your permission settings"* |

> **Koruma DARALDI, KALKMADI.** Sinyal sabit değil: iki farklı girdi, iki farklı
> çıktı (`CLAUDE.md §2.7 #9`).

⚠️ Ve `.env`'in **takip dışı** kaldığı ayrıca doğrulandı — `git status` yalnız
`.env.example`'ı gösteriyor (`M`), `.env` **hiç görünmüyor**. Repo `PUBLIC`.

⚠️ Ve eklenen bloğun **sır taşımadığı** ölçüldü: `.env.example`'daki yorum-dışı her
satır bir yer tutucu (`change-me` · `false` · `localhost` · `app_runtime` ·
`your-secret-key-change-in-production` …) — desen dışı **sıfır** değer.
