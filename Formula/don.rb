class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.8.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.5/don-aarch64-apple-darwin.tar.xz"
      sha256 "2421d05b812b323f378abe40397cbeb59a6976a888a2f3616e35ce0f44e668f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.5/don-x86_64-apple-darwin.tar.xz"
      sha256 "9296aabec01f31c9c3980cd50e8342ebc2cad7b02a5d6e3071a3ae2fae2250e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.5/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cbcac2eb1c8c7d32950a3780264047ca390cd9242b7fd2cd6cc40e6949ce9ef4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.8.5/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b2ad7e7baac14ba20c6d7d03aa1f76e095b52762652f3bac6524da73f25fd13"
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
