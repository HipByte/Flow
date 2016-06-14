module Net
  module Config
    # @!visibility private
    USER_AGENT = "Flow - https://github.com/HipByte/flow"

    class << self
      # User agent string to be used in all requests
      # @return [String]
      attr_accessor :user_agent
      # Time in seconds to wait for a connection to be made. Default is 30 seconds.
      # @return [Fixnum]
      attr_accessor :connect_timeout
      # Time in seconds to wait for a resource to finnish downloading. Default
      # is 7 days.
      # @return [Fixnum]
      attr_accessor :read_timeout

      def user_agent
        @user_agent ||= Net::Config::USER_AGENT
      end

      def connect_timeout
        @connect_timeout ||= 30
      end

      def read_timeout
        @read_timeout ||= 604800
      end
    end
  end
end
