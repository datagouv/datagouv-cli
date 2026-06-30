# datagouv-cli

[![CI](https://github.com/datagouv/datagouv-cli/actions/workflows/ci.yml/badge.svg)](https://github.com/datagouv/datagouv-cli/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`datagouv-cli` is a command-line tool for [data.gouv.fr](https://www.data.gouv.fr): work with datasets, organizations, resources, and topics from your terminal.

Install it on Linux or macOS with the command below — no other dependency required.

## 🚀 Installation

```bash
curl -fsSL https://raw.githubusercontent.com/datagouv/datagouv-cli/main/scripts/install.sh | bash
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
brew install datagouv/tap/datagouv-cli
```

### Manual binary

Download the binary for your platform from [GitHub Releases](https://github.com/datagouv/datagouv-cli/releases), make it executable, and place it on your `PATH`:

```bash
chmod +x datagouv-cli-linux-amd64
sudo mv datagouv-cli-linux-amd64 /usr/local/bin/datagouv-cli
```

## 🖥️ CLI

```bash
datagouv-cli --help
```

First set up your config:

```bash
datagouv-cli setup
```

You will be asked the environment you want to interact with, and your API key. They will be stored in a config file in your home directory. If you only intend to get data, you may leave the API key blank.

> Note: you may skip this setup step if you intend to target the production platform and fetch data.

### Displaying data

All objects have a `display` command that shows the object's main metadata in a human-readable way:

```bash
datagouv-cli organization display "534fff81a3a7292c64a77e5c"
```

### Getting data

All objects also have a `get` command that outputs metadata in JSON:

```bash
datagouv-cli organization get "534fff81a3a7292c64a77e5c" | jq .name
```

### Modifying objects

If you have run `setup` and filled in your API key, you may interact with objects (according to your rights on the platform):

```bash
datagouv-cli dataset create --title "New dataset" --description "Nice description" --organization-id "646b7187b50b2a93b1ae3d45"
datagouv-cli dataset update "69fb46c2bdeef492539acd61" --set title="New title" --set private=true
datagouv-cli resource create "69fb46c2bdeef492539acd61" "First resource" --file-to-upload file.csv --set type=main
datagouv-cli resource delete "49e370df-cd09-4792-915b-95d25c2adc08"
```

The `--help` command is available for all subcommands. Delete your config file with `datagouv-cli delete-config`.

For Python library usage, see [`datagouv_client`](https://github.com/datagouv/datagouv_client).

Quick start:

```bash
datagouv-cli setup
datagouv-cli dataset get <dataset-id>
```

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

Before submitting a PR, lint and format the code with [Ruff](https://astral.sh/ruff/):

```bash
uv run ruff check --fix && uv run ruff format
```

Run the test suite:

```bash
uv run pytest
```

### 🏷️ Releases and versioning

See [RELEASING.md](RELEASING.md).
