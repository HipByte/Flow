module UI
  class SwipeGesture
    def initialize(view, args, block)
      obj = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"_swipe:")
      obj.direction = (args || [:right]).inject(0) do |m, sym|
        m | (case sym
          when :right then UISwipeGestureRecognizerDirectionRight
          when :left then UISwipeGestureRecognizerDirectionLeft
          when :up then UISwipeGestureRecognizerDirectionUp
          when :down then UISwipeGestureRecognizerDirectionDown
          else
            raise "invalid swipe type #{sym}"
        end)
      end
      view.proxy.addGestureRecognizer(obj)
      @block = block
    end

    def _swipe(sender)
      @block.call
    end
  end
end
