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

    def header(field, value)
      @headers << Header.new(field, value)
    end

    def headers
      hash = {}
      @headers.map {|header| hash[header.field] = header.value}
      hash
    end

    def authorize(options)
      @authorization = Authorization.new(options)
    end
  end
end
