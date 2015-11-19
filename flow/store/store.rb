module Store
  def self.set(key, value)
    store = Store.new(Config.db_path)
    store.set(key, value)
  end

  def self.get(key)
    store = Store.new(Config.db_path)
    store.get(key)
  end

  def self.delete(key)
    store = Store.new(Config.db_path)
    store.delete(key)
  end
end
