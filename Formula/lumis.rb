class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.8.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.3/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "7e1ff1a0e6a92d83b1e95f016b7ddefb8df5fc86486f7ad1a90415135b5ec34f"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.3/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "32cc9da30052e63d48610cad7138b854a731cc4de69419d358227e480bcdea4f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.3/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e21ae554e73ab84cbd8ddba2e77a07a2bcdca75cb9c97e4a6c44854185e297fb"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.3/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "87947bea99ca42537489cd8dcc98662f8d80f0e691ceba827fabfbb1f9a7ffef"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
