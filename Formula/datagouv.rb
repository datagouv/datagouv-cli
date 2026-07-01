class Datagouv < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.4.0/datagouv-macos-arm64"
      sha256 "386cd4c0177e022f179803ed3ec4d79c42681e0936ab20dda8aa72ffbbd0fc56"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.4.0/datagouv-macos-amd64"
      sha256 "ae84808f89532f37e1dba27251e5b83d5740041599df7749ac8911d0e5d58f24"
    end
  end

  version "0.4.0"
  license "MIT"

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
