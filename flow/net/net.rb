module Net
  class << self

    # Creates a session with common configuration
    # @example
    #   session = Net.build('https://httpbin.org') do
    #     header(:content_type, :json)
    #   end
    #   session.get("/users") do |response|
    #   end
    #   session.get("/posts") do |response|
    #   end
    def build(base_url, &block)
      Session.build(base_url, &block)
    end

    # Track the reachability of a hostname
    # @example
    #   # this block will be called each time network status is updated
    #   reachability = Net.reachable?("www.google.fr") do |reachable|
    #     if reachable
    #       ###
    #     end
    #   end
    #   # stop network reachability tracking
    #   reachability.stop
    def reachable?(hostname = 'www.google.com', &block)
      Reachability.new(hostname, &block)
    end

    # Stub an url to return the desired Response object
    # @example
    #   Net.stub('www.example.com').and_return(Response.new(body:"example"))
    #   Net.get("www.example.com") do |response|
    #     response.body # example
    #   end
    def stub(base_url)
      expectation = Expectation.all.find{ |e| e.base_url == base_url }
      if expectation.nil?
        expectation = Expectation.new(base_url)
        Expectation.all << expectation
      end
      expectation
    end

    # @!method get(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response

    # @!method post(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response

    # @!method put(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response

    # @!method delete(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response

    # @!method patch(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response

    # @!method options(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response

    # @!method head(base_url, options)
    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    [:get, :post, :put, :delete, :patch, :options, :head].each do |http_medhod|
      define_method(http_medhod) do |base_url, *options, &callback|
        Request.send(http_medhod, base_url, options.shift || {}, callback)
      end
    end
  end
end
