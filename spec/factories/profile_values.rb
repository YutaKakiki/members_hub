FactoryBot.define do
  factory :profile_value do
    sequence(:content) {|n| "項目#{n}"}
    association :member
    association :profile_field
  end
end
