class FlowUIFragment < Android::App::Fragment
  def initialize(screen)
    @screen = screen
  end

  def onCreateView(inflater, container, savedInstanceState)
    @view ||= begin
      @screen.before_on_load
      @screen.view.container
    end
  end

  def onResume
    super
    @screen.before_on_show
    @screen.on_show
  end
end

module UI
  class Screen
    attr_accessor :navigation

    def self._background_color
      @background_color
    end

    def self.background_color(color)
      @background_color = color
    end

    def before_on_load
      CSSNode.set_scale(UI.density)
      view.background_color = self.class._background_color
      on_load
    end
    def on_load; end

    def before_on_show; end
    def on_show; end

    def view
      @view ||= begin
        view = UI::View.new
        view.container.setLayoutParams(Android::View::ViewGroup::LayoutParams.new(Android::View::ViewGroup::LayoutParams::MATCH_PARENT, Android::View::ViewGroup::LayoutParams::MATCH_PARENT))
        metrics = Android::Util::DisplayMetrics.new
        main_screen_metrics = UI.context.windowManager.defaultDisplay.getMetrics(metrics)
        view.width = main_screen_metrics.width / UI.density
        title_bar_height = 0
        resource_id = UI.context.resources.getIdentifier("status_bar_height", "dimen", "android")
        if resource_id > 0
          title_bar_height = UI.context.resources.getDimensionPixelSize(resource_id)
        end
        view.height = (main_screen_metrics.height - title_bar_height) / UI.density
        view
      end
    end

    def container
      @container ||= FlowUIFragment.new(self)
    end
  end
end
