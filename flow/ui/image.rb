module UI
  # @attr [String] source The name of the file of hte image to use
  # @attr resize_mode See {RESIZE_MODES RESIZE_MODES} for possible values
  class Image < View
    # @!parse
    #   # Posible values for the <code>resize_mode</code> atttribute.  Hash keys: :cover, :contain, :stretch
    #   RESIZE_MODES = {}
  end
end
