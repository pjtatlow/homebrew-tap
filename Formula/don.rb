class Don < Formula
  desc "Boss of your dev environment"
  homepage "https://github.com/pjtatlow/don"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.1.0/don-aarch64-apple-darwin.tar.xz"
      sha256 "75fc37d9e6653dff348b021e0e7f0d518f38fbbeba5164273802668f9419bdba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.1.0/don-x86_64-apple-darwin.tar.xz"
      sha256 "d780d27af89748988f71e99d9d5f4665e035a67f3e6dd0cc50f6ccf9456edfb0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pjtatlow/don/releases/download/v0.1.0/don-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "944e3e0b7848c04812caacdd562f532b49aeda636ced90eba4f376de03f967fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pjtatlow/don/releases/download/v0.1.0/don-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23e8dc6059c35d97868a03bc01225be7549162dfa0410a617449e560db0e0cbc"
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
