class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.5.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.8/don-aarch64-apple-darwin.tar.xz"
      sha256 "64255f8f97bf9dcb6cabf2c257b56a16e1b2f62e89e68994dec7a3f7d5faf669"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.8/don-x86_64-apple-darwin.tar.xz"
      sha256 "f068de0cd72ba4cf25692990c2c8c80616099016045aa3c6d09737b5ee45b309"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.8/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "187e64682a7e28ebda29cf63eeea53ea5014c1dac81357edec69fbde5b4281c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.5.8/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ef2ea54501987a3e25feb1622f4a9adac91439e7fdc05097aad9360c64ae2d5"
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
