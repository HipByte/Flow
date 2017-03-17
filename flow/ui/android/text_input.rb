class FlowUITextInputTextChangedListener
  def initialize(view)
    @view = view
  end

  def afterTextChanged(s)
    # Do nothing.
  end

  def beforeTextChanged(s, start, count, after)
    # Do nothing.
  end

  def onTextChanged(s, start, before, count)
    @view.trigger(:change, @view.text)
  end
end

module UI
  class TextInput < UI::Control
    include UI::SharedText
    include Eventable

    def secure?
      proxy.inputType & Android::Text::InputType::TYPE_TEXT_VARIATION_PASSWORD
    end

    def secure=(flag)
      type = Android::Text::InputType::TYPE_CLASS_TEXT
      type |= Android::Text::InputType::TYPE_TEXT_VARIATION_PASSWORD if flag
      proxy.inputType = type
    end

    def placeholder=(text)
      proxy.hint = text
    end

    def placeholder
      proxy.hint
    end

    def input_offset
      proxy.paddingLeft
    end

    def input_offset=(padding)
      proxy.setPadding(padding * UI.density, 0, 0, 0)
    end

    def proxy
      @proxy ||= begin
        edit_text = Android::Widget::EditText.new(UI.context)
        edit_text.setPadding(0, 0, 0, 0)
        edit_text.backgroundColor = Android::Graphics::Color::TRANSPARENT
        edit_text.addTextChangedListener FlowUITextInputTextChangedListener.new(self)
        edit_text
      end
    end
  end
end
