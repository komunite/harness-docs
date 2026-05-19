import os
import tempfile
import pytest
from fastapi.testclient import TestClient


@pytest.fixture()
def client(monkeypatch):
    # Her test izole bir SQLite dosyasi alir; sizinti olmaz.
    tmp = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
    tmp.close()
    monkeypatch.setenv("DB_PATH", tmp.name)
    monkeypatch.setenv("API_TOKEN", "test-token")
    # app modulu env'i import sirasinda okur; bu yuzden reload sart.
    import importlib
    import app as app_module
    importlib.reload(app_module)
    with TestClient(app_module.app) as c:
        yield c
    os.unlink(tmp.name)


@pytest.fixture()
def auth_headers():
    return {"Authorization": "Bearer test-token"}
