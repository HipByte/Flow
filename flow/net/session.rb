module Net
  class Session
    attr_reader :authorization

    def initialize(base_url, &block)
      @base_url = base_url
      @authorization = false
      @headers = []
      self.instance_eval(&block)
    end

    def self.build(base_url, &block)
      new(base_url, &block)
    end

    [:get, :post, :put, :delete, :patch, :options, :head].each do |http_method|
      define_method(http_method) do |endpoint, *options, &callback|
        options = (options.shift || {}).merge({method: http_method})
        request = Request.new("#{@base_url}#{endpoint}", options, self)
        request.run(&callback)
      end
    end

    # Sets a key/value pair header to be used in all requests in this session
    # @param [String] field
    # @param [String] value
    # @example
    #   session.header("Content-Type", "application/json")
    def header(field, value)
      @headers << Header.new(field, value)
    end

    # Returns a hash containing key/value pairs of headers
    # @return [Hash]
    # @example
    #   response.headers
    #   #=> { 'Content-Type' => 'application/json' }
    def headers
      hash = {}
      @headers.map {|header| hash[header.field] = header.value}
      hash
    end

    # Sets the Basic authentication data to be used in all requests
    # @param [Hash] options
    # @option options [String] user
    # @option options [String] password
    # @option options [String] token
    def authorize(options)
      @authorization = Authorization.new(options)
    end
  end
end
