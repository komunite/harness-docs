.PHONY: setup dev test check verify clean session-close

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

session-close:
	bash scripts/session_close.sh

clean:
	bash scripts/cleanup.sh
	rm -rf .venv .pytest_cache __pycache__ tests/__pycache__
