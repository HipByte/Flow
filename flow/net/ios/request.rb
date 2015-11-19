module Net
  class Request < AbstractRequest
    def get(url, options:request_options, callback:callback)
      @url = NSURL.URLWithString(url)
      @http_verb = "GET"
      @options = options.merge(request_options)
      @callback = callback
      run
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
      NSURLSession.sessionWithConfiguration(@session_configuration, delegate:self, delegateQueue:nil)
    end

    def request
      @request ||= build_request
    end

    def build_request
      request = NSMutableURLRequest.requestWithURL(@url)
      request.setHTTPMethod(http_verb)
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

    def options
      @options ||= build_options
    end

    private

    def build_options
      options = {}
      default_user_agent = Config.user_agent || Net::USER_AGENT
      options[:headers] = {'User-Agent' => default_user_agent}.merge(options[:headers] || {})
      options[:verbose] ||= Config.verbose
      options[:connect_timeout] = options.fetch(:connect_timeout, Config.connect_timeout)
      options[:read_timeout] = options.fetch(:read_timeout, Config.read_timeout)
      options
    end
  end
end
