module UI
  class Image < View
    attr_accessor :source

    def source=(source)
      @source = source
      container.image = UIImage.imageNamed(source)
    end

    def container
      @container ||=begin
        ui_image_view = UIImageView.alloc.init
        ui_image_view.translatesAutoresizingMaskIntoConstraints = false
        ui_image_view
      end
    end
  end
end
