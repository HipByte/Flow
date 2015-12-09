class Store
  DoesNotExist = '<____does_not_exist____>'
  def self.[](key)
    val = _storage.getString(key.to_s, DoesNotExist)
    val == DoesNotExist ? nil : JSON.load(val)
  end

  def self.[]=(key, value)
    editor = _storage.edit
    editor.putString(key.to_s, value.to_json)
    editor.commit
  end

  def self.delete(key)
    editor = _storage.edit
    editor.remove(key.to_s)
    editor.commit
  end

  def self.all
    all = {}
    _storage.getAll.each { |key, value| all[key] = JSON.load(value) }
    all
  end

  def self.context=(context)
    @storage = context.getSharedPreferences('userdefaults', Android::Content::Context::MODE_PRIVATE)
  end

  def self._storage
    @storage or raise "Call `Store.context = self' in your main activity"
  end
end
