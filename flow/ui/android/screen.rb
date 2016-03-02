class FlowFragment < Android::App::Fragment
  def initialize(screen)
    @screen = screen
  end

  def onCreateView(inflater, container, savedInstanceState)
    @view ||= begin
      @screen.before_on_load
      @screen.view.container
    end
  end
end

module UI
  def self.context
    @context or raise "Context missing"
  end

  def self.context=(context)
    @context = context
  end

  class Screen
    def self._background_color
      @background_color
    end

    def self.background_color(color)
      @background_color = color
    end

    def before_on_load
      CSSNode.set_scale UI.context.getResources.getDisplayMetrics.density
      view.background_color = UI::Color(self.class._background_color)
      on_load
    end

    def on_load
    end

    def view
      @view ||= begin
        view = UI::View.new
        view.container.setLayoutParams(Android::View::ViewGroup::LayoutParams.new(Android::View::ViewGroup::LayoutParams::MATCH_PARENT, Android::View::ViewGroup::LayoutParams::MATCH_PARENT))
        view
      end
    end

    def proxies
      @proxies ||= { fragment: FlowFragment.new(self) }
    end
  end
end
