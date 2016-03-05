class AppDelegate
  attr_accessor :window #needed atm
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    main_screen = WelcomeScreen.new
    navigation = UI::Navigation.new(main_screen)
    flow_app = UI::Application.new(navigation, self)
    flow_app.start
  end
end
