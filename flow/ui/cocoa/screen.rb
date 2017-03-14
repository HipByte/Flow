module UI
  class Controller < UIViewController
    include Eventable

    attr_accessor :navigation

    def initWithScreen(screen)
      if init
        @screen = screen
        on(:view_did_load) { @screen.before_on_load }
        on(:view_will_appear) { @screen.before_on_show }
        on(:view_did_appear) { @screen.on_show }
      end
      self
    end

    def loadView
      nav = @screen.navigation
      screen_size = UIScreen.mainScreen.bounds.size
      screen_view = @screen.view
      screen_view.width = screen_size.width
      screen_view.height = screen_size.height
      unless nav.bar_hidden?
        screen_view.height -= nav._height_of_navigation_bar
      end
      self.view = screen_view.proxy
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

      did_rotate = lambda do |context|
        @screen.view.width = size.width
        @screen.view.height = size.height
        @screen.view.update_layout
      end
      coordinator.animateAlongsideTransition(nil, completion:did_rotate)
    end

    def viewDidLayoutSubviews
      @screen.view.update_layout
    end

    def preferredStatusBarStyle
      @screen.status_bar_style or UIStatusBarStyleDefault
    end
  end

  class Screen
    attr_accessor :navigation

    def initialize
      @navigation = nil
    end

    def before_on_load
      view.background_color = :white
      on_load
    end
    def on_load; end

    def before_on_show; end
    def on_show; end

    def view
      @view ||= UI::View.new
    end

    attr_reader :status_bar_style

    def status_bar_style=(style)
      @status_bar_style = case style[:content]
        when :light
          UIStatusBarStyleLightContent
        when :dark, :default
          UIStatusBarStyleDefault
        else
          raise "invalid style"
      end
      proxy.setNeedsStatusBarAppearanceUpdate
    end

    def self.size
      UIScreen.mainScreen.bounds.size.to_a
    end

    def proxy
      @proxy ||= Controller.alloc.initWithScreen(self)
    end
  end
end
