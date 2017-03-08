module UI
  class Gradient
    attr_reader :colors

    def colors=(colors)
      raise ArgError, "must receive an array of 2 or 3 colors" if colors.size < 2 or colors.size > 3
      @colors = colors.map { |x| UI::Color(x).proxy }
    end
  end
end
