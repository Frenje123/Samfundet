# frozen_string_literal: true

class Sulten::ReservationType < ApplicationRecord
  has_many :reservations
  has_many :tables, through: :table_reservation_types

  def to_s
    name
  end
end
