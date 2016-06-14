module UI
  # @attr [Screen] root_screen
  class Navigation
    # @!method initialize(root_screen)
    # @param [Screen] root_screen The initial screen

    # Returns the current screen being shown
    # @!method screen
    # @return [Screen]

    # Shows the navigation bar
    # @!method show_bar

    # Hides the navigation bar
    # @!method hide_bar

    # Returns wether the navigation bar is hidden
    # @!method bar_hidden?

    # Sets the title shown in the navigation bar
    # @!method title=(title)
    # @param [String] title

    # Sets the color of the navigation bar
    # @!method bar_color=(color)
    # @param [Color] color

    # Pushes a screen onto the navigation stack, optionally animating the
    # transition
    # @!method push(screen, animated=true)
    # @param [Screen] screen
    # @param [Boolean] animated

    # Pushes a screen from the navigation stack, optionally animating the
    # transition
    # @!method pop(animated=true)
    # @param [Boolean] animated
  end
end
