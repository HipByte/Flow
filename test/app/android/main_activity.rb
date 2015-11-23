class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
p Digest::MD5.digest("hello world\n")
p Digest::SHA1.digest("hello world\n")
  end
end
