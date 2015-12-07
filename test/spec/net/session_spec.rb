describe Net::Session do
  before do
    @subject = Net::Session.build("www.example.com") do
      header(:content_type, :json)
      authorize(token: "xxxx")
    end
  end

  it ".headers" do
    @subject.headers.should == {"Content-Type" => "application/json"}
  end

  it ".authorization" do
    @subject.authorization.should.is_a? Net::Authorization
  end
end
