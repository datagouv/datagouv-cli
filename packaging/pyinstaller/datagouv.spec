# -*- mode: python ; coding: utf-8 -*-
"""PyInstaller spec for the datagouv CLI standalone binary (onedir layout)."""

from pathlib import Path

from PyInstaller.utils.hooks import collect_all, collect_submodules

block_cipher = None
project_root = Path(SPECPATH).resolve().parent.parent

hiddenimports = collect_submodules("datagouv_cli")
hiddenimports += collect_submodules("datagouv")
hiddenimports += [
    "typer",
    "rich",
    "shellingham",
    "tenacity",
    "niquests",
    "urllib3_future",
    "jh2",
    "qh3",
    "wassima",
    "charset_normalizer",
]

datas = []
binaries = []
for package in ("datagouv", "datagouv_cli"):
    pkg_datas, pkg_binaries, pkg_hiddenimports = collect_all(package)
    datas += pkg_datas
    binaries += pkg_binaries
    hiddenimports += pkg_hiddenimports

a = Analysis(
    [str(project_root / "datagouv_cli" / "__main__.py")],
    pathex=[str(project_root)],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        "datagouv.cli",
        "datagouv.commands",
        "datagouv.config",
        "datagouv._cli_shim",
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
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

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name="datagouv",
)
