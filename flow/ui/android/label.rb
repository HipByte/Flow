module UI
  class Label < UI::View
    include UI::Text

    def initialize
      super
      calculate_measure(true)
      self.text_alignment = :left
    end

    def measure(width, height)
      dimension = [width, height]
      unless width.nan?
        layout = Android::Text::StaticLayout.new(proxy.text, proxy.paint, width, Android::Text::Layout::Alignment::ALIGN_NORMAL, 1, 0, true)
        dimension[1] = layout.height
      end
      dimension
    end

    def proxy
      @proxy ||= Android::Widget::TextView.new(UI.context)
    end
  end
end
