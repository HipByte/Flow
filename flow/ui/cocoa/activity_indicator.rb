module UI
  class ActivityIndicator < UI::View
    def start
      container.startAnimating
    end

    def stop
      container.stopAnimating
    end

    def animating?
      container.isAnimating
    end

    def container
      @container ||= begin
        view = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
        view.color = UIColor.grayColor
        view
      end
    end
  end
end
