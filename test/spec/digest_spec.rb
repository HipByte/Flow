digests = [
  [Digest::SHA1, '2aae6c35c94fcfb415dbe95f408b9ce91ee846ed'],
  [Digest::MD5, '5eb63bbbe01eeed093cb22bb8f5acdc3']
]

digests.each do |klass, hello_world_md|
  describe "#{klass}" do
    it "can digest strings directly using .digest" do
      klass.digest('hello world').should == hello_world_md
    end

    it "can be instantiated using .new" do
      digest = klass.new
      digest.class.should == klass
    end

    it "can digest strings sequentially using #update and #digest" do
      digest = klass.new
      digest.update('hello')
      digest.update(' ')
      digest.update('world')
      digest.digest.should == hello_world_md
    end

    it "can be reset using #reset" do
      digest = klass.new
      digest.update('iaudnaidunfaisdfnasfjweawer')
      digest.reset
      digest.update('hello world')
      digest.digest.should == hello_world_md
    end
  end
end
