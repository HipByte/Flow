module UI
  class Navigation
    attr_reader :root_screen

    def initialize(root_screen)
      root_screen.navigation = self
      @root_screen = root_screen
      @current_screens = [@root_screen]
    end

    def show_bar
      container.setNavigationBarHidden(false)
    end

    def hide_bar
      container.setNavigationBarHidden(true)
    end

    def title=(title)
      @current_screens.last.container.title = title
    end

    def bar_color=(color)
      container.navigationBar.barTintColor = UI::Color(color).container
    end

    def container
      @container ||= UINavigationController.alloc.initWithRootViewController(@root_screen.container)
    end

    def push(screen, animated=true)
      @current_screens << screen
      screen.navigation = self
      self.container.pushViewController(screen.container, animated: animated)
    end

    def pop(animated=true)
      screen = @current_screens.pop
      self.container.popViewControllerAnimated(animated)
      screen
    end
  end
end
