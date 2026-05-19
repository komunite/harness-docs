# Progress

## Bugun (devraldigim oturum)

- P05 solution'i devraldim. Tum testler yesil, e2e yesil.
- Onceki ajan OTel eklemeye baslamis ama bitirmemis:
  - `otel_setup.py` icinde tracer None.
  - `app.py` icinde import var, decorator yok.
- Bu hali ile app calisiyor (None tracer hic cagrilmiyor) ama gozlemlenebilirlik **sozde** var.

## Sirada

- F06 OpenTelemetry instrumentation — TODO.
  - tracer provider + ConsoleSpanExporter kur.
  - Middleware span'i + handler basina child span ekle.
  - GenAI semconv attribute'lari (gen_ai.system, gen_ai.operation.name).
  - `make verify` koshtugunda stdout'a span dusmeli.

## Bloklar

- Yok.
