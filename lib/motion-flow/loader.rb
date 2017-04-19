$:.unshift("/Library/RubyMotion/lib")

module Motion
  class Flow
    def self.load_library(lib_name)
      lib_dir = File.join(File.dirname(__FILE__), '../../flow', lib_name)

      case Motion::Project::App.template
      when :android
        platform = 'android'
      when :ios, :tvos, :osx, :'ios-extension'
        platform = 'cocoa'
      else
        raise "Project template #{Motion::Project::App.template} not supported by Flow"
      end

      Motion::Project::App.setup do |app|
        app.files.concat(Dir.glob(File.join(lib_dir, '*.rb')))
        app.files.concat(Dir.glob(File.join(lib_dir, platform, '*.rb')))

        if platform == 'android'
          abis = %w{armeabi-v7a x86}
          if abis.all? { |x| File.exist?(File.join(lib_dir, 'android', x)) }
            abis.each do |abi|
              app.libs[abi] += Dir.glob(File.join(lib_dir, 'android', abi, "*.a")).map { |x| "\"#{x}\""}
            end
          end

          # TODO: figure out which of these vendor libs are required for each Flow lib. Figure out how to selectively add these only if they haven't already been added by the main project.
          # vendor_dir = File.join(File.dirname(__FILE__), '../../vendor/android')
          # v7_app_compat_dir = File.join(vendor_dir, 'support/v7/appcompat')
          # app.vendor_project(:jar => File.join(v7_app_compat_dir, "/libs/android-support-v4.jar"))
          # app.vendor_project(:jar => File.join(v7_app_compat_dir, "/libs/android-support-v7-appcompat.jar"), :resources => File.join(v7_app_compat_dir, "/res"), :manifest => File.join(v7_app_compat_dir, "/AndroidManifest.xml"))
          #
          # app.vendor_project(:jar => File.join(vendor_dir, 'google-play-services_lib/libs/google-play-services.jar'), :filter => ['^.com.google.android.gms.vision'], :resources => File.join(vendor_dir, 'google-play-services_lib/res'), :manifest => File.join(vendor_dir, 'google-play-services_lib/AndroidManifest.xml'))
          # app.manifest_entry('application', 'meta-data', :name => 'com.google.android.gms.version', :value => '@integer/google_play_services_version')
          # app.manifest_entry('application', 'meta-data', :name => 'com.google.android.gms.vision.DEPENDENCIES', :value => 'barcode')
        end

        if platform == 'cocoa'
          exts = Dir.glob(File.join(lib_dir, "cocoa/*.a"))
          unless exts.empty?
            app.vendor_project lib_dir, :static, :products => exts, :source_files => [], :force_load => true
          end
          # TODO: figure out which frameworks are required for each Flow lib
          app.frameworks += ['SystemConfiguration', 'CoreLocation', 'AddressBookUI']
        end

        yield app if block_given?
      end
    end
  end
end
