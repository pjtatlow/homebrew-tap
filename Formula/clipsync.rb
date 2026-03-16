class Clipsync < Formula
  desc "Clipboard sync across machines using SpacetimeDB with E2E encryption"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.5.0/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "9ab35b5b2b99322e01230f941ea9d1c7658bf8157142c8993510e9f720279fe3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.5.0/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "95cbcd445b370dc552a078af217a1a41583e72197c4097ea17a275074279f73c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.5.0/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "badad0cbaf6908d038ac03ccff7ca379dc4ef93fd4e206c1d71892921b8cacf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.5.0/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dee01d5b6845ddafb82b066e15e38f8405652196cfd94f43d5c2f997155ffb90"
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
