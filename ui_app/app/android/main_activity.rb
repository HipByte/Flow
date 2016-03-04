class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    requestWindowFeature(Android::View::Window::FEATURE_NO_TITLE)

    layout = Android::Widget::FrameLayout.new(self)
    layout.setId(Android::View::View.generateViewId)
    setContentView(layout)

    UI.context = self

    @main_screen = WelcomeScreen.new

    main_fragment = @main_screen.proxies[:fragment]
    transaction = getFragmentManager.beginTransaction
    transaction.replace(layout.getId, main_fragment)
    transaction.commit
  end
end
