module XNetwork
  class AbstractResponse
    def status
      fail
    end

    def mime_type
      fail
    end

    def body
      fail
    end

    def status_message
      fail
    end

    def headers
      fail
    end

    def json?
      fail
    end
  end
end
