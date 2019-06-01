# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    association :user
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.birthday(18, 65) }
    bio { Faker::Lorem.sentence(3) }
    gender { 'male' }
  end

  factory :invalid_profile, class: 'Profile' do
    association :user
    first_name {}
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.birthday(18, 65) }
    bio { Faker::Lorem.sentence(3) }
    gender { 'female' }
  end
end
