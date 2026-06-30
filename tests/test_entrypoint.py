import typer
from datagouv.cli import app


def test_app_is_typer_instance() -> None:
    assert isinstance(app, typer.Typer)


def test_main_module_imports() -> None:
    import datagouv_cli.__main__  # noqa: F401
