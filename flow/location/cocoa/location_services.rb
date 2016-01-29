class Location
  attr_accessor :_cllocation
  def self._from_cllocation(cllocation)
    obj = Location.new
    obj._cllocation = cllocation
    obj.latitude = cllocation.coordinate.latitude
    obj.longitude = cllocation.coordinate.longitude
    obj.altitude = cllocation.altitude
    obj.time = cllocation.timestamp
    obj.speed = cllocation.speed
    obj.accuracy = cllocation.horizontalAccuracy
    obj
  end

  class Monitor
    def self.enabled?
      CLLocationManager.locationServicesEnabled and CLLocationManager.authorizationStatus == KCLAuthorizationStatusAuthorized
    end

    def initialize(options, callback)
      @callback = callback
      @location_manager = CLLocationManager.new
      @location_manager.desiredAccuracy = KCLLocationAccuracyBest
      @location_manager.delegate = self
      @location_manager.requestAlwaysAuthorization
      start
    end

    def start
      @location_manager.startUpdatingLocation
    end

    def stop
      @location_manager.stopUpdatingLocation
    end

    def locationManager(manager, didUpdateLocations:locations)
      unless locations.empty?
        @callback.call(Location._from_cllocation(locations.last), nil)
      end
    end

    def locationManager(manager, didFailWithError:error)
      @callback.call(nil, error.localizedDescription)
    end
  end

  class Geocoder
    def initialize(obj, block)
      @callback = block
      @geocoder = CLGeocoder.new
      if obj.is_a?(Location)
        @geocoder.reverseGeocodeLocation(obj._cllocation, completionHandler:lambda do |placemarks, error|
          _handle(obj, placemarks, error)
        end)
      else
        @geocoder.geocodeAddressString(obj.to_s, completionHandler:lambda do |placemarks, error|
          _handle(nil, placemarks, error)
        end)
      end
    end

    def _handle(location, placemarks, error)
      if placemarks
        placemark = placemarks.last
        location ||= Location._from_cllocation(placemark.location)
        location.name = placemark.name
        location.address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, true)
        location.locality = placemark.locality
        location.postal_code = placemark.postalCode
        location.sub_area = placemark.subAdministrativeArea
        location.area = placemark.administrativeArea
        location.country = placemark.ISOcountryCode
        @callback.call(location, nil)
      else
        @callback.call(nil, error.localizedDescription)
      end
    end
  end
end
