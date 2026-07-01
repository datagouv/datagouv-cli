class Datagouv < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.4.1/datagouv-macos-arm64.tar.gz"
      sha256 "d21d03144c44dfdaab7f5952fb12c459f85615cde851befcba67bdc6d0642b25"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.4.1/datagouv-macos-amd64.tar.gz"
      sha256 "814861799ceaef2ab4581c47a8a934e246575d02a237796df16908203d3a7ea5"
    end
  end

  version "0.4.1"
  license "MIT"

  def install
    libexec.install "datagouv"
    bin.install_symlink libexec/"datagouv/datagouv" => "datagouv"
  end

  test do
    assert_match "datagouv", shell_output("#{bin}/datagouv --help")
  end
end
