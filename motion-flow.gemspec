Gem::Specification.new do |spec|
  spec.name        = 'motion-flow'
  spec.version     = '0.1.8'
  spec.summary     = 'Cross-platform app framework for RubyMotion'
  spec.description = "motion-flow allows you to write cross-platform
                      native mobile apps in Ruby."
  spec.author      = 'HipByte'
  spec.email       = 'info@hipbyte.com'
  spec.homepage    = 'http://www.rubymotion.com'
  spec.license     = 'BSD 2-clause "Simplified" License'
  spec.files       = Dir.glob('lib/**/*.rb') +
                     Dir.glob('flow/**/*.rb') +
                     Dir.glob('flow/**/*.a') +
                     Dir.glob('template/**/*') +
                     Dir.glob('vendor/**/*')
  spec.metadata    = { "rubymotion_template_dir" => "template" }
end
