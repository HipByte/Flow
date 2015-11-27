module Net
  USER_AGENT = "Net - https://bitbucket.org/hipbyte/flow"

  def self.session(base_url, &block)
    Session.build(base_url, &block)
  end

  class << self
    [:get, :post, :put, :delete, :patch, :options, :head].each do |http_medhod|
      define_method(http_medhod) do |base_url, *options, &callback|
        Request.send(http_medhod, base_url, options.shift || {}, &callback)
      end
    end
  end
end
