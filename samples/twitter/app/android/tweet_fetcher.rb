class TweetFetcher
  def self.fetch_tweets(&block)
    base64 = "xx"
    Net.post("https://api.twitter.com/oauth2/token", { body: "grant_type=client_credentials", headers: { "Authorization" => "Basic #{base64}", "Content-Type" => "application/x-www-form-urlencoded;charset=UTF-8"} }) do |response|
      @credentials = response.body

      Net.get("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=twitterapi&count=2", { headers: { "Authorization" => "Bearer #{@credentials["access_token"]}", } }) do |response|
        tweets = response.body.map { |t| Tweet.new(t) }
        block.call(tweets) if block
      end
    end
  end
end
