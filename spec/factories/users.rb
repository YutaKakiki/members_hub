FactoryBot.define do
  # テスト用のユーザーはメールアドレスを揃えたいのでシーケンスにしない
  factory :user do
    name { 'Example User' }
    email { 'test@example.com' }
    birth { Faker::Date.between(from: '2002-09-23', to: '2010-09-25') }
    password { 'password' }
    password_confirmation { 'password' }
    trait :authenticated do
      confirmed_at { Time.zone.now }
    end
  end
end
