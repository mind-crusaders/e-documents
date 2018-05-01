# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'yaml'

require_relative '../app'
require_relative '../document'

def app
  EDocuments::Api
end

DATA = YAML.safe_load File.read('db/seeds/document_seeds.yml')

describe 'Test EDocuments Web API' do
  include Rack::Test::Methods

  before do
    Dir.glob('db/*.txt').each { |filename| FileUtils.rm(filename) }
  end

  it 'should find the root route' do
    get '/'
    _(last_response.status).must_equal 200
  end

  describe 'Handle documents' do
    it 'HAPPY: should be able to get list of all documents' do
      EDocuments::Document.new(DATA[0]).save
      EDocuments::Document.new(DATA[1]).save

      get 'api/v1/documents'
      result = JSON.parse last_response.body
      _(result['document_ids'].count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single document' do
      EDocuments::Document.new(DATA[1]).save
      id = Dir.glob('db/*.txt').first.split(%r{[/\.]})[1]

      get "/api/v1/documents/#{id}"
      result = JSON.parse last_response.body

      _(last_response.status).must_equal 200
      _(result['id']).must_equal id
    end

    it 'SAD: should return error if unknown document requested' do
      get '/api/v1/documents/foobar'

      _(last_response.status).must_equal 404
    end

    it 'HAPPY: should be able to create new documents' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post 'api/v1/documents', DATA[1].to_json, req_header

      _(last_response.status).must_equal 201
    end
  end
end
