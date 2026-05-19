# otel_setup.py — tam OpenTelemetry kurulumu.
# Console exporter kullaniyoruz; harici bir collector kurmadan stdout'a span akar.
# GenAI semconv attribute'lari (gen_ai.system, gen_ai.operation.name) handler'larda
# her span'e set ediliyor — tasinabilirlik icin standart kalmali.
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter
from opentelemetry.sdk.resources import Resource

# Resource — servis kimligi her span'e otomatik baglanir.
_resource = Resource.create(
    {
        "service.name": "notes-api",
        "service.version": "0.1.0",
    }
)

# Global provider'i bir kez kuruyoruz. Idempotent: import birden fazla kez
# yapilirsa ikinci kez set_tracer_provider cagrisini atla.
_provider = trace.get_tracer_provider()
if not isinstance(_provider, TracerProvider):
    _provider = TracerProvider(resource=_resource)
    _provider.add_span_processor(BatchSpanProcessor(ConsoleSpanExporter()))
    trace.set_tracer_provider(_provider)

# Modul seviyesinde paylasilan tracer. app.py bunu import eder.
tracer = trace.get_tracer("notes-api")


# GenAI semconv attribute set helper'i. Spec hala Development statusunde;
# isim degisirse tek bir yerden guncellenir.
def set_genai_attrs(span, operation_name: str) -> None:
    span.set_attribute("gen_ai.system", "notes-api")
    span.set_attribute("gen_ai.operation.name", operation_name)
