class Task
  def self.every(interval, &block)
    Task::Timer.new(interval, true, block)
  end

  def self.after(delay, &block)
    Task::Timer.new(delay, false, block)
  end

  def self.main(&block)
    Task::Queue.schedule_on_main(block)
  end

  def self.background(&block)
    Task::Queue.schedule_on_background(block)
  end

  def self.queue
    Task::Queue.new
  end
end
