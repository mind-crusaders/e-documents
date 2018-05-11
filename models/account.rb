# frozen_string_literal: true

require 'json'
require 'sequel'

module EDocuments
  # Models a Account
  class Account < Sequel::Model
    one_to_many :documents
    plugin :association_dependencies, documents: :destroy
    plugin :timestamps, update_on_create:true
    plugin :whitelist_security
    set_allowed_columns :name, :surname, :email, :phone

    def password=(new_password)
      self.salt = SecureDB.new_salt
      self.password_hash = SecureDB.hash_password(salt, new_password)
    end

    def password?(try_password)
      try_hashed = SecureDB.hash_password(salt, try_password)
      try_hashed == password_hash
    end

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'Account',
            attributes: {
              id: id,
              name: name,
              surname: surname,
              email: email,
              phone: phone,
              accounts_type:accounts_type
            }
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end



