module Net
  class Request
    extend Actions

    attr_accessor :options

    def initialize(base_url, options, callback)
      @url = Java::Net::URL.new(base_url)
      @options = options
      @callback = callback
      set_defaults
    end

    def run
      AsyncTask.async do
  		  connection = @url.openConnection
  		  connection.setRequestMethod(options[:method].to_s.upcase)
        connection.setDoOutput(true) if options[:method] == :post
  		  connection.setRequestProperty("User-Agent", Config.user_agent)

        (options[:headers] || []).each do |key, value|
          connection.setRequestProperty(key, value)
        end

        if options[:method] == :post && options[:body]
          stream = connection.getOutputStream()
          stream.write(Java::Lang::String.new(@options[:body]).getBytes("UTF-8"))
        end

        input_reader = Java::Io::InputStreamReader.new(connection.getInputStream)
  		  input = Java::Io::BufferedReader.new(input_reader)
  		  inputLine = ""
  		  response = Java::Lang::StringBuffer.new
  		  while (inputLine = input.readLine) != nil do
          response.append(inputLine)
        end
        input.close

        AsyncTask.main_async do
          @callback.call(Response.new(connection, response))
        end
      end
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
