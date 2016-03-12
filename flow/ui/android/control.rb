module UI
  class Control < UI::View
    def resign_focus
      container.clearFocus
    end

    def request_focus
      container.requestFocus
    end

    def focus?
      container.hasFocus
    end
  end
end
