module UI
  class Font
    def self._wrap(font, size)
      new(font, size, nil)
    end

    def initialize(obj, size, trait=nil)
      if obj.is_a?(Android::Graphics::Typeface)
        @container = obj
      else
        style = case trait
          when :bold
            Android::Graphics::Typeface::BOLD
          when :italic
            Android::Graphics::Typeface::ITALIC
          when :bold_italic
            Android::Graphics::Typeface::BOLD_ITALIC
          else
            Android::Graphics::Typeface::NORMAL
        end
        @container = Android::Graphics::Typeface.create(obj, style)
      end
      @size = size
    end

    def name
      nil # TODO
    end

    def size
      @size
    end

    def trait
      @trait ||= begin
        case container.getStyle
          when Android::Graphics::Typeface::BOLD
            :bold
          when Android::Graphics::Typeface::ITALIC
            :italic
          when Android::Graphics::Typeface::BOLD_ITALIC
            :bold_italic
          else
            :normal
        end
      end
    end
  end
end
