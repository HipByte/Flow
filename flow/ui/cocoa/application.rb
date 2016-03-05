module UI
  class Application
    def initialize(navigation, context)
      @navigation = navigation
      context.window = container
    end

    def start
      container.rootViewController = @navigation.container
      container.makeKeyAndVisible
      true
    end

    def container
      @container ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    end
  end
end
