module EDocuments
    # Create new configuration for a project
    class CreateDocumentForAccount
      def self.call(account_id:, document_data:)
        Account.first(id: account_id)
               .add_document(document_data)
      end
    end
  end
  