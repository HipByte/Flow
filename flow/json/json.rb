class JSON
  # @example
  #   JSON.load('{"foo":"bar"}')
  #   #=> {"foo" => "bar"}
  # @!method self.load(str)
end

class Object
  # @!method to_json
  # @return [Hash]
  # @example
  #   {"foo" => "bar"}.to_json
  #   #=> '{"foo":"bar"}'
end
