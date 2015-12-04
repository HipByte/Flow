class Store
  def self.[](key)
    _storage.objectForKey(key)
  end

  def self.[]=(key, value)
    _storage.setObject(value, forKey:key)
  end

  def self.all
    _storage.dictionaryRepresentation
  end

  def self._storage
    NSUserDefaults.standardUserDefaults
  end
end
