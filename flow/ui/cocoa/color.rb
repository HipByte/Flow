module UI
  class Color
    def self._native?(color)
      color.is_a?(UIColor)
    end

    def self.rgba(r, g, b, a)
      new UIColor.colorWithRed(r/255.0, green:g/255.0, blue:b/255.0, alpha:a/255.0)
    end

    def to_a
      @ary_values ||= begin
        red_ptr = Pointer.new(:double)
        green_ptr = Pointer.new(:double)
        blue_ptr = Pointer.new(:double)
        alpha_ptr = Pointer.new(:double)

        if proxy.getRed(red_ptr, green:green_ptr, blue:blue_ptr, alpha:alpha_ptr)
          [red_ptr[0], green_ptr[0], blue_ptr[0], alpha_ptr[0]]
        else
          [0, 0, 0, 0]
        end.map { |x| (x * 255.0).round}
      end
    end

    def red
      to_a[0]
    end

    def green
      to_a[1]
    end

    def blue
      to_a[2]
    end

    def alpha
      to_a[3]
    end
  end
end
