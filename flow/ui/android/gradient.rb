module UI
  class Gradient
    def colors=(colors)
      raise ArgError, "must receive an array of 2 or 3 colors" if colors.size < 2 or colors.size > 3
      proxy.colors = colors.map { |x| UI::Color(x).proxy }
    end

    def proxy
      @proxy ||= Android::Graphics::Drawable::GradientDrawable.new
    end
  end
end
