module Net
  class Request < AbstractRequest
    def get(url, options:request_options, callback:callback)
      @url = Java::Net::URL.new(url)
      @http_verb = "GET"
      @options = options.merge(request_options)
      @callback = callback
      run
    end

    def run
      # a cross platform async gem would probably
      # be a good idea
      MotionAsync.async do
  		  connection = @url.openConnection
  		  connection.setRequestMethod(@http_verb)
  		  connection.setRequestProperty("User-Agent", Config.user_agent || Net::USER_AGENT)

        input_reader = Java::Io::InputStreamReader.new(connection.getInputStream)
  		  input = Java::Io::BufferedReader.new(input_reader)
  		  inputLine = ""
  		  response = Java::Lang::StringBuffer.new
  		  while (inputLine = input.readLine) != nil do
          response.append(inputLine)
        end
        input.close

        @callback.call(Response.new(connection, response))
      end
    end

    def options
      @options ||= {}
    end
  end
end
