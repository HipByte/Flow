module Flow
  class Base64
    def encode(string)
      bytes = string.getBytes("UTF-8")
      Android::Util::Base64.encodeToString(bytes, Android::Util::Base64::DEFAULT)
    end

    def decode(string)
      bytes = Android::Util::Base64.decode(string, Android::Util::Base64::DEFAULT)
      Java::Lang::String.new(bytes, "UTF-8")
    end
  end
end
