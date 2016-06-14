module UI
  # @param [Hash] font
  # @option font [String] name
  # @option font [Fixnum] size
  # @option font [Symbol] trait :normal, :bold, :italic, :bold_italic
  # @return [Font]
  def self.Font(font)
    case font
      when UI::Font
        self
      when Hash
        name = (font[:name] or raise ":name expected")
        size = (font[:size] or raise ":size expected")
        trait = (font[:trait] or :normal)
        UI::Font.new(name, size, trait)
      when Array
        raise "Expected Array of 2 or 3 elements" if font.size < 2 or font.size > 3
        UI::Font.new(*font)
      else
        raise "Expected UI::Font or Hash or Array"
    end
  end

  class Font
    attr_reader :proxy

    # @!method initialize(obj, size, trait=nil)
    # @param [String] name
    # @param [Fixnum] size
    # @param [Symbol] trait :normal, :bold, :italic, :bold_italic

    # Returns wether the font is italic
    # @return [Boolean]
    def italic?
      trait == :italic or trait == :bold_italic
    end

    # Returns wether the font is bold
    # @return [Boolean]
    def bold?
      trait == :bold or trait == :bold_italic
    end
  end
end
