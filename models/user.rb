# frozen_string_literal: true

require 'json'
require 'sequel'

module EDocuments
  # Models a user
  class User < Sequel::Model
    one_to_many :documents
    plugin :association_dependencies, documents: :destroy
    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :name, :surname, :email, :phone

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'user',
            attributes: {
              id: id,
              name: name,
              surname: surname,
              email: email,
              phone: phone
            }
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end