require File.join(File.dirname(__FILE__), 'common.rb')

$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

Motion::Project::App.setup do |app|
  app.api_version = '23' unless Motion::Project::Config.starter?
  app.build_dir = 'build/android'
  app.assets_dirs = ['resources']
  app.resources_dirs = []

  FLOW_COMPONENTS.each do |comp|
    libdir = File.join(File.dirname(__FILE__), '../flow/' + comp)
    app.files.concat(Dir.glob(File.join(libdir, '*.rb')))
    app.files.concat(Dir.glob(File.join(libdir, 'android/*.rb')))

    abis = %w{armeabi-v7a x86}
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

  app.manifest.child('application') do |application|
    application['android:theme'] = '@style/Theme.AppCompat.Light'
  end

  vendor_dir = File.join(File.dirname(__FILE__), '../vendor/android')
  v7_app_compat_dir = File.join(vendor_dir, 'support/v7/appcompat')
  app.vendor_project(:jar => File.join(v7_app_compat_dir, "/libs/android-support-v4.jar"))
  app.vendor_project(:jar => File.join(v7_app_compat_dir, "/libs/android-support-v7-appcompat.jar"), :resources => File.join(v7_app_compat_dir, "/res"), :manifest => File.join(v7_app_compat_dir, "/AndroidManifest.xml"))

  app.vendor_project(:jar => File.join(vendor_dir, 'google-play-services_lib/libs/google-play-services.jar'), :filter => ['^.com.google.android.gms.vision'], :resources => File.join(vendor_dir, 'google-play-services_lib/res'), :manifest => File.join(vendor_dir, 'google-play-services_lib/AndroidManifest.xml'))
  app.manifest_entry('application', 'meta-data', :name => 'com.google.android.gms.version', :value => '@integer/google_play_services_version')
  app.manifest_entry('application', 'meta-data', :name => 'com.google.android.gms.vision.DEPENDENCIES', :value => 'barcode')
end
