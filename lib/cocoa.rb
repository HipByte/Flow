require File.join(File.dirname(__FILE__), 'common.rb')

$:.unshift("/Library/RubyMotion/lib")
template = ENV['template'] || 'ios'
require "motion/project/template/#{template}"

Motion::Project::App.setup do |app|
  app.build_dir = "build/#{template}"
  app.deployment_target = '7.0' if template == :ios && !Motion::Project::Config.starter?

  files = []
  FLOW_COMPONENTS.each do |comp|
    libdir = File.join(File.dirname(__FILE__), '../flow/' + comp)
    files.concat(Dir.glob(File.join(libdir, '*.rb')))
    files.concat(Dir.glob(File.join(libdir, 'cocoa/*.rb')))

    exts = Dir.glob(File.join(libdir, "cocoa/*.a"))
    unless exts.empty?
      app.vendor_project libdir, :static, :products => exts, :source_files => [], :force_load => true
      if comp == 'ui'
        app.custom_init_funcs << 'Init_CSSNode'
      end
    end
  end
  app.files.unshift(*files)

  samples = %w(android ios osx).delete_if {|t| t == template}
  samples.each do |sample|
    app.files.delete_if { |path| path.start_with?("./app/#{sample}") }
  end
  app.spec_files.delete_if { |path| path.start_with?('./spec/helpers/android') }

  app.frameworks += ['SystemConfiguration', 'CoreLocation', 'AddressBookUI']
end
