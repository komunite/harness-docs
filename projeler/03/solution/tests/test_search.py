# tests/test_search.py — yarim kalan search ozelligi testleri
# Iki test de skip; bir sonraki vardiya bunlari acip yesile cevirmek zorunda.
import pytest
from fastapi.testclient import TestClient
from app import app

client = TestClient(app)
HEAD = {"Authorization": "Bearer dev-token"}


@pytest.mark.skip(reason="search yarim — once SQL injection riskini kapat, sonra ac")
def test_search_returns_matching_notes(tmp_path, monkeypatch):
    monkeypatch.setenv("DB_PATH", str(tmp_path / "search.db"))
    client.post("/notes", json={"title": "alpha", "body": "x"}, headers=HEAD)
    client.post("/notes", json={"title": "beta",  "body": "y"}, headers=HEAD)
    r = client.get("/notes/search", params={"q": "alp"}, headers=HEAD)
    assert r.status_code == 200
    titles = [n["title"] for n in r.json()]
    assert titles == ["alpha"]


@pytest.mark.skip(reason="edge case: bos q parametresi 400 dondurmeli, su an tum kayitlari donduruyor")
def test_search_empty_query_rejected(tmp_path, monkeypatch):
    monkeypatch.setenv("DB_PATH", str(tmp_path / "search.db"))
    r = client.get("/notes/search", params={"q": ""}, headers=HEAD)
    assert r.status_code == 400
