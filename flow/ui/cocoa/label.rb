module UI
  class Label < View
    include UI::SharedText

    def initialize
      super
      calculate_measure(true)
    end

    def height=(val)
      super
      calculate_measure(false)
    end

    def measure(width, height)
      #https://developer.apple.com/reference/foundation/nsattributedstring/1524971-draw
      at = proxy.attributedText
      return [0, 0] if at == nil or at.length == 0
      size = [width.nan? ? Float::MAX : width, Float::MAX]
      rect = at.boundingRectWithSize(size, options:NSStringDrawingUsesLineFragmentOrigin, context:nil)
      [width, rect.size.height.ceil]
    end

    def proxy
      @proxy ||= begin
        label = UILabel.alloc.init
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakByWordWrapping
        label.numberOfLines = 0
        label
      end
    end
  end
end
