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
        return "#{username}:#{password}"
      end
      if token?
        return token.to_s
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
      username && password
    end

    def token?
      token
    end
  end
end
