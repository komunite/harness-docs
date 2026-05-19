# Runbook

## Ilk kurulum

```
bash init.sh
make setup
```

## Gunluk akis

```
make dev        # gelistirme sunucusu
make test       # birim testler
make verify     # e2e
make check      # uc katman
```

## Sorun giderme

- `make test` patliyor: `make clean && make setup`.
- Port dolu: `PORT=8766 bash scripts/verify.sh`.
- DB kirli: `rm -f notes.db notes.db-journal`.
- OTel ciktisi gorunmuyor: `otel_setup.py` icinde `tracer` None mi kontrol et.
