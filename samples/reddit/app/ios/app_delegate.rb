class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    posts_screen = PostsScreen.new
    navigation = UI::Navigation.new(posts_screen)
    flow_app = UI::Application.new(navigation, self)
    flow_app.start
  end
end
