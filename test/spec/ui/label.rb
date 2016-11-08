describe UI::Label do
  describe "#measure" do
    context "when text is nil" do
      it "returns [0, 0]" do
        label = UI::Label.new
        label.text = nil
        w = h = 500.0
        label.measure(w,h).should == [0,0]
      end
    end

    context "when text is empty" do
      it "returns [0, 0]" do
        label = UI::Label.new
        label.text = ""
        w = h = 500.0
        label.measure(w,h).should == [0,0]
      end
    end

    context "when text is not empty" do
      it "returns the correct size" do
        label = UI::Label.new
        label.text = "Hello World"
        w = h = 500.0
        label.measure(w,h).should == [w, 20.287109375]
      end
    end
  end
end
