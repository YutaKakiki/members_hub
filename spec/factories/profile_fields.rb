FactoryBot.define do
  factory :profile_field do
    sequence(:name) { |n| "項目#{n}" }
    association :team
  end
end
