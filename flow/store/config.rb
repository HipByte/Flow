module Store
  module Config
    class << self
      attr_accessor :db_path
      def db_path
        @db_path || "store.sqlite"
      end
    end
  end
end
