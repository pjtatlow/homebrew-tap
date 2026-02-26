class Clipsync < Formula
  desc "Clipboard sync across machines using SpacetimeDB with E2E encryption"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.0/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "84a316ccb0be7d3ed5f8d7be92b6e9298db66b8818dbc20dc0a34ae48499ed14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.0/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "3d70f994265b5ba059678409d11560850d235a65b229e0f0c1fbc7c89a8d646d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.0/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c69a07459a99f6e7f8f4efd7961c3121536048d82e08dfeaf56e19fdd6582901"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.0/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3069cfc3d1c4c245cc30718321f712816fd5d6170cef33118613a4f9a78e120"
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
    bin.install "clipsync" if OS.mac? && Hardware::CPU.arm?
    bin.install "clipsync" if OS.mac? && Hardware::CPU.intel?
    bin.install "clipsync" if OS.linux? && Hardware::CPU.arm?
    bin.install "clipsync" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
