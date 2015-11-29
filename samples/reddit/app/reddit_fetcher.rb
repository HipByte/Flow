class RedditFetcher
  def self.fetch_posts(&block)
    Net.get("https://www.reddit.com/search.json?q=cats") do |response|
      posts = response.body['data']['children'].map { |t| Post.new(t['data']) }
      block.call(posts) if block
    end
  end
end
