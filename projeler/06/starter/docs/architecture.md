# Mimari

## Bilesenler

- **app.py** — FastAPI uygulamasi. Notes endpointleri + Bearer auth.
- **otel_setup.py** — OpenTelemetry tracer provider ve exporter kurulumu.
- **scripts/verify.sh** — Uctan uca HTTP davranis testi.
- **three_layer_check.sh** — Statik + birim + e2e uc katmanli kapi.

## Sinirlar

- HTTP katmani ile depolama tek dosyadadir (sqlite3). Buyume halinde `db.py`'ye ayrilir.
- OTel kurulumu app'ten ayri bir modulde. App, sadece `tracer`'i import eder.

## Veri akisi

```
Client -> FastAPI middleware (root span)
            -> auth dependency
            -> handler (child span)
                  -> sqlite3 conn
            -> response
```
