describe Net::Response do
  before do
    @response = Net::Response.new({
      status_code: 200,
      status_message: :ok,
      mime_type: "application/json",
      body: ''
    })
  end

  it "has a status" do
    @response.status.should == 200
  end

  it "has a status_message" do
    @response.status_message.should == :ok
  end

  it "has a mime_type" do
    @response.mime_type.should == "application/json"
  end

  it "has a body" do
    @response.body.should == ""
  end
end
