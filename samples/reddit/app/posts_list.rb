class PostsList < UI::List
  def initialize
    super
    self.flex = 1
    self.render_row do
      PostRow
    end
  end
end
