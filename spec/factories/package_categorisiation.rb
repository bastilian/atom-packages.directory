FactoryGirl.define do
  factory :package_categorisation do
    category { FactoryGirl.create(:category) }
    package  { FactoryGirl.create(:package)  }
  end
end
