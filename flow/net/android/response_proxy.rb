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
        status_message: status_message,
        headers: headers,
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

    def status_message
      @connection.getResponseMessage
    end

    def headers
      hash = Hash.new
      hash.putAll(@connection.getHeaderFields)
      hash.each do |k,v|
        array = []
        array.addAll(v)
        hash[k] = array.join(',')
      end
      hash
    end

    def json?
      mime_type.match /application\/json/
    end

    def build_body
      string = @response.toString
      if json? && !string.empty?
        return JSON.load(@response.toString)
      end
      string
    end
  end
end
