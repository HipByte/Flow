module Net
  module JSON
    # extracted from bubble wrap
    # would probably need a cross platform gem
    class ParserError < StandardError; end

    def self.parse(data)
      return nil unless data

      if data.respond_to?('dataUsingEncoding:')
        data = data.dataUsingEncoding(NSUTF8StringEncoding)
      end

      options = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
      error = Pointer.new(:id)
      json_object = NSJSONSerialization.JSONObjectWithData(data, options:options, error:error)
      if error[0]
        raise ParserError, error[0].description
      end

      json_object
    end

    def self.generate(obj)
      NSJSONSerialization.dataWithJSONObject(obj, options:0, error:nil).to_str
    end
  end
end
