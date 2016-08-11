module UI
  class Font
    def self._wrap(font, size)
      new(font, size, nil)
    end

    BuiltinFonts = {
      'ComingSoon' => 'casual',
      'DancingScript-Regular' => 'cursive',
      'DroidSansMono' => 'monospace',
      'Roboto-Regular' => 'sans-serif',
      'Roboto-Black' => 'sans-serif-black',
      'RobotoCondensed-Regular' => 'sans-serif-condensed',
      'RobotoCondensed-Light' => 'sans-serif-condensed-light',
      'Roboto-Light' => 'sans-serif-light',
      'Roboto-Medium' => 'sans-serif-medium',
      'CarroisGothicSC-Regular' => 'sans-serif-smallcaps',
      'Roboto-Thin' => 'sans-serif-thin',
      'NotoSerif-Regular' => 'serif',
      'CutiveMono' => 'serif-monospace'
    }

    def initialize(obj, size, trait=nil, extension=:ttf)
      if obj.is_a?(Android::Graphics::Typeface)
        @proxy = obj
      else
        family_name = BuiltinFonts[obj]
        if family_name
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
          @proxy = Android::Graphics::Typeface.create(family_name, style)
        else
          @proxy = Android::Graphics::Typeface.createFromAsset(UI.context.getAssets, obj + "." + extension.to_s)
        end
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
        case proxy.getStyle
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
