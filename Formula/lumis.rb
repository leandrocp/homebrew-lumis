class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.7.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.7.2/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "03bcad495b348b12baca1fd90312ae56d775bbc266abbe18f49748d4019d1d99"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.7.2/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "15e4027ceca30f1b8984b357153a925ca564a6645f3356cb6df3f059e1ca8212"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.7.2/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b01bca8db9a2841d1f49cac01919917b59bc62505046d6deae4e9f107ac3ee1a"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.7.2/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7dd42c6a18ba8da2f86c729054ea26ec0c479e87b1cc9bef482043fd62b9792"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
