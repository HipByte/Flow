module Net
  class ResponseProxy
    def self.build_response(connection, response)
      new(connection, response).response
    end

    def initialize(connection, response)
      @connection = connection
      @response = response
    end

    def response
      Response.new({
        status_code: status_code,
        status_message: nil, # FIXME
        headers: [], # FIXME
        body: build_body
      })
    end

    private

    def mime_type
      @connection.getContentType
    end

    def status_code
      @connection.getResponseCode
    end

    def json?
      mime_type.match /application\/json/
    end

    def build_body
      if json?
        return JSON.load(@response.toString)
      end

      @response.toString
    end
  end
end
