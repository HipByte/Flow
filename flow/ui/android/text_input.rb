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

class FlowUITextInputDateFocusListener
  def initialize(view)
    @view = view
  end

  def onFocusChange(view, has_focus)
    if has_focus
      calendar = Java::Util::Calendar.getInstance
      year = calendar.get(Java::Util::Calendar::YEAR)
      month = calendar.get(Java::Util::Calendar::MONTH)
      day = calendar.get(Java::Util::Calendar::DAY_OF_MONTH)

      Android::App::DatePickerDialog.new(UI.context, self, year, month, day).show
    end
  end

  def onDateSet(view, year, month, day)
    @view.trigger :change, year, month + 1, day
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

    attr_reader :date_picker

    def date_picker=(flag)
      if @date_picker != flag
        @date_picker = flag
        if flag
          proxy.onFocusChangeListener = FlowUITextInputDateFocusListener.new(self)
          proxy.removeTextChangedListener(@text_changed_listener)
        else
          proxy.onFocusChangeListener = nil
          proxy.addTextChangedListener(@text_changed_listener)
        end
      end
    end

    def proxy
      @proxy ||= begin
        edit_text = Android::Widget::EditText.new(UI.context)
        edit_text.setPadding(0, 0, 0, 0)
        edit_text.backgroundColor = Android::Graphics::Color::TRANSPARENT
        @text_changed_listener = FlowUITextInputTextChangedListener.new(self)
        edit_text.addTextChangedListener(@text_changed_listener)
        edit_text
      end
    end
  end
end
