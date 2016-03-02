module UI
  class Image < View
    attr_reader :source

    RESIZE_MODES = {
      scale_to_fill:  UIViewContentModeScaleToFill,
      aspect_fit:     UIViewContentModeScaleAspectFit,
      aspect_fill:    UIViewContentModeScaleAspectFill
    }

    def resize_mode=(resize_mode)
      container.contentMode = RESIZE_MODES.fetch(resize_mode.to_sym) do
        raise "Incorrect value, expected one of: #{RESIZE_MODES.keys.join(',')}"
      end
    end

    def resize_mode
      RESIZE_MODES.key(container.contentMode)
    end

    def source=(source)
      if @source != source
        @source = source
        container.image = UIImage.imageNamed(source)
      end
    end

    def container
      @container ||= begin
        ui_image_view = UIImageView.alloc.init
        ui_image_view.translatesAutoresizingMaskIntoConstraints = false
        ui_image_view
      end
    end
  end
end
