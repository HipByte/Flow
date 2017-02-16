module UI
  class Navigation
    attr_reader :root_screen

    def initialize(root_screen)
      root_screen.navigation = self
      @root_screen = root_screen
      @current_screens = [@root_screen]
    end

    def screen
      @current_screens.last
    end

    def _height_of_navigation_bar
      rect = proxy.navigationBar.frame
      rect.origin.y + rect.size.height
    end

    def show_bar
      if proxy.isNavigationBarHidden
        proxy.navigationBarHidden = false
        screen = @current_screens.last
        screen.view.height -= _height_of_navigation_bar
        screen.view.update_layout
      end
    end

    def hide_bar
      if !proxy.isNavigationBarHidden
        screen = @current_screens.last
        screen.view.height += _height_of_navigation_bar
        screen.view.update_layout
        proxy.navigationBarHidden = true
      end
    end

    def bar_hidden?
      proxy.isNavigationBarHidden
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
          if title = opt[:title]
            UIBarButtonItem.alloc.initWithTitle(title, style:UIBarButtonItemStylePlain, target:current_screen, action:opt[:action])
          elsif image = opt[:image]
            UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed(image), style:UIBarButtonItemStylePlain, target:current_screen, action:opt[:action])
          else
            nil
          end
        else
          nil
        end
      end
      navigation_item.backBarButtonItem = buttons[0]
      navigation_item.leftBarButtonItem = buttons[1]
      navigation_item.rightBarButtonItem = buttons[2]
      if items[:hide_back_button]
        navigation_item.hidesBackButton = true
      end
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

    def replace(screen, animated=true)
      ary = proxy.viewControllers
      raise "inconsistent view controllers chain" unless ary[-1] == @current_screens[-1].proxy
      screen.navigation = self
      @current_screens[-1] = screen
      ary = ary.dup
      ary[-1] = screen.proxy
      proxy.setViewControllers(ary, animated:animated)
    end

    def proxy
      @proxy ||= UINavigationController.alloc.initWithRootViewController(@root_screen.proxy)
    end
  end
end
