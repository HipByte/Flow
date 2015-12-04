class Post
  def initialize(post = {})
    @post = post
  end

  def title
    @post.fetch('title', nil)
  end

  def thumbnail
    thumbnail = @post.fetch('thumbnail', nil)
    return nil unless thumbnail.start_with?('http')
    thumbnail
  end

  def subreddit
    @post.fetch('subreddit', nil)
  end
end
