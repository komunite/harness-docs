.PHONY: setup dev test check

setup:
	python -m pip install -r requirements.txt

dev:
	uvicorn app:app --reload

test:
	pytest -q

check:
	pytest -q
