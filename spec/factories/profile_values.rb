FactoryBot.define do
  factory :profile_value do
    sequence(:content) { |n| "項目内容#{n}" }
    association :member
    association :profile_field
    trait :name do
      sequence(:content) { |n| "Example User#{n}" }
    end
    trait :birth do
      content {Faker::Date.between(from: 50.years.ago, to: 18.years.ago)}
    end
  end
end
