# frozen_string_literal: true

# run pry -r <path/to/this/file>
require 'rack/test'
include Rack::Test::Methods

require_relative '../init'

def app
  Edocument::Api
end
