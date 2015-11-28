module Net
  class Expectation
    class << self
      def all
        @expectations ||= []
      end

      def clear
        all.clear
      end

      def response_for(request)
        expectation = find_by(request)
        return nil if expectation.nil?
        expectation.response
      end

      def find_by(request)
        all.find do |expectation|
          expectation.matches?(request)
        end
      end
    end

    attr_reader :response

    def initialize(url)
      @url = url
    end

    def and_return(response)
      @response = response
    end

    def matches?(request)
      url_match?(request.base_url)
    end

    def response
      @response.mock = true
      @response
    end

    private

    def url_match?(request_url)
      case @url
      when String
        @url == request_url
      when Regexp
        @url === request_url
      when nil
        true
      else
        false
      end
    end
  end
end
