describe "Net" do
  before do
    @response = nil
  end

  it "can GET a JSON endpoint" do
    Net.get('http://pokeapi.co/api/v1/pokemon/1') do |response|
      @response = response
      resume
    end
    wait_max(4) do
      @response.body['abilities'][0]['name'].should == "chlorophyll"
    end
  end
end
