module Net
  module Config
    class << self
      attr_accessor :user_agent
      attr_accessor :connect_timeout
      attr_accessor :read_timeout

      def user_agent
        @user_agent ||= Net::USER_AGENT
      end

      def connect_timeout
        @connect_timeout ||= 30
      end

      def read_timeout
        @read_timeout ||= 60
      end
    end
  end
end
