describe UI::Color do
  context "#() protocol conversion" do
    it "should convert a String with a #" do
      UI::Color("#00F").to_a.should == [0, 0, 255, 255]
    end

    it "should convert a String without a #" do
      UI::Color("00F").to_a.should == [0, 0, 255, 255]
    end

    it "should convert a String without 6 digits" do
      UI::Color("FF8A19").to_a.should == [255, 137, 24, 255]
    end

    it "should convert a String without 8 digits (alpha component)" do
      UI::Color("88FF8A19").to_a.should == [255, 137, 24, 135]
    end

    it "should convert a 3 values Array to rgba with default alpha = 255" do
      UI::Color([0, 0, 1]).to_a.should == [0, 0, 1, 255]
    end

    it "should convert a 4 values Array" do
      UI::Color([0, 0, 1, 255]).to_a.should == [0, 0, 1, 255]
    end

    it "should convert native platform Color object" do
      if defined?(UIColor)
        UI::Color(UIColor.blueColor).to_a.should == [0, 0, 255, 255]
      else
        UI::Color(Android::Graphics::Color.argb(255, 0, 0, 255)).to_a.should == [0, 0, 255, 255]
      end
    end

    it "should convert a Symbol" do
      UI::Color(:blue).to_a.should == [0, 0, 255, 255]
    end
  end
end
