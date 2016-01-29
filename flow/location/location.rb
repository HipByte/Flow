class Location
  # Attributes set by the monitor service.
  attr_accessor :latitude, :longitude, :altitude, :time, :speed, :accuracy

  # Attributes set by the geocoder service.
  attr_accessor :name, :address, :locality, :postal_code, :sub_area, :area, :country

  def self.monitor_enabled?
    Location::Monitor.enabled?
  end

  def self.monitor(options, &block)
    Location::Monitor.new(options, block)
  end

  def self.geocode(str, &block)
    Location::Geocoder.new(str, block)
  end

  def geocode(&block)
    Location::Geocoder.new(self, block)
  end
end
