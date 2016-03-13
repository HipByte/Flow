module UI
  class Control < UI::View
    def blur
      container.clearFocus
    end

    def focus
      container.requestFocus
    end

    def focus?
      container.hasFocus
    end
  end
end
