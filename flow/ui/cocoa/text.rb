class FlowUITextView < UITextView
  # Flow text views are not selectable at the moment.
  def canBecomeFirstResponder
    false
  end
end

module UI
  class Text < View
    include UI::SharedText
    include Eventable

    def editable=(flag)
      proxy.editable = flag
    end

    def editable?
      proxy.editable
    end

    attr_reader :link_color

    def link_color=(color)
      if @link_color != color
        @link_color = color
        proxy.linkTextAttributes = { NSForegroundColorAttributeName => UI.Color(color).proxy }
      end
    end

    def links=(links)
      at = proxy.attributedText.mutableCopy

      links.each do |range, link|
        range = [range.begin, range.end - range.begin]
        at.addAttribute(NSLinkAttributeName, value:_add_link(link), range:range)
        at.addAttribute(NSUnderlineStyleAttributeName, value:1, range:range)
      end

      proxy.attributedText = at
      proxy.dataDetectorTypes = UIDataDetectorTypeLink
    end

    def _add_link(value)
      @links ||= {}
      link = "link#{@links.size}"
      @links[link] = value
      NSURL.URLWithString(link + '://')
    end

    def textView(view, shouldInteractWithURL:url, inRange:range)
      if @links and value = @links[url.scheme]
        trigger :link, value
        false 
      else
        true
      end
    end

    def proxy
      @proxy ||= begin
        view = FlowUITextView.alloc.init
        view.delegate = self
        view
      end
    end
  end
end
