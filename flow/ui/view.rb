module UI
  class View < CSSNode
    def on_swipe_left(&block)
      on_swipe [:left], &block
    end

    def on_swipe_right(&block)
      on_swipe [:right], &block
    end

    def on_swipe_up(&block)
      on_swipe [:up], &block
    end

    def on_swipe_down(&block)
      on_swipe [:down], &block
    end

    def on_swipe(args, &block)
      on_gesture :swipe, args, block
    end

    def on_gesture(type, args=nil, block)
      (@gestures ||= []) << case type
        when :swipe
          UI::SwipeGesture
        else
          raise "invalid gesture type #{type}"
      end.new(self, args, block)
    end
  end
end
