# frozen_string_literal: true

module Edocuments
  # Create new configuration for an account
  class CreateDocumentForAccount
    def self.call(account_id:, document_data:)
      Project.first(id: account_id)
             .add_document(document_data)
    end
  end
end
