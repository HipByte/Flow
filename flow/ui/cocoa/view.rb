module UI
  class View < CssNode
    attr_accessor :style

    def initialize
      @children = []
      @style = {
        top: 0,
        right: 0,
        bottom: 0,
        left: 0
      }
    end

    def tree
      {
        style: @style,
        children: @children.map {|child| {style: child.style} }
      }
    end

    def frame=(frame)
      container.frame = frame
    end

    def frame
      container.frame
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

    def parent
      container.superview
    end

    def container
      @container ||= proxies[:ui_view]
    end

    def add_child(child)
      @children << child
      container.addSubview(child.container)
    end

    def proxies
      ui_view = UIView.alloc.init
      ui_view.translatesAutoresizingMaskIntoConstraints = false

      {
        ui_view: ui_view
      }
    end
  end
end
