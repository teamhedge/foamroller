ENV['RACK_ENV'] = 'test'

require File.expand_path('../../lib/foamroller/', __FILE__)
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

