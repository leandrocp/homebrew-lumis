class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.8.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.9/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "04c0964dc54b2ccdfe7d68d54a9cf8ab8ec36f8014c7918b0406f5b896007d99"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.9/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "3468b2d236552d5ac69101a39595b1e46ad1476562ad096cc11ace0b1d5b8780"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.9/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5e00e54ed5ef8cf284691bc79432a39afe44ab0319f731328f73983bb04741b"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.9/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "44b11a8866bb6ae03c4012e6d73471d66f83690373fab1b9285fd2aea683ead1"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
