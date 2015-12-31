class AppDelegate
  attr_reader :window

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow

    @controller = RedditController.new

    RedditFetcher.fetch_posts('cats') do |posts|
      @controller.data = posts
    end
  end

  def buildWindow
    @window = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
                                                     styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
                                                     backing: NSBackingStoreBuffered,
                                                     defer: false)
    @window.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @window.orderFrontRegardless
  end
end
