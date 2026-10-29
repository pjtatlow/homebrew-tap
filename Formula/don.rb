class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.8.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.6/don-aarch64-apple-darwin.tar.xz"
      sha256 "a7ec6a83f3abc11dff42bd21528d9d1213465b72f0a08806c676f8baeb2ebfb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.6/don-x86_64-apple-darwin.tar.xz"
      sha256 "ffcae96ce28009a38c0b547c8702475dfe7db6ccfc65e49c9f06399cbc6c8ba8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.6/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5cb631062483ef9931ce1ae0689dcec048dcfe28fa3ad413c5eeb427f5696daf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.6/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73ba8c153fd7bb2ec08d5d4031ad30addd78cf158b9f092b355b1a47b9964d4d"
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
