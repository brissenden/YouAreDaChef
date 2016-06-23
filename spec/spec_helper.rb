if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'YouAreDaChef'