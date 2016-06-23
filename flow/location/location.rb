class Location
  attr_accessor :latitude, :longitude, :altitude, :time, :speed, :accuracy
  attr_accessor :name, :address, :locality, :postal_code, :sub_area, :area, :country

  def self.monitor_enabled?
    Location::Monitor.enabled?
  end

  def self.monitor(options={}, &block)
    options[:distance_filter] ||= 0
    Location::Monitor.new(options, block)
  end

  def self.geocode_enabled?
    Location::Geocoder.enabled?
  end

  def self.geocode(str, &block)
    Location::Geocoder.new(str, block)
  end

  def geocode(&block)
    Location::Geocoder.new(self, block)
  end
end
