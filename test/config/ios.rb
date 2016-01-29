# -*- coding: utf-8 -*-

Motion::Project::App.setup do |app|
  # Use `rake ios:config' to see complete project settings.
  app.name = 'test'
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.info_plist['NSLocationWhenInUseUsageDescription'] = "Required to test location services"
  app.info_plist['NSLocationAlwaysUsageDescription'] = "Required to test location services"
end
