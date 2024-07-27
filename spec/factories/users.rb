FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    sequence(:email) { |n| "test#{n}@example.com" }
    birth {Faker::Date.between(from: '2002-09-23', to: '2010-09-25')}
    password {"password"}
    password_confirmation {"password"}
  end
end
