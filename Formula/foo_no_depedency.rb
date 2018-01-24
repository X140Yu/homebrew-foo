class Foo < Formula
  desc "A Simple CLI"
  homepage "zhaoxinyu.me"
  url "https://github.com/X140Yu/homebrew-foo", :using => :git

  def install

    libexec.install Dir["*"]
    bin.write_exec_script (libexec/"foo")
  end
end