class Foo < Formula
  desc "A Simple CLI"
  homepage "zhaoxinyu.me"
  url "https://github.com/X140Yu/homebrew-foo", :using => :git, :tag => '0.0.1'

  resource "gli" do
    url "https://rubygems.org/downloads/gli-2.17.1.gem"
    sha256 "584d527f59c7f4911941776bd7ec733d3ab693e4fea35223816409083b1def3c"
  end

  def install

    (lib/"foo/vendor").mkpath
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system("gem", "install", r.cached_download, "--no-document",
             "--install-dir", "#{lib}/foo/vendor")
    end

    libexec.install Dir["*"]
    bin.write_exec_script (libexec/"foo")

    foo_path = (bin/"foo")

    FileUtils.chmod 0755, foo_path

    File.write(foo_path, exec_script)
  end

  def exec_script
    <<~EOS
      #!/bin/bash
      export DISABLE_BUNDLER_SETUP=1
      export GEM_HOME="#{HOMEBREW_PREFIX}/lib/foo/vendor"

      exec ruby "#{libexec}/foo" "$@"
    EOS
  end


end