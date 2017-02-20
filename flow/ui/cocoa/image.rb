module UI
  class Image < View
    attr_reader :source

    def source=(source)
      if @source != source
        @source = source

        image = case source
          when String
            UIImage.imageNamed(source)
          when NSData
            UIImage.imageWithData(source)
          else
            raise "Expected `String' or `NSData' object, got `#{source.class}'"
        end
        @original_image = proxy.image = image

        if width.nan? and height.nan?
          self.width = proxy.image.size.width
          self.height = proxy.image.size.height
        end
      end
    end

    def filter=(color)
      image = @original_image
      raise "source= must be set" unless image

      begin
        size = image.size
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
    
        context = UIGraphicsGetCurrentContext()
        area = CGRectMake(0, 0, size.width, size.height)
    
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -area.size.height)
    
        CGContextSaveGState(context)
        CGContextClipToMask(context, area, image.CGImage)
    
        UI::Color(color).proxy.set
        CGContextFillRect(context, area)
    
        CGContextRestoreGState(context)
    
        CGContextSetBlendMode(context, KCGBlendModeMultiply)
    
        CGContextDrawImage(context, area, image.CGImage)
    
        filter_image = UIGraphicsGetImageFromCurrentImageContext()
        proxy.image = filter_image
      ensure 
        UIGraphicsEndImageContext()
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
