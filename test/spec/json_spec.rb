describe "JSON" do
  it "can serialize empty arrays" do
    txt = [].to_json
    txt.should == '[]'
    JSON.load(txt).should == []
  end

  it "can serialize complex arrays" do
    ary = [1, 'two', {'three' => 3}, true, false, [5, 6.0, [7.1, 8]], 9, 10]
    txt = ary.to_json
    txt.class.should == String

    ary2 = JSON.load(txt)
    ary2.class.should == Array
    ary2.should == ary
  end

  it "can serialize empty hashes" do
    txt = {}.to_json
    txt.should == '{}'
    JSON.load(txt).should == {}
  end

  it "can serialize complex hashes" do
    hash = {
      'one' => 1,
      'two' => 2,
      'three' => { 'three' => 3 },
      'four' => true,
      'five' => false,
      'six' => 6.0,
      'seven' => [7.0, 7.1, 7.2],
      'eight' => [8, 8, 8, [8, [8, 8, 8]], 8, 8]
    }
    txt = hash.to_json
    txt.class.should == String

    hash2 = JSON.load(txt)
    hash2.class.should == Hash
    hash2.should == hash
  end
end
