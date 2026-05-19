# Proje 04 — Solution (features.json + verify + WIP=1)

## Durum

`features.json` artik bir primitif. Liste insan icin not degil, sistem icin veri yapisidir. `scripts/verify.sh` durumlari otomatik gunceller. WIP=1 kurali `AGENTS.md`'de yazili ve script tarafindan zorlanir.

## Bilesenler

- `features.json` — id, behavior, verification, state, depends_on, evidence alanlariyla makine okunabilir liste.
- `scripts/verify.sh` — `jq` ile aktif feature'i bulur, dogrulama komutunu calistirir, sifir cikis kodunda durumu `passing`'e dondurur ve dosyayi yerinde gunceller. WIP=1 ihlali gorurse erken cikar.
- `AGENTS.md` icinde "Feature Liste Kurallari" blogu — durum makinesi, pass-state kapisi, VCR kurali.
- `make verify` Makefile hedefi.

## Ozellik durum makinesi

```
not_started -> active -> passing
                 |
                 +--> blocked --> active (engel kalkinca)
```

Kurallar:

- WIP=1: ayni anda yalniz bir feature `active`.
- Geri alinmazlik: `passing` durumu manuel degistirilemez.
- Otomatik gecis: yalniz dogrulama komutu sifir cikis koduyla bittiginde `passing` yazilir.

## Hizli baslangic

```bash
bash init.sh
make setup
make test
make verify   # aktif feature varsa dogrulama komutunu calistirir
```

## Gozlem

- VCR (verified completion rate) `init.sh` ciktisinda durum dagilimindan hesaplanabilir.
- Bir oturum acildiginda hangi feature `active`, hangileri `blocked` net gorulur; oturum acilis teshis suresi `~3 dk` mertebesindedir.
