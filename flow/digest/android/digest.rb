module Digest
  class Base
    def initialize(algo)
      @digest = Java::Security::MessageDigest.getInstance(algo)
    end

    def _update(str)
      @digest.update(str.chars.map { |x| x.ord })
      self
    end

    def reset
      @digest.reset
      self
    end

    def hexdigest
      @digest.digest.map { |x| String.format('%02x', x) }.join
    end
  end

  class MD5 < Base
    def initialize
      super('MD5')
    end

    def self.digest(str)
      self.new._update(str).hexdigest
    end
  end

  class SHA1 < Base
    def initialize
      super('SHA1')
    end

    def self.digest(str)
      self.new._update(str).hexdigest
    end
  end
end
