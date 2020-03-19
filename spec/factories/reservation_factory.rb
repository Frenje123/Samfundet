# frozen_string_literal: true

FactoryBot.define do
  factory 'sulten/reservation_type' do
    trait :drinks do
      name { 'Drikke' }
      description { 'Bord bare for drikke' }
    end

    trait :food_drinks do
      name { 'Mat/drikke' }
      description { 'Bord for mat og drikke' }
    end
  end

  factory 'sulten/table' do
    number {
      all = Sulten::Table.all
      all.empty? ? 0 : all.last.number + 1
    }
    capacity { rand(1..12) }
    available { true }
    comment { Faker::Lorem.sentence }
  end

  factory 'sulten/reservation' do
    name { Faker::Name }
    email { Faker::Internet.email }
    telephone { Faker::PhoneNumber }
    people { rand(2..4) }
    reservation_from { Time.now }
    reservation_duration { 30 }
    reservation_type { nil }
    table { create('sulten/table') }
    allergies { rand(0..3) == 0 ? Faker::Lorem.sentence : nil }

    trait :skip_validations do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end