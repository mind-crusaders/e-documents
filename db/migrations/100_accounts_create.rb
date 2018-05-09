# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id

      String :name_secure, null: false
      String :surname_secure, null: false
      String :username_secure, null: false
      String :email_secure, null: false
      Integer :phone_secure, null: false
      String :password_hash
      String :salt
      String :accounts_type
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
 