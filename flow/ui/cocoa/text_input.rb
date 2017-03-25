class FlowTextField < UITextField
  attr_accessor :_input_offset

  def textRectForBounds(bounds)
    _padded_rect(bounds)
  end

  def editingRectForBounds(bounds)
    _padded_rect(bounds)
  end

  def _padded_rect(rect)
    @_input_offset ? CGRectInset(rect, @_input_offset, 0) : rect
  end
end

module UI
  class TextInput < Control
    include Eventable

    def on(event, &block)
      case event
        when :change
          proxy.addTarget(self, action: :on_change, forControlEvents: UIControlEventEditingChanged)
        when :focus
          proxy.addTarget(self, action: :on_focus, forControlEvents: UIControlEventEditingDidBegin)
        when :blur
          proxy.addTarget(self, action: :on_blur, forControlEvents: UIControlEventEditingDidEnd)
        else
          raise "Expected event to be in : `:change, :focus, :blur`"
      end

      super
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

    def secure?
      proxy.secureTextEntry
    end

    def secure=(is_secure)
      proxy.secureTextEntry = is_secure
    end

    def text=(text)
      if proxy.text != text
        proxy.text = text
        on_change unless @on_change_disabled
      end
    end

    def text
      proxy.text
    end

    def placeholder=(text)
      proxy.attributedPlaceholder = NSAttributedString.alloc.initWithString(text, attributes: { NSForegroundColorAttributeName => proxy.textColor })
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

    def input_offset
      proxy._input_offset
    end

    def input_offset=(padding)
      proxy._input_offset = padding
    end

    attr_reader :date_picker

    def date_picker=(flag)
      if @date_picker != flag
        @date_picker = flag
        if flag
          date_picker = UIDatePicker.alloc.init
          date_picker.datePickerMode = UIDatePickerModeDate
          date_picker.addTarget(self, action:'_datePickerValueChanged:', forControlEvents:UIControlEventValueChanged)
          proxy.inputView = date_picker
        else
          proxy.inputView = nil
        end
      end
    end

    def _datePickerValueChanged(sender)
      components = NSCalendar.currentCalendar.components(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit, fromDate:sender.date)
      @on_change_disabled = true
      begin
        trigger :change, components.year, components.month, components.day
      ensure
        @on_change_disabled = nil
      end
    end

    def proxy
      @proxy ||= FlowTextField.alloc.init
    end
  end
end
