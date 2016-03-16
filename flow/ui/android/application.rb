class UI::Application
  def initialize(navigation, context)
    UI.context = context
    @navigation = navigation
    UI.context.contentView = container
    UI.context.supportActionBar.elevation = UI.density # one bottom border line
  end

  def start
    fragment = @navigation.root_screen.container
    transaction = UI.context.fragmentManager.beginTransaction
    transaction.add(container.id, fragment, "screen-#{fragment.hashCode}")
    transaction.addToBackStack("screen-#{fragment.hashCode}")
    transaction.commit
  end

  def container
    @container ||= begin
      container = Android::Widget::FrameLayout.new(UI.context)
      container.id = Android::View::View.generateViewId
      container
    end
  end
end
