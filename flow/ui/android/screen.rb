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
      animator.duration = 300
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

  attr_accessor :_buttons, :_options_menu_items

  def onCreateOptionsMenu(menu, inflater)
    menu.clear
    @menu_actions = {}
    n = 0
    if _buttons
      _buttons.each do |opt|
        title = opt[:title]
        item = menu.add(Android::View::Menu::NONE, n, Android::View::Menu::NONE, title)
        mode = Android::View::MenuItem::SHOW_AS_ACTION_ALWAYS
        mode |= Android::View::MenuItem::SHOW_AS_ACTION_WITH_TEXT if title
        item.showAsAction = mode
        unless title
          drawable = UI::Image._drawable_from_source(opt[:image])
          drawable.targetDensity = UI.context.resources.displayMetrics.densityDpi # XXX needed so that the image properly scales, to investigate why
          item.icon = drawable
        end
        @menu_actions[n] = opt[:action]
        n += 1
      end
    end
    if _options_menu_items
      _options_menu_items.each do |opt|
        menu.add(Android::View::Menu::NONE, n, Android::View::Menu::NONE, opt[:title])
        @menu_actions[n] = opt[:action]
        n += 1
      end
    end
  end

  def onOptionsItemSelected(menu_item)
    id = menu_item.itemId
    if id == Android::R::Id::Home
      @screen.navigation.pop
    elsif action = @menu_actions[id]
      @screen.send(action)
    end  
  end
end

module UI
  class Screen
    attr_accessor :navigation

    def before_on_load
      CSSNode.set_scale(UI.density)
      view.background_color = :white
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
        view_height -= UI::Navigation.bar_height

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
