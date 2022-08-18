FactoryBot.define do
  factory :collection do
    name { Faker::Lorem.word }
    user { nil }
  end
end
