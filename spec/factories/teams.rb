FactoryBot.define do
  factory :team do
    name { 'Example Team' }
    password_digest { 'password' }
    uuid {"uuid"}
  end
end
