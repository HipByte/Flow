module Net
  USER_AGENT = "Net - https://bitbucket.org/hipbyte/flow"

  def self.get(url, *options, &callback)
    Request.get(url, options.shift || {}, callback)
  end

  def self.post(url, *options, &callback)
    Request.post(url, options.shift || {}, callback)
  end

  def self.delete(url, *options, &callback)
    Request.delete(url, options.shift || {}, callback)
  end

  def self.put(url, *options, &callback)
    Request.put(url, options.shift || {}, callback)
  end

  def self.patch(url, *options, &callback)
    Request.patch(url, options.shift || {}, callback)
  end

  def self.head(url, *options, &callback)
    Request.head(url, options.shift || {}, callback)
  end

  def self.options(url, *options, &callback)
    Request.options(url, options.shift || {}, callback)
  end
end
