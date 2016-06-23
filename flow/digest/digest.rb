module Digest
  class Base
    def initialize(algo)
      @digest = Java::Security::MessageDigest.getInstance(algo)
    end

    def update(str)
      @digest.update(str.chars.map { |x| x.ord })
      self
    end

    def reset
      @digest.reset
      self
    end

    def digest
      @digest.digest.map { |x| String.format('%02x', x) }.join
    end

    def self.digest(str)
      self.new.update(str).digest
    end
  end

  class MD5 < Base; def initialize; super('MD5'); end; end
  class SHA1 < Base; def initialize; super('SHA1'); end; end
  class SHA224 < Base; def initialize; super('SHA224'); end; end
  class SHA256 < Base; def initialize; super('SHA256'); end; end
  class SHA384 < Base; def initialize; super('SHA384'); end; end
  class SHA512 < Base; def initialize; super('SHA512'); end; end
end
