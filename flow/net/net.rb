module Net
  class << self
    def build(base_url, &block)
      Session.build(base_url, &block)
    end

    def reachable?(hostname = 'www.google.com', &block)
      Reachability.new(hostname, &block)
    end

    def stub(base_url)
      expectation = Expectation.all.find{ |e| e.base_url == base_url }
      if expectation.nil?
        expectation = Expectation.new(base_url)
        Expectation.all << expectation
      end
      expectation
    end

    [:get, :post, :put, :delete, :patch, :options, :head].each do |http_medhod|
      define_method(http_medhod) do |base_url, *options, &callback|
        Request.send(http_medhod, base_url, options.shift || {}, callback)
      end
    end
  end
end
