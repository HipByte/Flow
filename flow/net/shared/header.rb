module Net
  class Header
    SHORTHANDS = {
      content_type: 'Content-Type',
      accept: 'Accept',
      json: 'application/json'
    }

    attr_reader :field, :value

    def initialize(field, value)
      @field = SHORTHANDS.fetch(field, field)
      @value = SHORTHANDS.fetch(value, value)
    end
  end
end
