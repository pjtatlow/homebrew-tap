class Clipsync < Formula
  desc "Encrypted clipboard and configuration sync across machines using SpacetimeDB"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.1/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "f54a60f3d013fb1fb4fc8411f201feb8af5ce75800434895fefc3459049ab1ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.1/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "5897e155fe43a305ab84bffff2d3f38e6f3473ce79ec32abf43a6cf09ffc5f26"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.1/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0d7f97f999ee063578af8b98246e0a8098fdd5d4b098a201638c203b79b0853"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.1/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d52d25e2d8f2d04764290ca0781acc43c662acd2e813c4ae2798efe7b8b7252"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "clipsync"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "clipsync"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "clipsync"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "clipsync"
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
