module UI
  class View < CSSNode
    ANIMATION_OPTIONS = {
      ease_out: UIViewAnimationOptionCurveEaseOut,
      ease_in:  UIViewAnimationOptionCurveEaseIn,
      linear:   UIViewAnimationOptionCurveLinear
    }

    attr_accessor :_previous_width, :_previous_height

    def animate(options = {}, &block)
      animation_options = options.fetch(:options, :linear)

      UIView.animateWithDuration(options.fetch(:duration, 0),
        delay: options.fetch(:delay, 0),
        options: ANIMATION_OPTIONS.values_at(*animation_options).reduce(&:|),
        animations: lambda {
          self.root.update_layout
        },
        completion: lambda {|completion|
          block.call if block
        })
    end

    def border_color=(color)
      proxy.layer.borderColor = UI::Color(color).proxy.CGColor
    end

    def border_radius=(radius)
      proxy.layer.cornerRadius = radius
    end

    def border_width=(width)
      proxy.layer.borderWidth = width
    end

    def border_color
      proxy.layer.borderColor
    end

    def border_radius
      proxy.layer.cornerRadius
    end

    def border_width
      proxy.layer.borderWidth
    end

    def background_color
      UI::Color(proxy.backgroundColor)
    end

    def background_color=(background_color)
      proxy.backgroundColor = UI::Color(background_color).proxy
    end

    def hidden?
      proxy.hidden
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

      proxy.hidden = hidden

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
      proxy.addSubview(child.proxy)
    end

    def delete_child(child)
      if super
        child.proxy.removeFromSuperview
      end
    end

    def update_layout
      super
      _apply_layout([0, 0], proxy.frame.origin)
    end

    def proxy
      @proxy ||= begin
        ui_view = UIView.alloc.init
        ui_view.translatesAutoresizingMaskIntoConstraints = false
        ui_view
      end
    end

    def _apply_layout(absolute_point, origin_point)
      left, top, width, height = layout

      top_left = [absolute_point[0] + left, absolute_point[1] + top]
      bottom_right = [absolute_point[0] + left + width, absolute_point[1] + top + height]
      proxy.frame = [[left + origin_point[0], top + origin_point[1]], [bottom_right[0] - top_left[0], bottom_right[1] - top_left[1]]]

      absolute_point[0] += left
      absolute_point[1] += top

      children.each { |x| x._apply_layout(absolute_point, [0, 0]) }
    end
  end
end
