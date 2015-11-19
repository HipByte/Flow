module Store
  class Store < AbstractStore
    def initialize(db_path)
      @db_path = db_path
    end

    def set(key, value)
    end

    def get(key)
    end

    def delete(key)
    end

    def path
      @db_path
    end
  end
end
