class ViewController < UITableViewController
  attr_accessor :tweets
  def viewDidLoad
    self.tweets = []
    self.tableView.dataSource = self
    self.tableView.delegate = self

    TweetFetcher.fetch_tweets do |tweets|
      self.tweets = tweets
      self.tableView.reloadData
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    tweets.count
  end

  def tableView(tableView, cellForRowAtIndexPath:index)
    cell = tableView.dequeueReusableCellWithIdentifier("tweet")
    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:"tweet")
    end

    Net.get(self.tweets[index.row].user.profile_image_url_https) do |response|
      cell.imageView.image = UIImage.imageWithData(response.body.to_data)
      cell.setNeedsLayout
    end

    cell.textLabel.text = self.tweets[index.row].user.name
    cell.detailTextLabel.text = self.tweets[index.row].text
    cell
  end
end
