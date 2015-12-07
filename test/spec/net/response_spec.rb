describe Net::Response do
  before do
    @subject = Net::Response.new({
      status_code: 200,
      status_message: :ok,
      mime_type: "application/json",
      body: ''
    })
  end

  it ".status" do
    @subject.status.should == 200
  end

  it ".status_message" do
    @subject.status_message.should == :ok
  end

  it ".mime_type" do
    @subject.mime_type.should == "application/json"
  end

  it ".body" do
    @subject.body.should == ""
  end
end
