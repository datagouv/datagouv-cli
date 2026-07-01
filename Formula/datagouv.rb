class Datagouv < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/datagouv/datagouv-cli"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.4.2/datagouv-macos-arm64.tar.gz"
      sha256 "36984a5c098f35edc904efc0a08464248d7ef0621065c087c4f9da3c95236cfa"
    else
      url "https://github.com/datagouv/datagouv-cli/releases/download/v0.4.2/datagouv-macos-amd64.tar.gz"
      sha256 "22bd6a836cc64f71fe7683a86bdf9fca33a3776a13a3514c38baa40f78d1ba7a"
    end
  end

  version "0.4.2"
  license "MIT"

  def install
    # Homebrew chdirs into the single top-level folder of the tarball, so the
    # bundle contents (datagouv + _internal) are at the build root.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"datagouv" => "datagouv"
  end

  test do
    assert_match "datagouv", shell_output("#{bin}/datagouv --help")
  end
end
