# -*- coding: utf-8 -*-

Motion::Project::App.setup do |app|
  # Use `rake android:config' to see complete project settings.
  app.name = 'test'
  app.archs = ['x86']
  app.api_version = '22'
  app.vm_debug_logs = true
  app.permissions = ["android.permission.INTERNET", "android.permission.ACCESS_NETWORK_STATE"]
end
