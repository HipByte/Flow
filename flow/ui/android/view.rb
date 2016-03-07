module UI
  class View < CSSNode
    def background_color
      view = container.getBackground
      view.is_a?(Android::Graphics::Drawable::ColorDrawable) ? UI::Color(view.getColor) : nil
    end

    def background_color=(background_color)
      container.backgroundColor = UI::Color(background_color).container
    end

    def add_child(child)
      super
      container.addView(child.container)
    end

    def delete_child(child)
      if super
        container.removeView(child.container)
      end
    end

    def update_layout
      super
      _apply_layout
    end

    def _apply_layout
      if params = container.layoutParams
        left, top, width, height = layout
        if params.is_a?(Android::View::ViewGroup::MarginLayoutParams)
          params.leftMargin = left
          params.topMargin = top
        end
        params.width = width
        params.height = height
        container.layoutParams = params
      end
      children.each { |x| x._apply_layout }
    end

    def container
      @container ||= Android::Widget::FrameLayout.new(UI.context)
    end
  end
end
