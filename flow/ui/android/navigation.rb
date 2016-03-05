class FlowUIFragmentBackStackListener
  # Android doesn't call onResume when doing popBackStack
  # so we listhen to this event to call it ourselves
  def onBackStackChanged
    @previous_stack_entry_count ||= 0
    fragment_manager = UI.context.fragmentManager
    fragments_count = fragment_manager.backStackEntryCount

    # This is used to prevent to call onResume two times when pushing
    if @previous_stack_entry_count < fragment_manager.backStackEntryCount
      @previous_stack_entry_count = fragment_manager.backStackEntryCount
      return
    end

    if fragments_count > 0
      back_stack_entry = fragment_manager.getBackStackEntryAt(fragments_count - 1)
      fragment_tag = back_stack_entry.getName
      fragment = fragment_manager.findFragmentByTag(fragment_tag)
      fragment.onResume
      @previous_stack_entry_count = fragment_manager.backStackEntryCount
    end
  end
end

class UI::Navigation
  attr_reader :root_screen

  def initialize(root_screen)
    @root_screen = root_screen
    @root_screen.navigation = self
    container.addOnBackStackChangedListener(FlowUIFragmentBackStackListener.new)
  end

  def hide_bar
    UI.context.supportActionBar.hide
  end

  def show_bar
    UI.context.supportActionBar.show
  end

  def title=(title)
    UI.context.supportActionBar.title = title
  end

  def push(screen, animated=true)
    screen.navigation = self
    fragment = screen.container
    transaction = container.beginTransaction
    if animated
      transaction.transition = Android::App::FragmentTransaction::TRANSIT_FRAGMENT_OPEN
    end
    content_view = UI.context.findViewById(Android::R::Id::Content)
    transaction.add(content_view.id, fragment, "screen-#{fragment.object_id}")
    transaction.addToBackStack("screen-#{fragment.object_id}")
    transaction.commit
  end

  def pop(animated=true)
    # TODO implement immediate pop without poping animation
    container.popBackStack
  end

  def container
    @container ||= UI.context.fragmentManager
  end
end
