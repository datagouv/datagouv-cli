# homebrew-tap

Bootstrap files for the separate Homebrew tap repository.

Create a public repository named `homebrew-tap` under the `datagouv` GitHub organization, then copy the contents of this directory to the root of that repository.

After the first release of `datagouv-cli`, the release workflow updates `Formula/datagouv-cli.rb` automatically when `HOMEBREW_TAP_TOKEN` is configured.

## Usage

```bash
brew tap datagouv/tap
brew install datagouv-cli
```

## Manual update

If CI secrets are not configured yet, copy the generated formula from `packaging/brew/generated/datagouv-cli.rb` after a release build.
