# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test Document Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  it 'HAPPY: should be able to get list of all documents' do
    Edocument::Document.create(DATA[:documents][0]).save
    Edocument::Document.create(DATA[:documents][1]).save

    get 'api/v1/documents'
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result.count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single document' do
    doc_data = DATA[:documents][1]
    Edocument::Document.create(doc_data).save
    id = Edocument::Document.first.id

    get "/api/v1/documents/#{id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['id']).must_equal id
    _(result['name']).must_equal doc_data['name']
  end

  it 'SAD: should return error if unknown document requested' do
    get '/api/v1/documents/foobar'

    _(last_response.status).must_equal 404
  end

  describe 'Creating New Documents' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @doc_data = DATA[:documents][1]
    end

    it 'HAPPY: should be able to create new documents' do
      post 'api/v1/documents', @doc_data.to_json, @req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']
      doc = Edocument::Document.first

      _(created['id']).must_equal doc.id
      _(created['name']).must_equal @doc_data['name']
      _(created['repo_url']).must_equal @doc_data['repo_url']
    end

    it 'BAD: should not create document with illegal attributes' do
      bad_data = @doc_data.clone
      bad_data['created_at'] = '1900-01-01'
      post 'api/v1/documents', bad_data.to_json, @req_header

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end
