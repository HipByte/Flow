class ViewController < UITableViewController
  attr_accessor :posts
  def viewDidLoad
    self.posts = []
    self.tableView.dataSource = self
    self.tableView.delegate = self

    RedditFetcher.fetch_posts do |posts|
      self.posts = posts
      self.tableView.reloadData
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    posts.count
  end

  CELL_ID = "reddit_post"
  def tableView(tableView, cellForRowAtIndexPath:index)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID)
    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CELL_ID)
    end

    thumbnail = self.posts[index.row].thumbnail

    unless thumbnail == 'self'
      Net.get(self.posts[index.row].thumbnail) do |response|
        cell.imageView.image = UIImage.imageWithData(response.body.to_data)
        cell.setNeedsLayout
      end
    end

    cell.textLabel.text = self.posts[index.row].title
    cell.detailTextLabel.text = "sub: #{self.posts[index.row].subreddit}"
    cell
  end
end
