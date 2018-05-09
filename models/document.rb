# frozen_string_literal: true

require 'json'
require 'sequel'

module EDocuments
  # Models a secret document
  class Document < Sequel::Model
    many_to_one :accounts

    plugin :uuid, field: :id
    plugin :timestamps
    plugin :whitelist_security
    #We allow accounts to set everything but permission
    set_allowed_columns :filename, :relative_path, :description

    def description
      SecureDB.decrypt(self.description_secure)
    end

    def description=(plaintext)
      self.description_secure = SecureDB.encrypt(plaintext)
    end

    def content
      SecureDB.decrypt(self.content_secure)
    end

    def content=(plaintext)
      self.content_secure = SecureDB.encrypt(plaintext)
    end

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
            account: account
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end



