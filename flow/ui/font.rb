module UI
  def self.Font(font)
    case font
      when UI::Color
        self
      when Hash
        name = (font[:name] or raise ":name expected")
        size = (font[:size] or raise ":size expected")
        trait = (font[:trait] or :normal)
        UI::Font.new(name, size, trait)
      when Array
        case font.size
          when 2
          when 3
          else
            raise "Expected Array of 2 or 3 elements"
        end
        UI::Font.new(*font)
      else
        raise "Expected UI::Font or Array"
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
