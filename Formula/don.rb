class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.2/don-aarch64-apple-darwin.tar.xz"
      sha256 "4b424a292f3f30e5b760ee12cde0859976a655684311f893197bb62261ece81d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.2/don-x86_64-apple-darwin.tar.xz"
      sha256 "bdf83cf3ab3bea034243684a3a1aff07148b6f8cfce72b9143cd999b025e39cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.2/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e12d546a7a7184e3fe9d62c6cea86babc6d87694df2bb86b719f79489e09179"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.2/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6029b8a552693899381726632046814b8880992b8ab822f856285e32913c815c"
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
    bin.install "don" if OS.mac? && Hardware::CPU.arm?
    bin.install "don" if OS.mac? && Hardware::CPU.intel?
    bin.install "don" if OS.linux? && Hardware::CPU.arm?
    bin.install "don" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
