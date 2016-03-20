module UI
  class TextInput < Control
    include Eventable

    def initialize
      # TODO : register listeners only if needed
      proxy.addTarget(self, action: :on_change, forControlEvents: UIControlEventEditingChanged)
      proxy.addTarget(self, action: :on_focus, forControlEvents: UIControlEventEditingDidBegin)
      proxy.addTarget(self, action: :on_blur, forControlEvents: UIControlEventEditingDidEnd)
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
      UI::TEXT_ALIGNMENT.key(proxy.textAlignment)
    end

    def text_alignment=(text_alignment)
      proxy.textAlignment = UI::TEXT_ALIGNMENT.fetch(text_alignment.to_sym) do
        raise "Incorrect value, expected one of: #{UI::TEXT_ALIGNMENT.keys.join(',')}"
      end
    end

    def color
      UI::Color(proxy.textColor)
    end

    def color=(color)
      proxy.textColor = UI::Color(color).proxy
    end

    def secure
      proxy.secureTextEntry
    end

    def secure=(is_secure)
      proxy.secureTextEntry = is_secure
    end

    def text=(text)
      if proxy.text != text
        proxy.text = text
        on_change
      end
    end

    def text
      proxy.text
    end

    def placeholder=(text)
      proxy.placeholder = text
    end

    def placeholder
      proxy.placeholder
    end

    def font
      UI::Font._wrap(proxy.font)
    end

    def font=(font)
      proxy.font = UI::Font(font).proxy
    end

    def proxy
      @proxy ||= begin
        ui_text_field = UITextField.alloc.init
        ui_text_field.translatesAutoresizingMaskIntoConstraints = false
        ui_text_field
      end
    end
  end
end
