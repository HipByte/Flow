class CSSNode
  def margin=(margin)
    case margin
    when Fixnum
      self.margin_top = self.margin_right = self.margin_bottom = self.margin_left = margin
    when Array
      if margin.length == 2
        self.margin_top = self.margin_bottom = margin[0]
        self.margin_right = self.margin_left = margin[1]
      elsif margin.length == 4
        self.margin_top, self.margin_bottom, self.margin_right, self.margin_left = margin
      end
    end
  end
end
