FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.word  }
    user { nil }
  end
end
