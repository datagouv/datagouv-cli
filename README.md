# datagouv-cli

[![CI](https://github.com/datagouv/datagouv-cli/actions/workflows/ci.yml/badge.svg)](https://github.com/datagouv/datagouv-cli/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`datagouv-cli` is a command-line tool for [data.gouv.fr](https://www.data.gouv.fr): work with datasets, organizations, resources, and topics from your terminal.

## 🚀 Installation

Install it on Linux, macOS, or Windows — no other dependency required.

### Quick install (Linux / macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/datagouv/datagouv-cli/main/scripts/install.sh | bash
```

### Manual binary (all platforms)

Download the binary for your platform from [GitHub Releases](https://github.com/datagouv/datagouv-cli/releases) and place it on your `PATH`:

```bash
# Linux / macOS
chmod +x datagouv-cli-linux-amd64
sudo mv datagouv-cli-linux-amd64 /usr/local/bin/datagouv-cli
```

```powershell
# Windows
Move-Item datagouv-cli-windows-amd64.exe "$env:LOCALAPPDATA\Microsoft\WindowsApps\datagouv-cli.exe"
```

### Manual APT (Debian / Ubuntu)

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://datagouv.github.io/datagouv-cli/datagouv-cli.gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/datagouv-cli.gpg
echo "deb [signed-by=/etc/apt/keyrings/datagouv-cli.gpg] https://datagouv.github.io/datagouv-cli stable main" \
  | sudo tee /etc/apt/sources.list.d/datagouv-cli.list
sudo apt update && sudo apt install datagouv-cli
```

### Manual Homebrew (macOS)

```bash
brew tap datagouv/datagouv-cli https://github.com/datagouv/datagouv-cli.git
brew trust datagouv/datagouv-cli
brew install datagouv-cli
```

### Manual Chocolatey (Windows)

From a [GitHub Release](https://github.com/datagouv/datagouv-cli/releases) (replace `vX.Y.Z` with the desired version):

```powershell
choco install datagouv-cli --source="https://github.com/datagouv/datagouv-cli/releases/download/vX.Y.Z"
```

## Quick start

```bash
datagouv-cli setup
datagouv-cli dataset get <dataset-id>
```

## 🖥️ CLI

```bash
datagouv-cli --help
```

### Configuration

First set up your config:

```bash
datagouv-cli setup
```

You will be asked the environment you want to interact with, and your API key. They will be stored in a config file in your home directory. If you only intend to get data, you may leave the API key blank.

> Note: you may skip this setup step if you intend to target the production platform and fetch data.

To reset your settings, delete the config file with `datagouv-cli delete-config`.

### Displaying data

All objects have a `display` command that shows the object's main metadata in a human-readable way:

```bash
datagouv-cli organization display "534fff81a3a7292c64a77e5c"
> badges: [{'kind': 'public-service'}, {'kind': 'certified'}]
> ────────────────────
> business_number_id: 12002701600563
> ────────────────────
> created_at: 2014-04-17T18:21:21.523000+00:00
> ...
```

### Getting data

All objects also have a `get` command, that outputs all the object's metadata in JSON (directly fed from datagouv's API). You may for instance give the output to `jq` like:

```bash
datagouv-cli organization get "534fff81a3a7292c64a77e5c" | jq .name
> "Institut national de la statistique et des études économiques (Insee)"
```

### Modifying objects

If you have run the `setup` command and filled in your API key, you may interact with objects (according to your rights on the platform), for instance:

```bash
datagouv-cli dataset create --title "New dataset" --description "Nice description" --organization_id "646b7187b50b2a93b1ae3d45"
> Dataset created successfully ✓ id is 69fb46c2bdeef492539acd61
# use the `--set` argument to update keys (can be used multiple times in one call)
datagouv-cli dataset update "69fb46c2bdeef492539acd61" --set title="New title" --set private=true
> Dataset updated successfully ✓
datagouv-cli resource create "69fb46c2bdeef492539acd61" "First resource" --file-to-upload file.csv --set type=main
> Resource created successfully ✓ id is 49e370df-cd09-4792-915b-95d25c2adc08
datagouv-cli resource delete "49e370df-cd09-4792-915b-95d25c2adc08"
> Resource deleted successfully ✓
```

### Help

The `--help` flag is available for all subcommands.

## Python library

For programmatic access to the data.gouv.fr API, see [`datagouv_client`](https://github.com/datagouv/datagouv_client).

## 🛠️ Development

This project uses Python >=3.10,<3.15 and [uv](https://docs.astral.sh/uv/) to manage dependencies.

```bash
uv sync --dev
uv run datagouv-cli --help
```

Build a local binary:

```bash
uv run pyinstaller packaging/pyinstaller/datagouv.spec
./dist/datagouv-cli --help
```

## 🤝 Contributing

Before contributing to the repository and making any PR, it is necessary to initialize the pre-commit hooks:
```bash
uv sync --dev
uv run pre-commit install
```
Once this is done, code formatting and linting, as well as import sorting, will be automatically checked before each commit.

If you cannot use pre-commit, it is necessary to format, lint, and sort imports with [Ruff](https://astral.sh/ruff/) for linting and formatting. **Either running these commands manually or installing the pre-commit hook is required before submitting contributions.**
```bash
uv run ruff check --fix && uv run ruff format
```

### 🏷️ Releases and versioning

See [RELEASING.md](RELEASING.md).
