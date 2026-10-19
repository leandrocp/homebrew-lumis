# homebrew-lumis

Homebrew tap for [Lumis](https://lumis.sh).

```sh
brew trust --tap leandrocp/lumis
brew tap leandrocp/lumis
brew install lumis
```

The formula installs the prebuilt, checksummed CLI archive from the matching
[Lumis GitHub Release](https://github.com/leandrocp/lumis/releases).

The [Update formula workflow](../../actions/workflows/update-formula.yml) checks
hourly for a newer stable CLI release. It verifies all four archives against
their SHA-256 files, then installs and tests the candidate on macOS and Linux,
on both Intel and ARM runners, before committing it with this tap's `GITHUB_TOKEN`.
No cross-repository credential is needed.

Use **Run workflow** on `main` to retry a failed update. An incomplete release or
failed verification leaves the formula unchanged and fails the Actions run;
the next scheduled check tries again. A version already installed in the tap,
or an older one, produces no commit. Concurrent updates are serialized, and a
push fails rather than overwriting changes made while the candidate was tested.
