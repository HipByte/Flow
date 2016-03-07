module UI
  class Font
    def self._wrap(font)
      new(font, nil, nil)
    end

    def initialize(obj, size, trait=nil)
      if obj.is_a?(UIFont)
        @container = obj
      else
        desc = UIFontDescriptor.fontDescriptorWithFontAttributes UIFontDescriptorNameAttribute => obj
        case trait
          when :bold
            desc = desc.fontDescriptorWithSymbolicTraits UIFontDescriptorTraitBold
          when :italic
            desc = desc.fontDescriptorWithSymbolicTraits UIFontDescriptorTraitItalic
          when :bold_italic
            desc = desc.fontDescriptorWithSymbolicTraits UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic
        end
        @container = UIFont.fontWithDescriptor(desc, size:size)
      end
    end

    def name
      @container.fontName
    end

    def size
      @container.pointSize
    end

    def trait
      @trait ||= begin
        traits =  @container.fontDescriptor.symbolicTraits
        if (traits & UIFontDescriptorTraitItalic) != 0
          if (traits & UIFontDescriptorTraitBold) != 0
            :bold_italic
          else
            :italic
          end
        elsif (traits & UIFontDescriptorTraitBold) != 0
          :bold
        else
          :normal
        end
      end
    end
  end
end
