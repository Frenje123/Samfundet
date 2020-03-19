# frozen_string_literal: true

require 'rails_helper'

describe Sulten::Reservation do
  let(:reservation_type) { create('sulten/reservation_type', :drinks) }
  let(:tables) { [4, 5, 6].map { |c| create('sulten/table', capacity: c) } }
  let(:reservation_from) { (DateTime.now + 7.day).change({ hour: 18 }) }

  before do
    tables.each do |t|
      t.reservation_types << reservation_type
      create('sulten/reservation',
             :skip_validations,
             people: t.capacity,
             reservation_from: reservation_from,
             reservation_type: reservation_type,
             table: t,
      )
    end
  end

  context 'creating reservations when no tables are available at specific time, capacity and reservation type' do
    it 'should disallow reservation if no tables can house them at given capacity and time' do
      expect do
        create('sulten/reservation',
               people: 6,
               reservation_from: reservation_from,
               reservation_type: reservation_type,
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should allow reservatinos to be made back-to-back' do
      expect do
        create('sulten/reservation',
               people: 6,
               reservation_from: reservation_from.change({ hour: 18, min: 30 }),
               reservation_type: reservation_type,
        )
      end.not_to raise_error
    end

    it 'should allow reservatinos to be made an hour after all other reservations are done' do
      expect do
        create('sulten/reservation',
               people: 6,
               reservation_from: reservation_from.change({ hour: 19 }),
               reservation_type: reservation_type,
        )
      end.not_to raise_error
    end

    it 'should allow reservations to be made an hour before all are full' do
      r = build('sulten/reservation',
                 people: 6,
                 reservation_from: reservation_from.change({ hour: 17 }),
                 reservation_duration: 60,
                 reservation_type: reservation_type
      )
      expect do
        r.save
      end.not_to raise_error

      expect(r.table.number).not_to eq(-1)
    end
  end
end
