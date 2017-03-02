module UI
  class Application
    attr_reader :navigation

    @@instance = nil
    def initialize(navigation, context)
      @navigation = navigation
      context.window = proxy
      @@instance = self
    end

    def self.instance
      @@instance
    end

    def start
      proxy.rootViewController = @navigation.proxy
      proxy.makeKeyAndVisible
      true
    end

    def open_phone_call(number)
      url = NSURL.URLWithString("tel://#{number}")
      UIApplication.sharedApplication.openURL(url)
    end

    def proxy
      @proxy ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    end
  end
end
