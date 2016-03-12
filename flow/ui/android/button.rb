module UI
  class Button < UI::Control
    def color
      @type == :text ? UI::Color(container.textColor) : nil
    end

    def color=(color)
      _change_type :text
      container.textColor = UI::Color(color).container
    end

    def title
      @type == :text ? container.text : nil
    end

    def title=(text)
      _change_type :text
      container.text = text
    end

    def font
      @type == :text ? UI::Font._wrap(container.typeface, container.textSize) : nil
    end

    def font=(font)
      _change_type :text
      font = UI::Font(font)
      container.setTypeface(font.container)
      container.setTextSize(font.size)
    end

    def image=(image)
      _change_type :image
      stream = UI.context.getAssets.open(image)
      drawable = Android::Graphics::Drawable::Drawable.createFromStream(stream, nil)
      container.imageDrawable = drawable
      container.setPadding(0, 0, 0, 0)
      container.scaleType = Android::Widget::ImageView::ScaleType::FIT_XY
      container.backgroundColor = Android::Graphics::Color::TRANSPARENT
    end

    def _change_type(type)
      if @type != type
        @type = type
        @container = nil
      end
    end

    def container
      @container ||= case @type
        when :text
          Android::Widget::Button.new(UI.context)
        when :image
          Android::Widget::ImageButton.new(UI.context)
        else
          raise "incorrect button type `#{@type}'"
      end
    end
  end
end

