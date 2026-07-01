class DatagouvCli < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.2.0/datagouv-cli-macos-arm64"
      sha256 "d845f72e638170ed748d850242864484e1a111afab19bb25b9745edd0f046dc7"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.2.0/datagouv-cli-macos-amd64"
      sha256 "8028c3836429798e1173830cb34398e78a8cadbfad2fe8f17862756846cb68d3"
    end
  end

  version "0.2.0"
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
