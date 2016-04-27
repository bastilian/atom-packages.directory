FactoryGirl.define do
  factory :category do
    name { Faker::Name.name }
    keywords { Faker::Lorem.words }
  end
end
