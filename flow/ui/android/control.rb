module UI
  class Control < UI::View
    def resign_focus
      container.clearFocus
    end
  end
end
