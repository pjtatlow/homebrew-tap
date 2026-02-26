class Clipsync < Formula
  desc "Clipboard sync across machines using SpacetimeDB with E2E encryption"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.3.1/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "f0e79a4fb3efa2c4d2f8d3cb05b14a80c4f2c30713c0bec6319d6b3d57f49065"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.3.1/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "e2bb08850972425daa4670c48c9e151a92f7b5683892b9f56662d5ae1c76d0ad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.3.1/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e5ae3bcad82110a923784ef378aafc76347654cbd4c68ba2e2708a75ca4712c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.3.1/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "843bf96ac08c2862253223b97def45ba3cea40a25ae0b60b730908583f4e2c41"
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
