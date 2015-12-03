class RedditFetcher
  def self.fetch_posts(query, &block)
    Net.get("https://www.reddit.com/search.json?q=#{query}") do |response|
      if data = response.body['data']
        if children = data['children']
          posts = children.map do |t|
            post = Post.new(t['data'])
            post.thumbnail = nil unless post.thumbnail.start_with?('http')
            post
          end
        end
      end
      block.call(posts || []) if block
    end
  end
end
