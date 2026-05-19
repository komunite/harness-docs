# Capstone — starter

Onceki projeden (P05 solution) devraldik. Bes aparat yerinde:

- Repo: `AGENTS.md`, `docs/`, `DECISIONS.md`
- Durum: `init.sh`, `PROGRESS.md`, `features.json`
- Calisma zamani geri bildirimi: `make test`, `make verify`, `three_layer_check.sh`
- Oz-dogrulama: `executor.md` ile `verifier.md` rol ayrimi
- Gozlemlenebilirlik: **yarim**

Birinin OTel eklemeye basladigini goruyoruz ama yarim:

- `otel_setup.py` icinde `tracer = None`. Tracer provider kurulumu yok, exporter yok.
- `app.py` `from otel_setup import tracer` yapiyor ama hicbir `tracer.start_as_current_span(...)` cagrisi yok — cunku eklense `AttributeError` ile patlar.
- Sonuc: **gozlemlenebilirlik aparatı sozde var, gercekte yok.** App calisiyor, testler yesil, ama bir hata olusursa neden oldugunu trace ile takip etmek mumkun degil.

## Ilk gorev

`features.json` icindeki `F06 OpenTelemetry instrumentation` durumu `TODO`. Tamamla:

1. `otel_setup.py`: `TracerProvider`, `BatchSpanProcessor`, `ConsoleSpanExporter` kur. `tracer = trace.get_tracer("notes-api")`.
2. `app.py`: HTTP middleware'i parent span, her handler kendi child span'i. GenAI semconv attribute'lari (`gen_ai.system`, `gen_ai.operation.name`).
3. `make verify` cikti uretirken stdout'a OTel span'lari dusmeli.
4. `features.json` icinde `F06`'yi `DONE` yap.
5. `PROGRESS.md` ve gerekiyorsa `DECISIONS.md` guncellenir.

## Hizli baslangic

```bash
bash init.sh
make test
make verify
```

## Sira

`AGENTS.md` -> `PROGRESS.md` -> `features.json` -> kod.
