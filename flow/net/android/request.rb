module Net
  class Request
    extend Actions

    attr_reader :configuration, :session

    def initialize(url, options = {}, session = nil)
      @url = Java::Net::URL.new(url)
      @options = options
      @session = session
      @configuration = {}

      set_defaults
      configure
    end

    def run(&callback)
      AsyncTask.async do
        configuration[:headers].each do |key, value|
          url_connection.setRequestProperty(key, value)
        end

        if configuration[:method] == :post && configuration[:body]
          stream = url_connection.getOutputStream
          stream.write(Java::Lang::String.new(configuration[:body]).getBytes("UTF-8"))
        end

        input_reader = Java::Io::InputStreamReader.new(url_connection.getInputStream)
  		  input = Java::Io::BufferedReader.new(input_reader)
  		  inputLine = ""
  		  response = Java::Lang::StringBuffer.new
  		  while (inputLine = input.readLine) != nil do
          response.append(inputLine)
        end
        input.close

        AsyncTask.main_async do
          callback.call(Response.new(connection, response))
        end
      end
    end

    private

    def url_connection
      @url_connection ||= build_url_connection
    end

    def build_url_connection
      connection = @url.openConnection
      connection.setRequestMethod(configuration[:method].to_s.upcase)
      connection.setDoOutput(true) if configuration[:method] == :post
      connection
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

        authorization = session.authorization
        if authorization && authorization.basic?
          # TODO : implement base64 encoding for android
        end
      end

      configuration.merge!(@options)
    end
  end
end
