FactoryBot.define do
  factory :event do
    user
    start_date { Date.today }
    duration { 10 }
    name { Faker::Lorem.word }
    description  { Faker::Lorem.sentence }
    location { Faker::Address.full_address }
  end
end
