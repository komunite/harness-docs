.PHONY: setup dev test verify check clean

setup:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

dev:
	. .venv/bin/activate && uvicorn app:app --reload --port 8000

# Executor'in hizli geri besleme komutu. Tamamlanma yargisi degildir.
test:
	. .venv/bin/activate && pytest

# Verifier'in tam dogrulama kapisi: lint -> unit -> e2e siralamasi.
verify:
	. .venv/bin/activate && bash scripts/three_layer_check.sh

# CI ve teslim yargisi yalniz buna bakar.
check: verify
	@echo "verifier=passing"

clean:
	rm -f notes.db
	rm -rf .venv .pytest_cache __pycache__ tests/__pycache__
