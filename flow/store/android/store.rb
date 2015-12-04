class Store
  def self.[](key)
    _storage.getString(key, nil)
  end

  def self.[]=(key, value)
    editor = _storage.edit
    editor.putString(key, value)
    editor.commit
  end

  def self.all
    _storage.getAll
  end

  def self.context=(context)
    @storage = context.getSharedPreferences('userdefaults', Android::Content::Context::MODE_PRIVATE)
  end

  def self._storage
    @storage or raise "Call `Store.context = self' in your main activity"
  end
end
