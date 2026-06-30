class Datagouv < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv_cli"
  url "https://github.com/datagouv/datagouv_cli/releases/download/v0.0.0/datagouv-macos-arm64"
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv_cli/releases/download/v0.0.0/datagouv-macos-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    else
      url "https://github.com/datagouv/datagouv_cli/releases/download/v0.0.0/datagouv-macos-amd64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    if Hardware::CPU.arm?
      bin.install "datagouv-macos-arm64" => "datagouv"
    else
      bin.install "datagouv-macos-amd64" => "datagouv"
    end
  end

  test do
    assert_match "datagouv", shell_output("#{bin}/datagouv --help")
  end
end
