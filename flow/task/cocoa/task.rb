class Task
  class Timer
    def initialize(interval, repeats, block)
      queue = Dispatch::Queue.current
      @timer = Dispatch::Source.timer(interval, interval, 0.0, queue) do |src|
        begin
          block.call
        ensure
          stop unless repeats
        end
      end        
    end

    def stop
      if @timer
        @timer.cancel!
        @timer = nil
      end
    end
  end

  class Queue
    @@counter = 0
    def initialize
      @queue = Dispatch::Queue.new("com.hipbyte.flow.queue#{@@counter += 1}")
    end

    def schedule(&block)
      @queue.async(&block)
    end

    def wait
      @queue.sync {}
    end

    def self.schedule_on_main(block)
      Dispatch::Queue.main.async(&block)
    end

    def self.schedule_on_background(block)
      Dispatch::Queue.concurrent.async(&block)
    end
  end
end
