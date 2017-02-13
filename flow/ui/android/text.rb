module UI
  module Text
    def text_alignment
      case (proxy.gravity & Android::View::Gravity::HORIZONTAL_GRAVITY_MASK)
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
      proxy.gravity = val
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
      proxy.text.toString
    end

    def font
      UI::Font._wrap(proxy.typeface, proxy.textSize)
    end

    def font=(font)
      font = UI::Font(font)
      proxy.typeface = font.proxy
      proxy.textSize = font.size
    end
  end
end
