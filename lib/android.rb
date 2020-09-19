require File.join(File.dirname(__FILE__), 'common.rb')

$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'
require 'motion-gradle'

Motion::Project::App.setup do |app|
  app.api_version = ENV['ANDROID_APP_API_VERSION'] ||= '23' unless Motion::Project::Config.starter?
  app.build_dir = 'build/android'
  app.assets_dirs << 'resources'
  app.resources_dirs = []

  files = []
  FLOW_COMPONENTS.each do |comp|
    libdir = File.join(File.dirname(__FILE__), '../flow/' + comp)
    files.concat(Dir.glob(File.join(libdir, '*.rb')))
    files.concat(Dir.glob(File.join(libdir, 'android/*.rb')))

    abis = %w{armeabi-v7a x86}
    if abis.all? { |x| File.exist?(File.join(libdir, 'android', x)) }
      abis.each do |abi|
        app.libs[abi] += Dir.glob(File.join(libdir, 'android', abi, "*.a")).map { |x| "\"#{x}\""}
      end
    end
    if comp == 'ui'
      app.custom_init_funcs << 'Init_CSSNode'
    end
  end
  app.files.unshift(*files)

  app.files.delete_if { |path| path.start_with?('./app/ios') or path.start_with?('./app/osx') }
  app.spec_files.delete_if { |path| path.start_with?('./spec/helpers/cocoa') }

  app.manifest.child('application') do |application|
    application['android:theme'] = '@style/Theme.AppCompat.Light'
  end

  app.gradle do
    repository 'https://maven.google.com'
    dependency 'com.android.support:appcompat-v7:24.2.1'
    dependency 'com.android.support:support-v4:24.2.1'
    dependency 'com.google.android.gms:play-services-vision:11.8.0'
    dependency 'com.google.android.gms:play-services-vision-common:11.8.0'
  end

  app.manifest_entry('application', 'meta-data', :name => 'com.google.android.gms.version', :value => '@integer/google_play_services_version')
  app.manifest_entry('application', 'meta-data', :name => 'com.google.android.gms.vision.DEPENDENCIES', :value => 'barcode')
end
