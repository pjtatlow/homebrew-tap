class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.0/don-aarch64-apple-darwin.tar.xz"
      sha256 "84628ca8285682a948a5beffa700315b4c68c048f9f7448722a093861ca30210"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.0/don-x86_64-apple-darwin.tar.xz"
      sha256 "4e25595b4a1d2a9e382e69cfafcbf7d69499a978694b9713a5013ed9737705e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.0/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "967ab7854aff7afb26cae5d49f7058370d50effb14977469944250bb7bca6e31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.0/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "24dbcfe9d2e35b9af7b45702d3bf615a1c1ba1ba8ab8f8aab82f2cb477fea0cc"
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
