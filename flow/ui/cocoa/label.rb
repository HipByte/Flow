module UI
  class Label < View
    def initialize
      super
      calculate_measure(true)
    end

    def height=(val)
      super
      calculate_measure(false)
    end

    def measure(width, height)
      at = proxy.attributedText
      return [0, 0] if at == nil or at.length == 0
      size = [width.nan? ? Float::MAX : width, Float::MAX]
      rect = at.boundingRectWithSize(size, options:NSStringDrawingUsesLineFragmentOrigin, context:nil)
      [width, rect.size.height.ceil]
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

    def line_height=(spacing)
      at = proxy.attributedText

      ps = at.attribute(NSParagraphStyleAttributeName, atIndex:0, effectiveRange:nil)
      ps = ps ? ps.mutableCopy : NSMutableParagraphStyle.new
      ps.minimumLineHeight = spacing

      at = at.mutableCopy
      at.addAttribute(NSParagraphStyleAttributeName, value:ps, range:[0, at.length])
      proxy.attributedText = at
    end

    def line_height
      ps = proxy.attributedText.attribute(NSParagraphStyleAttributeName, atIndex:0, effectiveRange:nil)
      ps ? ps.minimumLineHeight : 0
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
