require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.color = true
  config.tty = true
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'YouAreDaChef'
