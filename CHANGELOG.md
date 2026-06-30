# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- CLI code migrated from `datagouv_client` (`cli.py`, `config.py`, `commands/`).
- Tests for config loading and CLI entrypoint.

### Changed

- Entry point now uses `datagouv_cli.cli:app` instead of `datagouv.cli:app`.
- Depends on `datagouv-client>=0.4.0` (library without embedded CLI).
- PyInstaller spec uses `collect_all` for `datagouv` and `datagouv_cli` packages.

## [0.1.1] - prior packaging-only releases

Initial standalone binary distribution wrapping CLI from `datagouv_client`.
