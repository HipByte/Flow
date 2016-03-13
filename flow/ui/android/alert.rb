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
      container.setTitle(title)
    end

    def message=(message)
      container.setMessage(message)
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
      container.setButton(button_type, title, @listener)
    end

    def show(&block)
      @complete_block = (block or raise "expected block")
      container.show
    end

    def _clicked(type)
      @complete_block.call(type)
      @listener = nil
    end

    def container
      @container ||= Android::App::AlertDialog.new(UI.context)
    end
  end
end
