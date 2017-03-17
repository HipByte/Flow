module UI
  module SharedText
    def text_proxy; proxy; end

    def text_alignment
      case (text_proxy.gravity & Android::View::Gravity::HORIZONTAL_GRAVITY_MASK)
        when Android::View::Gravity::LEFT
          :left
        when Android::View::Gravity::RIGHT
          :right
        else
          :center
      end
    end

    def text_alignment=(sym)
      val = Android::View::Gravity::CENTER_VERTICAL
      val |= case sym
        when :left
          Android::View::Gravity::LEFT
        when :center
          Android::View::Gravity::CENTER_HORIZONTAL
        when :right
          Android::View::Gravity::RIGHT
        else
          raise "Incorrect value, should be :left, :center or :right"
      end
      text_proxy.gravity = val
    end

    def color
      UI::Color(text_proxy.textColor)
    end

    def color=(color)
      text_proxy.textColor = UI::Color(color).proxy
    end

    def text=(text)
      text_proxy.text = text
    end

    def text
      text_proxy.text.toString
    end

    def font
      UI::Font._wrap(text_proxy.typeface, text_proxy.textSize)
    end

    def font=(font)
      font = UI::Font(font)
      text_proxy.typeface = font.proxy
      text_proxy.textSize = font.size
    end

    def line_height=(spacing)
      if @line_height != spacing
        @line_height = spacing * UI.density
        text_proxy.setLineSpacing(@line_height, 0)
      end
    end

    def line_height
      @line_height / UI.density
    end
  end
end
