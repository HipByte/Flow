module Store
  class Store < AbstractStore
    def initialize(db_path)
      @db_path = db_path
    end

    def set(key, value)
    end
    alias_method :[]=, :set

    def get(key)
    end
    alias_method :[], :get

    def delete(key)
    end

    def path
      @db_path
    end
  end
end
