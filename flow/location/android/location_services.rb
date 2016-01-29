class MonitorDelegate
  def initialize(callback)
    @callback = callback
  end

  def onLocationChanged(location)
    @callback.call(Location._from_jlocation(location), nil)
  end

  def onProviderDisabled(provider)
  end

  def onProviderEnabled(provider)
  end

  def onStatusChanged(provider, status, extra)
  end
end

class Location
  def self._from_jlocation(jlocation)
    obj = Location.new
    obj.latitude = jlocation.latitude
    obj.longitude = jlocation.longitude
    obj.altitude = jlocation.altitude
    obj.time = Time.new(jlocation.time)
    obj.speed = jlocation.speed
    obj.accuracy = jlocation.accuracy
    obj
  end

  def self.context=(context)
    @context = context
    @location_service = context.getSystemService(Android::Content::Context::LOCATION_SERVICE)
  end

  def self._context
    @context
  end

  def self._location_service
    @location_service or raise "Call `Location.context = self' in your main activity"
  end

  class Monitor
    def self.enabled?
      Location._location_service.isProviderEnabled('gps')
    end

    def initialize(options, callback)
      @options = options
      @delegate = MonitorDelegate.new(callback)
      start
    end

    def start
      Location._location_service.requestLocationUpdates('gps', 1000, @options[:distance_filter], @delegate)
    end

    def stop
      Location._location_service.removeUpdates(@delegate)
    end
  end

  class Geocoder
    def self.enabled?
      Android::Location::Geocoder.isPresent
    end

    def initialize(obj, block)
      geocoder = Android::Location::Geocoder.new(Location._context)
      addresses =
        if location_given = obj.is_a?(Location)
          geocoder.getFromLocation(obj.latitude, obj.longitude, 1)
        else
          geocoder.getFromLocationName(obj.to_s, 1)
        end
      if addresses and !addresses.empty?
        address = addresses.first
        unless location_given
          obj = Location.new
          obj.latitude = address.latitude
          obj.longitude = address.longitude
        end
        obj.name = address.featureName
        obj.address = begin
          str = ''
          i = 0
          count = address.getMaxAddressLineIndex
          while i < count
            str << address.getAddressLine(i) + "\n"
            i += 1
          end
          str
        end
        obj.locality = address.locality
        obj.postal_code = address.postalCode
        obj.sub_area = address.subAdminArea
        obj.area = address.adminArea
        obj.country = address.countryCode
        block.call(obj, nil)
      end
    end
  end
end
