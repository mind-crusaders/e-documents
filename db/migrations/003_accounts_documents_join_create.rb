# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(viewer_id: :accounts, document_id: :documents)
  end
end
