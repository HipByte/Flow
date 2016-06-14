describe Net::Config do
  it "can set connect_timeout" do
    Net::Config.connect_timeout = 10
    Net::Config.connect_timeout.should == 10
  end

  it "has a default connect_timeout" do
    Net::Config.connect_timeout = nil
    Net::Config.connect_timeout.should == 30
  end

  it "can set read_timeout" do
    Net::Config.read_timeout = 10
    Net::Config.read_timeout.should == 10
  end

  it "has a default read_timeout" do
    Net::Config.read_timeout = nil
    Net::Config.read_timeout.should == 604800
  end

  it "can set user_agent" do
    Net::Config.user_agent = "Some User Agent"
    Net::Config.user_agent.should == "Some User Agent"
  end

  it "has a default user_agent" do
    Net::Config.user_agent = nil
    Net::Config.user_agent.should == Net::Config::USER_AGENT
  end
end
