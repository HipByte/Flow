module Net
  class Authorization
    def initialize(options = {})
      @options = options

      if !basic? && !token?
        raise "Invalid arguments given for Authorization"
      end
    end

    def to_s
      if basic?
        base_64 = Flow::Base64.encode("#{username}:#{password}"
        return "Basic #{base_64}"
      end
      if token?
        return 'Token token="' + token + '"'
      end
    end

    def username
      @options.fetch(:username, false)
    end

    def password
      @options.fetch(:password, false)
    end

    def token
      @options.fetch(:token, false)
    end

    def basic?
      !!username && !!password
    end

    def token?
      !!token
    end
  end
end
