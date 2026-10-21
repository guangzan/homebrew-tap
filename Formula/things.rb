class Things < Formula
  desc "Production-grade, AI-first Things 3 CLI and MCP server"
  homepage "https://github.com/guangzan/things"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guangzan/things/releases/download/v0.1.0/things-aarch64-apple-darwin.tar.xz"
      sha256 "aa4a752a98f52bffb9045d2853705039b482926af4dc6a5ebcd4a56def378a9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guangzan/things/releases/download/v0.1.0/things-x86_64-apple-darwin.tar.xz"
      sha256 "edcb672f62aa67e369efa8ce13be8518be2889e0f04dee513e3d4f922b87ed07"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "things"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "things"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
