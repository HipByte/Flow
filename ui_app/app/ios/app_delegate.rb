class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # We will make it cleaner once we provide an abstraction for AppDelegate
    @window.rootViewController = WelcomeScreen.new.proxies[:ui_view_controller]
    @window.makeKeyAndVisible

    true
  end
end
