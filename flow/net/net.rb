module Net
  USER_AGENT = "Net - https://github.com/xmotion/x_network"

  def self.get(url, options = {}, &callback)
    request = Request.new
    request.get(url, options:options, callback:callback)
  end
end
