# Releasing datagouv-cli

This document describes how to publish a new version of the standalone CLI distribution.

## Prerequisites

Configure these GitHub repository settings once:

| Setting | Purpose |
|---------|---------|
| Secret `APT_GPG_PRIVATE_KEY` | Signs the APT repository (ASCII-armored private key) |
| Secret `HOMEBREW_TAP_TOKEN` | PAT with write access to the Homebrew tap repository |
| Variable `HOMEBREW_TAP_REPO` | Tap repository, default `datagouv/homebrew-tap` |
| GitHub Pages (`github-pages` environment) | Hosts the APT repository |

Export the public GPG key to the APT repo root as `datagouv.gpg` during release.

Bootstrap the Homebrew tap from [`homebrew-tap/`](homebrew-tap/README.md).

## Bump embedded library version

When `datagouv_client` releases a new version:

```bash
uv lock --upgrade-package datagouv-client
uv sync --dev
uv run pytest
uv run datagouv --help
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
curl -LO https://github.com/datagouv/datagouv_cli/releases/download/vX.Y.Z/datagouv-linux-amd64
sha256sum -c datagouv-linux-amd64.sha256
chmod +x datagouv-linux-amd64
./datagouv-linux-amd64 --help

# APT
sudo apt update
sudo apt install datagouv

# Homebrew
brew update
brew upgrade datagouv
```

## GPG key rotation

1. Generate a new key pair.
2. Update `APT_GPG_PRIVATE_KEY` in GitHub secrets.
3. Publish the new public key as `datagouv.gpg` via a release.
4. Communicate the change to users relying on the APT repository.

## Troubleshooting

- **PyInstaller build fails in CI**: check hidden imports in [`packaging/pyinstaller/datagouv.spec`](packaging/pyinstaller/datagouv.spec).
- **APT install fails**: verify GitHub Pages deployment and that `datagouv.gpg` is present.
- **Homebrew tap not updated**: verify `HOMEBREW_TAP_TOKEN` and that the tap repository exists.
