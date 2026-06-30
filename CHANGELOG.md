# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- CLI code migrated from `datagouv_client` (`cli.py`, `config.py`, `commands/`).
- Tests for config loading and CLI entrypoint.

### Changed

- Entry point now uses `datagouv_cli.cli:app` instead of `datagouv.cli:app`.
- Depends on `datagouv-client>=0.4.0,<0.5.0` from PyPI (library-only; CLI lives in this repo).
- PyInstaller spec uses `collect_all` for `datagouv` and `datagouv_cli` packages; HTTP hidden imports updated for `niquests` (replacing legacy `httpx` stack).

## [0.1.1] - prior packaging-only releases

Initial standalone binary distribution wrapping CLI from `datagouv_client`.
