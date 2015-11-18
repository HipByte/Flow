Gem::Specification.new do |spec|
  spec.name        = 'motion-flow'
  spec.version     = '0.1'
  spec.date        = Date.today
  spec.summary     = 'Cross-platform app framework for RubyMotion'
  spec.description = "motion-flow allows you to write cross-platform native mobile apps in Ruby."
  spec.author      = 'HipByte'
  spec.email       = 'info@hipbyte.com'
  spec.homepage    = 'http://www.rubymotion.com'
  spec.license     = 'Proprietary'
  spec.files       = Dir.glob('lib/**/*.rb') + Dir.glob('flow/**/*.rb') + Dir.glob('template/**/*')
  spec.metadata    = { "rubymotion_template_dir" => "template" }
end
