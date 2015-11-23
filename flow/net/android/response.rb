module Net
  class Response
    def initialize(connection, response)
      @connection = connection
      @response = response
    end

    def status
      @connection.getResponseCode
    end

    def body
      @body ||= build_body
    end

    def status_message
    end

    def headers
    end

    def json?
      mime_type.match /application\/json/
    end

    def mime_type
      @connection.getContentType
    end

    private

    def build_body
      if json?
        return JSON.load(@response.toString)
      end
      @response.toString
    end
  end
end
