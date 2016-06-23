module UI
  # Simple placeholder implementation
  # will need to be rewrite/improved
  module Eventable
    def on(event, action = nil, &block)
      if action
        __events__[event.to_sym] ||= action
      elsif block
        __events__[event.to_sym] ||= block
      end
    end

    def trigger(event, *args)
      # if no listener found we will do nothing
      return unless registered_event = __events__.fetch(event, nil)

      case registered_event
        when String, Symbol
          self.send(registered_event, *args)
        else
          registered_event.call(*args)
      end
    end

    def __events__
      @__events__ ||= {}
    end
  end
end
