module UI
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
    attr_reader :container

    def italic?
      trait == :italic or trait == :bold_italic
    end

    def bold?
      trait == :bold or trait == :bold_italic
    end
  end
end
