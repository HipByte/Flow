class FlowUIFragment < Android::App::Fragment
  def initialize(screen)
    @screen = screen
  end

  def onCreateView(inflater, proxy, savedInstanceState)
    @view ||= begin
      @screen.before_on_load
      @screen.view.proxy
    end
  end

  def onResume
    super
    @screen.before_on_show
    @screen.on_show
  end

  attr_accessor :_animate

  def onCreateAnimator(transit, enter, next_anim)
    if _animate
      animator = Android::Animation::ObjectAnimator.new
      animator.target = self
      animator.duration = 500
      case _animate
        when :fade
          animator.propertyName = "alpha"
          animator.setFloatValues(enter ? [0, 1] : [1, 0])
        when :slide
          display = UI.context.windowManager.defaultDisplay
          size = Android::Graphics::Point.new
          display.getSize(size)
          animator.propertyName = "translationX"
          animator.setFloatValues(enter ? [size.x, 0] : [0, size.x])
        else 
          raise "incorrect _animate value `#{_animate}'"
      end
      animator
    else
      nil
    end
  end
end

module UI
  class Screen
    attr_accessor :navigation

    def self._background_color
      @background_color or :white
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
        view.proxy.setLayoutParams(Android::View::ViewGroup::LayoutParams.new(Android::View::ViewGroup::LayoutParams::MATCH_PARENT, Android::View::ViewGroup::LayoutParams::MATCH_PARENT))
        metrics = Android::Util::DisplayMetrics.new
        main_screen_metrics = UI.context.windowManager.defaultDisplay.getMetrics(metrics)

        view_height = main_screen_metrics.height
        resource_id = UI.context.resources.getIdentifier("status_bar_height", "dimen", "android")
        if resource_id > 0
          view_height -= UI.context.resources.getDimensionPixelSize(resource_id)
        end

        view.width = main_screen_metrics.width / UI.density
        view.height = view_height / UI.density
        view
      end
    end

    def proxy
      @proxy ||= FlowUIFragment.new(self)
    end
  end
end
