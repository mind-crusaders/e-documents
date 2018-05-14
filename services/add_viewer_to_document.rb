# frozen_string_literal: true

module Edocument
  # Add a collaborator to another owner's existing project
  class AddViewerToDocument
    def self.call(email:, document_id:)
      collaborator = Account.first(email: email)
      document = Document.first(id: document_id)
      return false if document.owner.id == viewer.id
      document.add_viewer
      viewer
    end
  end
end
