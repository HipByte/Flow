module Net
  class Response
    attr_accessor :options

    def initialize(options = {})
      @options = options
      @headers = options[:headers]
    end

    def status
      options[:status_code]
    end

    def status_message
      options[:status_message]
    end

    def mime_type
      options[:mime_type]
    end

    def body
      options.fetch(:body, "")
    end

    def headers
      @headers
    end
  end
end
