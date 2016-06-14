# See {Digest::Base Digest::Base} to see the methods implemented in subclasses:
# - {Digest::MD5 Digest::MD5}
# - {Digest::SHA1 Digest::SHA1}
# - {Digest::SHA224 Digest::SHA224}
# - {Digest::SHA256 Digest::SHA256}
# - {Digest::SHA384 Digest::SHA384}
# - {Digest::SHA512 Digest::SHA512}
module Digest
  class Base
    # @example
    #   digest = Digest::MD5.new
    def initialize(algo)
      @digest = Java::Security::MessageDigest.getInstance(algo)
    end

    # @example
    #  digest.update('hello')
    def update(str)
      @digest.update(str.chars.map { |x| x.ord })
      self
    end

    # @example
    #   digest.reset
    def reset
      @digest.reset
      self
    end

    # @example
    #   digest.digest
    #   #=> '5d41402abc4b2a76b9719d911017c592'
    def digest
      @digest.digest.map { |x| String.format('%02x', x) }.join
    end

    # @example
    #   Digest::MD5.digest('hello')
    #   #=> '5d41402abc4b2a76b9719d911017c592'
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
