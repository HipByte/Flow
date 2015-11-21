module Net
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
      @body ||= build_body
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

    private

    def build_body
      if json?
        return JSON.load(@raw_body.to_str)
      end
      @raw_body
    end
  end
end
