class PostsScreen < UI::Screen
  def on_load
    self.input.on(:change) { |text| fetch_posts(text) }
    self.view.add_child(self.input)
    self.view.add_child(self.list)
    self.view.update_layout

    fetch_posts("cats")
  end

  protected

  def fetch_posts(query)
    return if query.length < 3
    RedditFetcher.fetch_posts(query) do |posts|
      self.list.data_source = posts
    end
  end

  def input
    @input ||= build_input
  end

  def build_input
    input = UI::TextInput.new
    input.height = 50
    input.justify_content = :flex_end
    input.margin = 5
    input
  end

  def list
    @list ||= PostsList.new
  end
end
