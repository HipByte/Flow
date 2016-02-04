require File.join(File.dirname(__FILE__), 'common.rb')

$:.unshift("/Library/RubyMotion/lib")
template = ENV['template'] || 'ios'
require "motion/project/template/#{template}"

Motion::Project::App.setup do |app|
  app.build_dir = "build/#{template}"
  app.deployment_target = '7.0' if template == :ios && !Motion::Project::Config.starter?

  FLOW_COMPONENTS.each do |comp|
    libdir = File.join(File.dirname(__FILE__), '../flow/' + comp)
    app.files.concat(Dir.glob(File.join(libdir, '*.rb')))
    app.files.concat(Dir.glob(File.join(libdir, 'cocoa/*.rb')))
    app.files.concat(Dir.glob(File.join(libdir, "cocoa/#{template}/*.rb")))

    unless Dir.glob(File.join(libdir, 'cocoa/*.{m,h}')).empty?
      app.vendor_project libdir, :static
    end
    unless Dir.glob(File.join(libdir, "cocoa/#{template}/*.{m,h}")).empty?
      app.vendor_project libdir, :static
    end
  end

  samples = %w(android ios osx).delete_if {|t| t == template}
  samples.each do |sample|
    app.files.delete_if { |path| path.start_with?("./app/#{sample}") if path.is_a?(String)}
  end
  app.spec_files.delete_if { |path| path.start_with?('./spec/helpers/android') if path.is_a?(String)}

  app.frameworks += ['SystemConfiguration', 'CoreLocation', 'AddressBookUI']
end
