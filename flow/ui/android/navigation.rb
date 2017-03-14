class UI::Navigation
  attr_reader :root_screen

  def initialize(root_screen)
    @root_screen = root_screen
    @root_screen.navigation = self
    @current_screens = []
  end

  def screen
    @current_screens.last
  end

  def hide_bar
    bar = UI.context.supportActionBar
    if bar.isShowing
      bar.hide
      Task.after 0.05 do
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

  def items=(items)
    fragment = @current_screens.last.proxy

    has_menu = false
    has_menu |= (fragment._buttons = items[:buttons])
    has_menu |= (fragment._options_menu_items = items[:options_menu_items])
    has_menu |= (UI.context.supportActionBar.displayHomeAsUpEnabled = (items[:home_button_enabled] or false))
    fragment.hasOptionsMenu = has_menu
  end

  BACK_STACK_ROOT_TAG = 'FlowBackStackRootTag'

  def _fragment_tag(fragment)
    "fragment-#{fragment.hashCode}"
  end

  def start
    replace @root_screen, false
  end

  def push(screen, animated=true)
    screen.navigation = self

    fragment = screen.proxy
    fragment._animate = animated ? :slide : false

    current_fragment = @current_screens.last.proxy
    current_fragment._animate = animated ? :fade : false

    transaction = proxy.beginTransaction
    transaction.hide(current_fragment)
    transaction.add(UI::Application.instance.proxy.id, fragment, _fragment_tag(fragment))
    transaction.addToBackStack(BACK_STACK_ROOT_TAG)
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

  def replace(new_screen, animated=true)
    # TODO: honor `animated'
    proxy.popBackStack(BACK_STACK_ROOT_TAG, Android::App::FragmentManager::POP_BACK_STACK_INCLUSIVE)

    new_screen.navigation = self
    fragment = new_screen.proxy
    transaction = proxy.beginTransaction
    if fragment.isAdded
      if first_screen = @current_screens.first 
        transaction.hide(first_screen.proxy)
      end
      transaction.show(fragment)
    else
      transaction.add(UI::Application.instance.proxy.id, fragment, _fragment_tag(fragment))
    end
    transaction.commit

    @current_screens = [new_screen]
  end

  def share_panel(text, animated=true)
    # TODO: honor `animated'
    Android::Support::V4::App::ShareCompat::IntentBuilder.from(UI.context).setText(text).setType("text/plain").startChooser
  end

  def proxy
    @proxy ||= UI.context.fragmentManager
  end
end
