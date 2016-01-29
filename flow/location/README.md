# Flow::Location

Location management and geocoding / reverse geocoding.

## Documentation

### Public API

#### Check if the location service is accessible

```ruby
Location.monitor_enabled? # => true or false
```

#### Start monitoring location updates

```ruby
monitor = Location.monitor do |location, err|
  if location
    puts location.latitude, location.longitude
  else
    puts err
  end
end
```

The `Location.monitor` method can optionally accept a `Hash` of key/value pairs. The current values are supported:

- `:distance_filter`: specifies the distance in meters (as a `Fixnum` object) with the previous location that should trigger a monitor update.

#### Stop/resume monitoring location updates

```ruby
monitor.stop
# ...
monitor.start # resume monitoring for updates
```

#### Access location properties

```ruby
puts location.latitude
puts location.longitude
puts location.altitude
puts location.time
puts location.speed
puts location.accuracy
```

#### Check if the geocoder service is accessible

```ruby
Location.geocode_enabled? # => true or false
```

#### Geocode a location object

```ruby
location.geocode do |location, err|
  if location
    puts location.address
  else
    puts err
  end
end
```

#### Reverse geocode a string

```ruby
Location.geocode('apple inc') do |location, err|
  if location
    puts location.address
  else
    puts err
  end
end
```

#### Access geocoding properties

```ruby
puts location.name
puts location.address
puts location.locality
puts location.postal_code
puts location.sub_area
puts location.area
puts location.country
```
