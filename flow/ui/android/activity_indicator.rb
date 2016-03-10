module UI
  class ActivityIndicator < UI::View
    def start
      container.setVisibility(Android::View::View::VISIBLE)
    end

    def stop
      container.setVisibility(Android::View::View::INVISIBLE)
    end

    def animating?
      container.getVisibility == Android::View::View::VISIBLE
    end

    def container
      @container ||= begin
        pbar = Android::Widget::ProgressBar.new(UI.context)
        pbar.setIndeterminate(true)
        pbar.setVisibility(Android::View::View::INVISIBLE)
        pbar
      end
    end
  end
end

