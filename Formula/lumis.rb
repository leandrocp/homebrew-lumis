class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.8.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.2/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "e5dbed92f4e96aec64f6b4143f39ec067c8eba49142511e1148d7ab12809fae3"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.2/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "2e702642e1efb5365ae2ad2b48bca730bf60c9ae78c002444f6e5fe034e9025a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.2/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2e292733f2b2c6e80c8307bfb535c06e08c16c6fd5e9d168663c57a04b4de2c"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.2/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4cf5a998735dce37bc684cf93bc9caec72cf9489e11616e6da84779838bfa2e"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
