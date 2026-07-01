# Releasing datagouv-cli

This document describes how to publish a new version of the standalone CLI distribution.

`datagouv-cli` is **not published on PyPI**. Users install it via apt, Homebrew, Chocolatey (self-hosted in this repo), or GitHub Release binaries. The command is `datagouv`.

## Library dependency

`datagouv-cli` depends on [`datagouv-client`](https://pypi.org/project/datagouv-client/) ([source](https://github.com/datagouv/datagouv_client)), a library-only package; CLI code lives in this repo. The version constraint is defined in [`pyproject.toml`](pyproject.toml). CI resolves it from PyPI and does not clone `datagouv_client`.

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
| GitHub Pages (`github-pages` environment) | Hosts the APT repository |

Export the public GPG key to the APT repo root as `datagouv.gpg` during release.

The Homebrew formula lives in [`Formula/datagouv.rb`](Formula/datagouv.rb) at the repo root. Because this repository is not named `homebrew-*`, users must tap it with an explicit URL:

```bash
brew tap datagouv/datagouv-cli https://github.com/datagouv/datagouv-cli.git
brew trust datagouv/datagouv-cli
brew install datagouv
```

The Chocolatey package lives in [`chocolatey/datagouv/`](chocolatey/datagouv/). It is self-hosted in this repository (not published on chocolatey.org). Users install from a GitHub Release source or from a local clone:

```powershell
choco install datagouv --source="https://github.com/datagouv/datagouv-cli/releases/download/vX.Y.Z"
```

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

- Builds binaries for Linux (amd64, arm64), macOS (amd64, arm64), and Windows (amd64)
- Creates a GitHub Release with auto-generated notes and uploads assets with checksums
- Builds `.deb` packages and a Chocolatey `.nupkg`
- Publishes the APT repository to GitHub Pages
- Updates `Formula/datagouv.rb` and `chocolatey/datagouv/` on `main`

## Verify a release

```bash
# GitHub Release asset
curl -LO https://github.com/datagouv/datagouv-cli/releases/download/vX.Y.Z/datagouv-linux-amd64
sha256sum -c datagouv-linux-amd64.sha256
chmod +x datagouv-linux-amd64
./datagouv-linux-amd64 --help

# APT
sudo apt update
sudo apt install datagouv

# Homebrew
brew tap datagouv/datagouv-cli https://github.com/datagouv/datagouv-cli.git
brew trust datagouv/datagouv-cli
brew update
brew upgrade datagouv

# Windows binary
Invoke-WebRequest -Uri https://github.com/datagouv/datagouv-cli/releases/download/vX.Y.Z/datagouv-windows-amd64.exe -OutFile datagouv.exe
./datagouv.exe --help

# Chocolatey
choco install datagouv --source="https://github.com/datagouv/datagouv-cli/releases/download/vX.Y.Z"
datagouv --help
```

## GPG key rotation

1. Generate a new key pair.
2. Update `APT_GPG_PRIVATE_KEY` in GitHub secrets.
3. Publish the new public key as `datagouv.gpg` via a release.
4. Communicate the change to users relying on the APT repository.

## Troubleshooting

- **PyInstaller build fails in CI**: check hidden imports in [`packaging/pyinstaller/datagouv.spec`](packaging/pyinstaller/datagouv.spec).
- **APT install fails**: verify GitHub Pages deployment and that `datagouv.gpg` is present.
- **Homebrew formula not updated**: verify the release workflow has `contents: write` permission and that `Formula/datagouv.rb` was pushed to `main`.
- **Windows build fails in CI**: check PyInstaller hidden imports in [`packaging/pyinstaller/datagouv.spec`](packaging/pyinstaller/datagouv.spec); network dependencies (`niquests`, `qh3`, `wassima`) are the most common cause.
- **Chocolatey package not updated**: verify that `chocolatey/datagouv/datagouv.nuspec` and `tools/chocolateyInstall.ps1` were pushed to `main`.

## Local development against unreleased library changes

By default, `uv` pulls `datagouv-client` from PyPI. To test against a local checkout:

```bash
uv add --editable ../datagouv_client
```

Revert before release unless you intentionally pin a git/path source.

## Migration from `datagouv-cli` command

The CLI command was renamed from `datagouv-cli` to `datagouv`. Existing users should:

```bash
# Command
datagouv-cli --help   →   datagouv --help

# APT
sudo apt remove datagouv-cli && sudo apt install datagouv

# Homebrew
brew uninstall datagouv-cli && brew install datagouv
```

Reconfigure the APT keyring and sources list if upgrading from a release before this rename (`datagouv.gpg` and `datagouv.list`).
