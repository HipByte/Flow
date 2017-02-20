module UI
  class Image < UI::View
    attr_reader :source

    def self._drawable_from_source(source)
      if source.is_a?(Android::Graphics::Bitmap)
        drawable = Android::Graphics::Drawable::BitmapDrawable.new(UI.context.resources, source)
      else
        candidates = [source]
        if UI.density > 0
          base = source.sub(/\.png$/, '')
          (1...UI.density.to_i).each do |i|
            candidates.unshift base + "@#{i + 1}x.png"
          end
        end
  
        @asset_files ||= UI.context.assets.list('')
        idx = candidates.index { |x| @asset_files.include?(x) }
        raise "Couldn't find an asset file named `#{source}'" unless idx
  
        stream = UI.context.assets.open(candidates[idx])
        drawable = Android::Graphics::Drawable::Drawable.createFromStream(stream, nil)
  
        image_density = UI.density - idx
        if image_density != UI.density
          bitmap = drawable.bitmap
          scale = (UI.density / image_density)
          size_x = drawable.intrinsicWidth * scale
          size_y = drawable.intrinsicHeight * scale
          bitmap_resized = Android::Graphics::Bitmap.createScaledBitmap(bitmap, size_x, size_y, false)
          drawable = Android::Graphics::Drawable::BitmapDrawable.new(UI.context.resources, bitmap_resized)
        end
      end
      drawable
    end

    def source=(source)
      if @source != source
        @source = source
        drawable = self.class._drawable_from_source(source)
        proxy.imageDrawable = drawable
        if width.nan? and height.nan?
          self.width = drawable.intrinsicWidth
          self.height = drawable.intrinsicHeight
        end
      end
    end

    def filter=(color)
      proxy.setColorFilter(UI::Color(color).proxy, Android::Graphics::PorterDuff::Mode::MULTIPLY)
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
