class FlowUIGestureListener < Android::View::GestureDetector::SimpleOnGestureListener
  attr_accessor :gestures

  def onDown(e)
    true
  end

  def onFling(e1, e2, velocity_x, velocity_y)
    @gestures.any? { |x| x.on_fling(e1, e2) }
  end
end

class FlowUIGestureTouchListener
  def initialize(detector)
    @detector = detector
  end

  def onTouch(view, event)
    @detector.onTouchEvent(event)
  end
end

module UI
  class SwipeGesture
    def initialize(view, args, block)
      unless listener = view.instance_variable_get(:'@_gesture_listener')
        listener = FlowUIGestureListener.new
        listener.gestures = []
        @detector = Android::View::GestureDetector.new(UI.context, listener)
        view.proxy.onTouchListener = FlowUIGestureTouchListener.new(@detector)
        view.instance_variable_set(:'@_gesture_listener', listener)
      end
      listener.gestures << self
      @args = (args || [:right])
      @block = block
    end

    def on_fling(e1, e2)
      e1_x, e1_y = e1.rawX, e1.rawY
      e2_x, e2_y = e2.rawX, e2.rawY
      delta_x = (e2_x - e1_x).abs
      delta_y = (e2_y - e1_y).abs
      threshold = 100
      (@args.any? do |arg|
        case arg
          when :left
            e2_x < e1_x and delta_x > threshold
          when :right
            e2_x > e1_x and delta_x > threshold
          when :up
            e2_x > e1_x and delta_y > threshold
          when :down
            e2_x < e1_x and delta_y > threshold
        end
      end and (@block.call; true))
    end
  end
end
