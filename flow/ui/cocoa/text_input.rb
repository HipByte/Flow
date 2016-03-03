module UI
  class TextInput < Control
    include Eventable

    def initialize
      # TODO : register listeners only if needed
      container.addTarget(self, action: :on_change, forControlEvents: UIControlEventEditingChanged)
      container.addTarget(self, action: :on_focus, forControlEvents: UIControlEventEditingDidBegin)
      container.addTarget(self, action: :on_blur, forControlEvents: UIControlEventEditingDidEnd)
    end

    def on_focus
      trigger(:focus)
    end

    def on_blur
      trigger(:blur)
    end

    def on_change
      trigger(:change, self.text)
    end

    def text_alignment
      UI::TEXT_ALIGNMENT.key(container.textAlignment)
    end

    def text_alignment=(text_alignment)
      container.textAlignment = UI::TEXT_ALIGNMENT.fetch(text_alignment.to_sym) do
        raise "Incorrect value, expected one of: #{UI::TEXT_ALIGNMENT.keys.join(',')}"
      end
    end

    def color
      UI::Color(container.textColor)
    end

    def color=(color)
      container.textColor = UI::Color(color).container
    end

    def secure
      container.secureTextEntry
    end

    def secure=(is_secure)
      container.secureTextEntry = is_secure
    end

    def text=(text)
      container.text = text
    end

    def text
      container.text
    end

    def container
      @container ||= begin
        ui_text_field = UITextField.alloc.init
        ui_text_field.translatesAutoresizingMaskIntoConstraints = false
        ui_text_field
      end
    end
  end
end
