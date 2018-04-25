# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String :name, null: false
      String :surname, null: false
      String :email, null: false
    end
  end
end
