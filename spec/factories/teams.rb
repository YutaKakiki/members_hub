FactoryBot.define do
  factory :team do
    name { 'Example Team' }
    password_digest { 'encrypted password' }
  end
end
