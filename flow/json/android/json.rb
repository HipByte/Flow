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
    obj = Org::JSON::JSONObject.wrap(self)
    if obj == nil
      raise "Can't serialize object to JSON"
    end
    obj.toString
  end
end
