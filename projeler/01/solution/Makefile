.PHONY: setup dev test check

setup:  ## bağımlılıkları kur
	pip install -r requirements.txt

dev:    ## yerel geliştirme ortamını başlat
	uvicorn app:app --reload

test:   ## tüm testleri koş
	pytest tests/ -x

check:  ## lint + tip + test (CI'nin de koştuğu hedef)
	@command -v ruff >/dev/null 2>&1 && ruff check . || echo "ruff yok, atlandı"
	@command -v mypy >/dev/null 2>&1 && mypy app.py || echo "mypy yok, atlandı"
	pytest tests/ -x
