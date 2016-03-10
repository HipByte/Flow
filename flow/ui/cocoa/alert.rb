module UI
  class Alert
    def title=(title)
      container.title = title
    end

    def message=(message)
      container.message = message
    end

    def set_button(title, type)
      @buttons ||= {}
      pos = container.addButtonWithTitle(title)
      if type == :cancel
        container.cancelButtonIndex = pos
      end
      @buttons[pos] = type
    end
 
    def show(&block)
      @complete_block = (block or raise "expected block")
      container.show
    end

    def alertView(view, clickedButtonAtIndex:pos)
      @complete_block.call(@buttons[pos] || :default)
    end

    def container
      @container ||= UIAlertView.alloc.initWithTitle("", message:"", delegate:self, cancelButtonTitle:nil, otherButtonTitles:nil)
    end
  end
end
