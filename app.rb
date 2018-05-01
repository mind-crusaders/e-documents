# frozen_string_literal: truee

require 'roda'
require 'json'

require_relative 'config/environments'
require_relative 'models/init'

module EDocuments
  # Web controller for EDocuments API
  class Api < Roda
    plugin :halt

    route do |routing|
      response['Content-Type'] = 'application/json'

      routing.root do
        { message: 'EDocumentsAPI up at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          @api_root = "api/v1"

          routing.on 'users' do
            @proj_route = "#{@api_root}/users"

            routing.on String do |proj_id|
              routing.on 'documents' do
                @doc_route = "#{@api_root}/users/#{proj_id}/documents"
                # GET api/v1/users/[proj_id]/documents/[doc_id]
                routing.get String do |doc_id|
                  doc = Document.where(user_id: user_id, id: doc_id).first
                  doc ? doc.to_json : raise('Document not found')
                rescue StandardError => error
                  routing.halt 404, { message: error.message }.to_json
                end

                # GET api/v1/users/[proj_id]/documents
                routing.get do
                  output = { data: user.first(id: proj_id).documents }
                  JSON.pretty_generate(output)
                rescue StandardError
                  routing.halt 404, { message: 'Could not find documents' }
                end

                # POST api/v1/users/[ID]/documents
                routing.post do
                  new_data = JSON.parse(routing.body.read)
                  proj = user.first(id: proj_id)
                  new_doc = proj.add_document(new_data)

                  if new_doc
                    response.status = 201
                    response['Location'] = "#{@doc_route}/#{new_doc.id}"
                    { message: 'Document saved', data: new_doc }.to_json
                  else
                    routing.halt 400, 'Could not save document'
                  end

                rescue StandardError
                  routing.halt 500, { message: 'Database error' }.to_json
                end
              end

              # GET api/v1/users/[ID]
              routing.get do
                proj = user.first(id: proj_id)
                proj ? proj.to_json : raise('user not found')
              rescue StandardError => error
                routing.halt 404, { message: error.message }.to_json
              end
            end

            # GET api/v1/users
            routing.get do
              output = { data: user.all }
              JSON.pretty_generate(output)
            rescue StandardError
              routing.halt 404, { message: 'Could not find users' }.to_json
            end

            # POST api/v1/users
            routing.post do
              new_data = JSON.parse(routing.body.read)
              new_proj = user.new(new_data)
              raise('Could not save user') unless new_proj.save

              response.status = 201
              response['Location'] = "#{@proj_route}/#{new_proj.id}"
              { message: 'user saved', data: new_proj }.to_json
            rescue StandardError => error
              routing.halt 400, { message: error.message }.to_json
            end
          end
        end
      end
    end
  end
end