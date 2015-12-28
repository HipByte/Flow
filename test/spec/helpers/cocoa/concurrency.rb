module Concurrency
  class Queue
    def initialize(queue)
      @queue = queue
    end

    def self.main
      new(Dispatch::Queue.main)
    end

    def async(&block)
      @queue.async(&block)
    end
  end
end
