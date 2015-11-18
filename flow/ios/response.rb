module XNetwork
  class Response < AbstractResponse
    def initialize(raw_body, response)
      @raw_body = raw_body
      @response = response
    end

    def status
      @response.statusCode
    end

    def mime_type
      @response.MIMEType
    end

    def body
      if json?
        body = NSString.alloc.initWithData(@raw_body, encoding:NSUTF8StringEncoding)
        return JSON.parse(body)
      end
      @raw_body
    end

    def status_message
      NSHTTPURLResponse.localizedStringForStatusCode(status)
    end

    def headers
      @response.allHeaderFields
    end

    def json?
      mime_type == "application/json"
    end
  end
end
