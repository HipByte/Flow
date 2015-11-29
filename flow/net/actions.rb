module Net
  class Request
    module Actions
      [:get, :post, :put, :delete, :patch, :options, :head].each do |http_medhod|
        define_method(http_medhod) do |base_url, *options, callback|
          options = options.shift || {}
          request = Request.new(base_url, options.merge(method: http_medhod))
          request.run(&callback)
        end
      end
    end
  end
end
