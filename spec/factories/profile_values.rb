FactoryBot.define do
  factory :profile_value do
    sequence(:content) { |n| "項目内容#{n}" }
    association :member
    association :profile_field
    trait :name do
      sequence(:content){|n| "Example User#{n}"}
    end
    trait :birth do
      sequence(:content){|n| "199#{n}-01-01"}
    end
  end
end
