module UI
  TEXT_ALIGNMENT = {
    left:     NSTextAlignmentLeft,
    center:   NSTextAlignmentCenter,
    right:    NSTextAlignmentRight,
    justify:  NSTextAlignmentJustified
  }

  def self.resource_str(name)
    if md = name.match(/(.*)\.(.*)$/)
      if path = NSBundle.mainBundle.pathForResource(md[1], ofType:md[2])
        File.read(path)
      end
    end
  end
end
