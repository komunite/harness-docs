.PHONY: setup dev test check verify clean

setup:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

dev:
	. .venv/bin/activate && uvicorn app:app --reload --port 8000

test:
	. .venv/bin/activate && pytest

verify:
	bash scripts/verify.sh

check:
	bash three_layer_check.sh

clean:
	rm -f notes.db notes.db-journal
	rm -rf .venv .pytest_cache __pycache__ tests/__pycache__
