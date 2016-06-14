module Net
  class Request
    # @!visibility private
    module Stubbable
      def stub!(&callback)
        if response = Expectation.response_for(self)
          callback.call(response)
          true
        end
      end
    end
  end
end
