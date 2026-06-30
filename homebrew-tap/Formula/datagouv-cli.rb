class DatagouvCli < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"
  url "https://github.com/datagouv/datagouv-cli/releases/download/v0.0.0/datagouv-cli-macos-arm64"
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.0.0/datagouv-cli-macos-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.0.0/datagouv-cli-macos-amd64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    if Hardware::CPU.arm?
      bin.install "datagouv-cli-macos-arm64" => "datagouv-cli"
    else
      bin.install "datagouv-cli-macos-amd64" => "datagouv-cli"
    end
  end

  test do
    assert_match "datagouv", shell_output("#{bin}/datagouv-cli --help")
  end
end
