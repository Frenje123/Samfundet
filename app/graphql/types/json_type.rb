# frozen_string_literal: true

module Types
  class JsonType < GraphQL::Schema::Scalar
    def self.coerce_input(value, _context)
      value
    end

    def self.coerce_result(value, _context)
      value
    end
  end
end
