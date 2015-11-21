module Net
  class Request
    extend Actions

    attr_accessor :options

    def initialize(base_url, options, callback)
      @url = NSURL.URLWithString(base_url)
      @options = options
      @callback = callback
      set_defaults
    end

    def run
      handler = lambda { |body, response, error|
        if response.nil? && error
          fail
        end
        @callback.call(Response.new(body, response))
      }
      task = session.dataTaskWithRequest(request, completionHandler:handler)
      task.resume
    end

    private

    def session
      @session ||= build_session
    end

    def build_session
      NSURLSession.sessionWithConfiguration(@session_configuration,
                                            delegate:self,
                                            delegateQueue:nil)
    end

    def request
      @request ||= build_request
    end

    def build_request
      request = NSMutableURLRequest.requestWithURL(@url)
      request.setHTTPMethod(options[:method].to_s.upcase)
      request
    end

    def session_configuration
      @session_configuration ||= build_session_configuration
    end

    def build_session_configuration
      config = NSURLSessionConfiguration.defaultSessionConfiguration
      config.allowsCellularAccess = false
      config.setHTTPAdditionalHeaders(@options[:headers])
      config.timeoutIntervalForRequest = @options[:connect_timeout]
      config.timeoutIntervalForResource = @options[:read_timeout]
      config.HTTPMaximumConnectionsPerHost = 1
      config
    end

    private

    def set_defaults
      options[:headers] ||= {}
      options[:headers] = {'User-Agent' => Config.user_agent}.merge(options[:headers])
      options[:connect_timeout] = options.fetch(:connect_timeout, Config.connect_timeout)
      options[:read_timeout] = options.fetch(:read_timeout, Config.read_timeout)
      options
    end
  end
end
