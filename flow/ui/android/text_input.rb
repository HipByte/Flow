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
    include UI::Text
    include Eventable

    def placeholder=(text)
      proxy.hint = text
    end

    def placeholder
      proxy.hint
    end

    def proxy
      @proxy ||= begin
        view = Android::Widget::EditText.new(UI.context)
        view.setPadding(0, 0, 0, 0)
        view.addTextChangedListener FlowUITextInputTextChangedListener.new(self)
        view
      end
    end
  end
end
