FactoryBot.define do
  factory :event do
    user
    start_date { Date.today }
    duration { 10 }
    end_date { Date.today + 10.days }
    name { Faker::Lorem.word }
    description  { Faker::Lorem.sentence }
    location { Faker::Address.full_address }
  end
end
