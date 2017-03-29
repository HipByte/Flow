module Net
  def self.setup_cookies
    @setup_cookies ||= begin
      Java::Net::CookieHandler.setDefault(Java::Net::CookieManager.new)
      true
    end
  end
end
