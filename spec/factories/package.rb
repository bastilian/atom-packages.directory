FactoryGirl.define do
  factory :package do
    name { Faker::Name.name }
  end
end
