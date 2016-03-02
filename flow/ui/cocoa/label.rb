module UI
  class Label < View
    def text_alignment
      UI::TEXT_ALIGNMENT.key(container.textAlignment)
    end

    def text_alignment=(text_alignment)
      container.textAlignment = UI::TEXT_ALIGNMENT[text_alignment]
    end

    def color
      container.textColor
    end

    def color=(color)
      container.textColor = UI::Color(color)
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
