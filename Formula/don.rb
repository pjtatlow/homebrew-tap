class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.7.1/don-aarch64-apple-darwin.tar.xz"
      sha256 "0e9f0f4114637d62f9f6ebcb8fea611f38cdcb94789af342448af336a2fe95a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.7.1/don-x86_64-apple-darwin.tar.xz"
      sha256 "956969ef583acd24218cb1e9b0f0f3761f1a1312cad259aad7ad3b231ae76fd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.7.1/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "66934bc4f93a4849b4f61dab8978e9c2a6ed2cda144cfddae305e4596754578c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.7.1/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ef9218e79c587d4e62959180f989f17529b8cf6ce61ec4dbd96911c2712a8ee"
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
