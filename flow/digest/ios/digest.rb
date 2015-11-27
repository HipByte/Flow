module Digest
  class Base
    def initialize(algo)
      @digest = FlowDigest.digestWithAlgo(algo)
    end

    def update(str)
      @digest.update(str.to_data)
      self
    end

    def reset
      @digest.reset
      self
    end

    def digest
      data = @digest.digest
      ptr = data.bytes
      digest = ''
      data.length.times do |i|
        byte = ptr[i]
        digest << '%02x' % byte
      end
      digest
    end
  end

  class MD5 < Base
    def initialize
      super('MD5')
    end

    def self.digest(str)
      self.new.update(str).digest
    end
  end

  class SHA1 < Base
    def initialize
      super('SHA1')
    end

    def self.digest(str)
      self.new.update(str).digest
    end
  end
end
