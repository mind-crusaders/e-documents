# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:documents) do
      primary_key :id
      foreign_key :user_id, table: :users

      String :id, null: false
      String :filename, null: false
      String :relative_path, null: false, default: ''
      String :description
      String :permission, null: false  
      
      
      DateTime :created_at
      DateTime :updated_at
      DateTime :expire_at

      unique [:user_id, :relative_path, :filename]
    end
  end
end
