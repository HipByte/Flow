class ViewController < UITableViewController
  attr_accessor :posts
  def viewDidLoad
    self.posts = []
    self.tableView.dataSource = self
    self.tableView.delegate = self

    search('cats')
  end

  def search(query)
    RedditFetcher.fetch_posts(query) do |posts|
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
    unless cell
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CELL_ID)
    end

    post = self.posts[index.row]

    if post.thumbnail
      Net.get(post.thumbnail) do |response|
        cell.imageView.image = UIImage.imageWithData(response.body.to_data)
        cell.setNeedsLayout
      end
    else
      cell.imageView.image = nil
      cell.setNeedsLayout
    end

    cell.textLabel.text = post.title
    cell.detailTextLabel.text = "sub: #{post.subreddit}"
    cell
  end
end
