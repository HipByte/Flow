$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

Motion::Project::App.setup do |app|
  app.api_version = '16' unless Motion::Project::Config.starter?
  app.build_dir = 'build/android'

  libdir = File.join(File.dirname(__FILE__), '../flow/net')
  app.files.concat(Dir.glob(File.join(libdir, '*.rb')))
  app.files.concat(Dir.glob(File.join(libdir, 'android/*.rb')))
  app.files.delete_if { |path| path.start_with?('./app/ios') }
end
