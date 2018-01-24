class Foo < Formula
  desc "A Simple CLI"
  homepage "zhaoxinyu.me"
  url "https://github.com/X140Yu/homebrew-foo", :using => :git, :tag => '0.0.1'

  # 因为依赖了 `gli` 这个 gem，所以在 resource 中添加 `gli`
  resource "gli" do
    url "https://rubygems.org/downloads/gli-2.17.1.gem"
    sha256 "584d527f59c7f4911941776bd7ec733d3ab693e4fea35223816409083b1def3c"
  end

  def install

    # 创建 vendor 文件夹，用来放所有依赖的 gem
    (lib/"foo/vendor").mkpath
    
    # 安装依赖的每一个 gem
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system("gem", "install", r.cached_download, "--no-document",
             "--install-dir", "#{lib}/foo/vendor")
    end

    # 安装所有源代码
    libexec.install Dir["*"]
    # 创建 foo 命令
    bin.write_exec_script (libexec/"foo")

    foo_path = (bin/"foo")

    # 修改 foo 的权限，让它可以被更改
    FileUtils.chmod 0755, foo_path

    # 把下面的脚本写入 foo 命令中
    File.write(foo_path, exec_script)
  end

  def exec_script
    <<~EOS
      #!/bin/bash
      export DISABLE_BUNDLER_SETUP=1
      # 在 path 中添加 vendor 目录，每次执行 foo 的时候，就可以找到依赖了
      export GEM_HOME="#{HOMEBREW_PREFIX}/lib/foo/vendor"

      # 执行我们创建的 foo 文件
      exec ruby "#{libexec}/foo" "$@"
    EOS
  end


end
