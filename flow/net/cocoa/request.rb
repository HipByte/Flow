module Net
  class Request
    extend Actions
    include Request::Stubbable

    attr_reader :configuration, :session, :base_url

    def initialize(url, options = {}, session = nil)
      @base_url = url
      @url = NSURL.URLWithString(url)
      @options = options
      @session = session
      @configuration = {}

      set_defaults
      configure
    end

    def run(&callback)
      return if stub!(&callback)

      Task.background do
        handler = lambda { |body, response, error|
          if response.nil? && error
            raise error.localizedDescription
          end
          Task.main do
            callback.call(ResponseProxy.build_response(body, response))
          end
        }
        task = ns_url_session.dataTaskWithRequest(ns_mutable_request,
                                                  completionHandler:handler)
        task.resume
      end
    end

    private

    def ns_url_session
      @ns_url_session ||= build_ns_url_session
    end

    def ns_mutable_request
      @ns_mutable_request ||= build_ns_mutable_request
    end

    def ns_url_session_configuration
      @ns_url_session_configuration ||= build_ns_url_session_configuration
    end

    def json?
      configuration[:headers].fetch('Content-Type', nil) == "application/json"
    end

    def build_body(body)
      return body.to_json.to_data if json? and body != ''
      body.to_data
    end

    def build_ns_url_session
      NSURLSession.sessionWithConfiguration(ns_url_session_configuration,
                                            delegate:self,
                                            delegateQueue:nil)
    end

    def build_ns_mutable_request
      request = NSMutableURLRequest.requestWithURL(@url)
      request.setHTTPMethod(configuration[:method].to_s.upcase)
      request.setHTTPBody(build_body(configuration[:body]), dataUsingEncoding:NSUTF8StringEncoding)
      request
    end

    def build_ns_url_session_configuration
      config = NSURLSessionConfiguration.defaultSessionConfiguration
      config.setHTTPAdditionalHeaders(configuration[:headers])
      config.timeoutIntervalForRequest = configuration[:connect_timeout]
      config.timeoutIntervalForResource = configuration[:read_timeout]
      config.HTTPMaximumConnectionsPerHost = 1
      config
    end

    def set_defaults
      configuration[:headers] = {
        'User-Agent' => Config.user_agent,
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
      configuration[:method] = :get
      configuration[:body] = ""
      configuration[:connect_timeout] = Config.connect_timeout
      configuration[:read_timeout] = Config.read_timeout
    end

    def configure
      if session
        configuration[:headers].merge!(session.headers)
        if session.authorization
          configuration[:headers].merge!({'Authorization' => session.authorization.to_s})
        end
      end

      configuration.merge!(@options)
    end
  end
end
