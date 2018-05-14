# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:documents) do
      uuid :id, primary_key: true
      foreign_key :owner_id, :accounts

      String :filename_secure, unique: true, null: false
      String :doctype_secure, unique: true
      DateTime :created_time
      DateTime :updated_time
    end
  end
end
