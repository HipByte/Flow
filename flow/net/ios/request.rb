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
        Dispatch::Queue.main.sync do
          @callback.call(Response.new(body, response))
        end
      }
      task = session.dataTaskWithRequest(request, completionHandler:handler)
      task.resume
    end

    def session
      @session ||= build_session
    end

    def request
      @request ||= build_request
    end

    def session_configuration
      @session_configuration ||= build_session_configuration
    end

    private

    def json?
      options[:headers].fetch('Content-Type', false) == "application/json"
    end

    def data_body(body)
      body ||= ""
      return body.to_json.to_data if body && json?
      body.to_data
    end

    def build_session
      NSURLSession.sessionWithConfiguration(session_configuration,
                                            delegate:self,
                                            delegateQueue:nil)
    end

    def build_request
      request = NSMutableURLRequest.requestWithURL(@url)
      request.setHTTPMethod(options[:method].to_s.upcase)
      request.setHTTPBody(data_body(options[:body]), dataUsingEncoding:NSUTF8StringEncoding)
      request
    end

    def build_session_configuration
      config = NSURLSessionConfiguration.defaultSessionConfiguration
      config.allowsCellularAccess = false
      config.setHTTPAdditionalHeaders(options[:headers])
      config.timeoutIntervalForRequest = options[:connect_timeout]
      config.timeoutIntervalForResource = options[:read_timeout]
      config.HTTPMaximumConnectionsPerHost = 1
      config
    end

    def set_defaults
      options[:headers] ||= {}
      options[:headers] = {
        'User-Agent' => Config.user_agent,
        'Content-Type' => options[:headers].fetch('Content-Type',
                                                  'application/x-www-form-urlencoded')
      }.merge(options[:headers])
      options[:connect_timeout] = options.fetch(:connect_timeout, Config.connect_timeout)
      options[:read_timeout] = options.fetch(:read_timeout, Config.read_timeout)
    end
  end
end
