# AGENTS.md — Notes API

Bu repo bir Notes API'sidir. Ajan asagidaki kurallarla calisir.

## Oturum acilisi

- Once `bash init.sh` cikitisini oku.
- `PROGRESS.md`, son 30 satir `DECISIONS.md`, `features.json` durum dagilimi, `git status` taranir.
- Hicbir sey degistirmeden once ne yapilacagi tek cumlede yazilir.

## Kod sozlesmesi

- API kurallari: `docs/api-patterns.md`
- Veritabani kurallari: `docs/database-rules.md`
- Guvenlik kurallari: `docs/security.md`
- Bu uc dosya birbirinden bagimsiz okunabilmelidir; cakistiklarinda en sert kural gecerlidir.

## Calistirma sozlesmesi

- Her degisiklikten sonra `make test`.
- Aktif feature uzerinde calisirken `make verify` ile dogrulama komutu calistirilir.
- Test ve verify yesil olmadan commit atilmaz.
- Yeni bagimlilik eklenmesi `DECISIONS.md`'ye not gerektirir.

## Feature Liste Kurallari

- Feature kaynak dosyasi: `features.json` (insan icin not degil, sistem icin primitiftir).
- Durumlar: `not_started`, `active`, `blocked`, `passing`.
- **WIP=1 invariant**: ayni anda yalniz tek bir feature `active` olabilir.
  - `scripts/verify.sh` bu kurali zorlar; birden cok `active` gorurse hicbir is yapmadan cikar.
- **Pass-state kapisi**: ajan kendi basina `passing` yazamaz.
  - Yalniz `scripts/verify.sh` durumu `passing`'e dondurur.
  - Dogrulama komutu sifir cikis kodu vermeden `passing` yok.
- VCR (verified completion rate) sub 1.0 iken yeni feature `active`'e alinamaz.
- `blocked` bir feature varsa, yeni feature acmadan once engel kaldirilir.
- Yeni feature ekleme yalniz init fazinda veya acik kullanici talebiyle.

## Kapanis sozlesmesi

- `PROGRESS.md` guncellenir: mevcut odak, son oturum kararlari, sonraki adim.
- Veri kaybi potansiyeli olan karar `DECISIONS.md`'ye eklenir.
- `git status` temiz birakilir (yarim kalan dosya stash veya commit).
- Aktif feature varsa `state` `active` veya `blocked` olarak birakilir; bos aktif bos kalmaz.
