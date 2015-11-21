module Net
  class Request
    module Actions
      def get(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :get), callback)
        request.run
      end

      def post(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :post), callback)
        request.run
      end

      def put(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :put), callback)
        request.run
      end

      def delete(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :delete), callback)
        request.run
      end

      def head(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :head), callback)
        request.run
      end

      def patch(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :patch), callback)
        request.run
      end

      def options(base_url, options, callback)
        request = Request.new(base_url, options.merge(method: :options), callback)
        request.run
      end
    end
  end
end
