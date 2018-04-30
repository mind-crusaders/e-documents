# frozen_string_literal: true

require 'json'
require 'sequel'

module EDocuments
  # Models a secret document
  class Document < Sequel::Model
    many_to_one :project

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'document',
            attributes: {
              id: id,
              filename: filename,
              relative_path: relative_path,
              description: description,
              content: content
            }
          },
          included: {
            project: project
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end
