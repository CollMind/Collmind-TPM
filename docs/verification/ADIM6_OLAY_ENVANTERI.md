# `ADIM 6` — Bileşen 3: Olay Envanteri (taze, S1–S4 karşılaştırılabilirliği)

**Tarih:** 2026-08-28 · **Ölçen:** backend-engineer (ADIM 6 dalgası)
**Kapsam:** `collmind.backend/src` — kod değiştirilmedi (bu ölçüm için).

## `1` — `107 ↔ 119` FARKININ KAYNAĞI (Z55 §1.1 şartı)

### Yöntem birebir aynı — sayım yöntemi FARKI DEĞİL

```bash
grep -rn "@Post(\|@Patch(\|@Put(\|@Delete(" src --include="*.controller.ts" | wc -l
```
Bugün: **107** (`@Post` 67 · `@Patch` 24 · `@Put` 0 · `@Delete` 16) — `Z51 §5`'in
kendi sayımıyla **birebir**, poz. kontrol `@Get`=112 de birebir aynı.

`ADIM 2` (2026-08-15, `ADIM2_OLCUM_2_4_5.md:67`) **aynı yöntemle** "backend'de
toplam 119 yazma ucu" ölçmüştü.

### Kaynak: 13 günlük GERÇEK kod değişikliği, yöntem farkı DEĞİL

```bash
git log --since="2026-08-15" --until="2026-08-28" -p -- 'src/**/*.controller.ts' \
  | grep -E "^-  *@(Post|Patch|Put|Delete)\("      # 14 satır SİLİNMİŞ
git log --since="2026-08-15" --until="2026-08-28" -p -- 'src/**/*.controller.ts' \
  | grep -E "^\+  *@(Post|Patch|Put|Delete)\("     # 2 satır EKLENMİŞ
```

**Silinen 14:**
```
@Post()                    tenant.controller.ts        (tenant create — T-307 ailesi)
@Delete(':id')             tenant.controller.ts         (T-307-m2: DELETE /tenants/:id öldürüldü)
@Post('reserve')           budget ailesi (iki kez)
@Post()                    (bir controller)
@Patch(':id')              (bir controller)
@Post('check-availability')
@Post('commit')
@Post('release')
@Post('adjust')
@Post('reports/forecast')
@Post(':id/approve')
@Post(':id/reject')
@Post(':id/cancel')
```
**Eklenen 2:** `@Patch(':id/scope')` · `@Patch(':id')` (user.controller.ts — A7/scope
ailesi, T-244).

**Net: -14 + 2 = -12.** `119 - 12 = 107` — **BİREBİR eşleşiyor.**

⇒ **Fark yöntem farkı DEĞİL.** 13 gün içinde gerçek endpoint konsolidasyonu/ölümü
oldu (bütçe rezervasyon uçlarının birleşmesi, `T-307-m2`'nin tenant DELETE'i
öldürmesi, agreement approve/reject/cancel akışının başka bir mekanizmaya taşınması
— `route-cell-map`/`single-mechanism` guard ailesinin konusu). `DISIPLIN`: *"bir
sayım farkı kaynağı gösterilmeden yorumlanamaz"* — **kaynak yukarıda, git diff ile
gösterildi.**

## `2` — DENETİM ÜRETEN UÇLAR: `15 → 17` (kaynağı gösterilen ARTIŞ)

```bash
grep -rn "\.logAdminAction(" src --include="*.ts" | grep -v ".spec.ts" | wc -l   # 17
grep -rln "\.logAdminAction(" src --include="*.ts" | grep -v ".spec.ts" | wc -l  # 7 dosya
```
`ADIM 2`: *"15 üretim çağrı noktası"* (2026-08-15). Fark kaynağı:
```bash
git log --since="2026-08-15" --until="2026-08-28" -p -- 'src/**/*.service.ts' \
  | grep -E "^[-+].*\.logAdminAction\("
# +2, -0  →  15 + 2 = 17
```
İki yeni çağrı `user.service.ts`'te (`A7`/`T-244`: `SCOPE_UPDATE`/`SCOPE_REVOKE_ALL`,
`DENETIM_SOZLUGU.md Madde 1`). **Fark de kaynağı gösterilerek kapatıldı.**

## `3` — BİLİNEN BOŞLUKLAR (ADIM 2 bulgusu, TAZE ölçümle doğrulandı)

| boşluk | ADIM 2 (08-15) | bugün (08-28) |
|---|---|---|
| plan yaşam-döngüsü → denetim üretimi | SIFIR | ✅ **hâlâ SIFIR** (7 üretici dosya arasında `plan.service.ts` yok) |
| auth (giriş/çıkış/yetki reddi) → denetim üretimi | SIFIR | ✅ **hâlâ SIFIR** (`auth.controller.ts`/`.service.ts` üretici listesinde yok) |
| `§2.5` sessiz atlama (`if (adminId && adminEmail)`, `else` yok) | 6 vaka (mechanic ×3, channel ×3) | ✅ **hâlâ 6** (channel.service.ts'te değişken adı `userId`/`userEmail` — aynı desen, farklı isim) |
| `app_runtime`'da `DELETE`/`UPDATE` yok ama SAHİBE karşı koruma yok | — | ✅ doğrulandı: `admin_audit_logs` üzerinde `app_runtime`/`app_operator`'a DELETE/UPDATE GRANT'i yok (`information_schema.role_table_grants` boş döndü) — ama tablo sahibi `app_migrate`'in kendisi hâlâ sınırsız (owner muafiyeti, `Z54`'ün konusu, `FORCE` aktivasyon dalgasında kapanacak) |
| `K-2.11.7` (DB-seviyesi immutability) mekanizma yok | trigger=0 | ✅ **hâlâ 0** (`information_schema.triggers WHERE event_object_table='admin_audit_logs'` → 0) |

## `4` — YAPILMAYAN: 107 UCUN TAMAMININ `S1–S4` SINIFLANDIRMASI

`ADIM 2` `S1–S4`'ü yalnız `modules/master-data` (39 uç) için uyguladı. Bu turda
`§1`'in kaynak-gösterimli farkı kapatması (`git diff`) `S1–S4`'ü YENİDEN
uygulamadan da 107↔119 farkını **kapatıyor** (fark bir sınıflandırma
metodolojisi anlaşmazlığı değil, ölçülebilir kod değişikliği).

⛔ **Ama bu, master-data DIŞINDAKİ 68 ucun (107-39) `S1`(CollMind-sahipli)/`S2`
(ERP-sahipli)/`S3`(yan etkisiz)/`S4`(toplu konfigürasyon) sınıflandırmasını
YAPMADI.** Bu, her modülün veri sahipliğini (CollMind mi ERP mi besliyor)
tek tek bilmeyi gerektiren bir alan-bilgisi işidir — `agreements`/`settlements`/
`ledger`/`plans` gibi actuals-first/planning-first çekirdek modülleri byounded
context'lerinde CollMind-sahipli görünüyor (S1 adayı), ama bunu ADIM 2'nin
titizliğiyle (her ucu tek tek okuyup) doğrulamak bu turun bütçesinde DEĞİLDİ.

**Açık iş, TASK olarak kaydedilmeli** (DISIPLIN: "bilinen eksiklik TODO ile değil,
TASK ile kaydedilir") — `T-311`/yeni bir task'a: *"master-data dışındaki 68 yazma
ucunun S1–S4 sınıflandırması ve denetim-üretim boşluk haritası"*.
