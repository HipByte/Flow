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
      @container ||= begin
        view = Android::Widget::EditText.new(UI.context)
        view.setPadding(0, 0, 0, 0)
        view
      end
    end
  end
end


