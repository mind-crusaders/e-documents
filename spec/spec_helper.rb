ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  app.DB[:documents].delete
  app.DB[:accounts].delete
end

DATA = {}
DATA[:documents] = YAML.safe_load File.read('db/seeds/document_seeds.yml')
DATA[:accounts] = YAML.safe_load File.read('db/seeds/user_seeds.yml')
