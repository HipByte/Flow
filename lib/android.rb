require File.join(File.dirname(__FILE__), 'common.rb')

$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

Motion::Project::App.setup do |app|
  app.api_version = '21' unless Motion::Project::Config.starter?
  app.build_dir = 'build/android'
  app.assets_dirs = ['resources']
  app.resources_dirs = []

  FLOW_COMPONENTS.each do |comp|
    libdir = File.join(File.dirname(__FILE__), '../flow/' + comp)
    app.files.concat(Dir.glob(File.join(libdir, '*.rb')))
    app.files.concat(Dir.glob(File.join(libdir, 'android/*.rb')))

    abis = %w{armeabi x86}
    if abis.all? { |x| File.exist?(File.join(libdir, 'android', x)) }
      abis.each do |abi|
        app.libs[abi] += Dir.glob(File.join(libdir, 'android', abi, "*.a"))
      end
    end
    if comp == 'ui'
      app.custom_init_funcs << 'Init_CSSNode'
    end
  end

  app.files.delete_if { |path| path.start_with?('./app/ios') }
  app.files.delete_if { |path| path.start_with?('./app/osx') }
  app.spec_files.delete_if { |path| path.start_with?('./spec/helpers/cocoa') }
end
