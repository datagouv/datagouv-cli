import json

from datagouv_cli import config


def test_save_and_load_config(tmp_path, monkeypatch) -> None:
    config_path = tmp_path / ".datagouv_config.json"
    monkeypatch.setattr(config, "CONFIG_PATH", config_path)

    config.save_config("demo", "secret-key")
    loaded = config.load_config()

    assert loaded["environment"] == "demo"
    assert loaded["api_key"] == "secret-key"
    assert loaded["headers"]["User-Agent"].startswith("datagouv-cli/")


def test_load_config_without_file(tmp_path, monkeypatch) -> None:
    config_path = tmp_path / ".datagouv_config.json"
    monkeypatch.setattr(config, "CONFIG_PATH", config_path)

    loaded = config.load_config()

    assert "environment" not in loaded
    assert loaded["headers"]["User-Agent"].startswith("datagouv-cli/")


def test_delete_config(tmp_path, monkeypatch) -> None:
    config_path = tmp_path / ".datagouv_config.json"
    monkeypatch.setattr(config, "CONFIG_PATH", config_path)
    config_path.write_text(json.dumps({"environment": "prod"}))

    config._delete_config()

    assert not config_path.exists()
