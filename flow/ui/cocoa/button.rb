module UI
  class Button < Control
    def initialize
      super
    end

    def container
      @container ||= proxies[:ui_button]
    end

    def border_color=(color)
      container.layer.borderColor = UI::Color(color).CGColor
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

    def color=(color)
      case color
      when Hash
        color.map do |state, color|
          container.setTitleColor(UI::Color(color), forState: _state_for_key(state))
        end
      else
        container.setTitleColor(UI::Color(color), forState: _state_for_key(:normal))
      end
    end

    def color(state = :normal)
      container.titleColorForState(_state_for_key(state))
    end

    def title=(title)
      case title
      when Hash
        title.map do |state, title|
          container.setTitle(title, forState: _state_for_key(state))
        end
      when String
        container.setTitle(title, forState: _state_for_key(:normal))
      end
    end

    def title(state = :normal)
      container.titleForState(_state_for_key(state))
    end

    def proxies
      ui_button = UIButton.buttonWithType(UIButtonTypeCustom)
      ui_button.translatesAutoresizingMaskIntoConstraints = false

      {
        ui_button: ui_button
      }
    end
  end
end
