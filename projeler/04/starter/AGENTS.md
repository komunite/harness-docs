# AGENTS.md — Notes API

Bu repo bir Notes API'sidir. Ajan asagidaki kurallarla calisir.

## Oturum acilisi

- Once `bash init.sh` cikitisini oku.
- `PROGRESS.md`, son 30 satir `DECISIONS.md`, `features.md`, `git status` taranir.
- Hicbir sey degistirmeden once ne yapilacagi tek cumlede yazilir.

## Kod sozlesmesi

- API kurallari: `docs/api-patterns.md`
- Veritabani kurallari: `docs/database-rules.md`
- Guvenlik kurallari: `docs/security.md`
- Bu uc dosya birbirinden bagimsiz okunabilmelidir; cakistiklarinda en sert kural gecerlidir.

## Calistirma sozlesmesi

- Her degisiklikten sonra `make test`.
- Test yesil olmadan commit atilmaz.
- Yeni bagimlilik eklenmesi `DECISIONS.md`'ye not gerektirir.

## Ozellik takibi (serbest form)

- Mevcut ozellikler `features.md` icinde insan dilinde listelidir.
- Hangi ozellik tamam, hangi yarim, hangi engelli — dosya su an buna deterministik cevap vermiyor.

## Kapanis sozlesmesi

- `PROGRESS.md` guncellenir: mevcut odak, son oturum kararlari, sonraki adim.
- Veri kaybi potansiyeli olan karar `DECISIONS.md`'ye eklenir.
- `git status` temiz birakilir (yarim kalan dosya stash veya commit).
