.PHONY: setup dev test check clean

setup:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

dev:
	. .venv/bin/activate && uvicorn app:app --reload --port 8000

test:
	. .venv/bin/activate && pytest

check: test
	@echo "ok"

clean:
	rm -f notes.db
	rm -rf .venv .pytest_cache __pycache__ tests/__pycache__
