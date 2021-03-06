# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test account Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  it 'HAPPY: should be able to get list of all accounts' do
    EDocuments::Account.create(DATA[:accounts][0]).save
    EDocuments::Account.create(DATA[:accounts][1]).save

    get 'api/v1/accounts'
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single account' do
    existing_proj = DATA[:accounts][1]
    EDocuments::Account.create(existing_proj).save
    id = EDocuments::Account.first.id

    get "/api/v1/accounts/#{id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data']['attributes']['id']).must_equal id
    _(result['data']['attributes']['name']).must_equal existing_proj['name']
  end

  it 'SAD: should return error if unknown account requested' do
    get '/api/v1/accounts/foobar'

    _(last_response.status).must_equal 404
  end

  describe 'Creating New accounts' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @proj_data = DATA[:accounts][1]
    end
    
    it 'HAPPY: should be able to create new accounts' do
      existing_proj = DATA[:accounts][1]
  
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post 'api/v1/accounts', existing_proj.to_json, req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0
  
      created = JSON.parse(last_response.body)['data']['data']['attributes']
      proj = EDocuments::Account.first
  
      _(created['id']).must_equal proj.id
      _(created['surname']).must_equal existing_account['surname']
      _(created['username']).must_equal existing_account['username']
      _(created['email']).must_equal existing_account['email']
      _(created['phone']).must_equal existing_account['phone']
    end
    it 'BAD: should not create project with illegal attributes' do
      bad_data = @proj_data.clone
      bad_data['created_at'] = '1900-01-01'
      post 'api/v1/accounts', bad_data.to_json, @req_header
  
      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end  
end