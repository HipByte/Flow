module Store
  class AbstractStore
    def set(key, value)
      fail
    end

    def get(key)
      fail
    end

    def delete(key)
      fail
    end

    def path
      fail
    end
  end
end
