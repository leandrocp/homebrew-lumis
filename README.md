# homebrew-lumis

Homebrew tap for [Lumis](https://lumis.sh).

```sh
brew trust --tap leandrocp/lumis
brew tap leandrocp/lumis
brew install lumis
```

The formula installs the prebuilt, checksummed CLI archive from the matching
[Lumis GitHub Release](https://github.com/leandrocp/lumis/releases).

The [Lumis release workflow](https://github.com/leandrocp/lumis/blob/main/.github/workflows/homebrew-release.yml)
updates the formula's version, URLs, and checksums after each stable CLI release.
