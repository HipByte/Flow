module UI
  class Button < UI::View
    def color
      UI::Color(container.textColor)
    end

    def color=(color)
      container.textColor = UI::Color(color).container
    end

    def title=(text)
      container.text = text
    end

    def title
      container.text
    end

    def container
      @container ||= Android::Widget::Button.new(UI.context)
    end
  end
end

