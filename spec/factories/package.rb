FactoryGirl.define do
  factory :package do
    name { Faker::Name.name }
    keywords { Faker::Lorem.words(4) }
  end
end
