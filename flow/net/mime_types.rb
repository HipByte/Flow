module Net
  module MimeTypes
    JSON = %w(
      application/json
      application/vnd.api+json
    )

    def self.json
      JSON
    end
  end
end
