class Task
  class Timer
    def initialize(interval, repeats, block)
      interval *= 1000
      if interval <= 0
        raise ArgError, "negative or too small interval"
      end
      @timer = Java::Util::Concurrent::Executors.newSingleThreadScheduledExecutor
      @future =
        if repeats
          @timer.scheduleAtFixedRate(block, interval, interval, Java::Util::Concurrent::TimeUnit::MILLISECONDS)
        else
          @timer.schedule(block, interval, Java::Util::Concurrent::TimeUnit::MILLISECONDS)
        end
    end

    def stop
      if @future
        @future.cancel(true)
        @future = nil
      end
    end
  end

  class Queue
    def initialize
      @queue = Java::Util::Concurrent::Executors.newSingleThreadExecutor
    end

    def schedule(&block)
      @queue.execute(block)
    end

    def self.schedule_on_main(block)
      @main_handle ||= begin
        looper = Android::Os::Looper.getMainLooper
        Android::Os::Handler.new(looper)
      end
      @main_handle.post(block)
    end

    def self.schedule_on_background(block)
      @thread_pool ||= Java::Util::Concurrent::Executors.newCachedThreadPool
      @thread_pool.execute(block)
    end
  end
end
