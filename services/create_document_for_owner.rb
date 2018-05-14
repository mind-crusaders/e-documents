# frozen_string_literal: true

module Edocument
  # Service object to create a new document for an owner
  class CreateDocumentForOwner
    def self.call(owner_id:, document_data:)
      Account.find(id: owner_id)
             .add_owned_document(document_data)
    end
  end
end
