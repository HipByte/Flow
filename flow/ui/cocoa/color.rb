module UI
  def self.Color(color)
    case color
    when String
      UI::Color.hex(color)
    when Symbol
      UI::Color.symbol(color)
    else
      color
    end
  end


  # Mostly borrowed from BubbleWrap
  # will need a lot more work
  class Color
    def self.symbol(symbol)
      Color.send("#{symbol}")
    end

    def self.hex(hex_color)
      hex_color = hex_color.gsub("#", "")
      case hex_color.size
        when 3
          colors = hex_color.scan(%r{[0-9A-Fa-f]}).map!{ |el| (el * 2).to_i(16) }
        when 6
          colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
        when 8
          colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
        else
          raise ArgumentError
      end
      if colors.size == 3
        Color.rgb_color(colors[0], colors[1], colors[2])
      elsif colors.size == 4
        Color.rgba_color(colors[1], colors[2], colors[3], colors[0])
      else
        raise ArgumentError
      end
    end

    def self.rgb_color(r,g,b)
      rgba_color(r,g,b,1)
    end

    def self.rgba_color(r,g,b,a)
      r,g,b = [r,g,b].map { |i| i / 255.0}
      if a > 1.0
        a = a / 255.0
      end
      UIColor.colorWithRed(r, green: g, blue:b, alpha:a)
    end

    def self.red
      UIColor.redColor
    end

    def self.black
      UIColor.blackColor
    end

    def self.white
      UIColor.whiteColor
    end

    def self.blue
      UIColor.blueColor
    end

    def self.yellow
      UIColor.yellowColor
    end

    def self.green
      UIColor.greenColor
    end
  end
end
