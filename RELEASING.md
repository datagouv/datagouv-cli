# Releasing datagouv-cli

This document describes how to publish a new version of the standalone CLI distribution.

`datagouv-cli` is **not published on PyPI**. Users install it via apt, Homebrew, or GitHub Release binaries.

The build resolves `datagouv-client` from **PyPI** (see `pyproject.toml`). CI does not clone `datagouv_client`.

## Library dependency

Current constraint: `datagouv-client>=0.4.0,<0.5.0` (PyPI **0.4.x**, library-only; CLI code lives in this repo).

When a new **`datagouv-client`** version is published on PyPI, update **this repo** (`datagouv-cli`) to pick it up:

```bash
uv lock --upgrade-package datagouv-client
uv run pytest
git add uv.lock
git commit -m "chore: bump datagouv-client to X.Y.Z"
```

If the constraint range in `pyproject.toml` also changes, include that file in the commit. Then cut a new CLI release if you want users to get the updated library.

## Prerequisites

Configure these GitHub repository settings once:

| Setting | Purpose |
|---------|---------|
| Secret `APT_GPG_PRIVATE_KEY` | Signs the APT repository (ASCII-armored private key) |
| Secret `HOMEBREW_TAP_TOKEN` | PAT with write access to the Homebrew tap repository |
| Variable `HOMEBREW_TAP_REPO` | Tap repository, default `datagouv/homebrew-tap` |
| GitHub Pages (`github-pages` environment) | Hosts the APT repository |

Export the public GPG key to the APT repo root as `datagouv-cli.gpg` during release.

Bootstrap the Homebrew tap from [`homebrew-tap/`](homebrew-tap/README.md).

## Cut a release

Releases are fully handled by CI. Pushing a version tag on `main` triggers [`release.yml`](.github/workflows/release.yml).

The version in `pyproject.toml` is derived from git tags via `setuptools_scm` — no manual edit needed.

1. Update [`CHANGELOG.md`](CHANGELOG.md) on `main` (summarize changes since the last release).
2. Commit and push to `main`.
3. Create and push an annotated tag:

```bash
git tag -a vX.Y.Z -m "Version X.Y.Z"
git push origin vX.Y.Z
```

The workflow then:

- Builds binaries for Linux (amd64, arm64) and macOS (amd64, arm64)
- Creates a GitHub Release with auto-generated notes and uploads assets with checksums
- Builds `.deb` packages
- Publishes the APT repository to GitHub Pages
- Updates the Homebrew tap formula

## Verify a release

```bash
# GitHub Release asset
curl -LO https://github.com/datagouv/datagouv-cli/releases/download/vX.Y.Z/datagouv-cli-linux-amd64
sha256sum -c datagouv-cli-linux-amd64.sha256
chmod +x datagouv-cli-linux-amd64
./datagouv-cli-linux-amd64 --help

# APT
sudo apt update
sudo apt install datagouv-cli

# Homebrew
brew update
brew upgrade datagouv-cli
```

## GPG key rotation

1. Generate a new key pair.
2. Update `APT_GPG_PRIVATE_KEY` in GitHub secrets.
3. Publish the new public key as `datagouv-cli.gpg` via a release.
4. Communicate the change to users relying on the APT repository.

## Troubleshooting

- **PyInstaller build fails in CI**: check hidden imports in [`packaging/pyinstaller/datagouv.spec`](packaging/pyinstaller/datagouv.spec).
- **APT install fails**: verify GitHub Pages deployment and that `datagouv-cli.gpg` is present.
- **Homebrew tap not updated**: verify `HOMEBREW_TAP_TOKEN` and that the tap repository exists.

## Local development against unreleased library changes

By default, `uv` pulls `datagouv-client` from PyPI. To test against a local checkout:

```bash
uv add --editable ../datagouv_client
```

Revert before release unless you intentionally pin a git/path source.
