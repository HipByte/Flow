module UI
  def self.alert(opt={}, &block)
    alert = UI::Alert.new
    alert.title = (opt[:title] or raise ":title needed")
    alert.message = (opt[:message] or raise ":message needed")

    buttons = [:cancel, :default]
    has_button = false
    buttons.each do |button|
      if title = opt[button]
        alert.set_button(title, button)
        has_button = true
      end
    end
    alert.set_button('Cancel', :cancel) unless has_button

    alert.show(&block)
    @last_alert = alert # Keep a strong reference to the alert object has it has to remain alive.
  end
end
