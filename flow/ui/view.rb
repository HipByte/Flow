module UI
  # @attr border_width
  # @attr [Color] border_color
  # @attr [Fixnum] border_radius
  # @attr [Color] background_color
  # @attr [Float] alpha
  class View < CSSNode
    # Returns wether the view is hidden
    # @!method hidden?
    # @return [Boolean]

    # Sets the hidden state of the view
    # @!method hidden=(hidden)
    # @param [Boolean] hidden

    # Update the position of the view and all its children
    # @!method update_layout

    # Returns the platform-spegific object
    # @!method proxy
  end
end
