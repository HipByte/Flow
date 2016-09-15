class FlowUIViewLayoutChangeListener
  def initialize(view)
    @view = view
  end

  def onLayoutChange(view, left, top, right, bottom, old_left, old_top, old_right, old_bottom)
    if (right - left) != (old_right - old_left) or (top - bottom) != (old_top - old_bottom)
      @view.update_layout
    end
  end
end

module UI
  class View < CSSNode
    attr_accessor :_previous_width, :_previous_height

    def background_color
      view = proxy.getBackground
      view.is_a?(Android::Graphics::Drawable::ColorDrawable) ? UI::Color(view.getColor) : nil
    end

    def background_color=(background_color)
      proxy.backgroundColor = UI::Color(background_color).proxy
    end

    def hidden?
      proxy.visibility != Android::View::View::VISIBLE
    end

    def hidden=(hidden)
      if hidden
        if !self.width.nan?
          self._previous_width = self.width
          self.width = 0
        end

        if !self.height.nan?
          self._previous_height = self.height
          self.height = 0
        end
      else
        self.width = self._previous_width if self._previous_width
        self.height = self._previous_height if self._previous_height
      end

      proxy.visibility = hidden ? Android::View::View::INVISIBLE : Android::View::View::VISIBLE

      self.root.update_layout
    end

    def alpha
      proxy.alpha
    end

    def alpha=(value)
      proxy.alpha = value
    end

    def add_child(child)
      super
      proxy.addView(child.proxy)
    end

    def delete_child(child)
      if super
        proxy.removeView(child.proxy)
      end
    end

    def update_layout
      super
      _apply_layout
    end

    def proxy
      @proxy ||= Android::Widget::FrameLayout.new(UI.context)
    end

    def _apply_layout
      if params = proxy.layoutParams
        left, top, width, height = layout
        if params.is_a?(Android::View::ViewGroup::MarginLayoutParams)
          params.leftMargin = left
          params.topMargin = top
        end
        params.width = width
        params.height = height
        proxy.layoutParams = params
      end
      children.each { |child| child._apply_layout }
    end

    def _autolayout_when_resized=(value)
      if value
        unless @layout_listener
          @layout_listener = FlowUIViewLayoutChangeListener.new(self)
          proxy.addOnLayoutChangeListener(@layout_listener)
        end
      else
        if @layout_listener
          proxy.removeOnLayoutChangeListener(@layout_listener)
          @layout_listener = nil
        end
      end
    end
  end
end
