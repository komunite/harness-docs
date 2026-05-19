# Decisions

## D01 — SQLite varsayilan depolama

- **Karar:** Kapsam dahili oldugu surece SQLite kullan.
- **Gerekce:** Sifir bagimlilik, test ortami icin yeterli.
- **Alternatif:** Postgres — fazla erken bir karmasiklik.

## D02 — Bearer auth, tek token

- **Karar:** Env'den okunan tek token ile Bearer auth.
- **Gerekce:** Capstone scope'u; gercek auth provider kapsam disi.

## D03 — OpenTelemetry GenAI semconv

- **Karar:** Trace standardi OTel GenAI semconv olacak.
- **Gerekce:** Tasinabilirlik; AgentOps/Inspect AI gibi araclar ayni attribute'lari okur.
- **Statu:** Hala "Development". `OTEL_SEMCONV_STABILITY_OPT_IN` ile gecis gerekli olabilir.

## D04 — ConsoleSpanExporter (capstone icin yeterli)

- **Karar:** Harici collector kurmadan stdout'a span yazdir.
- **Gerekce:** Egitim/demo ortami; ek altyapi bagimliligi yok.
- **Alternatif:** OTLP exporter + Jaeger — ileri proje icin.
