class JSON
  def self.load(str)
    error_ptr = Pointer.new(:id)
    obj = NSJSONSerialization.JSONObjectWithData(str.to_data, options:0, error:error_ptr)
    if obj == nil
      raise error_ptr[0].description
    end
    obj
  end
end

class Object
  def to_json
    raise "Invalid JSON object" unless NSJSONSerialization.isValidJSONObject(self)
    error_ptr = Pointer.new(:id)
    data = NSJSONSerialization.dataWithJSONObject(self, options:0, error:error_ptr)
    if data == nil
      raise error_ptr[0].description
    end
    data.to_str
  end
end
