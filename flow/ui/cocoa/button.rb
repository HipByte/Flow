module UI
  class Button < Control
    include Eventable

    def color=(color)
      case color
      when Hash
        color.map do |state, color|
          container.setTitleColor(UI::Color(color).container, forState: CONTROL_STATES[state])
        end
      else
        container.setTitleColor(UI::Color(color).container, forState: CONTROL_STATES[:normal])
      end
    end

    def color(state = :normal)
      UI::Color(container.titleColorForState(CONTROL_STATES[state]))
    end

    def title=(title)
      case title
      when Hash
        title.map do |state, title|
          container.setTitle(title, forState: CONTROL_STATES[state])
        end
      when String
        container.setTitle(title, forState: CONTROL_STATES[:normal])
      end
    end

    def title(state = :normal)
      container.titleForState(CONTROL_STATES[state])
    end

    def image=(image)
      container.setImage(UIImage.imageNamed(image), forState: CONTROL_STATES[:normal])
    end

    def font
      UI::Font._wrap(container.titleLabel.font)
    end

    def font=(font)
      container.titleLabel.font = UI::Font(font).container
    end

    def on_tap
      trigger(:tap)
    end

    def container
      @container ||= begin
        ui_button = UIButton.buttonWithType(UIButtonTypeCustom)
        ui_button.translatesAutoresizingMaskIntoConstraints = false
        ui_button.addTarget(self, action: :on_tap, forControlEvents: UIControlEventTouchUpInside)
        ui_button
      end
    end
  end
end
