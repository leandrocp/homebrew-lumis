class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.8.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.5/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "7c9ea168c3f48848d1b1f89ed5d065ef52d539e57bd0cd7763cc203e081c0b07"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.5/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "8795e3ee9fb426cd46a36ad999099f30811fc45daabbea090588eaa5a858d4d7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.5/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0c0549e54c67e6a6d34c48ce9d7e5fca80d49ce14e8993a08b0850d553680ee6"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.5/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "73320ccddd2666682b14c54e76f88fea2b25bfdbd68429cb300388df159a1eb3"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
