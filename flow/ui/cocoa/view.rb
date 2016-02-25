module UI
  class View < CSSNode
    RESIZE_MODE = {
      scale_to_fill:  UIViewContentModeScaleToFill,
      aspect_fit:     UIViewContentModeScaleAspectFit,
      aspect_fill:    UIViewContentModeScaleAspectFill
    }

    def resize_mode=(resize_mode)
      container.contentMode = RESIZE_MODE.fetch(resize_mode)
    end

    def resize_mode
      RESIZE_MODE.key(container.contentMode)
    end

    def background_color
      container.backgroundColor
    end

    def background_color=(background_color)
      container.backgroundColor = UI::Color(background_color)
    end

    def hidden
      container.hidden
    end

    def hidden=(hidden)
      container.hidden = hidden
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

    def layout!
      super
      _apply_layout([0, 0])
    end

    def _apply_layout(absolute_point)
      top_left = [absolute_point[0] + left, absolute_point[1] + top]
      bottom_right = [absolute_point[0] + left + width, absolute_point[1] + top + height]
      container.frame = [[left, top], [bottom_right[0] - top_left[0], bottom_right[1] - top_left[1]]]

      absolute_point[0] += left
      absolute_point[1] += top

      children.each { |x| x._apply_layout(absolute_point) }
    end

    def container
      @container ||=begin
        ui_view = UIView.alloc.init
        ui_view.translatesAutoresizingMaskIntoConstraints = false
        ui_view
      end
    end
  end
end
