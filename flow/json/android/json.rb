class Org::JSON::JSONArray
  def _to_obj
    ary = Array.new
    length.times do |i|
      obj = get(i)
      case obj
        when Org::JSON::JSONObject, Org::JSON::JSONArray
          obj = obj._to_obj
      end
      ary << obj
    end
    ary
  end
end

class Org::JSON::JSONObject
  def _to_obj
    iter = self.keys
    hash = Hash.new
    while iter.hasNext
      key = iter.next
      obj = get(key)
      case obj
        when Org::JSON::JSONObject, Org::JSON::JSONArray
          obj = obj._to_obj
      end
      hash[key] = obj
    end
    hash
  end
end

class JSON
  def self.load(str)
    tok = Org::JSON::JSONTokener.new(str)
    obj = tok.nextValue
    if obj == nil
      raise "Can't deserialize object from JSON"
    end
    case obj
      when Org::JSON::JSONObject, Org::JSON::JSONArray
        obj = obj._to_obj
    end
    obj
  end
end

class Object
  def to_json
    # The Android JSON API expects real Java String objects.
    obj = self
    case obj
      when String
        obj = obj.toString
      when Hash
        map = Hash.new
        obj.each do |key, value|
          key = key.toString if key.is_a?(String)
          value = value.toString if value.is_a?(String)
          map[key] = value
        end
        obj = map
      when Array
        obj = obj.map { |item| item.is_a?(String) ? item.toString : item }
    end

    obj = Org::JSON::JSONObject.wrap(obj)
    if obj == nil
      raise "Can't serialize object to JSON"
    end
    obj.toString
  end
end
