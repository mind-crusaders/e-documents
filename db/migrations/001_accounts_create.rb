# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id

      String :username, null: false, unique: true
      String :email, null: false, unique: true
      String :password_hash
      String :salt
      String :lastname, null: true, unique: false
      String :firstname, null: true, unique: false
      DateTime :dob, null: true, unique: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
