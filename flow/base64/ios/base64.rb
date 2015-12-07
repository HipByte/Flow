module Flow
  class Base64
    def self.encode(string)
      data = string.to_data
      data.base64EncodedStringWithOptions(0)
    end

    def self.decode(string)
      data = NSData.alloc.initWithBase64EncodedString(string, options: 0)
      NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)
    end
  end
end
