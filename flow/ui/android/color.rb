module UI
  class Color
    def self._native?(color)
      color.is_a?(Fixnum)
    end

    def self.rgba(r, g, b, a)
      new Android::Graphics::Color.argb(a, r, g, b)
    end

    def red
      Android::Graphics::Color.red(container)
    end

    def green
      Android::Graphics::Color.green(container)
    end

    def blue
      Android::Graphics::Color.blue(container)
    end

    def alpha
      Android::Graphics::Color.alpha(container)
    end

    def to_a
      [red, green, blue, alpha]
    end
  end
end
