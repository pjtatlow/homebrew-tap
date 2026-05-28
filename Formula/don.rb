class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/0.5.3/don-aarch64-apple-darwin.tar.xz"
      sha256 "31fe17f543c7836be6788e48b0167064fef5514a8d03f072a96836b6b6df6609"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/0.5.3/don-x86_64-apple-darwin.tar.xz"
      sha256 "d618a1df10d74d18ac8b1a811ea2bd9bf295852f3eb145c84e98e4ce8d9314bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/0.5.3/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "988d9913fb489bafe6084893e3dd96d01aad7626aa48b83c263ea5f7cb1ca5f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/0.5.3/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a15506c0c46919851648982b653aba35fa5e0ed56aa9c3c3286213038db4369c"
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
