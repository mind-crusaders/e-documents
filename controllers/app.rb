# frozen_string_literal: true

require 'roda'
require 'json'

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
            @usr_route = "#{@api_root}/users"

            routing.on String do |usr_id|
              routing.on 'documents' do
                @doc_route = "#{@api_root}/users/#{usr_id}/documents"
                # GET api/v1/users/[usr_id]/documents/[doc_id]
                routing.get String do |doc_id|
                  doc = Document.where(user_id: user_id, id: doc_id).first
                  doc ? doc.to_json : raise('Document not found')
                rescue StandardError => error
                  routing.halt 404, { message: error.message }.to_json
                end

                # GET api/v1/users/[usr_id]/documents
                routing.get do
                  output = { data: user.first(id: usr_id).documents }
                  JSON.pretty_generate(output)
                rescue StandardError
                  routing.halt 404, { message: 'Could not find documents' }
                end

                # POST api/v1/users/[ID]/documents
                routing.post do
                  new_data = JSON.parse(routing.body.read)
                  usr = user.first(id: usr_id)
                  new_doc = usr.add_document(new_data)

                  if new_doc
                    response.status = 201
                    response['Location'] = "#{@doc_route}/#{new_doc.id}"
                    { message: 'Document saved', data: new_doc }.to_json
                  else
                    raise 'Could not save document'
                  end

                rescue Sequel::MassAssignmentRestriction
                  routing.halt 400, { message: 'Illegal Request' }.to_json
                rescue StandardError
                  routing.halt 500, { message: 'Database error' }.to_json
                end
              end

              # GET api/v1/users/[ID]
              routing.get do
                usr = user.first(id: usr_id)
                usr ? usr.to_json : raise('user not found')
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
              new_usr = user.new(new_data)
              raise('Could not save user') unless new_usr.save

              response.status = 201
              response['Location'] = "#{@usr_route}/#{new_usr.id}"
              { message: 'user saved', data: new_usr }.to_json
            rescue Sequel::MassAssignmentRestriction
              routing.halt 400, { message: 'Illegal Request' }.to_json
            rescue StandardError => error
              routing.halt 500, { message: error.message }.to_json
            end
          end
        end
      end
    end
  end
end