class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = ViewController.alloc.init
    rootViewController.title = 'ios-twitter'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = rootViewController
    @window.makeKeyAndVisible

    true
  end
end
