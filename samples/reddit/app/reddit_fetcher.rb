class RedditFetcher
  def self.fetch_posts(query, &block)
    Net.get("https://www.reddit.com/search.json?q=#{query}") do |response|
      if data = response.body['data']
        if children = data['children']
          posts = children.map do |t|
            Post.new(t['data'])
          end
        end
      end
      block.call(posts || []) if block
    end
  end
end
