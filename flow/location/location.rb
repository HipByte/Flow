# @attr [Float] latitude Populated by the location monitoring service
# @attr [Float] latitude Populated by the location monitoring service
# @attr [Float] longitude Populated by the location monitoring service
# @attr [Float] altitude Populated by the location monitoring service
# @attr [Time]  time Populated by the location monitoring service
# @attr [Float] speed Populated by the location monitoring service
# @attr [Float] accuracy Populated by the location monitoring service
#
# @attr [String] name Populated after reverse geocoding a string
# @attr [String] address Populated after reverse geocoding a string
# @attr [String] localiton Populated after reverse geocoding a string
# @attr [String] postal_code Populated after reverse geocoding a string
# @attr [String] sub_area Populated after reverse geocoding a string
# @attr [String] area Populated after reverse geocoding a string
# @attr [String] country Populated after reverse geocoding a string
class Location

  attr_accessor :latitude, :longitude, :altitude, :time, :speed, :accuracy
  attr_accessor :name, :address, :locality, :postal_code, :sub_area, :area, :country

  # Checks if the location service is accessible
  # @example
  #   Location.monitor_enabled? # => true or false
  def self.monitor_enabled?
    Location::Monitor.enabled?
  end

  # Starts monitoring for location updates.
  #
  # @param [Hash] options
  # @option options [Fixnum] :distance_filter The distance in meters from the
  #   previous location that should trigger a monitor update.
  #
  # @return [Monitor]
  #
  # @example
  #   monitor = Location.monitor do |location, err|
  #     if location
  #       puts location.latitude, location.longitude
  #     else
  #       puts err
  #     end
  #   end
  def self.monitor(options={}, &block)
    options[:distance_filter] ||= 0
    Location::Monitor.new(options, block)
  end

  # Checks if the geocoder service is accessible
  # @return [Boolean]
  def self.geocode_enabled?
    Location::Geocoder.enabled?
  end

  # Reverse geocode a string
  # @example
  #   Location.geocode('apple inc') do |location, err|
  #     if location
  #       puts location.address
  #     else
  #       puts err
  #     end
  #   end
  def self.geocode(str, &block)
    Location::Geocoder.new(str, block)
  end

  def geocode(&block)
    Location::Geocoder.new(self, block)
  end
end
