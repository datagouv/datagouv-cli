class DatagouvCli < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.2.1/datagouv-cli-macos-arm64"
      sha256 "592b67243993dbf23ab956c38691c817ca2db7d91e155d866534c53f9f849e7c"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.2.1/datagouv-cli-macos-amd64"
      sha256 "aac8064c38c5c4b166951d3afebbaf9bfbf6ea2ff24f72ad49e40ef7d9c42a91"
    end
  end

  version "0.2.1"
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
