class Model
  # All models have an id
  attr_accessor :id

  def initialize(attrs = {})
    set(attrs)
    self
  end

  def set(attrs, opts = {})
    return unless attrs.is_a?(Hash)
    attrs.each do |key,value|
      method = "#{key}="
      if respond_to?(method)
        send(method, value)
      end
    end
    self
  end

  def build_or_update_object(original, klass, obj)
    if obj.is_a?(klass)
      obj
    else
      # Assume we're dealing with a hash
      if original.is_a?(klass)
        original.set(obj)
      else
        klass.new(obj)
      end
    end
  end

  class << self
    def attribute_names
      @_attribute_names ||= ['id']
    end

    # By maintaining a list of attributes, we can make sure that only attributes we
    # know about are set when we receive data from outside.
    def attributes(*args)
      args.each do |arg|
        attribute_names << arg.to_s
        attr_accessor arg
      end
    end
  end
end
