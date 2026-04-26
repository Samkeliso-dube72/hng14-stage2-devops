from fastapi.testclient import TestClient
from main import app
from unittest.mock import MagicMock

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_create_job(monkeypatch):
    mock_redis = MagicMock()
    monkeypatch.setattr("main.r", mock_redis)

    response = client.post("/jobs")
    assert response.status_code == 200
    assert "job_id" in response.json()


def test_get_job(monkeypatch):
    mock_redis = MagicMock()
    mock_redis.hget.return_value = "completed"
    monkeypatch.setattr("main.r", mock_redis)

    response = client.get("/jobs/test-id")
    assert response.status_code == 200
    assert response.json()["status"] == "completed"
