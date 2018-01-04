module UI
  class Web < View
    attr_accessor :configuration

    def initialize(configuration = nil)
      super()
      @configuration = configuration || WKWebViewConfiguration.new
    end

    def load_html(string)
      proxy.loadHTMLString(string, baseURL: NSBundle.mainBundle.bundleURL)
    end

    def proxy
      @proxy ||= begin
        ui_web_view = WKWebView.alloc.initWithFrame([[0,0], [1024, 768]], configuration: @configuration)
        ui_web_view.translatesAutoresizingMaskIntoConstraints = false
        ui_web_view.UIDelegate = self
        ui_web_view.NavigationDelegate = self
        ui_web_view
      end
    end
  end
end
