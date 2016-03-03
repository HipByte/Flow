module UI
  def self.Color(color)
    if UI::Color._native?(color)
      UI::Color.new(color)
    else
      case color
        when UI::Color
          self
        when String
          UI::Color.hex(color)
        when Symbol
          UI::Color.symbol(color)
        when Array
          UI::Color.rgba(*color)
        else
          raise "Expected UI::Color, String, Symbol or Array of Fixnum objects"
      end
    end
  end

  class Color
    attr_reader :container
    def initialize(container)
      @container = container
    end

    def self.symbol(symbol)
      send(symbol)
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
      rgba(r, g, b, 255)
    end

    def self.black
      rgb(0, 0, 0)
    end

    def self.white
      rgb(255, 255, 255)
    end

    def self.red
      rgb(255, 0, 0)
    end

    def self.green
      rgb(0, 255, 0)
    end

    def self.blue
      rgb(0, 0, 255)
    end

=begin 
    # convert these to rgba() calls
    def self.dark_gray; UIColor.darkGrayColor; end
    def self.light_gray; UIColor.lightGrayColor; end
    def self.gray; UIColor.grayColor; end
    def self.cyan; UIColor.cyanColor; end
    def self.yellow; UIColor.yellowColor; end
    def self.magenta; UIColor.magentaColor; end
    def self.orange; UIColor.orangeColor; end
    def self.purple; UIColor.purpleColor; end
    def self.brown; UIColor.brownColor; end
    def self.clear; UIColor.clearColor; end
    def self.transparent; UIColor.clearColor; end
=end
  end
end
