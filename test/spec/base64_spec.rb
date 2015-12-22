describe Base64 do
  context "#decode" do
    before do
      @subject = Base64.decode("eHg=")
    end

    it "returns a base64 encoded string" do
      @subject.should == "xx"
    end
  end

  context "#encode" do
    before do
      @subject = Base64.encode("xx")
    end

    it "returns a base64 encoded string" do
      @subject.should == "eHg="
    end
  end
end
