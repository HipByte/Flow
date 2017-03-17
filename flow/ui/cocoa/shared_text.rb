module UI
  module SharedText
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

    def _text=(text)
      if text
        proxy.text = text
        if text.size > 0 and @line_height
          at = proxy.attributedText.mutableCopy
          if ps = at.attribute(NSParagraphStyleAttributeName, atIndex:0, effectiveRange:nil)
            ps = ps.mutableCopy
          else
            ps = NSMutableParagraphStyle.new
          end
          ps.minimumLineHeight = @line_height
          at.addAttribute(NSParagraphStyleAttributeName, value:ps, range:[0, at.length])
          proxy.attributedText = at
        end
      end
    end

    def text=(text)
      self._text = text
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
      if @line_height != spacing
        @line_height = spacing
        self._text = proxy.text
      end
    end

    def line_height
      @line_height
    end
  end
end
