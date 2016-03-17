module UI
  class Web < View
    def load_html(str)
      container.loadHTMLString str, baseURL: NSBundle.mainBundle.bundleURL
    end

    def webView(webView, shouldStartLoadWithRequest:request, navigationType:navType)
      true
    end

    def container
      @container ||= begin
        view = UIWebView.new
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view
      end
    end
  end
end

