# frozen_string_literal: true

require 'json'
require 'sequel'

module EDocuments
  # Models a secret document
  class Document < Sequel::Model
    many_to_one :user

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'document',
            attributes: {
              id: id,
              filename: filename,
              relative_path: relative_path,
              description: description,
              permission: permission,
            }
          },
          included: {
            user: user
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end



