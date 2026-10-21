class Things < Formula
  desc "Production-grade, AI-first Things 3 CLI and MCP server"
  homepage "https://github.com/guangzan/things"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guangzan/things/releases/download/v0.1.2/things-aarch64-apple-darwin.tar.xz"
      sha256 "c2d4b8015577db23df3156fcc3a7cdcd5c7fa133f709104a7f6873e1153592f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guangzan/things/releases/download/v0.1.2/things-x86_64-apple-darwin.tar.xz"
      sha256 "5f2bd04f90ad6bdde92a150e0d39a837ae6b71dffa5691bdb92307573e225a45"
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

  test do
    assert_match version.to_s, shell_output("#{bin}/things --version")
  end
end
