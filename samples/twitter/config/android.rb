# -*- coding: utf-8 -*-

Motion::Project::App.setup do |app|
  # Use `rake android:config' to see complete project settings.
  app.name = 'Twitter'
  app.archs = ['x86']
  app.vm_debug_logs = true
  app.permissions = ["android.permission.INTERNET"]
end
