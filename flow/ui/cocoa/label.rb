module UI
  class Label < View
    def text_alignment
      UI::TEXT_ALIGNMENT.key(container.textAlignment)
    end

    def text_alignment=(text_alignment)
      container.textAlignment = UI::TEXT_ALIGNMENT.fetch(text_alignment) do
        raise "Incorrect value, expected one of: #{UI::TEXT_ALIGNMENT.keys.join(',')}"
      end
    end

    def color
      UI::Color(container.textColor)
    end

    def color=(color)
      container.textColor = UI::Color(color).container
    end

    def text=(text)
      container.text = text
    end

    def text
      container.text
    end

    def container
      @container ||= begin
        ui_label = UILabel.alloc.init
        ui_label.translatesAutoresizingMaskIntoConstraints = false
        ui_label
      end
    end
  end
end
