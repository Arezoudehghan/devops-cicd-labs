import pytest

from app import app


@pytest.fixture()
def client():
    app.config.update(TESTING=True)

    with app.test_client() as test_client:
        yield test_client


def test_home(client, monkeypatch):
    monkeypatch.setenv("APP_ENV", "testing")

    response = client.get("/")

    assert response.status_code == 200
    assert response.get_json()["environment"] == "testing"


def test_health(client, monkeypatch):
    monkeypatch.setenv("APP_ENV", "testing")
    monkeypatch.setenv("APP_VERSION", "test-sha")

    response = client.get("/health")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status"] == "ok"
    assert data["environment"] == "testing"
    assert data["version"] == "test-sha"
