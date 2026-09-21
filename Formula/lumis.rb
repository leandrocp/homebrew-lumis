class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.5.1/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "b3e5eae6a616893ea2bde8c464d0a03c3b603d5879c423c55d93377023291427"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.5.1/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "64c9fd1576f1415ad3825bc9a98fbc543322a9ba72ee571d518921737a0c2233"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.5.1/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4ed7d4bc7f845d59de322c169025d27cb7c6b1daed796a8e11e7fca93a8972e"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.5.1/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "90db7983c98430eff5c68fbb5029ded7fd5a0b6d2496b55cdde762f007f922f6"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
