# Recipe — Gözlemlenebilirliği bağlamak

Mevcut bir düzeneğe OpenTelemetry GenAI semconv uyumlu iz iskeletini eklemek.

## Hedef

Her oturum için tek bir trace ID. Her feature span olur, her doğrulama adımı alt span olur. Aracın değişmesinden bağımsız tek standart: trace per session, span per feature, sub-span per verify step.

## Önkoşullar

- Python projesi (Node/Go şablonları için "Özelleştirme" bölümü).
- `opentelemetry-api`, `opentelemetry-sdk` yüklü veya yüklenebilir.
- `verifier.md` ve `three_layer_check.sh` mevcut — gözlemlenebilirlik bunların üzerine biner.

## Adımlar

### 1. Paketleri yükle

```bash
pip install \
  opentelemetry-api \
  opentelemetry-sdk \
  opentelemetry-exporter-otlp \
  opentelemetry-instrumentation-fastapi
```

İlk koşumda Jaeger gibi bir backend olmayabilir; console exporter ile başla, sonra OTLP'ye geç.

### 2. otel_setup.py — tek dosyada provider

`otel_setup.py` adıyla repo köküne dosya yarat:

```python
import os
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter
from opentelemetry.sdk.resources import Resource

os.environ.setdefault("OTEL_SEMCONV_STABILITY_OPT_IN", "gen_ai_latest_experimental")

resource = Resource.create({"service.name": "duzenek-harness"})
provider = TracerProvider(resource=resource)
provider.add_span_processor(BatchSpanProcessor(ConsoleSpanExporter()))
trace.set_tracer_provider(provider)

tracer = trace.get_tracer("duzenek.harness", "0.1.0")
```

Console exporter stdout'a yazar; ilk faz için yeterli. OTLP'ye geçince `OTLPSpanExporter` ile değiştir.

### 3. Uygulamaya middleware bağla

FastAPI örnek:

```python
from fastapi import FastAPI, Request
from otel_setup import tracer

app = FastAPI()

@app.middleware("http")
async def trace_middleware(request: Request, call_next):
    with tracer.start_as_current_span(f"http {request.method} {request.url.path}") as span:
        span.set_attribute("http.method", request.method)
        span.set_attribute("http.route", request.url.path)
        response = await call_next(request)
        span.set_attribute("http.status_code", response.status_code)
        return response
```

Span ağacının orta katmanı bu middleware ile doğal olarak oluşur.

### 4. Verifier scriptine session span'ı sar

`scripts/verify.sh` koşmadan önce session trace ID üret:

```bash
export HARNESS_SESSION_ID="session-$(date -u +%Y%m%d-%H%M%S)"
```

Uygulama bu env'i okuyup span attribute'una eşler:

```python
SESSION_ID = os.environ.get("HARNESS_SESSION_ID", "session-local")
span.set_attribute("gen_ai.conversation.id", SESSION_ID)
span.set_attribute("harness.session.id", SESSION_ID)
```

### 5. Üç doğrulama adımına span ekle

`three_layer_check.sh` koşumlarını ayrı span'lara böl. Python verifier varsa:

```python
with tracer.start_as_current_span("verify lint") as s:
    s.set_attribute("harness.verify.step", "lint")
    # ... koş, sonuç attribute'una yaz
```

Bash içinde direkt span yapamazsın; ama Python wrapper'la sarabilirsin. Veya log satırlarına trace ID echo et ki sonradan eşle.

### 6. Duman testi

```bash
make verify
```

stdout'ta GenAI semconv attribute'larını ara:

```
gen_ai.operation.name = http
gen_ai.conversation.id = session-20260518-...
harness.feature.id = F01
harness.verify.step = e2e
```

Bu satırlar görünmüyorsa exporter sessizleştirilmiş veya middleware bağlanmamış. otel_setup.py'nin import edildiğinden emin ol — `import otel_setup` yetmez, `from otel_setup import tracer` ile gerçek yüklemeyi tetikle.

### 7. AGENTS.md'ye kural ekle

```markdown
## Gozlemlenebilirlik

- OTel ciktisi sessize alinmaz; console exporter trace'leri stdout'a
  yazar. Bu bir bug degil, bir aparat.
- Her oturum bir trace ID; her feature span; her verify adimi alt span.
- gen_ai.* attribute'lari semconv'a baglidir; harness.* namespace'i
  duzenege ozgudur. Ikisi karismaz.
```

## Kanıt

- `make verify` çıktısında en az bir `gen_ai.operation.name` görünür.
- `harness.session.id` her koşumda farklı bir değer alır.
- Verify adımları span olarak görünür (lint/unit/e2e ayrı).
- Hata durumunda span `status: error` taşır; root cause span ağacında izlenir.

## Yaygın hatalar

- **Span yok ama hata da yok** — Provider set edilmemiş. `trace.set_tracer_provider(provider)` çağrısı atlanmış. `otel_setup.py`'nin app.py'den önce import edildiğinden emin ol.
- **`gen_ai.*` attribute'ları görünmüyor** — `OTEL_SEMCONV_STABILITY_OPT_IN` env'i set edilmemiş. Stabilite hala Development; opt-in zorunlu.
- **OTLP exporter sessiz** — Backend (Jaeger) ayakta değilse OTLP exporter retry'da takılır, çıktı yer. Console exporter ile başla, sonra OTLP'ye geç.
- **harness.* ile gen_ai.* karışıyor** — Namespace disiplini. Standart isimler aracın işidir, namespace isimleri düzeneğin. İkisi karışırsa downstream analiz kırılır.

## Özelleştirme

- **Node.js**: `@opentelemetry/api`, `@opentelemetry/sdk-node`. Span isimleri ve attribute setleri aynı.
- **Go**: `go.opentelemetry.io/otel`. SDK ergonomisi farklı, semconv aynı.
- **Cost kontrolü**: `ParentBased(TraceIdRatioBased(0.1))` ile başarılı trace'lerin %10'unu sample'la; hata içeren trace'ler her zaman tutulur.
