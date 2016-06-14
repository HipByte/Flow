class Store
  # Returns the value of a key
  # @example
  #   Store['foo']
  #   #=> 42
  # @!method self.[](key)

  # Sets a value for a key
  # @example
  #   Store['foo'] = 42
  # @!method self.[]=(key, value)

  # Deletes a key from storage.
  # @example
  #   Store.delete('foo')
  # @!method self.delete(key)

  # Returns a hash containing all the keys and values
  # @return [Hash]
  # @example
  #   Store.all
  #   #=> { 'foo' => 42 }
  # @!method self.all
end
