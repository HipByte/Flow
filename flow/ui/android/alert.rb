class FlowUIAlertClickListener
  def initialize(alert)
    @alert = alert
  end

  def onClick(alert_dialog, button_type)
    type = case button_type
      when Android::App::AlertDialog::BUTTON_NEGATIVE
        :cancel
      else
        :default
    end
    @alert._clicked(type)
  end
end

module UI
  class Alert
    def title=(title)
      proxy.setTitle(title)
    end

    def message=(message)
      proxy.setMessage(message)
    end

    def set_button(title, type)
      button_type = case type
        when :cancel
          Android::App::AlertDialog::BUTTON_NEGATIVE
        when :default
          Android::App::AlertDialog::BUTTON_NEUTRAL
        else
           raise "expected :cancel or :default"
      end
      @listener ||= FlowUIAlertClickListener.new(self)
      proxy.setButton(button_type, title, @listener)
    end

    def show(&block)
      @complete_block = (block or raise "expected block")
      proxy.show
    end

    def _clicked(type)
      @complete_block.call(type)
      @listener = nil
    end

    def proxy
      @proxy ||= Android::App::AlertDialog.new(UI.context)
    end
  end
end
