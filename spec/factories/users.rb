FactoryBot.define do
  # テスト用のユーザーはメールアドレスを揃えたいのでシーケンスにしない
  factory :user do
    name { 'Example User' }
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    trait :authenticated do
      confirmed_at { Time.zone.now }
    end
    trait :multiple do
      sequence(:name) { |n| "Example User#{n}" }
      sequence(:email) { |n| "test#{n}@example.com" }
    end
  end
end
