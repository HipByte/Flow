module UI
  class View < CSSNode
    ANIMATION_OPTIONS = {
      ease_out: UIViewAnimationOptionCurveEaseOut,
      ease_in:  UIViewAnimationOptionCurveEaseIn,
      linear:   UIViewAnimationOptionCurveLinear
    }

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
      container.layer.borderColor = UI::Color(color).container.CGColor
    end

    def border_radius=(radius)
      container.layer.cornerRadius = radius
    end

    def border_width=(width)
      container.layer.borderWidth = width
    end

    def border_color
      container.layer.borderColor
    end

    def border_radius
      container.layer.cornerRadius
    end

    def border_width
      container.layer.borderWidth
    end

    def background_color
      UI::Color(container.backgroundColor)
    end

    def background_color=(background_color)
      container.backgroundColor = UI::Color(background_color).container
    end

    def hidden?
      container.hidden
    end

    def hidden=(hidden)
      container.hidden = hidden
    end

    def alpha
      container.alpha
    end

    def alpha=(value)
      container.alpha = value
    end

    def add_child(child)
      super
      container.addSubview(child.container)
    end

    def delete_child(child)
      if super
        child.container.removeFromSuperview
      end
    end

    def update_layout
      super
      _apply_layout([0, 0])
    end

    def _apply_layout(absolute_point)
      left, top, width, height = layout

      top_left = [absolute_point[0] + left, absolute_point[1] + top]
      bottom_right = [absolute_point[0] + left + width, absolute_point[1] + top + height]
      container.frame = [[left, top], [bottom_right[0] - top_left[0], bottom_right[1] - top_left[1]]]

      absolute_point[0] += left
      absolute_point[1] += top

      children.each { |x| x._apply_layout(absolute_point) }
    end

    def container
      @container ||= begin
        ui_view = UIView.alloc.init
        ui_view.translatesAutoresizingMaskIntoConstraints = false
        ui_view
      end
    end
  end
end
