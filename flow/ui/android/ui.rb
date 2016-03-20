module UI
  def self.context
    @context or raise "Context missing"
  end

  def self.context=(context)
    @context = context
  end

  def self.density
    @density ||= UI.context.resources.displayMetrics.density
  end
end
