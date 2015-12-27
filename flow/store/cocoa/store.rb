class Store
  def self.[](key)
    _storage.objectForKey(key.to_s)
  end

  def self.[]=(key, value)
    _storage.setObject(value, forKey:key.to_s)
  end

  def self.delete(key)
    _storage.removeObjectForKey(key.to_s)
  end

  def self.all
    _storage.dictionaryRepresentation
  end

  def self._storage
    NSUserDefaults.standardUserDefaults
  end
end
