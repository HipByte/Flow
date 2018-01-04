class PostRow < UI::ListRow
  def initialize
    self.align_items = :flex_start
    self.flex_direction = :row

    self.add_child(thumbnail)
    self.add_child(content)
      content.add_child(subreddit)
      content.add_child(title)
  end

  def update(post)
    title.text = post.title
    subreddit.text = "/r/#{post.subreddit}"

    if post.thumbnail
      Net.get(post.thumbnail) do |response|
        thumbnail.source = response.body.dataUsingEncoding(NSUTF8StringEncoding)
      end
    end
  end

  protected

  def thumbnail
    @thumbnail ||= build_thumbnail
  end

  def build_thumbnail
    image = UI::Image.new
    image.width = 32
    image.height = 32
    image.margin = [5, 15, 5, 5]
    image
  end

  def subreddit
    @subreddit ||= build_subreddit
  end

  def build_subreddit
    label = UI::Label.new
    label.flex = 1
    label.margin = [0, 0, 5, 0]
    label.font = {name: "Helvetica", size: 14, trait: :bold}
    label
  end

  def title
    @title ||= build_title
  end

  def build_title
    label = UI::Label.new
    label.flex = 1
    label.font = {name: "Helvetica", size: 12}
    label
  end

  def content
    @content ||= build_content
  end

  def build_content
    view = UI::View.new
    view.flex = 1
    view.margin = [5, 5, 15, 5]
    view
  end
end
