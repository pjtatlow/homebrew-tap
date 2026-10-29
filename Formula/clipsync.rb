class Clipsync < Formula
  desc "Encrypted clipboard and configuration sync across machines using SpacetimeDB"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.8.0/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "2271f74c74f67d779f04b6e2a0078a79e20b608e48b455dcbbb89989659ff46a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.8.0/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "93b79bbb1e7cd654ada82c7de81eb56e60bccefdadc93a2572e5e70eaf3dc7e8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.8.0/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d2b96bfd8bf12d5bfcdff1d421a3646b261e32c4097b7dfc74a1df6c4b2d5080"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.8.0/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05b84f5c43a1480dc0d68b68cbf102381ab919be86f72a208b420ccd1a992109"
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
