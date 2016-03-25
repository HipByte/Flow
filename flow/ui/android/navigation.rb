class UI::Navigation
  attr_reader :root_screen

  def initialize(root_screen)
    @root_screen = root_screen
    @root_screen.navigation = self
    @current_screens = [@root_screen]
  end

  def hide_bar
    bar = UI.context.supportActionBar
    if bar.isShowing
      bar.hide
      Task.after 0.05 do
        screen = @current_screens.last
        screen.view.height += (bar.height / UI.density)
        screen.view.update_layout
      end
    end
  end

  def show_bar
    bar = UI.context.supportActionBar
    if !bar.isShowing
      bar.show
      Task.after 0.05 do
        screen = @current_screens.last
        screen.view.height -= (bar.height / UI.density)
        screen.view.update_layout
      end
    end
  end

  def title=(title)
    UI.context.supportActionBar.title = title
  end

  def bar_color=(color)
    UI.context.supportActionBar.backgroundDrawable = Android::Graphics::Drawable::ColorDrawable.new(UI::Color(color).proxy)
  end

  def push(screen, animated=true)
    screen.navigation = self

    fragment = screen.proxy
    fragment._animate = animated ? :slide : false

    current_fragment = @current_screens.last.proxy
    current_fragment._animate = animated ? :fade : false

    transaction = proxy.beginTransaction
    transaction.hide(current_fragment)
    transaction.add(UI.context.findViewById(Android::R::Id::Content).id, fragment, nil)
    transaction.addToBackStack(nil)
    transaction.commit

    @current_screens << screen
  end

  def pop(animated=true)
    if @current_screens.size > 1
      current_screen = @current_screens.pop
      current_screen.proxy._animate = animated ? :slide : false
      previous_screen = @current_screens.last
      previous_screen.proxy._animate = animated ? :fade : false

      previous_screen.before_on_show
      proxy.popBackStack
      previous_screen.on_show

      current_screen
    else
      nil
    end
  end

  def proxy
    @proxy ||= UI.context.fragmentManager
  end
end
