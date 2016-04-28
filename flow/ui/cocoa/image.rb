module UI
  class Image < View
    attr_reader :source

    def source=(source)
      if @source != source
        @source = source

        case source
          when String
            proxy.image = UIImage.imageNamed(source)
          when NSData
            proxy.image = UIImage.imageWithData(source)
          else
            raise "Expected `String` or `NSdata` object, got `#{source.class}`"
          end

        if width.nan? and height.nan?
          self.width = proxy.image.size.width
          self.height = proxy.image.size.height
        end
      end
    end

    RESIZE_MODES = {
      cover: UIViewContentModeScaleToFill,
      contain: UIViewContentModeScaleAspectFit,
      stretch: UIViewContentModeScaleAspectFill
    }

    def resize_mode=(resize_mode)
      proxy.contentMode = RESIZE_MODES.fetch(resize_mode.to_sym) do
        raise "Incorrect value, expected one of: #{RESIZE_MODES.keys.join(',')}"
      end
    end

    def resize_mode
      RESIZE_MODES.key(proxy.contentMode)
    end

    def proxy
      @proxy ||= begin
        ui_image_view = UIImageView.alloc.init
        ui_image_view.translatesAutoresizingMaskIntoConstraints = false
        ui_image_view
      end
    end
  end
end
