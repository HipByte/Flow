module Net
  USER_AGENT = "Net - https://bitbucket.org/hipbyte/flow"

  def self.get(url, options = {}, &callback)
    request = Request.new
    request.get(url, options:options, callback:callback)
  end
end
