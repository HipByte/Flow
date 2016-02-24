module UI
  class Screen < UIViewController
    include Eventable

    attr_accessor :children
    attr_accessor :navigation

    attr_accessor :left_button_title
    attr_accessor :right_button_title
    attr_accessor :on_left_button_pressed
    attr_accessor :on_right_button_pressed

    class << self
      attr_accessor :__background_color__
      attr_accessor :__title__

      def inherited(base)
        base.__background_color__ = UI::Color.white
        super
      end

      def title(title)
        self.__title__ = title
      end

      def background_color(color)
        self.__background_color__ = UI::Color(color)
      end
    end

    def present(screen, args = {})
      if screen.is_a?(UI::Navigation)
        self.presentViewController(screen.proxies[:ui_navigation_controller], animated: args.fetch(:animated, true),
                                               completion: args.fetch(:completion, nil))
      end

      if screen.is_a?(Class)
        self.presentViewController(screen.new, animated: args.fetch(:animated, true),
                                               completion: args.fetch(:completion, nil))
      end
    end

    def proxies
      @proxies ||= build_proxies
    end

    def build_proxies
      {
        ui_view: self.view
      }
    end

    def init
      super
      @children = []
      @navigation = nil
      self
    end

    def viewDidLoad
      super
      self.view.backgroundColor = self.class.__background_color__
      self.title = self.class.__title__

      if self.left_button_title
        button = UIBarButtonItem.alloc.initWithTitle(self.left_button_title,
                                                     style: UIBarButtonItemStylePlain,
                                                     target: self,
                                                     action: "__left_button_pressed__:")
        self.navigationItem.leftBarButtonItem = button
      end

      if self.right_button_title
        button = UIBarButtonItem.alloc.initWithTitle(self.right_button_title,
                                                     style: UIBarButtonItemStylePlain,
                                                     target: self,
                                                     action: "__right_button_pressed__:")
        self.navigationItem.rightBarButtonItem = button
      end

      on_load
    end

    def __left_button_pressed__(sender)
      trigger(:left_button_pressed)
    end

    def __right_button_pressed__(sender)
      trigger(:right_button_pressed)
    end

    def container
      @container ||= proxies[:ui_view]
    end

    def on_load
    end

    def add_child(child)
      @children << child
      container.addSubview(child.container)
    end

    def remove_child(child)
      @children.delete(child)
      child.container.removeFromSuperview
    end

    def proxies
      @proxies ||= build_proxies
    end

    def proxies
      {
        ui_view: self.view
      }
    end
  end
end
