digests = [
  [Digest::MD5, '5eb63bbbe01eeed093cb22bb8f5acdc3'],
  [Digest::SHA1, '2aae6c35c94fcfb415dbe95f408b9ce91ee846ed'],
  [Digest::SHA224, '2f05477fc24bb4faefd86517156dafdecec45b8ad3cf2522a563582b'],
  [Digest::SHA256, 'b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9'],
  [Digest::SHA384, 'fdbd8e75a67f29f701a4e040385e2e23986303ea10239211af907fcbb83578b3e417cb71ce646efd0819dd8c088de1bd'],
  [Digest::SHA512, '309ecc489c12d6eb4cc40f50c902f2b4d0ed77ee511a7c7a9bcd3ca86d4cd86f989dd35bc5ff499670da34255b45b0cfd830e81f605dcf7dc5542e93ae9cd76f']
]

digests.each do |klass, hello_world_md|
  describe "#{klass}" do
    it "can digest strings directly using .digest" do
      klass.digest('hello world').should == hello_world_md
    end

    it "can be instantiated using .new" do
      digest = klass.new
      digest.class.should == klass
    end

    it "can digest strings sequentially using #update and #digest" do
      digest = klass.new
      digest.update('hello')
      digest.update(' ')
      digest.update('world')
      digest.digest.should == hello_world_md
    end

    it "can be reset using #reset" do
      digest = klass.new
      digest.update('iaudnaidunfaisdfnasfjweawer')
      digest.reset
      digest.update('hello world')
      digest.digest.should == hello_world_md
    end
  end
end
