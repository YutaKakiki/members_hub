FactoryBot.define do
  factory :member do
    association :user
    association :team
  end
end
