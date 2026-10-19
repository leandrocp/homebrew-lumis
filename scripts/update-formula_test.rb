require "fileutils"
require "minitest/autorun"
require "minitest/mock"
require_relative "update-formula"

class FormulaUpdateTest < Minitest::Test
  def setup
    @directory = Dir.mktmpdir("lumis-formula-test-")
    @path = File.join(@directory, "lumis.rb")
    @original = File.read(File.expand_path("../Formula/lumis.rb", __dir__))
      .gsub(/cargo-lumis-cli\/v[^\/]+\//, "cargo-lumis-cli/v0.7.2/")
      .sub(/^  version "[^"]+"$/, '  version "0.7.2"')
    File.write(@path, @original)
  end

  def teardown
    FileUtils.remove_entry(@directory)
  end

  def release(version, draft: false, prerelease: false)
    {
      "tag_name" => "cargo-lumis-cli/v#{version}",
      "draft" => draft,
      "prerelease" => prerelease,
      "assets" => FormulaUpdate::TARGETS.flat_map do |target|
        [{ "name" => "lumis-#{target}.tar.gz" }, { "name" => "lumis-#{target}.sha256" }]
      end,
    }
  end

  def with_download(corrupt: nil, malformed: nil)
    downloader = lambda do |tag, directory|
      FormulaUpdate::TARGETS.each do |target|
        archive = "lumis-#{target}.tar.gz"
        bytes = "#{tag}:#{target}"
        File.write(File.join(directory, archive), bytes)
        digest = Digest::SHA256.hexdigest(bytes)
        digest = "0" * 64 if target == corrupt
        filename = target == malformed ? "another-archive.tar.gz" : archive
        File.write(File.join(directory, "lumis-#{target}.sha256"), "#{digest}  #{filename}\n")
      end
    end
    FormulaUpdate.stub(:download, downloader) { yield }
  end

  def test_updates_to_highest_stable_cli_version_and_is_idempotent
    releases = [release("0.9.0"), release("0.10.0"), release("0.11.0", draft: true),
      release("0.12.0", prerelease: true), release("0.13.0-rc.1"),
      release("99.0.0").merge("tag_name" => "npm-lumis/v99.0.0")]
    with_download do
      assert_equal "0.10.0", FormulaUpdate.update(@path, releases)
      updated = File.read(@path)
      assert_includes updated, 'version "0.10.0"'
      FormulaUpdate::TARGETS.each do |target|
        assert_includes updated, "cargo-lumis-cli/v0.10.0/lumis-#{target}.tar.gz"
        digest = Digest::SHA256.hexdigest("cargo-lumis-cli/v0.10.0:#{target}")
        assert_includes updated, "sha256 \"#{digest}\""
      end
      assert_nil FormulaUpdate.update(@path, releases)
      assert_equal updated, File.read(@path)
    end
  end

  def test_does_not_downgrade_or_rewrite_the_same_version
    ["0.7.1", "0.7.2"].each do |version|
      assert_nil FormulaUpdate.update(@path, [release(version)])
      assert_equal @original, File.read(@path)
    end
  end

  def test_incomplete_newest_release_fails_without_falling_back
    incomplete = release("0.9.0")
    incomplete.fetch("assets").pop
    error = assert_raises(RuntimeError) { FormulaUpdate.update(@path, [release("0.8.0"), incomplete]) }
    assert_match(/incomplete/, error.message)
    assert_equal @original, File.read(@path)
  end

  def test_checksum_mismatch_leaves_formula_unchanged
    with_download(corrupt: FormulaUpdate::TARGETS.last) do
      error = assert_raises(RuntimeError) { FormulaUpdate.update(@path, [release("0.8.0")]) }
      assert_match(/Checksum mismatch/, error.message)
      assert_equal @original, File.read(@path)
    end
  end

  def test_wrong_checksum_filename_leaves_formula_unchanged
    with_download(malformed: FormulaUpdate::TARGETS.last) do
      error = assert_raises(RuntimeError) { FormulaUpdate.update(@path, [release("0.8.0")]) }
      assert_match(/Invalid checksum file/, error.message)
      assert_equal @original, File.read(@path)
    end
  end

  def test_no_stable_cli_release_fails
    assert_raises(RuntimeError) { FormulaUpdate.update(@path, [release("1.0.0", prerelease: true)]) }
    assert_equal @original, File.read(@path)
  end
end
