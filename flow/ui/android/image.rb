module UI
  class Image < UI::View
    attr_reader :source

    def self._drawable_and_density_from_source(source)
      candidates = [source]
      if UI.density > 0
        base = source.sub(/\.png$/, '')
        (1...UI.density.to_i).each do |i|
          candidates.unshift base + "@#{i + 1}x.png"
        end
      end

      @asset_files ||= UI.context.assets.list('')
      image_density = candidates.index { |x| @asset_files.include?(x) }
      raise "Couldn't find an asset file named `#{source}'" unless image_density

      stream = UI.context.assets.open(candidates[image_density])
      drawable = Android::Graphics::Drawable::Drawable.createFromStream(stream, nil)
      [drawable, image_density + 1]
    end

    def self._drawable_from_source(source)
      _drawable_and_density_from_source(source)[0]
    end

    def source=(source)
      if @source != source
        @source = source
        drawable, image_density = self.class._drawable_and_density_from_source(source)
        proxy.imageDrawable = drawable
        if width.nan? and height.nan?
          self.width = drawable.intrinsicWidth * (UI.density / image_density)
          self.height = drawable.intrinsicHeight * (UI.density / image_density)
        end
      end
    end

    RESIZE_MODES = {
      cover: Android::Widget::ImageView::ScaleType::CENTER_CROP,
      contain: Android::Widget::ImageView::ScaleType::CENTER_INSIDE,
      stretch: Android::Widget::ImageView::ScaleType::FIT_XY
    }

    def resize_mode=(resize_mode)
      proxy.scaleType = RESIZE_MODES.fetch(resize_mode.to_sym) do
        raise "Incorrect value, expected one of: #{RESIZE_MODES.keys.join(',')}"
      end
    end

    def resize_mode
      RESIZE_MODES.key(proxy.scaleType)
    end

    def proxy
      @proxy ||= Android::Widget::ImageView.new(UI.context)
    end
  end
end
