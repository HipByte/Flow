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

    def proxy
      @proxy ||= begin
        pbar = Android::Widget::ProgressBar.new(UI.context)
        pbar.setIndeterminate(true)
        pbar
      end
    end
  end
end
