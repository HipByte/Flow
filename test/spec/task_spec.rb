describe Task do
  before do
    @proxy = Class.new do
      attr_accessor :proof
    end.new
  end

  describe '.after' do
    it 'schedules and executes timers' do
      @proxy.proof = false
      Task.after 0.5 do
        @proxy.proof = true
      end
      wait_for_change @proxy, 'proof' do
        @proxy.proof.should == true
      end
    end
  end

  describe '.every' do
    it 'runs callbacks repeatedly' do
      @proxy.proof = 0
      @timer = Task.every 0.5 do
        @proxy.proof = @proxy.proof + 1
        @timer.stop if @proxy.proof > 2
      end
      wait 1.1 do
        @proxy.proof.should >= 2
      end
    end
  end

  describe '.stop' do
    it 'cancels timers' do
      @proxy.proof = true
      timer = Task.after 10.0 do
        @proxy.proof = false
      end
      timer.stop
      @proxy.proof.should == true
    end

    it 'cancels periodic timers' do
      @proxy.proof = true
      timer = Task.every 10.0 do
        @proxy.proof = false
      end
      timer.stop
      @proxy.proof.should == true
    end
  end

  describe '.main' do
    it 'runs on the main thread' do
      @proxy.proof = false
      Task.main do
        @proxy.proof = Task.main?
      end

      wait_for_change @proxy, 'proof' do
        @proxy.proof.should == true
      end
    end
  end

  describe '.schedule' do
    it 'waits for completion' do
      @proxy.proof = 0

      queue = Task.queue
      queue.schedule { @proxy.proof += 1 }
      queue.schedule { @proxy.proof += 1 }
      queue.wait

      wait 0.1 do
        @proxy.proof.should == 2
      end
    end
  end

  describe '.background' do
    it 'runs on the background thread' do
      @proxy.proof = true
      Task.background do
        @proxy.proof = Task.main?
      end

      wait_for_change @proxy, 'proof' do
        @proxy.proof.should == false
      end
    end
  end
end
