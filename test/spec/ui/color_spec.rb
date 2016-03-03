describe UI::Color do
  context "#() protocol conversion" do
    before do
      @blue_color = UIColor.blueColor
      @blue_alpha_color = UIColor.colorWithRed(0/255.0, green:0/255.0, blue:1/255.0, alpha:1.0)

      r, g, b, a = [1, (0x8A.to_f/0xFF.to_f), (0x19/0xFF.to_f), (0x88.to_f/0xFF.to_f)]
      @orange_color = UIColor.colorWithRed(r, green:g, blue:b, alpha:1.0)
      @orange_alpha_color = UIColor.colorWithRed(r, green:g, blue:b, alpha:a)
    end

    it "should convert a String with a #" do
      UI::Color("#00F").container.should == @blue_color
    end

    it "should convert a String without a #" do
      UI::Color("00F").container.should == @blue_color
    end

    it "should convert a String without 3 digits" do
      UI::Color("00F").container.should == @blue_color
    end

    it "should convert a String without 6 digits" do
      UI::Color("FF8A19").container.should == @orange_color
    end

    it "should convert a String without 8 digits (alpha component)" do
      UI::Color("88FF8A19").container.should == @orange_alpha_color
    end

    it "should convert a 3 values Array to rgba with default alpha = 255" do
      UI::Color([0, 0, 1]).container.should == @blue_alpha_color
    end

    it "should convert a 4 values Array" do
      UI::Color([0, 0, 1, 255]).container.should == @blue_alpha_color
    end

    it "should convert a UIColor" do
      UI::Color(UIColor.blueColor).container.should == @blue_color
    end

    it "should convert a Symbol" do
      UI::Color(:blue).container.should == UIColor.blueColor
    end
  end
end
