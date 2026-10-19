class Lumis < Formula
  desc "Syntax highlighter powered by Tree-sitter and Neovim themes"
  homepage "https://lumis.sh"
  version "0.8.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.1/lumis-aarch64-apple-darwin.tar.gz"
      sha256 "6cbf4e1d9db9234dd717306d3afe0d501617b39f141d66f7dd719603aa8396bb"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.1/lumis-x86_64-apple-darwin.tar.gz"
      sha256 "4c0e1a1479f075547f986fb92f9a353d1cfa3d98451e49abe5706bf9bc5b49cd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.1/lumis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "07fa4c09350f26f9e69ff3e6c705afbb9d7b01dfc0079350c99615759cd4b388"
    else
      url "https://github.com/leandrocp/lumis/releases/download/cargo-lumis-cli/v0.8.1/lumis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1fbca09be62bee1efedd96c145974b2f4563dc1108900408b9615491ef220f37"
    end
  end

  def install
    bin.install "lumis"
  end

  test do
    assert_match "lumis-cli #{version}", shell_output("#{bin}/lumis --version")
  end
end
