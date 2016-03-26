module UI
  class ActivityIndicator < UI::View
    def initialize
      super
      self.hidden = true
    end

    def start
      self.hidden = false
    end

    def stop
      self.hidden = true
    end

    def animating?
      !hidden?
    end

    def color=(color)
      proxy.indeterminateDrawable.tint = UI::Color(color).proxy
    end

    def proxy
      @proxy ||= begin
        progress_bar = Android::Widget::ProgressBar.new(UI.context)
        progress_bar.setIndeterminate(true)
        progress_bar
      end
    end
  end
end
