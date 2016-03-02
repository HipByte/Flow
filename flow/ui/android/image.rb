module UI
  class Image < UI::View
    attr_reader :source

    def source=(source)
      if @source != source
        @source = source
        stream = UI.context.getAssets.open(source)
        drawable = Android::Graphics::Drawable::Drawable.createFromStream(stream, nil)
        container.setImageDrawable(drawable)
      end
    end

    def container
      @container ||= Android::Widget::ImageView.new(UI.context)
    end
  end
end
