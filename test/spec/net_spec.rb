describe Net do
  before do
    @response = nil
  end

  describe ".reachable?" do
    before do
      @reachable = false
    end

    # FIXME : Sometimes, this spec will be failed with "LocalJumpError: no block given"
    # it "tracks network reachability state" do
    #   Net.reachable?("www.google.com") do |reachable|
    #     sleep 0.1
    #     @reachable = reachable
    #     resume
    #   end

    #   wait do
    #     @reachable.should == true
    #   end
    # end
  end

  describe ".stub" do
    before do
      @url = "http://unkown_domain.test"
      @request = Net::Request.new(@url)
      @expected_response = Net::Response.new
    end

    it "doesnt hit network" do
      Net.stub(@url).and_return(@expected_response)
      Net.get(@url) do |response|
        response.should == @expected_response
      end
    end
  end

  describe ".get" do
    it "can pass Token based HTTP auth" do
      session = Net.build(HTTP_SERVER) do
        authorize(token: 'rubymotion')
      end
      session.get('/token_auth_protected') do |response|
        @response = response
        resume
      end

      wait do
        @response.body.should == "Welcome"
      end
    end

    it "can pass Basic HTTP auth" do
      session = Net::Session.build(HTTP_SERVER) do
        authorize(username: 'username', password: 'admin')
      end
      session.get('/basic_auth_protected') do |response|
        @response = response
        resume
      end

      wait do
        @response.body.should == "Welcome"
      end
    end

    it "has a correct TXT response" do
      Net.get("#{HTTP_SERVER}/txt?user=1") do |response|
        @response = response
        resume
      end

      wait do
        @response.body.should.match /User: 1/
        @response.status.should == 200
        @response.status_message.should == "HTTP/1.1 200 OK"
      end
    end
  end

  describe ".post" do
    it "has a correct JSON response" do
      options = {
        body: {user: 1},
        headers: {
          'Content-Type' => 'application/json'
        }
      }
      Net.post("#{HTTP_SERVER}?test=1", options) do |response|
        @response = response
        resume
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.headers['X-Request-Method'].should == "POST"
        @response.status_message.should == "HTTP/1.1 200 OK"
      end
    end

    it "can post form url encoded body" do
      options = {
        body: "user=1"
      }
      Net.post("#{HTTP_SERVER}/form", options) do |response|
        @response = response
        resume
      end

      wait do
        @response.body['data'].should == "user=1"
      end
    end
  end

  describe ".put" do
    it "has a correct JSON response" do
      options = {
        body: {user: 1},
        headers: {
          'Content-Type' => 'application/json'
        }
      }
      Net.put("#{HTTP_SERVER}?test=1", options) do |response|
        @response = response
        resume
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.headers['X-Request-Method'].should == "PUT"
        @response.status_message.should == "HTTP/1.1 200 OK"
      end
    end
  end

  describe ".patch" do
    it "has a correct JSON response" do
      options = {
        body: {user: 1},
        headers: {
          'Content-Type' => 'application/json'
        }
      }
      Net.patch("#{HTTP_SERVER}?test=1", options) do |response|
        @response = response
        resume
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.headers['X-Request-Method'].should == "PATCH"
        @response.status_message.should == "HTTP/1.1 200 OK"
      end
    end
  end

  describe ".delete" do
    it "has a correct JSON response" do
      options = {
        body: {user: 1},
        headers: {
          'Content-Type' => 'application/json'
        }
      }
      Net.delete("#{HTTP_SERVER}?test=1", options) do |response|
        @response = response
        resume
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.headers['X-Request-Method'].should == "DELETE"
        @response.status_message.should == "HTTP/1.1 200 OK"
      end
    end
  end

  describe ".head" do
    it "has a correct response" do
      Net.head(HTTP_SERVER) do |response|
        @response = response
        resume
      end

      wait do
        @response.headers['X-Request-Method'].should == "HEAD"
      end
    end
  end

  describe ".options" do
    it "has a correct response" do
      Net.options(HTTP_SERVER) do |response|
        @response = response
        resume
      end

      wait do
        @response.headers['X-Request-Method'].should == "OPTIONS"
      end
    end
  end
end
