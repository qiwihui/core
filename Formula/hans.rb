class Hans < Formula
    desc "Tunnel IP over ICMP"
    homepage "http://code.gerade.org/hans/"
    url "https://github.com/friedrich/hans/archive/v1.0.tar.gz"
    version "1.0"
    sha256 "53090083d440466e573b35f2eeab0b4b0dcd3e6290f797c999b4f5a0b5caaba2"

    def install
      system "make"
      bin.install "bin/hans"
    end
  
    test do
      system "#{sbin}/hans", "-v"
    end
  end
  