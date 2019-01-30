class Iodine < Formula
  desc "Tunnel IPv4 data through a DNS server"
  homepage "http://code.kryo.se/iodine/"
  url "http://code.kryo.se/iodine/iodine-0.7.0.tar.gz"
  sha256 "ad2b40acf1421316ec15800dcde0f587ab31d7d6f891fa8b9967c4ded93c013e"

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "iodine"
    bin.install "iodined"
    man8.install "iodine.8"
  end

  test do
    system "#{sbin}/iodine", "-v"
  end
end
