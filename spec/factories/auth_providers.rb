FactoryBot.define do
  factory :auth_provider do
    association :user
    uid { "10000000000" }
    provider { "google_oauth2" }
  end
end
