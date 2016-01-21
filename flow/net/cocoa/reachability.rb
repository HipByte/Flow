module Net
  class Reachability
    def initialize(hostname, &block)
      @internal_callback = Proc.new do |target, flags, pointer|
        block.call(reachable_with_flags?(flags))
      end
      block.weak!
      @reachability = SCNetworkReachabilityCreateWithName(KCFAllocatorDefault,
                                                          hostname.UTF8String)

      start_tracking_network
    end

    def stop
      SCNetworkReachabilityUnscheduleFromRunLoop(@reachability,
                                                 CFRunLoopGetCurrent(),
                                                 KCFRunLoopDefaultMode)
      SCNetworkReachabilitySetCallback(@reachability, nil, @context)
    end

    protected

    def reachable_with_flags?(flags)
      return false unless flags

      if (flags & KSCNetworkReachabilityFlagsReachable) == 0
        return false
      end

      true
    end

    def start_tracking_network
      @context = Pointer.new(SCNetworkReachabilityContext.type)
      if SCNetworkReachabilitySetCallback(@reachability, @internal_callback,
                                          @context)
        if SCNetworkReachabilityScheduleWithRunLoop(@reachability,
                                                    CFRunLoopGetCurrent(),
                                                    KCFRunLoopDefaultMode)
          return true
        end
      end

      false
    end
  end
end
