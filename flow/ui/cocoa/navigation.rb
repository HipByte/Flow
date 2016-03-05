module UI
  class Navigation
    attr_reader :root_screen

    def initialize(root_screen)
      root_screen.navigation = self
      @root_screen = root_screen
    end

    def show_bar
      container.setNavigationBarHidden(false)
    end

    def hide_bar
      container.setNavigationBarHidden(true)
    end

    def title=(title)
      root_screen.container.title = title
    end

    def container
      @container ||= UINavigationController.alloc.initWithRootViewController(@root_screen.container)
    end

    def push(screen, animated=true)
      screen.navigation = self
      self.container.pushViewController(screen.container, animated: animated)
    end

    def pop(animated=true)
      self.container.popViewControllerAnimated(animated)
    end
  end
end
