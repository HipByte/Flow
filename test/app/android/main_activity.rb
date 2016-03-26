class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    Store.context = self
    Net.context = self
    super
  end
end
