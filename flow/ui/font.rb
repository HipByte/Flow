module UI
  def self.Font(font)
    case font
      when UI::Color
        self
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
  end
end
