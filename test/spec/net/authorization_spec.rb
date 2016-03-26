describe Net::Authorization do
  context "Invalid params" do
    it "expects valid token or basic params" do
      Proc.new { Net::Authorization.new }.should.raise? RuntimeError
    end
  end

  context "Basic authorization" do
    before do
      @subject = Net::Authorization.new(username: "foo", password: "bar")
    end

    it ".to_s" do
      @subject.to_s.should == "Basic Zm9vOmJhcg=="
    end

    it ".username" do
      @subject.username.should == "foo"
    end

    it ".password" do
      @subject.password.should == "bar"
    end

    it ".basic?" do
      @subject.basic?.should == true
    end

    it ".token?" do
      @subject.token?.should == false
    end
  end

  context "Token authorization" do
    before do
      @subject = Net::Authorization.new(token: "xxxx")
    end

    it ".to_s" do
      @subject.to_s.should == "Token token=\"xxxx\""
    end

    it ".basic?" do
      @subject.basic?.should == false
    end

    it ".token" do
      @subject.token.should == "xxxx"
    end

    it ".token?" do
      @subject.token?.should == true
    end
  end
end
