module UI
  class Label < UI::View
    include UI::SharedText

    def initialize
      super
      calculate_measure(true)
      self.text_alignment = :left
    end

    def height=(val)
      super
      calculate_measure(false)
    end

    def measure(width, height)
      dimension = [width, height]
      unless width.nan?
        spacing_mult = @line_height ? 0 : 1
        spacing_add = @line_height || 0
        layout = Android::Text::StaticLayout.new(proxy.text, proxy.paint, width, Android::Text::Layout::Alignment::ALIGN_NORMAL, spacing_mult, spacing_add, true)
        dimension[1] = layout.height
      end
      dimension
    end

    def proxy
      @proxy ||= Android::Widget::TextView.new(UI.context)
    end
  end
end
