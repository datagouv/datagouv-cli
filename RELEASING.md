# Releasing datagouv-cli

This document describes how to publish a new version of the standalone CLI distribution.

`datagouv-cli` is **not published on PyPI**. Users install it via apt, Homebrew, or GitHub Release binaries.

## Coordinated release with datagouv_client

The CLI depends on `datagouv-client>=0.4.0` (library without embedded CLI). Release in this order:

1. Merge and publish **`datagouv_client` v0.4.0** on PyPI (lib only + deprecation shim for `datagouv` command).
2. Bump `datagouv-client` in this repo: `uv lock --upgrade-package datagouv-client`.
3. Remove `[tool.uv.sources]` path override from `pyproject.toml` once PyPI has 0.4.0.
4. Tag **`datagouv_cli` v0.4.0** to build and publish binaries.

### Release checklist

```bash
# 1. datagouv_client — merge PR, then tag and publish
cd datagouv_client
./tag_version.sh 0.4.0   # or your release process
# verify PyPI: pip index versions datagouv-client

# 2. datagouv_cli — drop path override once PyPI has 0.4.0
cd ../datagouv_cli
# remove [tool.uv.sources] from pyproject.toml
uv lock --upgrade-package datagouv-client
uv sync --dev
uv run pytest
uv run pyinstaller packaging/pyinstaller/datagouv.spec --clean --noconfirm
./scripts/smoke-test-binary.sh ./dist/datagouv-cli

# 3. tag CLI release
git tag v0.4.0 && git push origin v0.4.0
```

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

## Bump embedded library version

When `datagouv_client` releases a new version:

```bash
uv lock --upgrade-package datagouv-client
uv sync --dev
uv run pytest
uv run datagouv-cli --help
git add pyproject.toml uv.lock
git commit -m "chore: bump datagouv-client to X.Y.Z"
```

## Cut a release

1. Update [`CHANGELOG.md`](CHANGELOG.md).
2. Tag the release:

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

3. The [`release.yml`](.github/workflows/release.yml) workflow will:
   - Build binaries for Linux (amd64, arm64) and macOS (amd64, arm64)
   - Create a GitHub Release with checksums
   - Build `.deb` packages
   - Publish the APT repository to GitHub Pages
   - Update the Homebrew tap formula

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
