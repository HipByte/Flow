module XNetwork
  class AbstractRequest
    attr_accessor :options
    attr_accessor :http_verb

    def get(url, options:options, callback:callback)
      fail
    end

    def options
      fail
    end
  end
end
