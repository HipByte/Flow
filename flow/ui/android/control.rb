module UI
  class Control < UI::View
    def blur
      proxy.clearFocus
    end

    def focus
      proxy.requestFocus
    end

    def focus?
      proxy.hasFocus
    end
  end
end
