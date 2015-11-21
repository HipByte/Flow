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
      @response.toString
    end

    def status_message
    end

    def headers
    end
  end
end
