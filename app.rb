require 'roda'
require 'json'
require 'base64'


require_relative 'user_dir/user_info'
 
module PassportApi
  # Web controller for Credence API
  class Api < Roda
    plugin :environments
    plugin :halt

    configure do
      User.setup
    end

    route do |routing|
      response['Content-Type'] = 'application/json'

      routing.root do
        { message: 'The Api is running   at /passportAppApi' }.to_json
      end

      routing.on 'passportApi' do
        routing.on 'user_dir' do
          
            # POST passportApi/user_dir/[ID]
            routing.get String do |id|
              User.find(id).to_json
            rescue StandardError
              routing.halt 404, { message: 'User not found' }.to_json
            end

            # GET passportApi/user_dir
            routing.get do
              output = { document_ids: User.all }
              JSON.pretty_generate(output)
            end

            # POST passportApi/user_dir
            routing.post do
              new_data = JSON.parse(routing.body.read)
              new_user = User.new(new_data)

              if new_user.save
                response.status = 201
                { message: 'User saved', id: new_doc.id }.to_json
              else
                routing.halt 400, { message: 'Could not save User' }.to_json
              end
            end
          end
        end
      end
    end
  end
end
