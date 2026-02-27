class Clipsync < Formula
  desc "Clipboard sync across machines using SpacetimeDB with E2E encryption"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.1/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "5698bebb3a0030df138734ac67e54abcb37357766db6a3d6a1aa263d0eeadb2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.1/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "460d62550c4ddf58250875592cb646d6c158af5f4ffff7b22e5b00c825cee934"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.1/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff13fa34d92c974a78dde886a9f4d0cff60bc6ffc98a8fe52ee995fc338dc5b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.4.1/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b28cbe3fb9af8f5eab2912ffa7ba5e65fd313ad1dfc2d1d6467fd512141038cc"
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
