module UI
  class Web < View
    def load_html(string)
      proxy.loadHTMLString(string, baseURL: NSBundle.mainBundle.bundleURL)
    end

    def webView(web_view, shouldStartLoadWithRequest:request, navigationType:navigation_type)
      true
    end

    def proxy
      @proxy ||= begin
        ui_web_view = UIWebView.new
        ui_web_view.translatesAutoresizingMaskIntoConstraints = false
        ui_web_view.delegate = self
        ui_web_view
      end
    end
  end
end
