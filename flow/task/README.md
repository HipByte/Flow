# Task

Task manager / scheduler. A simpler (but portable) version of Apple's dispatch library. Uses `Dispatch` on Cocoa and `java.util.concurrent.Executors` on Android. 

## Documentation

### Public API

#### Schedule a block after a given interval (in seconds)

```ruby
timer = Task.after 0.5 do
  # ...
end
```

#### Schedule a block at every given interval (in seconds)

```ruby
timer = Task.every 2.5 do
  # ...
end
```

#### Cancel a scheduled block

```ruby
timer.stop
```

#### Run a block on the main thread

```ruby
Task.main do
  # ...
end
```

#### Run a block concurrently in the background

Blocks will be distributed among a pool of threads and may be executed in parallel.

```ruby
Task.background do
  # ...
end
```

#### Create a serial queue

A `Task::Queue` object keeps a reference to a single thread. 

```ruby
q = Task.queue
```

#### Run a block on a serial queue

Blocks will be run on the thread associated to the queue in sequential order.

```ruby
# This snippet will, in a separate thread:
#   sleep one second
#   print "ok1"
#   sleep one second
#   print "ok2"

q.schedule do
  sleep 1
  puts "ok1"
end
q.schedule do
  sleep 1
  puts "ok2"
end
```
