class FlowViewLayoutChangeListener
  def initialize(view)
    @view = view
  end

  def onLayoutChange(view, left, top, right, bottom, old_left, old_top, old_right, old_bottom)
    @view.update_layout
  end
end

module UI
  class View < CSSNode
    def background_color
      view = container.getBackground
      view.is_a?(Android::Graphics::Drawable::ColorDrawable) ? UI::Color(view.getColor) : nil
    end

    def background_color=(background_color)
      container.backgroundColor = UI::Color(background_color).container
    end

    def hidden?
      container.visibility != Android::View::View::VISIBLE
    end

    def hidden=(value)
      container.visibility = value ? Android::View::View::INVISIBLE : Android::View::View::VISIBLE
    end

    def alpha
      container.alpha
    end

    def alpha=(value)
      container.alpha = value
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

    def _autolayout_when_resized=(value)
      if value
        unless @layout_listener
          @layout_listener = FlowViewLayoutChangeListener.new(self)
          container.addOnLayoutChangeListener(@layout_listener)
        end
      else
        if @layout_listener
          container.removeOnLayoutChangeListener(@layout_listener)
          @layout_listener = nil
        end
      end
    end

    def container
      @container ||= begin
        view = Android::Widget::FrameLayout.new(UI.context)
        view.focusableInTouchMode = true
        view
      end
    end
  end
end
