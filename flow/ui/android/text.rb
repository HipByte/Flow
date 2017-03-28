class FlowUITextViewSpan < Android::Text::Style::ClickableSpan
  def initialize(view, link)
    @view, @link = view, link
  end

  def onClick(view)
    @view.trigger :link, @link
  end
end

module UI
  class Text < UI::View
    include UI::SharedText
    def text_proxy; proxy; @text_proxy; end
    include Eventable

    def editable?
      @editable
    end

    def editable=(flag)
      if @editable != flag
        @editable = flag
        @proxy = nil
      end
    end

    attr_accessor :link_color

    def links=(links)
      ss = Android::Text::SpannableString.new(self.text)

      links.each do |range, link|
        span = FlowUITextViewSpan.new(self, link)
        ss.setSpan(span, range.begin, range.end, Android::Text::Spanned::SPAN_EXCLUSIVE_EXCLUSIVE)

        if @link_color
          fspan = Android::Text::Style::ForegroundColorSpan.new(UI.Color(@link_color).proxy)
          ss.setSpan(fspan, range.begin, range.end, Android::Text::Spanned::SPAN_INCLUSIVE_INCLUSIVE)
        end
      end

      @text_proxy.text = ss
      @text_proxy.movementMethod = Android::Text::Method::LinkMovementMethod.getInstance
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
