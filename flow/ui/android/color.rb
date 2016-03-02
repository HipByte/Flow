module UI
  class Color
    def self._native?(color)
      color.is_a?(Fixnum)
    end

    def self.rgba(r, g, b, a = 1)
      Android::Graphics::Color.argb(a, r, g, b)
    end
  end
end
