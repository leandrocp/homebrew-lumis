class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.8.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.8/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "b6303208f80cfce2cbf51dd2376af962f9e16cb7f961699fa6074e6b4731c3a8"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.8/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "0b607d76bdf4c57dc645f43af68a9ed67f95f2adee40f023e868c579355f09eb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.8/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "03427e1b112e502a058098e783d0b8b89da6a2b7a0cccd1dbac60ba89681b9a2"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.8/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "526d54aa9f5f406f0273d0fb07c4cf8608bb4b0b2bed3074e0b68903eddae748"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
