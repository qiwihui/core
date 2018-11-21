require "language/go"

class Goquiet < Formula
  desc "A shadowsocks plugin that obfuscates SS traffic and can defend against active probing"
  homepage "https://github.com/cbeuw/GoQuiet"
  url "https://github.com/cbeuw/GoQuiet/archive/v1.2.2.tar.gz"
  sha256 "0f5c02aec25eb0598082dbbb7b47b377efa2d53277b90c3c426d5cfb8511e865"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cbeuw").mkpath
    ln_s buildpath, "src/github.com/cbeuw/GoQuiet"

    system "make"
    bin.install Dir["build/*"]
    prefix.install_metafiles
    system "make", "install"
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/gq-client -h 2>&1", 2)
    assert_match "Usage of", shell_output("#{bin}/gq-server -h 2>&1", 2)
  end
end