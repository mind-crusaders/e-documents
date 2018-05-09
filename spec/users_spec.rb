# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test user Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  it 'HAPPY: should be able to get list of all users' do
    EDocuments::User.create(DATA[:users][0]).save
    EDocuments::User.create(DATA[:users][1]).save

    get 'api/v1/users'
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single user' do
    existing_proj = DATA[:users][1]
    EDocuments::User.create(existing_proj).save
    id = EDocuments::User.first.id

    get "/api/v1/users/#{id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data']['attributes']['id']).must_equal id
    _(result['data']['attributes']['name']).must_equal existing_proj['name']
  end

  it 'SAD: should return error if unknown user requested' do
    get '/api/v1/users/foobar'

    _(last_response.status).must_equal 404
  end

  describe 'Creating New Users' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @proj_data = DATA[:users][1]
    end
    
    it 'HAPPY: should be able to create new users' do
      existing_proj = DATA[:users][1]
  
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post 'api/v1/users', existing_proj.to_json, req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0
  
      created = JSON.parse(last_response.body)['data']['data']['attributes']
      proj = EDocuments::User.first
  
      _(created['id']).must_equal proj.id
      _(created['surname']).must_equal existing_user['surname']
      _(created['username']).must_equal existing_user['username']
      _(created['email']).must_equal existing_user['email']
      _(created['phone']).must_equal existing_user['phone']
    end
    it 'BAD: should not create project with illegal attributes' do
      bad_data = @proj_data.clone
      bad_data['created_at'] = '1900-01-01'
      post 'api/v1/users', bad_data.to_json, @req_header
  
      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end  
end