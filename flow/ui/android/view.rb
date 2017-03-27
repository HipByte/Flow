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

    # These properties are used when generating the background drawable right after layout.
    attr_accessor :background_color, :background_gradient, :border_color, :border_width, :border_radius, :shadow_offset, :shadow_color, :shadow_radius

    def hidden?
      proxy.visibility != Android::View::View::VISIBLE
    end

    def hidden=(flag)
      if flag != hidden?
        if flag
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
  
        proxy.visibility = flag ? Android::View::View::INVISIBLE : Android::View::View::VISIBLE
  
        self.root.update_layout
      end
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

    def insert_child(index, child)
      super
      proxy.addView(child.proxy, index)
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
        resized = params.width != width or params.height != height
        params.width = width
        params.height = height
        proxy.layoutParams = params
        _regenerate_background if resized
      end
      children.each { |child| child._apply_layout }
    end

    def _regenerate_background
      return unless @background_gradient or @background_color or @border_width or @shadow_radius

      width, height = layout[2], layout[3]
      return unless width > 0 and height > 0

      bitmap = Android::Graphics::Bitmap.createBitmap(width, height, Android::Graphics::Bitmap::Config::ARGB_8888)
      canvas = Android::Graphics::Canvas.new(bitmap)

      paint = Android::Graphics::Paint.new
      if @background_gradient
        colors = @background_gradient.colors
        positions = case colors.size
          when 2 then [0, 1]
          when 3 then [0, 0.5, 1]
          else raise "invalid number of colors"
        end
        paint.shader = Android::Graphics::LinearGradient.new(0, 0, 0, height, colors, positions, Android::Graphics::Shader::TileMode::MIRROR)
      elsif @background_color
        paint.color = UI::Color(@background_color).proxy
      end

      shadow_radius = (@shadow_radius || 0) * UI.density
      if shadow_radius > 0
        x = y = 0
        if @shadow_offset
          x, y = @shadow_offset
        end
        color = UI::Color(@shadow_color || :black).proxy
        paint.setShadowLayer(shadow_radius, x, y, color)
        proxy.setLayerType(Android::View::View::LAYER_TYPE_SOFTWARE, paint) # disable hardware acceleration when drawing shadows, seems required on some devices
        proxy.setPadding(shadow_radius, shadow_radius, shadow_radius, shadow_radius)
      end

      corner_radius = (@border_radius || 0) * UI.density
      canvas.drawRoundRect(shadow_radius, shadow_radius, width - shadow_radius, height - shadow_radius, corner_radius, corner_radius, paint)

      border_width = (@border_width || 0) * UI.density
      if border_width > 0
        paint = Android::Graphics::Paint.new
        paint.color = UI::Color(@border_color || :black).proxy
        paint.style = Android::Graphics::Paint::Style::STROKE
        paint.strokeWidth = border_width
        canvas.drawRoundRect(border_width, border_width, width - border_width, height - border_width, corner_radius, corner_radius, paint)
      end

      proxy.background = Android::Graphics::Drawable::BitmapDrawable.new(UI.context.resources, bitmap)
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
