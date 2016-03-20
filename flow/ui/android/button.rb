class FlowUIButtonClickListener
  def initialize(view)
    @view = view
  end

  def onClick(button)
    @view.trigger :tap
  end
end

module UI
  class Button < UI::Control
    include Eventable

    def color
      @type == :text ? UI::Color(proxy.textColor) : nil
    end

    def color=(color)
      _change_type :text
      proxy.textColor = UI::Color(color).proxy
    end

    def title
      @type == :text ? proxy.text : nil
    end

    def title=(text)
      _change_type :text
      proxy.text = text
    end

    def font
      @type == :text ? UI::Font._wrap(proxy.typeface, proxy.textSize) : nil
    end

    def font=(font)
      _change_type :text
      font = UI::Font(font)
      proxy.setTypeface(font.proxy)
      proxy.setTextSize(font.size)
    end

    def image=(image)
      _change_type :image
      stream = UI.context.getAssets.open(image)
      drawable = Android::Graphics::Drawable::Drawable.createFromStream(stream, nil)
      proxy.imageDrawable = drawable
      proxy.setPadding(0, 0, 0, 0)
      proxy.scaleType = Android::Widget::ImageView::ScaleType::FIT_XY
      proxy.backgroundColor = Android::Graphics::Color::TRANSPARENT
    end

    def _change_type(type)
      if @type != type
        @type = type
        @proxy = nil
      end
    end

    def proxy
      @proxy ||= begin
        case @type
          when :text
            button = Android::Widget::Button.new(UI.context)
            button.setPadding(0, 0, 0, 0)
            button.allCaps = false
          when :image
            button = Android::Widget::ImageButton.new(UI.context)
          else
            raise "incorrect button type `#{@type}'"
        end
        button.onClickListener = FlowUIButtonClickListener.new(self)
        button
      end
    end
  end
end
