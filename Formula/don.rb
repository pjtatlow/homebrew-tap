class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.3/don-aarch64-apple-darwin.tar.xz"
      sha256 "3baa71fd43fcb40898c2b6d3b9cc066751a2a318a45ffe23ec7002d1f54b2f33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.3/don-x86_64-apple-darwin.tar.xz"
      sha256 "198c49959ff88bffd463863e26a9be21d4100d564e084cbcdb3ac2e776645c2a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.3/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "511dcb06a6ba03002d57d2196bc42155aecd4c2ad227f8a9c1e6cff29cc7ba24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.3/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "070a9fc2c047e01d3e57dadcd8ae748772fa09cc3a8371699f34b46ad271583f"
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
