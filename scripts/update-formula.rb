require "digest"
require "json"
require "open3"
require "rubygems"
require "tmpdir"

module FormulaUpdate
  REPOSITORY = "leandrocp/lumis"
  TAG = /\Acargo-lumis-cli\/v((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))\z/
  TARGETS = %w[
    aarch64-apple-darwin
    x86_64-apple-darwin
    aarch64-unknown-linux-gnu
    x86_64-unknown-linux-gnu
  ].freeze

  def self.gh(*arguments)
    output, error, status = Open3.capture3("gh", *arguments)
    raise "gh #{arguments.first} failed: #{error}" unless status.success?

    output
  end

  def self.download(tag, directory)
    patterns = TARGETS.flat_map do |target|
      ["--pattern", "lumis-#{target}.tar.gz", "--pattern", "lumis-#{target}.sha256"]
    end
    gh("release", "download", tag, "--repo", REPOSITORY, "--dir", directory, *patterns)
  end

  def self.update(path, releases)
    stable = releases.reject { |release| release.fetch("draft") || release.fetch("prerelease") }
      .select { |release| TAG.match?(release.fetch("tag_name")) }
    release = stable.max_by { |item| Gem::Version.new(TAG.match(item.fetch("tag_name"))[1]) }
    raise "No stable CLI release found" unless release

    tag = release.fetch("tag_name")
    version = TAG.match(tag)[1]
    formula = File.read(path)
    current = formula.match(/^  version "([^"]+)"$/) or raise "Formula version not found"
    return nil if Gem::Version.new(version) <= Gem::Version.new(current[1])

    assets = release.fetch("assets").map { |asset| asset.fetch("name") }
    required = TARGETS.flat_map { |target| ["lumis-#{target}.tar.gz", "lumis-#{target}.sha256"] }
    missing = required - assets
    raise "Release #{tag} is incomplete: missing #{missing.join(', ')}" unless missing.empty?

    updated = formula.sub(current[0], "  version \"#{version}\"")
    Dir.mktmpdir("lumis-release-") do |directory|
      download(tag, directory)
      TARGETS.each do |target|
        archive = "lumis-#{target}.tar.gz"
        checksum = File.read(File.join(directory, "lumis-#{target}.sha256"))
          .match(/\A([0-9a-f]{64})[ \t]+\*?#{Regexp.escape(archive)}\s*\z/)
        raise "Invalid checksum file for #{archive}" unless checksum

        digest = Digest::SHA256.file(File.join(directory, archive)).hexdigest
        raise "Checksum mismatch for #{archive}" unless digest == checksum[1]

        url = "https://github.com/#{REPOSITORY}/releases/download/"
        pattern = /^      url "#{Regexp.escape(url)}cargo-lumis-cli\/v[^\/\"]+\/#{Regexp.escape(archive)}"\n      sha256 "[0-9a-f]{64}"$/
        raise "Expected one formula entry for #{target}" unless updated.scan(pattern).length == 1

        updated = updated.sub(pattern, "      url \"#{url}#{tag}/#{archive}\"\n      sha256 \"#{digest}\"")
      end
    end
    File.write(path, updated)
    version
  end
end

if $PROGRAM_NAME == __FILE__
  releases = JSON.parse(FormulaUpdate.gh("api", "--paginate", "--slurp", "repos/#{FormulaUpdate::REPOSITORY}/releases?per_page=100")).flatten(1)
  version = FormulaUpdate.update(File.expand_path("../Formula/lumis.rb", __dir__), releases)
  puts(version ? "Updated formula to #{version}" : "Formula is already up to date; no changes")
  if ENV["GITHUB_OUTPUT"]
    File.open(ENV.fetch("GITHUB_OUTPUT"), "a") do |output|
      output.puts("changed=#{!version.nil?}")
      output.puts("version=#{version}")
    end
  end
end
