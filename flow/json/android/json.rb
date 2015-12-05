class JSON
  def self.load(str)
    tok = Org::JSON::JSONTokener.new(str)
    obj = tok.nextValue
    if obj == nil
      raise "Can't deserialize object from JSON"
    end

    # Transform pure-Java JSON objects to Ruby types.
    @convert_java ||= (lambda do |obj|
      case obj
        when Org::JSON::JSONArray
          obj.length.times.map { |i| @convert_java.call(obj.get(i)) }
        when Org::JSON::JSONObject
          iter = obj.keys
          hash = Hash.new
          while iter.hasNext
            key = iter.next
            value = obj.get(key)
            hash[@convert_java.call(key)] = @convert_java.call(value)
          end
          hash
        when Java::Lang::String
          obj.to_s
        else
          obj
      end
    end)
    @convert_java.call(obj)
  end
end

class Object
  def to_json
    # The Android JSON API expects real Java String objects.
    @@fix_string ||= (lambda do |obj|
      case obj
        when String
          obj = obj.toString
        when Hash
          map = Hash.new
          obj.each do |key, value|
            key = key.toString if key.is_a?(String)
            value = @@fix_string.call(value)
            map[key] = value
          end
          obj = map
        when Array
          obj = obj.map do |item|
            item.is_a?(String) ? item.toString : @@fix_string.call(item)
          end
      end
      obj
    end)

    obj = Org::JSON::JSONObject.wrap(@@fix_string.call(self))
    if obj == nil
      raise "Can't serialize object to JSON"
    end
    obj.toString.to_s
  end
end
