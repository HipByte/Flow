module Net
  class Request
    # @!visibility private
    module Actions
      [:get, :post, :put, :delete, :patch, :options, :head].each do |http_method|
        define_method(http_method) do |base_url, *options, callback|
          options = options.shift || {}
          request = Request.new(base_url, options.merge(method: http_method))
          request.run(&callback)
        end
      end
    end
  end
end
