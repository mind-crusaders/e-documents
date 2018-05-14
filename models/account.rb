require 'sequel'
require 'json'

module Edocument
  # Models a registered account
  class Account < Sequel::Model
    one_to_many :owned_documents, class: :'Edocument::Document', key: :owner_id
    plugin :association_dependencies, owned_documents: :destroy

    many_to_many :views,
                 class: :'Edocument::Document',
                 join_table: :accounts_documents,
                 left_key: :viewer_id, right_key: :document_id

    plugin :whitelist_security
    set_allowed_columns :username, :email, :password, :lastname, :firstname

    plugin :timestamps, update_on_create: true

    def documents
      owned_documents + views
    end

    def password=(new_password)
      self.salt = SecureDB.new_salt
      self.password_hash = SecureDB.hash_password(salt, new_password)
    end

    def password?(try_password)
      try_hashed = SecureDB.hash_password(salt, try_password)
      try_hashed == password_hash
    end

    def to_json(options = {})
      JSON(
        {
          type: 'account',
          id: id,
          username: username,
          email: email,
          lastname: lastname,
          firstname: firstname
        }, options
      )
    end
  end
end
