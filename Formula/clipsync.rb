class Clipsync < Formula
  desc "Encrypted clipboard and configuration sync across machines using SpacetimeDB"
  homepage "https://github.com/pjtatlow/clipsync"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.9.0/clipsync-aarch64-apple-darwin.tar.xz"
      sha256 "42f4bfc02a9a22c3cdf6cca9639efe31533d8daf64ed9ecb0084a1d173cabedb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.9.0/clipsync-x86_64-apple-darwin.tar.xz"
      sha256 "193e3801a51c79d12a27eb147d3fc818b0f62de1dfaf501bb671c8a65f521683"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.9.0/clipsync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "447b1f8dd353b9dbd7ae86a64cd00801c42743f0f1e72c1e20dde7afa3521746"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/clipsync/releases/download/v0.9.0/clipsync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2772a695609c5e608d793a519fe1d3b87e10c681ff52c6623b2c0c5f558424e"
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
