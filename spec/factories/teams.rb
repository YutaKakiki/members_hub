FactoryBot.define do
  factory :team do
    name { 'Example Team' }
    password_digest {BCrypt::Password.create('password')}
    uuid {"uuid"}
  end
end
