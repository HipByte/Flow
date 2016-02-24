EXTENSIONS = [
  { :files => ['flow/ui/css_node.c'], :lib => 'flow/ui/cocoa/libcss_node.a' }, 
  { :files => ['flow/digest/cocoa/digest.m'], :lib => 'flow/digest/cocoa/libdigest.a' }
]

XCODE_PATH = '/Applications/Xcode.app'
XCODE_IOS_DEPLOYMENT_TARGET = '7.0'
BUILD_DIR = 'build'

desc 'Build the extensions'
task 'build' do
  toolchain_bin = XCODE_PATH + '/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin'
  cc = toolchain_bin + '/clang'
  build_dir = File.join(BUILD_DIR, 'ios')
  EXTENSIONS.each do |extension|
    src_paths = extension[:files]
    lib_path = extension[:lib]
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
    if !File.exist?(lib_path) or objs.any? { |x| File.mtime(x) > File.mtime(lib_path) }
      mkdir_p File.dirname(lib_path)
      rm_f lib_path
      sh "/usr/bin/ar rcu #{lib_path} #{objs.join(' ')}"
      sh "/usr/bin/ranlib #{lib_path}"
    end
  end
end

desc 'Clean up build files'
task 'clean' do
  rm_rf BUILD_DIR
  EXTENSIONS.each do |extension|
    rm_f extension[:lib]
  end 
end

desc 'Create motion-flow.gem file'
task 'gem' do
  sh "gem build motion-flow.gemspec"
end
