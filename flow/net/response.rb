module Net
  class Response
    # @!visibility private
    attr_accessor :options, :mock

    # @!visibility private
    def initialize(options = {})
      @options = options
      @headers = options[:headers]
      @mock = false
    end

    # Returns the HTTP status code of the response
    # @return [Fixnum]
    # @example
    #   response.status_code
    #   #=> 200
    def status
      options[:status_code]
    end

    # Returns the HTTP status message of the response according to RFC 2616
    # @return [String]
    # @example
    #   response.status_message
    #   #=> "OK"
    def status_message
      options[:status_message]
    end

    # Returns the mime type of the response
    # @return [String]
    # @example
    #   repsonse.status_message
    #   #=> "OK"
    def mime_type
      options[:mime_type]
    end

    # Returns body of the response
    # @return [String]
    # @example
    #   response.body
    #   #=> "Hello World"
    def body
      options.fetch(:body, "")
    end

    # Returns a hash containing key/value pairs of headers
    # @return [Hash]
    # @example
    #   response.headers
    #   #=> { 'Content-Type' => 'application/josn' }
    def headers
      @headers
    end
  end
end
