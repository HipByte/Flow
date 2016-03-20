module UI
  class Application
    def initialize(navigation, context)
      @navigation = navigation
      context.window = proxy
    end

    def start
      proxy.rootViewController = @navigation.proxy
      proxy.makeKeyAndVisible
      true
    end

    def proxy
      @proxy ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    end
  end
end
