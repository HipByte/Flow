module UI
  class TextInput < UI::Control
    include UI::Text

    def placeholder=(text)
      container.hint = text
    end

    def placeholder
      container.hint
    end

    def container
      @container ||= Android::Widget::EditText.new(UI.context)
    end
  end
end


