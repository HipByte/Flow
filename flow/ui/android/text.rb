module UI
  class Text < UI::View
    include UI::SharedText
    def text_proxy; proxy; @text_proxy; end

    def editable?
      @editable
    end

    def editable=(flag)
      if @editable != flag
        @editable = flag
        @proxy = nil
      end
    end

    def proxy
      @proxy ||= begin
        scroll = Android::Widget::ScrollView.new(UI.context)
        @text_proxy = @editable ? Android::Widget::EditText.new(UI.context) : Android::Widget::TextView.new(UI.context)
        scroll.addView(@text_proxy)
        scroll
      end
    end
  end
end
