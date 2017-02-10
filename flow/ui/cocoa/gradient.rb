module UI
  class Gradient
    def colors=(colors)
      raise ArgError, "must receive an array of 2 or 3 colors" if colors.size < 2 or colors.size > 3
      proxy.colors = colors.map { |x| UI::Color(x).proxy.CGColor }
    end

    def proxy
      @proxy ||= CAGradientLayer.layer
    end
  end
end
