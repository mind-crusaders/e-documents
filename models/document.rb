# frozen_string_literal: true

module Edocument
  # Models a project
  class Document < Sequel::Model
    many_to_one :owner, class: :'Edocument::Account'
  
    many_to_many :viewers,
                 class: :'Edocument::Account',
                 join_table: :accounts_documents,
                 left_key: :document_id, right_key: :viewer_id

    #one_to_many :documents
    plugin :association_dependencies
    #add_association_dependencies documents: :destroy, viewers: :nullify

    

    plugin :uuid, field: :id

    plugin :whitelist_security
    set_allowed_columns :filename, :doctype

    plugin :timestamps, update_on_create: true

    def filename
      SecureDB.decrypt(self.filename_secure)
    end

    def filename=(plaintext)
      self.filename_secure = SecureDB.encrypt(plaintext)
    end

    def doctype
      SecureDB.decrypt(self.doctype_secure)
    end

    def doctype=(plaintext)
      self.doctype_secure = SecureDB.encrypt(plaintext)
    end

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'document',
          id: id,
          owner_id: owner_id,
          filename_secure: filename_secure,
          doctype_secure: doctype_secure
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end
