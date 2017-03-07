class UI::Application
  attr_reader :navigation

  @@instance = nil
  def initialize(navigation, context)
    UI.context = context
    @navigation = navigation
    UI.context.contentView = proxy
    UI.context.supportActionBar.elevation = UI.density # one bottom border line
    @@instance = self
  end

  def self.instance
    @@instance
  end

  def start
    fragment = @navigation.root_screen.proxy
    transaction = UI.context.fragmentManager.beginTransaction
    transaction.add(proxy.id, fragment, nil)
    transaction.addToBackStack(nil)
    transaction.commit
  end

  def open_url(url)
    _open_url(Android::Content::Intent::ACTION_VIEW, url)
  end

  def open_phone_call(number)
    _open_url(Android::Content::Intent::ACTION_CALL, "tel:" + number)
  end

  def _open_url(action, url)
    intent = Android::Content::Intent.new(action, Android::Net::Uri.parse(url))
    UI.context.startActivity(intent)
  end

  def proxy
    @proxy ||= begin
      frame_layout = Android::Widget::FrameLayout.new(UI.context)
      frame_layout.id = Android::View::View.generateViewId
      frame_layout
    end
  end
end
