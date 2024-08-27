FactoryBot.define do
  factory :profile_field do
    sequence(:name) { |n| "項目#{n}" }
    association :team
    trait :name do
      name {"名前"}
    end
    trait :birth do
      name {"生年月日"}
    end
  end
end
