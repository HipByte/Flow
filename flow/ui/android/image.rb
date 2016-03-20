module UI
  class Image < UI::View
    attr_reader :source

    def source=(source)
      if @source != source
        @source = source
        stream = UI.context.getAssets.open(source)
        drawable = Android::Graphics::Drawable::Drawable.createFromStream(stream, nil)
        proxy.imageDrawable = drawable
        self.width = drawable.intrinsicWidth * UI.density
        self.height = drawable.intrinsicHeight * UI.density
      end
    end

    RESIZE_MODES = {
      cover: Android::Widget::ImageView::ScaleType::CENTER_CROP,
      contain: Android::Widget::ImageView::ScaleType::CENTER_INSIDE,
      stretch: Android::Widget::ImageView::ScaleType::FIT_XY
    }

    def resize_mode=(resize_mode)
      proxy.scaleType = RESIZE_MODES.fetch(resize_mode.to_sym) do
        raise "Incorrect value, expected one of: #{RESIZE_MODES.keys.join(',')}"
      end
    end

    def resize_mode
      RESIZE_MODES.key(proxy.scaleType)
    end

    def proxy
      @proxy ||= Android::Widget::ImageView.new(UI.context)
    end
  end
end
