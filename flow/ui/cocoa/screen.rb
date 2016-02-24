module UI
  class Controller < UIViewController
    include Eventable

    def initWithScreen(screen)
      @screen = screen
      init

      on(:view_did_load) do
        @screen.before_on_load
      end

      self
    end

    def _view
      screen.view
    end

    def _view=(view)
      self.view = view.container
    end

    def loadView
      @screen.view.width = UIScreen.mainScreen.bounds.size.width
      @screen.view.height = UIScreen.mainScreen.bounds.size.height
      @screen.container.translatesAutoresizingMaskIntoConstraints = true
      self.view = @screen.container
    end

    def viewDidLoad
      super
      trigger(:view_did_load)
    end
  end

  class Screen
    attr_accessor :view
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

    def initialize
      @children = []
      @navigation = nil
    end

    def before_on_load
      view.background_color = self.class.__background_color__
      proxies[:ui_view_controller].title = self.class.__title__

      on_load
    end

    def on_load; end

    def view
      @view ||= UI::View.new
    end

    def view=(view)
      @view = view
      proxies[:ui_view_controller]._view = view
    end

    def container
      @container ||= view.container
    end

    def proxies
      @proxies ||= build_proxies
    end

    def build_proxies
      ui_view_controller = Controller.alloc.initWithScreen(self)

      {
        ui_view_controller: ui_view_controller
      }
    end
  end
end
