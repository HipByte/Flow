class ReachabilityDelegate < Android::Net::ConnectivityManager::NetworkCallback
  def initialize(hostname, block)
    @hostname = hostname
    @block = block
  end

  def onAvailable(network)
    begin
      sockaddr = Java::Net::InetSocketAddress.new(@hostname, 80)
      sock = Java::Net::Socket.new
      sock.connect(sockaddr, 2000) # 2 seconds timeout
      sock.close
      @block.call(true)
    rescue
      @block.call(false)
    end
  end

  def onLost(network)
    @block.call(false)
  end
end

module Net
  def self.context=(context)
    @connectivity = context.getSystemService(Android::Content::Context::CONNECTIVITY_SERVICE)
  end

  def self._connectivity
    @connectivity or raise "Call `Net.context = self' in your main activity"
  end

  class Reachability
    def initialize(hostname, &block)
      builder = Android::Net::NetworkRequest::Builder.new
      builder.addCapability(Android::Net::NetworkCapabilities::NET_CAPABILITY_INTERNET)
      builder.addTransportType(Android::Net::NetworkCapabilities::TRANSPORT_WIFI)
      builder.addTransportType(Android::Net::NetworkCapabilities::TRANSPORT_CELLULAR)
      @delegate = ReachabilityDelegate.new(hostname, block)
      Net._connectivity.registerNetworkCallback(builder.build, @delegate) 
    end

    def stop
      if @delegate
        Net._connectivity.unregisterNetworkCallback(@delegate)
        @delegate = nil
      end
    end
  end
end
