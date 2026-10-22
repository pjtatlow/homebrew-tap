class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.4/don-aarch64-apple-darwin.tar.xz"
      sha256 "c056a8d244d949e051bad7297ae662eb7d551c604dba6767a24d789837401384"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.4/don-x86_64-apple-darwin.tar.xz"
      sha256 "78cdf65c6dca734818a3c14b91b2c602553f416d5fe702ac58f68fcac13dfe7d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.4/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6daecb77796ee7857fb36b63717c6c715ccef05b1db954441491a949c6612126"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.4/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8a265782ba8ec9580a0ae78d8395a77f2452cd09182eda91b175839be663a111"
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
      bin.install "don"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "don"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "don"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "don"
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
