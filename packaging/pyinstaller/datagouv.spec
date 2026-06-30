# -*- mode: python ; coding: utf-8 -*-
"""PyInstaller spec for the datagouv CLI standalone binary."""

from pathlib import Path

block_cipher = None
project_root = Path(SPECPATH).resolve().parent.parent

a = Analysis(
    [str(project_root / "datagouv_cli" / "__main__.py")],
    pathex=[str(project_root)],
    binaries=[],
    datas=[],
    hiddenimports=[
        "datagouv",
        "datagouv.cli",
        "datagouv.commands",
        "datagouv.commands.dataset",
        "datagouv.commands.organization",
        "datagouv.commands.resource",
        "datagouv.commands.topic",
        "datagouv.commands.utils",
        "datagouv.config",
        "datagouv.api.client",
        "datagouv.api.dataset",
        "datagouv.api.organization",
        "datagouv.api.resource",
        "datagouv.api.topic",
        "datagouv.utils.base_object",
        "datagouv.utils.retry",
        "typer",
        "rich",
        "click",
        "shellingham",
        "httpx",
        "httpcore",
        "anyio",
        "certifi",
        "tenacity",
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name="datagouv",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
