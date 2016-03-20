module UI
  class Color
    def self._native?(color)
      color.is_a?(Fixnum)
    end

    def self.rgba(r, g, b, a)
      new Android::Graphics::Color.argb(a, r, g, b)
    end

    def red
      Android::Graphics::Color.red(proxy)
    end

    def green
      Android::Graphics::Color.green(proxy)
    end

    def blue
      Android::Graphics::Color.blue(proxy)
    end

    def alpha
      Android::Graphics::Color.alpha(proxy)
    end

    def to_a
      [red, green, blue, alpha]
    end
  end
end
