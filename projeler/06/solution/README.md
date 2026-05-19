# Capstone — solution

Tum bes aparat + runtime gozlemlenebilirligi + temiz teslim.

## Bes aparat

1. **Repo** — `AGENTS.md`, `docs/`, `DECISIONS.md`, `Quality.md`, `sprint-contracts/`.
2. **Durum** — `init.sh`, `PROGRESS.md`, `features.json`.
3. **Calisma zamani geri bildirimi** — `make test`, `make verify`, `three_layer_check.sh`.
4. **Oz-dogrulama** — `executor.md` ile `verifier.md` rol ayrimi.
5. **Gozlemlenebilirlik** — `otel_setup.py` (TracerProvider + ConsoleSpanExporter) + `app.py` middleware/handler span'leri (GenAI semconv).

Ek olarak: **temiz teslim** — `scripts/session_close.sh` (bes boyut) ve `scripts/cleanup.sh` (idempotent).

## Hizli baslangic

```bash
bash init.sh
make check                        # uc katman
bash scripts/session_close.sh     # bes boyut
```

## OTel ciktisi

`make verify` koshturuldugunda console exporter span'lari stdout'a yazar. Ornek satir:

```
{"name": "POST /notes", "context": {...}, "attributes": {"http.method": "POST", "gen_ai.system": "notes-api", "gen_ai.operation.name": "http.request", ...}}
```

Her HTTP istegi bir parent span, her handler bir child span. Hata olusursa hangi katmanda (middleware mi, handler mi, DB mi) gerceklestigi trace agacinda dogrudan gorunur.

## Quality.md

Modul basina A/B/C notu. En dusuk puanli modul `&larr; Once buraya gir` ile isaretli. Sonraki vardiya nereden baslayacagini sezgiyle degil kanitla secer.

## Oturum kapanisi

```bash
bash scripts/session_close.sh
```

Bes boyutu (Build / Test / Progress / Artifact / Startup) tek tek dogrular. Bir tanesi kirilirsa oturum kapanmaz.

## Sira

`AGENTS.md` -> `PROGRESS.md` -> `DECISIONS.md` -> `Quality.md` -> `features.json` -> kod.
