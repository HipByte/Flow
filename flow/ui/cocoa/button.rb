module UI
  class Button < Control
    include Eventable

    def initialize
      super
      calculate_measure(true)
    end

    def measure(width, height)
      self.proxy.sizeToFit

      [
        width.nan? ? self.proxy.frame.size.width : width,
        height.nan? ? self.proxy.frame.size.height : height
      ]
    end

    def color=(color)
      case color
      when Hash
        color.map do |state, color|
          proxy.setTitleColor(UI::Color(color).proxy, forState: CONTROL_STATES[state])
        end
      else
        proxy.setTitleColor(UI::Color(color).proxy, forState: CONTROL_STATES[:normal])
      end
    end

    def color(state = :normal)
      UI::Color(proxy.titleColorForState(CONTROL_STATES[state]))
    end

    def title=(title)
      case title
      when Hash
        title.map do |state, title|
          proxy.setTitle(title, forState: CONTROL_STATES[state])
        end
      when String
        proxy.setTitle(title, forState: CONTROL_STATES[:normal])
      end
    end

    def title(state = :normal)
      proxy.titleForState(CONTROL_STATES[state])
    end

    def image=(image)
      proxy.setImage(UIImage.imageNamed(image), forState: CONTROL_STATES[:normal])
    end

    def font
      UI::Font._wrap(proxy.titleLabel.font)
    end

    def font=(font)
      proxy.titleLabel.font = UI::Font(font).proxy
    end

    def on_tap
      trigger(:tap)
    end

    def proxy
      @proxy ||= begin
        ui_button = UIButton.buttonWithType(UIButtonTypeCustom)
        ui_button.translatesAutoresizingMaskIntoConstraints = false
        ui_button.addTarget(self, action: :on_tap, forControlEvents: UIControlEventTouchUpInside)
        ui_button
      end
    end
  end
end
