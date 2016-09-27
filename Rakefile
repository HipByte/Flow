EXTENSIONS = [
  { :files => ['flow/ui/css_node.c'],
    :ios => { :lib => 'flow/ui/cocoa/libcss_node.a' },
    :android => { :lib_armeabi => 'flow/ui/android/armeabi-v7a/libcss_node.a',
                  :lib_x86 => 'flow/ui/android/x86/libcss_node.a' } },
  { :files => ['flow/digest/cocoa/digest.m'],
    :ios => { :lib => 'flow/digest/cocoa/libdigest.a' } }
]

BUILD_DIR = 'build'
XCODE_PATH = '/Applications/Xcode.app'
XCODE_IOS_DEPLOYMENT_TARGET = '7.0'
ANDROID_NDK_PATH = File.expand_path(ENV['RUBYMOTION_ANDROID_NDK'] || '~/.rubymotion-android/ndk')
ANDROID_API = '16'

desc 'Build the extensions'
task 'build' => [:"build:ios", :"build:android"]

desc 'Build the extensions for iOS'
task 'build:ios' do
  EXTENSIONS.each do |extension|
    src_paths = extension[:files]
    if extension[:ios]
      # iOS
      toolchain_bin = XCODE_PATH + '/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin'
      cc = toolchain_bin + '/clang'
      build_dir = File.join(BUILD_DIR, 'ios')
      objs = []
      %w{iPhoneSimulator iPhoneOS}.each do |platform|
        sdk_path = "#{XCODE_PATH}/Contents/Developer/Platforms/#{platform}.platform/Developer/SDKs/#{platform}.sdk"
        cflags = "-isysroot \"#{sdk_path}\" -F#{sdk_path}/System/Library/Frameworks -fobjc-legacy-dispatch -fobjc-abi-version=2 -I. -Werror -I./include "
        case platform
          when 'iPhoneSimulator'
            cflags << " -arch i386 -arch x86_64 -mios-simulator-version-min=#{XCODE_IOS_DEPLOYMENT_TARGET} -DCC_TARGET_OS_IPHONE"
          when 'iPhoneOS'
            cflags << " -arch armv7 -arch armv7s -arch arm64 -mios-version-min=#{XCODE_IOS_DEPLOYMENT_TARGET} -DCC_TARGET_OS_IPHONE"
        end
        src_paths.each do |src_path|
          obj_path = File.join(build_dir, platform, src_path + '.o')
          if !File.exist?(obj_path) or File.mtime(src_path) > File.mtime(obj_path)
            mkdir_p File.dirname(obj_path)
            sh "#{cc} #{cflags} -c #{src_path} -o #{obj_path}"
          end
          objs << obj_path
        end
      end
      lib_path = extension[:ios][:lib]
      if !File.exist?(lib_path) or objs.any? { |x| File.mtime(x) > File.mtime(lib_path) }
        mkdir_p File.dirname(lib_path)
        rm_f lib_path
        sh "/usr/bin/ar rcu #{lib_path} #{objs.join(' ')}"
        sh "/usr/bin/ranlib #{lib_path}"
      end
    end
  end
end

desc 'Build the extensions for Android'
task 'build:android' do
  EXTENSIONS.each do |extension|
    src_paths = extension[:files]
    if extension[:android]
      # Android
      cc = File.join(ANDROID_NDK_PATH, 'toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++')
      toolchain_bin = "#{ANDROID_NDK_PATH}/toolchains/x86-4.9/prebuilt/darwin-x86_64/i686-linux-android/bin"
      ar = toolchain_bin + "/ar"
      ranlib = toolchain_bin + "/ranlib"
      %w{armeabi x86}.each do |arch|
        cflags =
          case arch
            when 'x86'
              "-mno-sse -mno-mmx -no-canonical-prefixes -msoft-float -target i686-none-linux-android -gcc-toolchain \"#{ANDROID_NDK_PATH}/toolchains/x86-4.8/prebuilt/darwin-x86_64\" -MMD -MP -fpic -ffunction-sections -funwind-tables -fexceptions -fstack-protector -fno-strict-aliasing -O0 -fno-omit-frame-pointer -DANDROID -I\"#{ANDROID_NDK_PATH}/platforms/android-#{ANDROID_API}/arch-x86/usr/include\" -Wformat -Werror=format-security -DCC_TARGET_OS_ANDROID -I./include"
            when 'armeabi'
              "-no-canonical-prefixes -target armv5te-none-linux-androideabi -march=armv5te -mthumb -msoft-float -marm -gcc-toolchain \"#{ANDROID_NDK_PATH}/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64\" -mtune=xscale -MMD -MP -fpic -ffunction-sections -funwind-tables -fexceptions -fstack-protector -fno-strict-aliasing -fno-omit-frame-pointer -DANDROID -I\"#{ANDROID_NDK_PATH}/platforms/android-#{ANDROID_API}/arch-arm/usr/include\" -Wformat -Werror=format-security -DCC_TARGET_OS_ANDROID -I./include"
          end
        objs = []
        src_paths.each do |src_path|
          obj_path = File.join(BUILD_DIR, 'android-' + arch, src_path + '.o')
          if !File.exist?(obj_path) or File.mtime(src_path) > File.mtime(obj_path)
            mkdir_p File.dirname(obj_path)
            sh "#{cc} #{cflags} -c #{src_path} -o #{obj_path}"
          end
          objs << obj_path
        end
        lib_path = extension[:android]["lib_#{arch}".intern]
        if !File.exist?(lib_path) or objs.any? { |x| File.mtime(x) > File.mtime(lib_path) }
          mkdir_p File.dirname(lib_path)
          rm_f lib_path
          sh "#{ar} rcu #{lib_path} #{objs.join(' ')}"
          sh "#{ranlib} #{lib_path}"
        end
      end
    end
  end
end

desc 'Clean up build files'
task 'clean' do
  rm_rf BUILD_DIR
  EXTENSIONS.each do |extension|
    if extension[:ios]
      rm_f extension[:ios][:lib]
    end
    if extension[:android]
      extension[:android].each { |_, path| rm_f path }
    end
  end 
end

desc 'Create motion-flow.gem file'
task 'gem' => [:build] do
  sh "gem build motion-flow.gemspec"
end

task :default => :build
