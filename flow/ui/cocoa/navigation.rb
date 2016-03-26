module UI
  class Navigation
    attr_reader :root_screen

    def initialize(root_screen)
      root_screen.navigation = self
      @root_screen = root_screen
      @current_screens = [@root_screen]
    end

    def show_bar
      proxy.setNavigationBarHidden(false)
    end

    def hide_bar
      proxy.setNavigationBarHidden(true)
    end

    def title=(title)
      @current_screens.last.proxy.title = title
    end

    def bar_color=(color)
      bar = proxy.navigationBar
      bar.barTintColor = UI::Color(color).proxy
      bar.translucent = false
    end

    def items=(items)
      current_screen = @current_screens.last
      navigation_item = current_screen.proxy.navigationItem
      buttons = [:back_button, :left_button, :right_button].map do |key|
        if opt = items[key]
          UIBarButtonItem.alloc.initWithTitle(opt[:title], style:UIBarButtonItemStylePlain, target:current_screen, action:opt[:action])
        else
          nil
        end
      end
      navigation_item.backBarButtonItem = buttons[0]
      navigation_item.leftBarButtonItem = buttons[1]
      navigation_item.rightBarButtonItem = buttons[2]
    end

    def push(screen, animated=true)
      @current_screens << screen
      screen.navigation = self
      proxy.pushViewController(screen.proxy, animated: animated)
    end

    def pop(animated=true)
      if @current_screens.size > 1
        screen = @current_screens.pop
        proxy.popViewControllerAnimated(animated)
        screen
      else
        nil
      end
    end

    def proxy
      @proxy ||= UINavigationController.alloc.initWithRootViewController(@root_screen.proxy)
    end
  end
end
