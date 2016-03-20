module UI
  class Alert
    def title=(title)
      proxy.title = title
    end

    def message=(message)
      proxy.message = message
    end

    def set_button(title, type)
      @buttons ||= {}
      pos = proxy.addButtonWithTitle(title)
      if type == :cancel
        proxy.cancelButtonIndex = pos
      end
      @buttons[pos] = type
    end

    def show(&block)
      @complete_block = (block or raise "expected block")
      proxy.show
    end

    def alertView(view, clickedButtonAtIndex:pos)
      @complete_block.call(@buttons[pos] || :default)
    end

    def proxy
      @proxy ||= UIAlertView.alloc.initWithTitle("", message:"", delegate:self, cancelButtonTitle:nil, otherButtonTitles:nil)
    end
  end
end
