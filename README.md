# datagouv-cli

Command-line tool for [data.gouv.fr](https://www.data.gouv.fr): work with datasets, organizations, resources, and topics from your terminal.

Install it on Linux or macOS with the command below — no other dependency required.

## Installation

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

## Usage

```bash
datagouv-cli --help
```

Quick start:

```bash
datagouv-cli setup
datagouv-cli dataset get <dataset-id>
```

## Development

Requirements: [uv](https://docs.astral.sh/uv/), Python 3.10+.

```bash
uv sync --dev
uv run datagouv-cli --help
uv run pytest
uv run ruff check .
```

Build a local binary:

```bash
uv run pyinstaller packaging/pyinstaller/datagouv.spec
./dist/datagouv-cli --help
```

## Releasing

See [RELEASING.md](RELEASING.md).

## License

MIT — see [LICENSE](LICENSE).
