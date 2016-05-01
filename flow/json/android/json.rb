class JSON
  def self.load(str)
    tok = Org::JSON::JSONTokener.new(str)
    obj = tok.nextValue
    if obj == nil
      raise "Can't deserialize object from JSON"
    end

    # Transform pure-Java JSON objects to Ruby types.
    convert_java(obj)
  end

  def self.convert_java(obj)
    case obj
      when Org::JSON::JSONArray
        obj.length.times.map { |i| convert_java(obj.get(i)) }
      when Org::JSON::JSONObject
        iter = obj.keys
        hash = Hash.new
        loop do
          break unless iter.hasNext
          key = iter.next
          value = obj.get(key)
          hash[convert_java(key)] = convert_java(value)
        end
        hash
      when Java::Lang::String
        obj.to_s
      when Org::JSON::JSONObject::NULL
        nil
      else
        obj
    end
  end
end

class Object
  def to_json
    # The Android JSON API expects real Java String objects.
    @@fix_string ||= (lambda do |obj|
      case obj
        when String, Symbol
          obj = obj.toString
        when Hash
          map = Hash.new
          obj.each do |key, value|
            key = key.toString if key.is_a?(String) || key.is_a?(Symbol)
            value = @@fix_string.call(value)
            map[key] = value
          end
          obj = map
        when Array
          obj = obj.map do |item|
            (item.is_a?(String) || item.is_a?(Symbol)) ? item.toString : @@fix_string.call(item)
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
