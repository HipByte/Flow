module UI
  # @attr text_alignment
  # @attr [Color] color
  # @attr secure
  # @attr [String] text
  # @attr [String] placeholder
  # @attr [Font] font
  class TextInput < Control
    include Eventable

    # Execute a block when a certain event happens. Possible event values:
    #   :on_change, :on_focus, :on_blur
    # @!method on(event, &block)
  end
end
