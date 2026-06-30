# datagouv-cli

Standalone binary distribution of the [data.gouv.fr CLI](https://github.com/datagouv/datagouv_client).

This repository packages the CLI from [`datagouv_client`](https://github.com/datagouv/datagouv_client) as installable binaries for Linux and macOS. For Python library usage, install [`datagouv-client`](https://pypi.org/project/datagouv-client/) from PyPI instead.

## Installation

### APT (Debian / Ubuntu)

```bash
curl -fsSL https://raw.githubusercontent.com/datagouv/datagouv-cli/main/scripts/install.sh | bash
```

Or manually:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://datagouv.github.io/datagouv-cli/datagouv-cli.gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/datagouv-cli.gpg
echo "deb [signed-by=/etc/apt/keyrings/datagouv-cli.gpg] https://datagouv.github.io/datagouv-cli stable main" \
  | sudo tee /etc/apt/sources.list.d/datagouv-cli.list
sudo apt update && sudo apt install datagouv-cli
```

### Homebrew (macOS)

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

See the [datagouv_client CLI documentation](https://github.com/datagouv/datagouv_client#-cli).

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
