describe "Net" do
  before do
    @response = nil
  end

  describe ".get" do
    it "can pass Basic HTTP auth" do
      session = Net::Session.build(HTTP_SERVER) do
        authorize(username: 'username', password: 'admin')
      end
      session.get('/protected') do |response|
        @response = response
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.body.should == "Welcome"
      end
    end

    it "has a correct TXT response" do
      Net.get("#{HTTP_SERVER}/txt?user=1") do |response|
        @response = response
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.body.should.match /User: 1/
        @response.status.should == 200
        @response.mime_type.should == "text/plain"
        @response.status_message.should == "no error"
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
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.mime_type.should == "application/json"
        @response.headers['X-Request-Method'].should == "POST"
        @response.status_message.should == "no error"
      end
    end

    it "can post form url encoded body" do
      options = {
        body: "user=1"
      }
      Net.post("#{HTTP_SERVER}/form", options) do |response|
        @response = response
        Concurrency::Queue.main.async { resume }
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
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.mime_type.should == "application/json"
        @response.headers['X-Request-Method'].should == "PUT"
        @response.status_message.should == "no error"
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
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.mime_type.should == "application/json"
        @response.headers['X-Request-Method'].should == "PATCH"
        @response.status_message.should == "no error"
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
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.body['args']['test'].should == "1"
        @response.body['json']['user'].should == 1
        @response.status.should == 200
        @response.mime_type.should == "application/json"
        @response.headers['X-Request-Method'].should == "DELETE"
        @response.status_message.should == "no error"
      end
    end
  end

  describe ".head" do
    it "has a correct response" do
      Net.head(HTTP_SERVER) do |response|
        @response = response
        Concurrency::Queue.main.async { resume }
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
        Concurrency::Queue.main.async { resume }
      end

      wait do
        @response.headers['X-Request-Method'].should == "OPTIONS"
      end
    end
  end
end
