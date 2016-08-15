describe UI::View do
  context "#hidden=(hidden)" do
    it "should set size to [0, 0]" do
      view = UI::View.new
      view.width = 100
      view.height = 100
      view.hidden = true
      view.width.should == 0
      view.height.should == 0
    end

    it "should restore previous size" do
      view = UI::View.new
      view.width = 100
      view.height = 100
      view.hidden = true
      view.hidden = false
      view.width.should == 100
      view.height.should == 100
    end
  end
end
