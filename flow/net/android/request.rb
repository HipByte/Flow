module Net
  class Request
    extend Actions
    include Request::Stubbable

    attr_reader :configuration, :session, :base_url

    def initialize(url, options = {}, session = nil)
      @base_url = url
      @url = Java::Net::URL.new(url)
      @options = options
      @session = session
      @configuration = {}

      set_defaults
      configure
    end

    def run(&callback)
      return if stub!(&callback)

      Task.background do
        configuration[:headers].each do |key, value|
          url_connection.setRequestProperty(key, value)
        end

        if do_method? and body = configuration[:body]
          stream = url_connection.getOutputStream
          body = body.to_json if json?
          stream.write(Java::Lang::String.new(body).getBytes("UTF-8"))
        end

        response_code = url_connection.getResponseCode
        stream = response_code >= 400 ? url_connection.getErrorStream : url_connection.getInputStream

        response = nil
        if url_connection.getContentType.match(/^image\//)
          # Response as bitmap.
          response = Android::Graphics::BitmapFactory.decodeStream(stream)
        else
          # Response as text.
          input_reader = Java::Io::InputStreamReader.new(stream)
          input = Java::Io::BufferedReader.new(input_reader)
          inputLine = ""
          response = Java::Lang::StringBuffer.new
          while (inputLine = input.readLine) != nil do
            response.append(inputLine)
          end
          input.close
        end

        Task.main do
          callback.call(ResponseProxy.build_response(url_connection, response))
        end
      end
    end

    private

    def do_method?
      case configuration[:method]
        when :post, :put, :patch, :delete
          true
      end
    end

    def json?
      Net::MimeTypes::JSON.include?(configuration[:headers].fetch('Content-Type', nil))
    end

    def url_connection
      @url_connection ||= begin
        connection = @url.openConnection
        connection.setRequestMethod(configuration[:method].to_s.upcase)
        connection.setDoOutput(true) if do_method?
        connection
      end
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
