module UI
  class Label < View
    def initialize
      super
      calculate_measure(true)
    end

    def measure(width, height)
      return [0,0] if proxy.attributedText.nil? || proxy.attributedText.length == 0
      size = [width.nan? ? Float::MAX : width, Float::MAX]
      rect = proxy.attributedText.boundingRectWithSize(size, options:NSStringDrawingUsesLineFragmentOrigin, context:nil)
      [width, rect.size.height]
    end

    def text_alignment
      UI::TEXT_ALIGNMENT.key(proxy.textAlignment)
    end

    def text_alignment=(text_alignment)
      proxy.textAlignment = UI::TEXT_ALIGNMENT.fetch(text_alignment) do
        raise "Incorrect value, expected one of: #{UI::TEXT_ALIGNMENT.keys.join(',')}"
      end
    end

    def color
      UI::Color(proxy.textColor)
    end

    def color=(color)
      proxy.textColor = UI::Color(color).proxy
    end

    def text=(text)
      proxy.text = text
    end

    def text
      proxy.text
    end

    def font
      UI::Font._wrap(proxy.font)
    end

    def font=(font)
      proxy.font = UI::Font(font).proxy
    end

    def proxy
      @proxy ||= begin
        ui_label = UILabel.alloc.init
        ui_label.translatesAutoresizingMaskIntoConstraints = false
        ui_label.lineBreakMode = NSLineBreakByWordWrapping
        ui_label.numberOfLines = 0
        ui_label
      end
    end
  end
end
