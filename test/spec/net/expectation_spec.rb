describe "Net::Expectation" do
  before do
    @url = "www.example.com"
    @subject = Net::Expectation.new(@url)
  end

  after do
    Net::Expectation.clear
  end

  describe ".new" do
    it "sets url" do
      @subject.instance_variable_get(:@url).should == @url
    end
  end

  describe ".all" do
    context "when @expectations nil" do
      it "returns empty array" do
        Net::Expectation.all.should == []
      end
    end
  end

  describe ".clear" do
    it "clears all" do
      Net::Expectation.all << Net::Expectation.new('www')
      Net::Expectation.all.count.should == 1
      Net::Expectation.clear
      Net::Expectation.all.should == []
    end
  end

  describe "#and_return" do
    before do
      @response = Net::Response.new
    end

    it "sets response" do
      @subject.and_return(@response)
      @subject.response.should == @response
    end
  end

  describe "#matches?" do
    before do
      @request = Net::Request.new(@url)
    end

    it "should match identic string url" do
      @subject.matches?(@request).should == true
    end
  end

  describe "#response" do
    before do
      @response = Net::Response.new
      @subject.and_return(Net::Response.new)
    end

    it "marks the response as mocked" do
      @subject.response.mock.should == true
    end
  end
end
