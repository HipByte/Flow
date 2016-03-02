module UI
  class Color
    def self._native?(color)
      color.is_a?(UIColor)
    end

    def self.rgba(r, g, b, a)
      UIColor.colorWithRed(r/255.0, green:g/255.0, blue:b/255.0, alpha:a/255.0)
    end
  end
end
