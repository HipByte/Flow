module UI
  # @attr [Navigation] navigation Returns the navigation object associated to
  #   this screen
  class Screen
    # Called after the screen has been loaded
    # @!method on_load

    # Called after the screen is hown
    # @!method on_show

    # Returns the root view of this screen
    # @!method view
    # @return [View]

    # Returns the patform-specific object
    # @!method proxy
  end
end
