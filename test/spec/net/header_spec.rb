describe "Net::Header" do
  it "has a a field and a value" do
    header = Net::Header.new('Content-Type', 'application/json')
    header.field.should == 'Content-Type'
    header.value.should == 'application/json'
  end

  it "rewrites shorthands" do
    header = Net::Header.new(:content_type, :json)
    header.field.should == 'Content-Type'
    header.value.should == 'application/json'
  end
end
