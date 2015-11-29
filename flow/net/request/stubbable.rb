module Net
  class Request
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
