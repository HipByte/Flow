module Concurrency
  class Queue
    def initialize(queue)
      @handler = Android::Os::Handler.new(queue)
    end

    def self.main
      new(Android::Os::Looper.getMainLooper)
    end

    def async(&block)
      @handler.post(block)
    end
  end
end
