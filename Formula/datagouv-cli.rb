class DatagouvCli < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.3.0/datagouv-cli-macos-arm64"
      sha256 "4db1c6a1653160f17a3f18feaa303eba57cfff381edaf3300ea0be6a79109277"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.3.0/datagouv-cli-macos-amd64"
      sha256 "ea0960b6c7ef7a4a5e8c0b2b3fab28c00fc25f303747eeb060d37d825f429922"
    end
  end

  version "0.3.0"
  license "MIT"

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
