# Proje 04 — Starter (Serbest Formda Ozellikler)

## Durum

Notes API canonical hali calisiyor. `/notes/search` ucu parametreli sorgu ile guvenli; testler aktif ve gecer durumda.

Ozellikler insanlar icin bir markdown listesi (`features.md`). Hangisi tamamlandi, hangisi yarim, hangisi engellendi — bilinmiyor. Liste prozadir, makine okuyamaz, durum etiketi yoktur.

## Sorunlar

- `features.md` icindeki notlar belirsiz: "devam ediyor?", "henuz baslanmadi", "belirsiz".
- Hangi ozelligin uctan uca dogrulandigini soyleyen bir kontrol yok.
- Ajanlar oturum acilisinda once 10-15 dakika "neredeyim" arar.
- Birden fazla ozellik ayni anda yarim baslayabilir; WIP=1 zorlayan mekanik kapi yok.
- "passing" iddiasi ile gercek aralarinda kanit yok.

## Hedef

`solution/` icinde ayni proje:

- `features.md` yerine `features.json` — id, behavior, verification, state, depends_on, evidence ile yapilandirilmis.
- `scripts/verify.sh` — aktif ozelligi calistirir, sifir cikis kodunda `state` alanini `passing`'e dondurur.
- WIP=1 mekanik kilit: ayni anda birden cok `active` varsa script erken cikar.
- `AGENTS.md` icinde "Feature Liste Kurallari" blogu.

## Hizli baslangic

```bash
bash init.sh
make setup
make test
```
