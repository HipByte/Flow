module Store
  class Store < AbstractStore
    def initialize(db_path)
      @db_path = db_path
      # open_connection using adapter
    end

    def set(key, value)
      # set key using adapter and serializer
    end

    def get(key)
      # get key using adapter and deserializer
    end

    def delete(key)
      # delete key using adapter
    end

    def path
      @db_path
    end
  end
end
