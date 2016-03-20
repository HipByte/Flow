module UI
  class ActivityIndicator < UI::View
    def start
      proxy.startAnimating
    end

    def stop
      proxy.stopAnimating
    end

    def animating?
      proxy.animating?
    end

    def proxy
      @proxy ||= begin
        view = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
        view.color = UIColor.grayColor
        view
      end
    end
  end
end
