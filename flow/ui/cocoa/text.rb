module UI
  class Text < View
    include UI::SharedText

    def editable=(flag)
      proxy.editable = flag
    end

    def editable?
      proxy.editable
    end

    def proxy
      @proxy ||= UITextView.alloc.init
    end
  end
end
