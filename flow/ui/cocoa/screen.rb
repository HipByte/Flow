module UI
  class Controller < UIViewController
    include Eventable

    attr_accessor :navigation

    def initWithScreen(screen)
      @screen = screen
      init
      on(:view_did_load) { @screen.before_on_load}
      on(:view_did_load) { @screen.before_on_load}
      on(:view_will_appear) { @screen.before_on_show}
      on(:view_did_appear) { @screen.on_show}
      self
    end

    def loadView
      @screen.view.width = UIScreen.mainScreen.bounds.size.width
      @screen.view.height = UIScreen.mainScreen.bounds.size.height
      @screen.view.proxy.translatesAutoresizingMaskIntoConstraints = true
      self.view = @screen.view.proxy
    end

    def viewDidAppear(animated)
      super
      trigger(:view_did_appear)
    end

    def viewWillAppear(animated)
      super
      trigger(:view_will_appear)
    end

    def viewDidLoad
      super
      self.edgesForExtendedLayout = UIRectEdgeNone
      trigger(:view_did_load)
    end

    def viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
      super

      did_rotate = lambda {|context|
        @screen.view.width = size.width
        @screen.view.height = size.height
        @screen.view.update_layout
      }
      coordinator.animateAlongsideTransition(nil, completion:did_rotate)
    end
  end

  class Screen
    attr_accessor :view
    attr_accessor :navigation
    attr_accessor :left_button_title
    attr_accessor :right_button_title
    attr_accessor :on_left_button_pressed
    attr_accessor :on_right_button_pressed

    class << self
      attr_accessor :__background_color__
      attr_accessor :__title__

      def title(title)
        self.__title__ = title
      end

      def background_color(color)
        self.__background_color__ = color
      end
    end

    def initialize
      @navigation = nil
    end

    def before_on_load
      view.background_color = (self.class.__background_color__ or :white)
      proxy.title = self.class.__title__

      on_load
    end
    def on_load; end

    def before_on_show; end
    def on_show; end

    def view
      @view ||= UI::View.new
    end

    def proxy
      @proxy ||= Controller.alloc.initWithScreen(self)
    end
  end
end
