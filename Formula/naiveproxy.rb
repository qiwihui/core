class Naiveproxy < Formula
  desc "Naive is a proxy to transport traffic as Chromium traffic."
  homepage "https://github.com/klzgrad/naiveproxy"
  version "v83.0.4103.61-1"
  url "https://github.com/klzgrad/naiveproxy/releases/download/#{version}/naiveproxy-#{version}-osx.tar.xz"
  sha256 "bca6cad9c95b0aefb3e0cb2cb30eabe53c8010774a8be9538c74a848a9471836"

  def install
    bin.install "naive"
    (buildpath/"naiveproxy-config.json").write <<~EOS
      {
        "listen": "socks://127.0.0.1:1080",
        "proxy": "https://user:pass@domain.example",
        "padding": true
      }
    EOS
    etc.install "naiveproxy-config.json"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/naiveproxy/bin/naive #{HOMEBREW_PREFIX}/etc/naiveproxy-config.json"
  
  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/naive</string>
          <string>#{etc}/naiveproxy-config.json</string>
          <string>-u</string>
        </array>
        <key>StandardErrorPath</key>
        <string>/usr/local/var/log/naiveproxy.log</string>
        <key>StandardOutPath</key>
        <string>/usr/local/var/log/naiveproxy-config.err.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/naive", "--version"
    (testpath/"naiveproxy-config-client.json").write <<~EOS
      {
        "listen": "socks://127.0.0.1:1080",
        "proxy": "http://127.0.0.1:8081",
        "padding": true
      }
    EOS
    (testpath/"naiveproxy-config-server.json").write <<~EOS
      {
        "listen": "http://127.0.0.1:8081",
        "padding": true
      }
    EOS
    server = fork { exec bin/"naive", testpath/"naiveproxy-config-server.json" }
    client = fork { exec bin/"naive", testpath/"naiveproxy-config-client.json" }
    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:1080", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end