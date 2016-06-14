class Task
  class Timer
    # Cancel a scheduled block
    # @!method stop
  end

  class Queue
    # Run a block on a serial queue. Blocks will be run on the thread associated
    # to the queue in sequential order. The first block will have to finish
    # before the second block can run.
    # @!method schedule
    # @example
    #   q = Task.queue

    # Wait for all scheduled blocks to finish on a serial queue
    # @!method wait
    # @example
    #   q = Task.queue
    #   q.wait
  end

  # Schedule a block at every given interval (in seconds)
  # @return [Timer]
  # @example
  #   timer = Task.every 2.5 do
  #     # ...
  #   end
  def self.every(interval, &block)
    Task::Timer.new(interval, true, block)
  end

  # Schedule a block after a given interval (in seconds)
  # @example
  #   timer = Task.after 0.5 do
  #     # ...
  #   end
  def self.after(delay, &block)
    Task::Timer.new(delay, false, block)
  end

  # Run a block on the main thread
  # @example
  #   Task.main do
  #     # ...
  #   end
  def self.main(&block)
    Task::Queue.schedule_on_main(block)
  end

  # Run a block concurrently in the background
  # Blocks will be distributed among a pool of threads and may be executed in parallel.
  # @example
  #   Task.background do
  #     # ...
  #   end
  def self.background(&block)
    Task::Queue.schedule_on_background(block)
  end

  # Create a serial queue
  # A <code>Task::Queue</code> object keeps a reference to a single thread.
  # @return [Queue]]
  # @example
  #   q = Task.queue
  def self.queue
    Task::Queue.new
  end

  # Check is the method has been called from the main thread
  # @!method self.main?
  # @example
  #   Task.main?
end
