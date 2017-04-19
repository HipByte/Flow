require_relative 'loader'

# Load Dependencies
require_relative 'task'

Motion::Flow.load_library 'ui' do |app|
  app.custom_init_funcs << 'Init_CSSNode'
end
