class ThingsAi < Formula
  desc "Production-grade, AI-first Things 3 CLI and MCP server"
  homepage "https://github.com/guangzan/things-ai"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guangzan/things-ai/releases/download/v0.2.0/things-ai-aarch64-apple-darwin.tar.xz"
      sha256 "5e4d1efd3dcbc4ea3c986e404ee4845578078ab24e9b25e36bcdd54528a8c16d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guangzan/things-ai/releases/download/v0.2.0/things-ai-x86_64-apple-darwin.tar.xz"
      sha256 "cf951e00b9bf5d51ad09b857ec3d0eaa3b3bf9c633fc52b7282a38938d168d37"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
  }

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
      bin.install "ta"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ta"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ta --version")
  end
end
