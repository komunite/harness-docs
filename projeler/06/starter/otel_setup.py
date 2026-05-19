# otel_setup.py — YARIM BIRAKILMIS GIRISIM
# Bir onceki vardiyadaki ajan OpenTelemetry eklemeye baslamis ama bitirmemis.
# Tracer provider yok, exporter yok, sadece None bir referans var.
# Bu dosyayi import eden her yer sessizce kirik:
# tracer.start_as_current_span(...) cagrildigi an AttributeError firlatir.

from opentelemetry import trace

# TODO: tracer provider ve exporter ekle
# TODO: tracer = trace.get_tracer("notes-api") olmali
tracer = None  # broken; asagidaki app.py bunu kullanmak istiyor
