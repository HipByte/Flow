module UI
  def self.Color(color)
    case color
    when String
      UI::Color.hex(color)
    when Symbol
      UI::Color.symbol(color)
    when Array
      UI::Color.rgba(*color)
    when UIColor
      color
    else
      raise ArgumentError
    end
  end

  class Color
    def self.symbol(symbol)
      send("#{symbol}")
    end

    def self.hex(hex_color)
      hex_color.gsub!("#", "")

      colors =  case hex_color.size
                when 3
                  hex_color.scan(%r{[0-9A-Fa-f]}).map!{ |el| (el * 2).to_i(16) }
                when 6, 8
                  hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
                else
                  raise ArgumentError
                end

      if colors.size == 3
        rgb(*colors)
      elsif colors.size == 4
        rgba(*colors[1..3], colors[0])
      else
        raise ArgumentError
      end
    end

    def self.rgb(r, g, b)
      rgba(r, g, b, 1)
    end

    def self.rgba(r, g, b, a = 1)
      if a > 1.0
        a = a / 255.0
      end

      UIColor.colorWithRed(r/255.0, green:g/255.0, blue:b/255.0, alpha:a)
    end

    def self.black; UIColor.blackColor; end
    def self.dark_gray; UIColor.darkGrayColor; end
    def self.light_gray; UIColor.lightGrayColor; end
    def self.white; UIColor.whiteColor; end
    def self.gray; UIColor.grayColor; end
    def self.red; UIColor.redColor; end
    def self.green; UIColor.greenColor; end
    def self.blue; UIColor.blueColor; end
    def self.cyan; UIColor.cyanColor; end
    def self.yellow; UIColor.yellowColor; end
    def self.magenta; UIColor.magentaColor; end
    def self.orange; UIColor.orangeColor; end
    def self.purple; UIColor.purpleColor; end
    def self.brown; UIColor.brownColor; end
    def self.clear; UIColor.clearColor; end
    def self.transparent; UIColor.clearColor; end
  end
end
