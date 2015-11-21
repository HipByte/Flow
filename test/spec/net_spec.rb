describe "Net" do
  before do
    @response = nil
  end

  it "can GET TXT from a valid TXT endpoint" do
    @response = nil
    Net.get('https://httpbin.org/robots.txt') do |response|
      @response = response
      Dispatch::Queue.main.async { resume }
    end
    wait do
      @response.body.should.match /User-agent: */
      @response.status.should == 200
      @response.mime_type.should == "text/plain"
      @response.status_message.should == "no error"
    end
  end

  it "can POST JSON to a valid JSON endpoint" do
    @response = nil
    options = {
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {user: 1}
    }
    Net.post('https://httpbin.org/post?test=1', options) do |response|
      @response = response
      Dispatch::Queue.main.async { resume }
    end
    wait do
      @response.body['args']['test'].should == "1"
      @response.body['json']['user'].should == 1
      @response.mime_type.should == "application/json"
    end
  end

  it "can POST FORM to a valid form url encoded endpoint" do
    @response = nil
    options = {
      body: "user=1"
    }
    Net.post('https://httpbin.org/post', options) do |response|
      @response = response
      Dispatch::Queue.main.async { resume }
    end
    wait do
      @response.body['form']['user'].should == "1"
    end
  end

  it "can GET JSON from a valid JSON endpoint" do
    @response = nil
    Net.get('https://httpbin.org/get?test=1') do |response|
      @response = response
      Dispatch::Queue.main.async { resume }
    end
    wait do
      @response.body['args']['test'].should == "1"
      @response.mime_type.should == "application/json"
    end
  end
end
