class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.2.3/don-aarch64-apple-darwin.tar.xz"
      sha256 "0dc3893f4355867b9bb958cb4bfe939bdbbd446920ddee9f7a7ad41bf9d7358e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.2.3/don-x86_64-apple-darwin.tar.xz"
      sha256 "4b2a9dd9819f83b4675447789288c03051214883898e4dacf9687ad2940f3b28"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.2.3/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9caca71ca0790c1d055d0a96cbe9b0c50378dbba559e444e40906b965a030f8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.2.3/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b935bdaed5475a3f704cdb1364a0d77cc8a0a41a0c92ad2f4831faef267c923b"
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
