class Clipsync < Formula
  desc "Encrypted clipboard and configuration sync across machines using SpacetimeDB"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.0/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "ebe85acfa75001048e2fb41f473c4b61ee01a275bf681e2c920e5fd72092c483"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.0/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "feacb168f6f161cb3367ba38691d17f94517750d2f78716455be111ebba1969c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.0/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4cd888c49886a3745057eb8465f4c195f149c9dc0943882adec3bdaf4ad356b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.6.0/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e9f6ba395b3a0e695b65547d806e53f571ebd84e2182782623fec9783142257"
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
