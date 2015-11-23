class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    @contentLayout = Android::Widget::FrameLayout.new(self)
    @contentLayout.setId(Android::View::View.generateViewId)

    @list = Android::Widget::ListView.new(self)
    @list.adapter = TimelineAdapter.new(self, Android::R::Layout::Simple_list_item_1)
    @list.choiceMode = Android::Widget::AbsListView::CHOICE_MODE_SINGLE
    @list.dividerHeight = 0
    @list.backgroundColor = Android::Graphics::Color::WHITE
    @list.onItemClickListener = self
    self.contentView = @list

    TweetFetcher.fetch_tweets do |tweets|
      @list.adapter.tweets = tweets
      @list.adapter.clear()
      @list.adapter.addAll(tweets)
      @list.adapter.notifyDataSetChanged
    end
  end

  def onItemClick(parent, view, position, id)
  end

  def density
    @density ||= resources.displayMetrics.density
  end
end
