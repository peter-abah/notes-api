FactoryBot.define do
  factory :note do
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph }
    user { nil }
    collection { nil }
  end
end
